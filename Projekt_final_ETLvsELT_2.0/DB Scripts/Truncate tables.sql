--------------------------------------------------------
--  HD Tables
--------------------------------------------------------
TRUNCATE TABLE D_AIRPORT; 
TRUNCATE TABLE D_PLANE_DATA;  
TRUNCATE TABLE D_STATIONS;
TRUNCATE TABLE F_FLIGHTS; 
TRUNCATE TABLE F_WEATHER;
TRUNCATE TABLE D_AIRPORT2STATIONS;

--------------------------------------------------------
--  STG Tables
--------------------------------------------------------
truncate table STG_F_FLIGHTS_TEMP;
truncate table STG_F_FLIGHTS;
truncate table STG_F_WEATHER_TEMP;
truncate table STG_F_WEATHER;
truncate table STG_D_STATIONS_TEMP;
truncate table STG_D_STATIONS;
truncate table STG_D_STATES_TEMP;
truncate table STG_D_PLANE_DATA_TEMP;
truncate table STG_D_PLANE_DATA;
truncate table STG_D_AIRPORT_TEMP;
truncate table STG_D_AIRPORT;


select 'ALTER TABLE '||table_name||' NOLOGGING;' from ALL_TABLES where owner = 'HD_STAGGING';
select 'ALTER TABLE '||table_name||' NOLOGGING;' from ALL_TABLES where owner = 'ETL_STAGGING';

