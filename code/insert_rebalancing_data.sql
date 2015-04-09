#### REBALANCING DATA

create table rebalancing_data (
entry_id int(11) primary key auto_increment,
station_id int(3) not null,
bikes_available int(4) not null,
docks_available int(4) not null,
time datetime not null
);

load data infile '/Users/mexican/code/projects/insight/babs/data/201402_rebalancing_data.csv'
into table rebalancing_data
fields terminated by ',' 
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines
(station_id,bikes_available,docks_available,@time)
set
time = str_to_date(@time, '%Y/%m/%d %H:%i:%s');

load data infile '/Users/mexican/code/projects/insight/babs/data/201408_rebalancing_data.csv'
into table rebalancing_data
fields terminated by ',' 
enclosed by '"'
lines terminated by '\n'
ignore 1 lines
(station_id,bikes_available,docks_available,@time)
set
time = str_to_date(@time, '%Y-%m-%d %H:%i:%s'); # note the - instead of /! Sneaky!
