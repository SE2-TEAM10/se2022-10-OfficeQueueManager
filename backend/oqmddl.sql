--
-- File generated with SQLiteStudio v3.3.3 on ven ott 14 18:59:13 2022
--
-- Text encoding used: UTF-8
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: client
CREATE TABLE client (id INTEGER PRIMARY KEY UNIQUE NOT NULL, waiting BOOLEAN);
INSERT INTO client (id, waiting) VALUES (1, 0);
INSERT INTO client (id, waiting) VALUES (2, 0);
INSERT INTO client (id, waiting) VALUES (3, 0);
INSERT INTO client (id, waiting) VALUES (4, 1);
INSERT INTO client (id, waiting) VALUES (5, 0);

-- Table: manager
CREATE TABLE manager (id INTEGER PRIMARY KEY UNIQUE NOT NULL, name VARCHAR (10) NOT NULL, surname VARCHAR NOT NULL, mail VARCHAR NOT NULL, password VARCHAR NOT NULL, salt VARCHAR NOT NULL);
INSERT INTO manager (id, name, surname, mail, password, salt) VALUES (1, 'john', 'smith', 'john.smith@polito.it', '7c2ae1791c5cd76a84334c1ccb7495a35da08eb528122fd039a7b250d5567350', '84228d5ba9fb332d602bc105d8ccffdc');

-- Table: officer
CREATE TABLE officer (id INTEGER PRIMARY KEY UNIQUE NOT NULL, name VARCHAR NOT NULL, surname VARCHAR NOT NULL);
INSERT INTO officer (id, name, surname) VALUES (1, 'mike', 'blue');
INSERT INTO officer (id, name, surname) VALUES (2, 'jennifer', 'lopez');
INSERT INTO officer (id, name, surname) VALUES (3, 'samuel', 'black');
INSERT INTO officer (id, name, surname) VALUES (4, 'anthony', 'glass');
INSERT INTO officer (id, name, surname) VALUES (5, 'simon', 'tiger');

-- Table: officer_service
CREATE TABLE officer_service (of_id INTEGER REFERENCES officer (id) ON DELETE CASCADE ON UPDATE CASCADE, serv_id INTEGER REFERENCES service (id) ON DELETE CASCADE ON UPDATE CASCADE, total_queue INTEGER DEFAULT (0));
INSERT INTO officer_service (of_id, serv_id, total_queue) VALUES (1, 1, 0);
INSERT INTO officer_service (of_id, serv_id, total_queue) VALUES (2, 1, 0);
INSERT INTO officer_service (of_id, serv_id, total_queue) VALUES (2, 2, 0);
INSERT INTO officer_service (of_id, serv_id, total_queue) VALUES (3, 2, 1);

-- Table: officer_service_client
CREATE TABLE officer_service_client (of_id INTEGER REFERENCES officer (id) ON DELETE CASCADE ON UPDATE CASCADE, serv_id INTEGER REFERENCES service (id) ON DELETE CASCADE ON UPDATE CASCADE, client_id INTEGER REFERENCES client (id) ON DELETE CASCADE ON UPDATE CASCADE, queue INTEGER, served INTEGER);
INSERT INTO officer_service_client (of_id, serv_id, client_id, queue, served) VALUES (1, 1, 1, 0, 0);
INSERT INTO officer_service_client (of_id, serv_id, client_id, queue, served) VALUES (1, 2, 1, 0, 0);
INSERT INTO officer_service_client (of_id, serv_id, client_id, queue, served) VALUES (3, 2, 4, 1, 0);
INSERT INTO officer_service_client (of_id, serv_id, client_id, queue, served) VALUES (3, 2, 3, 0, 1);

-- Table: service
CREATE TABLE service (id INTEGER PRIMARY KEY UNIQUE NOT NULL, tag_name VARCHAR NOT NULL, service_time TIME NOT NULL);
INSERT INTO service (id, tag_name, service_time) VALUES (1, 'shipping', '00:05:00');
INSERT INTO service (id, tag_name, service_time) VALUES (2, 'account managements', '00:10:00');
INSERT INTO service (id, tag_name, service_time) VALUES (3, 'tax', '00:30:05');

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
