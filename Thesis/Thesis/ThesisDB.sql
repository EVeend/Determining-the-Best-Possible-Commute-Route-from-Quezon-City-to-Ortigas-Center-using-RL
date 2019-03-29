CREATE DATABASE ThesisDB;

CREATE TABLE Environment(
    environment_id varchar(11),
    origin varchar(11), 
    destination varchar(11),
    mode_of_transportation varchar(11),
    route_id varchar(20),
    distance decimal(20,2),
    transport_fare int,
    route_code varchar(8),
    action_name varchar(500)
);

CREATE TABLE id_table(
    environment_id varchar(11),
    environment_name varchar(500)
);

CREATE TABLE Locations(
    location_id varchar(15),
    location_name varchar(100),
    location_type varchar(15)
);

CREATE TABLE Time(
    hour varchar(10)
);

INSERT INTO Locations VALUES ('A-01', 'Eastwood City', 'Origin');
INSERT INTO Locations VALUES ('A-02', 'Quezon City Circle', 'Origin');
INSERT INTO Locations VALUES ('A-03', 'University of the Philippines', 'Origin');
INSERT INTO Locations VALUES ('A-04', 'SM North EDSA Public Transport Terminal', 'Origin');
INSERT INTO Locations VALUES ('A-05', 'UP-Ayala Technohub', 'Origin');
INSERT INTO Locations VALUES ('A-06', 'LRT Katipunan Station', 'Origin');
INSERT INTO Locations VALUES ('A-07', 'LRT Araneta-Cubao Station', 'Origin');

INSERT INTO Locations VALUES ('B-01', 'EDSA Shrine', 'Destination');
INSERT INTO Locations VALUES ('B-02', 'Robinsons Galleria', 'Destination');
INSERT INTO Locations VALUES ('B-03', 'Saint Pedro Poveda College', 'Destination');
INSERT INTO Locations VALUES ('B-04', 'Robinsons Equitable Tower', 'Destination');
INSERT INTO Locations VALUES ('B-05', 'Crowne Plaza', 'Destination');
INSERT INTO Locations VALUES ('B-06', 'Asian Development Bank', 'Destination');
INSERT INTO Locations VALUES ('B-07', 'SM Megamall', 'Destination');
INSERT INTO Locations VALUES ('B-08', 'Ortigas Building', 'Destination');
INSERT INTO Locations VALUES ('B-09', 'Robinsons Cyberscape Ayala', 'Destination');
INSERT INTO Locations VALUES ('B-10', 'East of Galleria Condominium', 'Destination');
INSERT INTO Locations VALUES ('B-11', 'Ortigas Park', 'Destination');
INSERT INTO Locations VALUES ('B-12', 'San Miguel Corporation Head Office', 'Destination');
INSERT INTO Locations VALUES ('B-13', 'EDSA Shangri-La', 'Destination');
INSERT INTO Locations VALUES ('B-14', 'Lourdes School of Mandaluyong', 'Destination');
INSERT INTO Locations VALUES ('B-15', 'University of Asia and the Pacific', 'Destination');
INSERT INTO Locations VALUES ('B-16', 'The Pearl Place', 'Destination');
INSERT INTO Locations VALUES ('B-17', 'The Philippine Stock Exchange, Inc.', 'Destination');

INSERT INTO Time VALUES ('00:00');
INSERT INTO Time VALUES ('01:00');
INSERT INTO Time VALUES ('02:00');
INSERT INTO Time VALUES ('03:00');
INSERT INTO Time VALUES ('04:00');
INSERT INTO Time VALUES ('05:00');
INSERT INTO Time VALUES ('06:00');
INSERT INTO Time VALUES ('07:00');
INSERT INTO Time VALUES ('08:00');
INSERT INTO Time VALUES ('09:00');
INSERT INTO Time VALUES ('10:00');
INSERT INTO Time VALUES ('11:00');
INSERT INTO Time VALUES ('12:00');
INSERT INTO Time VALUES ('13:00');
INSERT INTO Time VALUES ('14:00');
INSERT INTO Time VALUES ('15:00');
INSERT INTO Time VALUES ('16:00');
INSERT INTO Time VALUES ('17:00');
INSERT INTO Time VALUES ('18:00');
INSERT INTO Time VALUES ('19:00');
INSERT INTO Time VALUES ('20:00');
INSERT INTO Time VALUES ('21:00');
INSERT INTO Time VALUES ('22:00');
INSERT INTO Time VALUES ('23:00');

COMMIT;

SELECT location_name FROM Locations WHERE location_type = 'Destination';
SELECT hour FROM Time;

DROP TABLE Locations;
DROP TABLE Environment;
DROP TABLE id_table;
DROP TABLE Time;
