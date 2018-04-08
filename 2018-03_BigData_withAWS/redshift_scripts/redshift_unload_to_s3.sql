unload ($$
select 
id as ORD_DELAY_ID, 
DAY_OF_MONTH, 
DAY_OF_WEEK, 
FL_DATE, 
YEAR,
MONTH,
UNIQUE_CARRIER, 
FL_NUM, 
substring(DEP_TIME, 1, 2) as DEP_HOUR, 
cast(DEP_DEL15 as smallint) as DEP_DEL15,
cast(AIR_TIME as integer) as AIR_TIME, 
cast(FLIGHTS as smallint) as FLIGHTS, 
cast(DISTANCE as smallint) as DISTANCE,
cancelled
from ord_flights 
where origin='ORD'
$$)
to 's3://leesa.east2.training/enriched_flight_data/ORD_flights_' 
credentials 'aws_access_key_id=<!put your aws_access_key_id here !>;aws_secret_access_key=<!put your aws_secret_access_key here !>'
ALLOWOVERWRITE
ESCAPE
DELIMITER AS ','
ADDQUOTES
NULL AS ''
PARALLEL OFF;