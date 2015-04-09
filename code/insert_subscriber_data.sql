#### SUBSCRIBER DATA

create table subscriber_data (
date datetime primary key,
total_subscribers mediumint(5) not null,
san_francisco mediumint(5) not null,
redwood_city mediumint(5) not null,
palo_alto mediumint(5) not null,
mountain_view mediumint(5) not null,
san_jose mediumint(5) not null
);

load data infile '/Users/mexican/code/projects/insight/babs/data/subscribers.csv'
into table subscriber_data
fields terminated by ',' 
lines terminated by '\n'
ignore 1 lines
(@date,total_subscribers,san_francisco,redwood_city,palo_alto,mountain_view,san_jose)
set
date = str_to_date(@date, '%m/%d/%Y');