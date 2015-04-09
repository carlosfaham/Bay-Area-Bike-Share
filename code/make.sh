# -------------------------------------------------------------------------------
#                   Bay Area Bike Share (BABS) Open Data
#                       http://bayareabikeshare.com
#
#   This data was part of the BABS data challenge.
#   This script fetches the data and insert into MySQL.
#   Unfortunately, the data is messy and needs to be munged first.
#   There are e.g.
#       badly formatted values, changing formats, partitioned data
#       that needs to be combined, et.
#
#   The data are first parsed with perl, then inserted into MySQL with a script
#
# Apr 2015 C.H. Faham
# -------------------------------------------------------------------------------

# Reference:
#   * perl commands: -p print output, -i change file in place, -e inline command
#   * to test, remove the i

# Make the folder, download the data, unzip
mkdir data
cd data
curl -O https://s3.amazonaws.com/trackerdata/201402_babs_open_data.zip
curl -O https://s3.amazonaws.com/trackerdata/201408_babs_open_data.zip
unzip -o 201402_babs_open_data.zip
unzip -o 201408_babs_open_data.zip

# -----------------
# *** Trip data ***
# -----------------

# 201402_trip_data.csv
# Change missing zip codes to NULL
perl -pi -e 's/,\r\n/,\\N\r\n/g' 201402_trip_data.csv
# Delete -1234 ending for some zip codes
perl -pi -e 's/-\d{4}\r\n/\r\n/g' 201402_trip_data.csv

# 201402_trip_data.csv  ...OH BOY
# Change missing zip codes to NULL
perl -pi -e 's/,\r\n/,\\N\r\n/g' 201408_trip_data.csv
# Change 'nil' to \N
perl -pi -e 's/nil/\\N/g' 201408_trip_data.csv
# Delete -1234 ending for some zip codes
perl -pi -e 's/-\d{4}\r\n/\r\n/g' 201408_trip_data.csv
# Change zip codes that are longer than 5 digits to \N (some are 11-digit long!)
perl -pi -e 's/,\d{5}\d+\r\n/,\\N\r\n/g' 201408_trip_data.csv
# Change v6z2x, M4S1P and similar bad zip codes to \N
perl -pi -e 's/,[A-Za-z].{4}\r\n/,\\N\r\n/g' 201408_trip_data.csv

# Insert data into MySQL
mysql -u root -p babs < insert_trip_data.sql

# --------------------
# *** Station data ***
# --------------------

# Both files OK

# Insert data into MySQL
mysql -u root -p babs < insert_station_data.sql

# ------------------------
# *** Rebalancing data ***
# ------------------------

# 201402_rebalancing_data.csv
# OK

# 201408_rebalancing_data.csv
# *** WARNING ***
# fields are terminated by '\n'
# date string separator is '-' instead of '/'

# Insert data into MySQL
mysql -u root -p babs < insert_rebalancing_data.sql

# -----------------------
# *** Subscriber data ***
# -----------------------
# This is NOT included in the two .zip files above since it was not part of the data challenge.
# Data was available from Aug 2013 until Dec 2014. (There is some 2015 data but there is a big gap.)
# It is served in pieces at http://www.bayareabikeshare.com/system-metrics/annual-members
# 
# There is unfortunately no direct link for the files!
# They had to be downloaded from the browser individually, 
# and renamed temp_subscribers1.csv,temp_subscribers2.csv ... temp_subscribers5.csv

# For reproducibility, I put the pieces in a zip file in dropbox. Download the pieces:
curl -L -o subscriber_data.zip https://www.dropbox.com/s/vojodtmmoio80va/subscriber_data.zip?dl=1
unzip -o subscriber_data.zip

# Combine them into 1 file
head -1 temp_subscribers1.csv > subscribers.csv
for f in temp_subscribers*.csv; do (tail -n+2 "${f}"; echo) >> subscribers.csv; done

# Insert data into MySQL
mysql -u root -p babs < insert_subscriber_data.sql


# ---------------------
# *** Customer data ***
# ---------------------
# Same as above. Data was available from Aug 2013 until Dec 2014.
# (There is some 2015 data but there is a big gap.)
# Download from http://www.bayareabikeshare.com/system-metrics/casual-members
# but there is no direct link. 

# Download the pieces
curl -L -o customer_data.zip https://www.dropbox.com/s/8z4dg0j1ceonriq/customer_data.zip?dl=1
unzip -o customer_data.zip

# Combine into 1 file
head -1 temp_customers1.csv > customers.csv
for f in temp_customers*.csv; do (tail -n+2 "${f}"; echo) >> customers.csv; done

# Insert data into MySQL
mysql -u root -p babs < insert_customer_data.sql

# ---------------------
# *** Weather data ***
# ---------------------
# The data is repeated 5 times, one for each of 5 zip codes

# 201402_weather_data.csv
# For precipitation, the word T means < 0.01. Replace by 0.01
perl -pi -e 's/,T,/,0.01,/g' 201402_weather_data.csv
# Replace empty fields (,,) with ,\N,
# Run it twice since ,,,, only becomes ,\N,,\N, the first time
perl -pi -e 's/,,/,\\N,/g' 201402_weather_data.csv
perl -pi -e 's/,,/,\\N,/g' 201402_weather_data.csv

# 201408_weather_data.csv
# For precipitation, the word T means < 0.01. Replace by 0.01
perl -pi -e 's/,T,/,0.01,/g' 201408_weather_data.csv
# Replace empty fields (,,) with ,\N, (same as with 201402 file)
perl -pi -e 's/,,/,\\N,/g' 201408_weather_data.csv
perl -pi -e 's/,,/,\\N,/g' 201408_weather_data.csv

# Insert data into MySQL
mysql -u root -p babs < insert_weather_data.sql

