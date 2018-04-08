select 
id as ORD_DELAY_ID, 
DAY_OF_MONTH, 
DAY_OF_WEEK, 
FL_DATE, 
f_days_from_holiday(year, month, day_of_month) as DAYS_TO_HOLIDAY, 
UNIQUE_CARRIER, 
FL_NUM, 
substring(DEP_TIME, 1, 2) as DEP_HOUR, 
cast(DEP_DEL15 as smallint) as DEP_DEL15,
cast(AIR_TIME as integer) as AIR_TIME, 
cast(FLIGHTS as smallint) as FLIGHTS, 
cast(DISTANCE as smallint) as DISTANCE
from ord_flights 
where origin='ORD' 
and cancelled = 0
limit 10