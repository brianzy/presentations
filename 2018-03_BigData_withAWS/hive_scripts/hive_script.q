CREATE EXTERNAL TABLE IF NOT EXISTS weather_raw (
 station  VARCHAR(50),
 station_name   VARCHAR(50),
 latitude  decimal(5,5),
 longitude  decimal(5,5),
 elevation  decimal(5,5),
 wdate   date,
 awnd   decimal(5,5),
 pgtm   decimal(5,5),
 prcp   decimal(5,5),
 snow   decimal(5,5),
 snwd   decimal(5,5),
 tavg   decimal(5,5),
 tmax   decimal(5,5),
 tmin   decimal(5,5),
 wdf2   decimal(5,5),
 wdf5   decimal(5,5),
 wsf2   decimal(5,5),
 wsf5   decimal(5,5),
 wt01   decimal(5,5),
 wt02   decimal(5,5),
 wt03   decimal(5,5),
 wt04   decimal(5,5),
 wt05   decimal(5,5),
 wt06   decimal(5,5),
 wt08   decimal(5,5),
 wt09   decimal(5,5),
 wt13   decimal(5,5),
 wt14  decimal(5,5),
 wt16   decimal(5,5),
 wt17   decimal(5,5),
 wt18   decimal(5,5),
 wt19   decimal(5,5),
 wt20   decimal(5,5)
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
LOCATION 's3://leesa.east2.training/weatherdata/'
TBLPROPERTIES("skip.header.line.count"="1");

CREATE TABLE weather AS SELECT station, station_name, elevation, latitude, longitude, 
wdate AS dt, prcp, snow, tmax, tmin, awnd FROM weather_raw;

select * from weather limit 10;


--how to write to s3
insert overwrite directory 's3n://leesa.east2.training/hive_enriched_data/'
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
select * from weather;