PRAGMA foreign_keys = 1;

CREATE TABLE domains (
  id                    INTEGER PRIMARY KEY AUTOINCREMENT,
  name                  VARCHAR(255) NOT NULL COLLATE NOCASE,
  ns34                  VARCHAR(40) DEFAULT NULL,
  ns12                  VARCHAR(40) DEFAULT NULL,
  ns56                  VARCHAR(40) DEFAULT NULL,
  dnssec                TINYINT DEFAULT 0,
  dnssec_keyid          VARCHAR(5) DEFAULT NULL,
  last_update           INTEGER DEFAULT NULL,
);
