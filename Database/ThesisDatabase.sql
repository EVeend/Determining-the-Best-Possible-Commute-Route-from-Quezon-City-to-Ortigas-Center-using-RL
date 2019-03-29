CREATE TABLE Environment(
    environment_id varchar(11),
    case_id varchar(12),
    time varchar(12),
    origin varchar(11), 
    destination varchar(11),
    mode_of_transportation varchar(11),
    route_id varchar(20),
    distance decimal(20,2),
    transport_fare int,
    route_code varchar(8),
    speed decimal(20,2),
    traffic_level int,
    weather_level int,
    action_name varchar(500)
);


CREATE TABLE id_table(
    environment_id varchar(11),
    environment_name varchar(500)
);

CREATE TABLE results(
    environment_id varchar(11),
    case_id varchar(12),
    time varchar(12),
    estimated_travel_time decimal(20,2), 
    transport_fare int,
    weather_level int,
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

