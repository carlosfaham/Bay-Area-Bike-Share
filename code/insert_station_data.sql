#### STATION DATA

create table station_data (
station_id int(3) primary key,
name varchar(50) not null,
latitude float(9,6) not null,
longitude float(9,6) not null,
dockcount int(4),
landmark varchar(30),
landmark_code char(2) default NULL,
installation varchar(10)
);

load data infile '/Users/mexican/code/projects/insight/babs/data/201408_station_data.csv'
into table station_data
fields terminated by ','
lines terminated by '\r\n'
ignore 1 lines
(station_id,name,latitude,longitude,dockcount,landmark,installation);

# Add landmark codes for easy combining with station names e.g. concat(name,'[',landmark_code,']')
update station_data set landmark_code = 'SJ' where landmark = 'San Jose';
update station_data set landmark_code = 'RC' where landmark = 'Redwood City';
update station_data set landmark_code = 'MV' where landmark = 'Mountain View';
update station_data set landmark_code = 'PA' where landmark = 'Palo Alto';
update station_data set landmark_code = 'SF' where landmark = 'San Francisco';