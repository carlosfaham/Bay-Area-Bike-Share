#### TRIP DATA

create table trip_data (
trip_id int(11) primary key auto_increment,
duration_sec int(6) not null,
start_date datetime not null,
start_station varchar(100),
start_terminal int(3) not null,
end_date datetime not null,
end_station varchar(100),
end_terminal int(3) not null,
bike_num int(4) not null,
subscription_type varchar(15) not null,
trip_cost smallint(3) default 0,
zip_code mediumint(5) default 0);

load data infile '/Users/mexican/code/projects/insight/babs/data/201402_trip_data.csv'
into table trip_data
fields terminated by ','
lines terminated by '\r\n'
ignore 1 lines
(trip_id,
duration_sec,
@start_date,
start_station,
start_terminal,
@end_date,
end_station,
end_terminal,
bike_num,
subscription_type,
zip_code)
set
start_date = str_to_date(@start_date, '%m/%d/%Y %H:%i'),
end_date = str_to_date(@end_date, '%m/%d/%Y %H:%i');

load data infile '/Users/mexican/code/projects/insight/babs/data/201408_trip_data.csv'
into table trip_data
fields terminated by ','
lines terminated by '\r\n'
ignore 1 lines
(trip_id,
duration_sec,
@start_date,
start_station,
start_terminal,
@end_date,
end_station,
end_terminal,
bike_num,
subscription_type,
zip_code)
set
start_date = str_to_date(@start_date, '%m/%d/%Y %H:%i'),
end_date = str_to_date(@end_date, '%m/%d/%Y %H:%i');

# This estimates the total trip cost due to overage fees
#
# Trips less than 30 mins have no additional costs
# Overage fees:
#   + $4 (30 min - 60 min trip)
#   + $7 (each additional 30 min)
#   Maximum daily fee = $150
update trip_data set trip_cost = 0;
update trip_data set trip_cost = trip_cost+4 where duration_sec > 1800;
update trip_data set trip_cost = trip_cost+7 where duration_sec > 3600;
update trip_data set trip_cost = trip_cost+7 where duration_sec > 5400;
update trip_data set trip_cost = trip_cost+7 where duration_sec > 7200;
update trip_data set trip_cost = trip_cost+7 where duration_sec > 9000;
update trip_data set trip_cost = trip_cost+7 where duration_sec > 10800;
update trip_data set trip_cost = trip_cost+7 where duration_sec > 12600;
update trip_data set trip_cost = trip_cost+7 where duration_sec > 14400;
update trip_data set trip_cost = trip_cost+7 where duration_sec > 16200;
update trip_data set trip_cost = trip_cost+7 where duration_sec > 18000;
update trip_data set trip_cost = trip_cost+7 where duration_sec > 19800;
update trip_data set trip_cost = trip_cost+7 where duration_sec > 21600;
update trip_data set trip_cost = trip_cost+7 where duration_sec > 23400;
update trip_data set trip_cost = trip_cost+7 where duration_sec > 25200;
update trip_data set trip_cost = trip_cost+7 where duration_sec > 27000;
update trip_data set trip_cost = trip_cost+7 where duration_sec > 28800;
update trip_data set trip_cost = trip_cost+7 where duration_sec > 30600;
update trip_data set trip_cost = trip_cost+7 where duration_sec > 32400;
update trip_data set trip_cost = trip_cost+7 where duration_sec > 34200;
update trip_data set trip_cost = trip_cost+7 where duration_sec > 36000;
update trip_data set trip_cost = trip_cost+7 where duration_sec > 37800;
update trip_data set trip_cost = trip_cost+7 where duration_sec > 39601;
update trip_data  set trip_cost = 150 where trip_cost > 150;