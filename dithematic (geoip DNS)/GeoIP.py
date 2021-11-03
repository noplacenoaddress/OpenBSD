#!/bin/env python3
#
# All-in-one Python script for auto-generating the GeoIP.acl file for BIND,
# the Berkeley Internet Name Domain.
#
# It sources GeoIP data from MaxMind/IP2Location/DB-IP and processes it to
# generate a unified GeoIP.acl file, in the current working directory,
# containing country specific ACLs for both the IPv4 and IPv6 address space.
#
# For the latest version, including any updates and/or bug fixes, visit
# https://geoip.site/GeoIP.py
#
# Copyright &copy; 2020 Mark Hedges &lt;mark@phix.me&gt;
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#   * Redistributions of source code must retain the above copyright
#     notice, this list of conditions and the following disclaimer.
#
#   * Redistributions in binary form must reproduce the above copyright
#     notice, this list of conditions and the following disclaimer in the
#     documentation and/or other materials provided with the distribution.
#
#   * Neither the name of the copyright holder nor the
#     names of its contributors may be used to endorse or promote products
#     derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.


import re
import gzip
import pandas
import socket
import struct
import fnmatch
import zipfile
import requests

from sys import argv
from mpmath import mag
from datetime import date
from tempfile import mkstemp
from os import environ, remove


USER_AGENT = 'https://geoip.site/GeoIP.py'


def fetch(url):
    '''
    Helper function for fetching a file.
    '''

    filename = mkstemp()[1]

    try:
        open(filename, 'wb').write(requests.get(url, headers={'User-Agent': USER_AGENT}).content)

    except:
        remove(filename)
        raise

    return filename


def MaxMind(url, kwargs):
    '''
    Custom function for processing MaxMind GeoLite2 Country & City CSV databases.
    '''

    def read(pattern, **kwargs):
        pattern = f'GeoLite2-{db}-CSV_*/GeoLite2-{db}-{pattern}.csv'
        files = fnmatch.filter(i.namelist(), pattern)
        if len(files) != 1:
            remove(filename)
            raise Exception('Failed to locate exactly one file matching:\n  %s\nwithin:\n  %s' % (pattern, url))
        return pandas.read_csv(i.open(files[0]), **kwargs)

    db = kwargs['db']
    key = kwargs['key']
    dtype = {x: str for x in key}
    dtype['postal_code'] = str

    filename = fetch(url)
    i = zipfile.ZipFile(filename)
    locations = read('Locations-en', keep_default_na=False)

    acls = {}

    for v in '46':
        seen = set()
        for geoname_id in ['geoname_id', 'registered_country_geoname_id', 'represented_country_geoname_id']:
            blocks = read('Blocks-IPv' + v, dtype=dtype).fillna(0)
            blocks[geoname_id] = blocks[geoname_id].astype(int)
            df = pandas.merge(locations, blocks, left_on='geoname_id', right_on=geoname_id)[key + ['network']]
            df['key'] = df[key].apply(lambda x: ':'.join(filter(None, x)) or 'ZZ', axis=1)
            for acl in df.key.unique():
                networks = df.loc[acl == df.key].network.to_list()
                acls.setdefault(acl, []).extend(x for x in networks if x not in seen)
                seen.update(networks)

    remove(filename)

    return acls


'''
Define source of GeoIP data and how to process it.
'''
PROVIDERS = {

    'DB-IP': [
        [
            dict(range=[0, 1], key=[2]),
            'https://download.db-ip.com/free/dbip-country-lite-{}.csv.gz'.format(date.today().strftime('%Y-%m')),
            None,
        ],
    ],

    'DB-IP.continent': [
        [
            dict(range=[0, 1], key=[2]),
            'https://download.db-ip.com/free/dbip-city-lite-{}.csv.gz'.format(date.today().strftime('%Y-%m')),
            None,
        ],
    ],

    'DB-IP.region': [
        [
            dict(range=[0, 1], key=[3, 4]),
            'https://download.db-ip.com/free/dbip-city-lite-{}.csv.gz'.format(date.today().strftime('%Y-%m')),
            None,
        ],
    ],

    'IP2Location': [
        [
            dict(range=[0, 1], key=[2]),
            'https://download.ip2location.com/lite/IP2LOCATION-LITE-DB1.CSV.ZIP',
            'IP2LOCATION-LITE-DB1.CSV',
        ],
        [
            dict(range=[0, 1], key=[2]),
            'https://download.ip2location.com/lite/IP2LOCATION-LITE-DB1.IPV6.CSV.ZIP',
            'IP2LOCATION-LITE-DB1.IPV6.CSV',
        ],
    ],

    'MaxMind': [
        [
            MaxMind,
            'https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-Country-CSV&suffix=zip&license_key=' + environ['MAXMIND_LICENSE_KEY'],
            dict(db='Country', key=['country_iso_code']),
        ],
    ],

    'MaxMind.area': [
        [
            MaxMind,
            'https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City-CSV&suffix=zip&license_key=' + environ['MAXMIND_LICENSE_KEY'],
            dict(db='City', key=['country_iso_code', 'subdivision_1_iso_code', 'subdivision_2_iso_code', 'metro_code']),
        ],
    ],

    'MaxMind.continent': [
        [
            MaxMind,
            'https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-Country-CSV&suffix=zip&license_key=' + environ['MAXMIND_LICENSE_KEY'],
            dict(db='Country', key=['continent_code']),
        ],
    ],

    'MaxMind.region': [
        [
            MaxMind,
            'https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-City-CSV&suffix=zip&license_key=' + environ['MAXMIND_LICENSE_KEY'],
            dict(db='City', key=['country_iso_code', 'subdivision_1_iso_code']),
        ],
    ],

}


'''
Upper limit for IPv4 global unicast address space, excluding multicast.
This value also acts as a boundary for considering when integers are to
be treated as IPv4 or IPv6 addresses; IPv4 for integers less than this,
IPv6 for integers greater than or equal to this.
'''
IPv4 = 7 * 1 << 29


'''
Network and mask for 2000::/3 IPv6 global unicast address space.
'''
IPv6n = 1 << 125
IPv6m = 7 * IPv6n


def _i(s):
    '''
    Converts a string to an integer IP address. If no '.' or ':'
    characters are found, assumes that the string represents a number
    and returns the direct integer conversion, otherwise proceeds with
    conversion on the presumption that the existence of '.' characters
    indicates an IPv4 address and ':' characters an IPv6 address.
    '''

    if ':' in s:
        x, y = struct.unpack('!2Q', socket.inet_pton(socket.AF_INET6, s))
        return y | x << 64
    elif '.' in s:
        return struct.unpack('!I', socket.inet_aton(s))[0]
    else:
        return int(s)


def _a(x):
    '''
    IP range aggregator and splitter function.
    First merges adjacent ranges together. Then
    splits those ranges on network boundaries.
    '''

    for k, v in x.items():
        i, v = 1, sorted(map(_r, v))
        while i < len(v):
            b1, e1 = v[i]
            b0, e0 = v[i-1]
            if b1 == e0 + 1:
                v[i] = (b0, e1)
                del v[i-1]
                continue
            i += 1
        x[k] = []
        for r in v:
            x[k].extend(_s(*r))

    return x


def _r(x):
    '''
    Given a network range, as a string containing a '-' character,
    or a network address and netmask, as a string containing a '/'
    character, returns the actual IP range as a two element tuple
    containing the begin and end integers for that network.
    '''

    if '-' in x:
        return tuple(map(_i, x.split('-')))
    elif '/' in x:
        n, m = map(_i, x.split('/'))
        return n, n-1+2**((32 if n < IPv4 else 128)-m)


def _s(b, e):
    '''
    Recursive IP range splitter function.
    '''

    if 'x' not in locals():
        x = []

    if e < b:
        b, e = e, b

    if e < IPv4:
        '''Range is IPv4'''
        s = 32
    else:
        '''Presume range is IPv6 and force beginning to be at least the IPv4 boundary'''
        s, b = 128, max(b, IPv4)

    l = mag(e-b+1)-1
    m = 2**s-2**l
    n = m & e

    if n == m & b:
        _v(b) and x.append((b, s-l))
    else:
        x.extend(_s(b, n-1))
        x.extend(_s(n, e))

    return x


def _v(n):
    '''
    Rudimentary IP address validation function.
    Checks IP address resides in global unicast address space.
    '''

    return n < IPv4 or IPv6n == n & IPv6m


def main():

    PROVIDER = PROVIDERS.get(argv[1]) if len(argv) > 1 else None

    if PROVIDER is None:
        print('First argument must be one of the following:\n')
        for s in sorted(PROVIDERS):
            print(' * ' + s)
        exit(1)

    ACLs, RE = {}, re.compile('[^\w-]+')

    for META, URL, FILE in PROVIDER:

        if callable(META):
            ACLs = META(URL, FILE)
            break

        l = URL.lower()
        filename = fetch(URL)

        key = META['key']
        range = META['range']
        begin, end = range

        try:
            if l.endswith('.gz'):
                i = gzip.open(filename)
            elif l.endswith('.zip'):
                i = zipfile.ZipFile(filename).open(FILE)
            df = pandas.read_csv(i, header=None, keep_default_na=False, dtype={x: str for x in key + range})
            df['key'] = df[key].apply(lambda x: ':'.join(filter(None, map(lambda x: RE.sub('.', x), x))), axis=1)
            df['range'] = df[range].apply(lambda x: '-'.join(x), axis=1)
            df = df[['key', 'range']]
            for acl in df.key.unique():
                ACLs.setdefault(acl if len(acl) > 1 else 'ZZ', []).extend(df.loc[acl == df.key].range.to_list())

        except:
            raise

        finally:
            remove(filename)

    with open('GeoIP.acl', 'w') as file:
        for k, v in sorted(_a(ACLs).items()):
            file.write('acl ' + k + ' {\n')
            for n, m in sorted(v):
                file.write('\t{}/{};\n'.format(
                    socket.inet_ntop(socket.AF_INET, struct.pack('!I', n)) if n < IPv4 else
                    socket.inet_ntop(socket.AF_INET6, struct.pack('!2Q', n >> 64, n & (1 << 64) - 1)),
                    m)
                )
            file.write('};\n\n')


if __name__ == '__main__':
    main()
