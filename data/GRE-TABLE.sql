CREATE TABLE [GRE] (  
	[HOST-SRCID] NVARCHAR(30) ,  
	[PTP] NVARCHAR(5) PRIMARY KEY,  
	[PTP-NETWORK] NVARCHAR(16),
	[PTP-LATENCY] INTEGER,
	[INTERFACE] NVARCHAR(13),
	[COST] INTEGER,
	[HOPCOST] INTEGER
);  

INSERT INTO GRE (HOST-SRCID, PTP, PTP-NETWORK, PTP-LATENCY, INTERFACE, COST, HOPCOST)
VALUES
	("indra@ca.telecomlobby.com", "ES-FR", "10.10.10.252/30", 24, "tun0", 12, 0),
	("indra@ca.telecomlobby.com", "ES-UK", "10.10.10.228/30", 35, "tun3", 17, 0),
	("indra@ca.telecomlobby.com", "ES-US", "10.10.10.236/30", 139, "tun1", 70, 0),
	("indra@ca.telecomlobby.com", "ES-JP", "10.10.10.232/30", 267, "tun2", 133, 0),
	("uma@ca.telecomlobby.com", "FR-ES", "10.10.10.252/30", 24, "gre-tunnel1", 12, 0),
	("uma@ca.telecomlobby.com", "FR-UK", "10.10.10.248/30", 6, "gre-tunnel2", 3, 13),
	("uma@ca.telecomlobby.com", "FR-US", "10.10.10.244/30", 109, "gre-tunnel4", 55, 65),
	("uma@ca.telecomlobby.com", "FR-JP", "10.10.10.240/30", 231, "gre-tunnel3", 115, 125),
	("ganesha@ca.telecomlobby.com", "UK-ES", "10.10.10.228/30", 35, "gre1", 17, 0),
	("ganesha@ca.telecomlobby.com", "UK-FR", "10.10.10.248/30", 6, "gre0", 3, 13),
	("ganesha@ca.telecomlobby.com", "UK-US", "10.10.10.225/30", 105, "gre2", 52, 62),
	("ganesha@ca.telecomlobby.com", "UK-JP", "10.10.10.114/30", 244, "gre3", 122, 132),
	("shiva@ca.telecomlobby.com", "JP-ES", "10.10.10.232/30", 267, "gre12", 133, 0),
	("shiva@ca.telecomlobby.com", "JP-FR", "10.10.10.240/30", 231, "gre0", 115, 125),
	("shiva@ca.telecomlobby.com", "JP-US", "10.10.10.118/30", 151, "gre2", 75, 0),
	("shiva@ca.telecomlobby.com", "JP-UK", "10.10.10.114/30", 244, "gre3", 122, 132),
	("saraswati@ca.telecomlobby.com", "US-ES", "10.10.10.236/30", 139, "gre1", 70, 0),
	("saraswati@ca.telecomlobby.com", "US-FR", "10.10.10.244/30", 109, "gre0", 55, 65),
	("saraswati@ca.telecomlobby.com", "US-UK", "10.10.10.225/30", 105, "gre2", 52, 62),
	("saraswati@ca.telecomlobby.com", "US-JP", "10.10.10.118/30", 151, "gre3", 75, 0);
	
