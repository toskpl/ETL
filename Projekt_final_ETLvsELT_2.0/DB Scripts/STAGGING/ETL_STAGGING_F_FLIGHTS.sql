truncate table ETL_STAGGING.STG_F_FLIGHTS_TEMP;
truncate table ETL_STAGGING.STG_F_FLIGHTS;

--------------------------------------------------------
--  DDL for Table STG_F_FLIGHTS_TEMP
--------------------------------------------------------

drop table ETL_STAGGING.STG_F_FLIGHTS_TEMP;
CREATE TABLE ETL_STAGGING.STG_F_FLIGHTS_TEMP (	
FYEAR VARCHAR2(40) 
,FMONTH VARCHAR2(20)
,DAYOFMONTH VARCHAR2(20)
,DAYOFWEEK VARCHAR2(10)
,DEPTIME VARCHAR2(40)
,CRSDEPTIME VARCHAR2(40)
,ARRTIME VARCHAR2(40)
,CRSARRTIME VARCHAR2(40)
,UNIQUECARRIER VARCHAR2(20)
,FLIGHTNUM VARCHAR2(40)
,TAILNUM VARCHAR2(20)
,ACTUALELAPSEDTIME VARCHAR2(20)
,CRSELAPSEDTIME VARCHAR2(20)
,AIRTIME VARCHAR2(20)
,ARRDELAY VARCHAR2(20)
,DEPDELAY VARCHAR2(20)
,ORIGIN VARCHAR2(30)
,DEST VARCHAR2(30)
,DISTANCE VARCHAR2(30)
,TAXIIN VARCHAR2(20)
,TAXIOUT VARCHAR2(20)
,CANCELLED VARCHAR2(10)
,CANCELLATIONCODE VARCHAR2(20)
,DIVERTED VARCHAR2(10)
,CARRIERDELAY VARCHAR2(20)
,WEATHERDELAY VARCHAR2(20)
,NASDELAY VARCHAR2(20)
,SECURITYDELAY VARCHAR2(20)
,LATEAIRCRAFTDELAY VARCHAR2(20)
 );
 

--------------------------------------------------------
--  DDL for Table STG_F_FLIGHTS_SKEY_TEMP
--------------------------------------------------------

drop table ETL_STAGGING.STG_F_FLIGHTS_SKEY_TEMP;
CREATE TABLE ETL_STAGGING.STG_F_FLIGHTS_SKEY_TEMP (	
DWH_SOURCE_KEY VARCHAR2(50)
,DWH_VALID_FROM DATE
,FYEAR VARCHAR2(40) 
,FMONTH VARCHAR2(20)
,DAYOFMONTH VARCHAR2(20)
,DAYOFWEEK VARCHAR2(10)
,DEPTIME VARCHAR2(40)
,CRSDEPTIME VARCHAR2(40)
,ARRTIME VARCHAR2(40)
,CRSARRTIME VARCHAR2(40)
,UNIQUECARRIER VARCHAR2(20)
,FLIGHTNUM VARCHAR2(40)
,TAILNUM VARCHAR2(20)
,ACTUALELAPSEDTIME VARCHAR2(20)
,CRSELAPSEDTIME VARCHAR2(20)
,AIRTIME VARCHAR2(20)
,ARRDELAY VARCHAR2(20)
,DEPDELAY VARCHAR2(20)
,ORIGIN VARCHAR2(30)
,DEST VARCHAR2(30)
,DISTANCE VARCHAR2(30)
,TAXIIN VARCHAR2(20)
,TAXIOUT VARCHAR2(20)
,CANCELLED VARCHAR2(10)
,CANCELLATIONCODE VARCHAR2(20)
,DIVERTED VARCHAR2(10)
,CARRIERDELAY VARCHAR2(20)
,WEATHERDELAY VARCHAR2(20)
,NASDELAY VARCHAR2(20)
,SECURITYDELAY VARCHAR2(20)
,LATEAIRCRAFTDELAY VARCHAR2(20)
 );

--------------------------------------------------------
--  DDL for Table STG_F_FLIGHTS
--------------------------------------------------------
drop table ETL_STAGGING.STG_F_FLIGHTS;
CREATE TABLE ETL_STAGGING.STG_F_FLIGHTS (	
 DWH_SOURCE_KEY VARCHAR2(50)
,DWH_DELETE_FLAG VARCHAR2(1)
,DWH_INSERT_FLAG VARCHAR2(1)
,DWH_VALID_FROM DATE
,FYEAR VARCHAR2(40) 
,FMONTH VARCHAR2(20)
,DAYOFMONTH VARCHAR2(20)
,DAYOFWEEK VARCHAR2(10)
,DEPTIME VARCHAR2(40)
,CRSDEPTIME VARCHAR2(40)
,ARRTIME VARCHAR2(40)
,CRSARRTIME VARCHAR2(40)
,UNIQUECARRIER VARCHAR2(20)
,FLIGHTNUM VARCHAR2(40)
,TAILNUM VARCHAR2(20)
,ACTUALELAPSEDTIME VARCHAR2(20)
,CRSELAPSEDTIME VARCHAR2(20)
,AIRTIME VARCHAR2(20)
,ARRDELAY VARCHAR2(20)
,DEPDELAY VARCHAR2(20)
,ORIGIN VARCHAR2(30)
,DEST VARCHAR2(30)
,DISTANCE VARCHAR2(30)
,TAXIIN VARCHAR2(20)
,TAXIOUT VARCHAR2(20)
,CANCELLED VARCHAR2(10)
,CANCELLATIONCODE VARCHAR2(20)
,DIVERTED VARCHAR2(10)
,CARRIERDELAY VARCHAR2(20)
,WEATHERDELAY VARCHAR2(20)
,NASDELAY VARCHAR2(20)
,SECURITYDELAY VARCHAR2(20)
,LATEAIRCRAFTDELAY VARCHAR2(20)
 );
 
 
 
 
CREATE INDEX "STG_F_FLIGHTS_SKEY_IDX" ON STG_F_FLIGHTS ("DWH_SOURCE_KEY");
CREATE INDEX "STG_F_FLIGHTS_SKEY_TEMP_SK_IDX" ON STG_F_FLIGHTS_SKEY_TEMP ("DWH_SOURCE_KEY");
DROP INDEX STG_F_FLIGHTS_SKEY_TEMP_SK_IDX;