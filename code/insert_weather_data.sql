#### WEATHER DATA

create table weather_data (
date datetime not null,
zip_code mediumint(5) not null,
city_code char(2),
max_temperature_F tinyint(3),
mean_temperature_F tinyint(3),
min_temperature_F tinyint(3),
max_dew_point_F tinyint(3),
mean_dew_point_F tinyint(3),
min_dew_point_F tinyint(3),
max_humidity tinyint(3),
mean_humidity tinyint(3),
min_humidity tinyint(3),
max_sea_level_pressure_In float(4,2),
mean_sea_level_pressure_In float(4,2),
min_sea_level_pressure_In float(4,2),
max_visibility_miles tinyint(3),
mean_visibility_miles tinyint(3),
min_visibility_miles tinyint(3),
max_wind_speed_mph tinyint(3),
mean_wind_speed_mph tinyint(3),
max_gust_speed_mph tinyint(3) default NULL,
precipitation_In float(4,2),
cloud_cover tinyint(3),
events varchar(10),
wind_dir_degrees mediumint(3),
PRIMARY KEY(date, zip_code)
);

load data infile '/Users/mexican/code/projects/insight/babs/data/201402_weather_data.csv'
into table weather_data
fields terminated by ',' 
lines terminated by '\n'
ignore 1 lines
(@date,
max_temperature_F,
mean_temperature_F,
min_temperature_F,
max_dew_point_F,
mean_dew_point_F,
min_dew_point_F,
max_humidity,
mean_humidity,
min_humidity,
max_sea_level_pressure_In,
mean_sea_level_pressure_In,
min_sea_level_pressure_In,
max_visibility_miles,
mean_visibility_miles,
min_visibility_miles,
max_wind_speed_mph,
mean_wind_speed_mph,
max_gust_speed_mph,
precipitation_In,
cloud_cover,
events,
wind_dir_degrees,
zip_code)
set
date = str_to_date(@date, '%m/%d/%Y');

load data infile '/Users/mexican/code/projects/insight/babs/data/201408_weather_data.csv'
into table weather_data
fields terminated by ',' 
lines terminated by '\n'
ignore 1 lines
(@date,
max_temperature_F,
mean_temperature_F,
min_temperature_F,
max_dew_point_F,
mean_dew_point_F,
min_dew_point_F,
max_humidity,
mean_humidity,
min_humidity,
max_sea_level_pressure_In,
mean_sea_level_pressure_In,
min_sea_level_pressure_In,
max_visibility_miles,
mean_visibility_miles,
min_visibility_miles,
max_wind_speed_mph,
mean_wind_speed_mph,
max_gust_speed_mph,
precipitation_In,
cloud_cover,
events,
wind_dir_degrees,
zip_code)
set
date = str_to_date(@date, '%m/%d/%Y');

# Add city code for easy referencing
update weather_data set city_code='SF' where zip_code = 94107;
update weather_data set city_code='RC' where zip_code = 94063;
update weather_data set city_code='PA' where zip_code = 94301;
update weather_data set city_code='MV' where zip_code = 94041;
update weather_data set city_code='SJ' where zip_code = 95113;