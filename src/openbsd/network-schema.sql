PRAGMA foreign_keys = 1;

CREATE TABLE domains (
  id                    INTEGER PRIMARY KEY,
  name                  VARCHAR(255) NOT NULL COLLATE NOCASE,
  ns1                   VARCHAR(40) DEFAULT NULL,
  ns2                   VARCHAR(40) DEFAULT NULL,
  ns3                   VARCHAR(40) DEFAULT NULL,
  dnssec                TINYINT DEFAULT 0,
  dnssec_keyid          VARCHAR(5) DEFAULT NULL,
  last_update           INTEGER DEFAULT NULL,
  last_check            INTEGER DEFAULT NULL,
);
