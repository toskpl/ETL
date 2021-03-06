CREATE TABLE SOURCE.D_AIRPORT 
(	IATA VARCHAR2(50 BYTE), 
AIRPORT VARCHAR2(50 BYTE), 
CITY VARCHAR2(50 BYTE), 
STATE VARCHAR2(50 BYTE), 
COUNTRY VARCHAR2(50 BYTE), 
LAT VARCHAR2(50 BYTE), 
LONGS VARCHAR2(50 BYTE)
) TABLESPACE SOURCE ;

CREATE TABLE SOURCE.D_PLANE_DATA 
(	TAILNUM VARCHAR2(20 BYTE), 
TYPE VARCHAR2(20 BYTE), 
MANUFACTURER VARCHAR2(30 BYTE), 
ISSUE_DATE VARCHAR2(10 BYTE), 
MODEL VARCHAR2(20 BYTE), 
STATUS VARCHAR2(20 BYTE), 
AIRCRAFT_TYPE VARCHAR2(30 BYTE), 
ENGINE_TYPE VARCHAR2(20 BYTE), 
YEAR VARCHAR2(4 BYTE)
) TABLESPACE SOURCE ;

CREATE TABLE SOURCE.D_STATES 
(	CODE VARCHAR2(2 BYTE), 
NAME VARCHAR2(50 BYTE)
) TABLESPACE SOURCE ;

CREATE TABLE SOURCE.D_STATIONS 
(	ID VARCHAR2(11 BYTE), 
LATITUDE VARCHAR2(10 BYTE), 
LONGITUDE VARCHAR2(10 BYTE), 
ELEVATION VARCHAR2(10 BYTE), 
STATE VARCHAR2(2 BYTE), 
NAME VARCHAR2(30 BYTE), 
GSNFLAG VARCHAR2(3 BYTE), 
HCNFLAG VARCHAR2(3 BYTE), 
WMOID VARCHAR2(5 BYTE)
) TABLESPACE SOURCE ;

--------------------------------------------------------
--  DDL for View SRC_V_F_FLIGHTS to limit amount of data for each stage of loading
--------------------------------------------------------

CREATE OR REPLACE FORCE VIEW SOURCE.SRC_V_F_FLIGHTS (
FYEAR 
,FMONTH
,DAYOFMONTH
,DAYOFWEEK
,DEPTIME
,CRSDEPTIME
,ARRTIME
,CRSARRTIME
,UNIQUECARRIER
,FLIGHTNUM
,TAILNUM
,ACTUALELAPSEDTIME
,CRSELAPSEDTIME
,AIRTIME
,ARRDELAY
,DEPDELAY
,ORIGIN
,DEST
,DISTANCE
,TAXIIN
,TAXIOUT
,CANCELLED
,CANCELLATIONCODE
,DIVERTED
,CARRIERDELAY
,WEATHERDELAY
,NASDELAY
,SECURITYDELAY
,LATEAIRCRAFTDELAY
,ID
) AS select * from SRC_F_FLIGHTS where year IN (1987);



CREATE TABLE SOURCE.F_FLIGHTS 
(	YEAR VARCHAR2(40 BYTE), 
MONTH VARCHAR2(20 BYTE), 
DAYOFMONTH VARCHAR2(20 BYTE), 
DAYOFWEEK VARCHAR2(10 BYTE), 
DEPTIME VARCHAR2(40 BYTE), 
CRSDEPTIME VARCHAR2(40 BYTE), 
ARRTIME VARCHAR2(40 BYTE), 
CRSARRTIME VARCHAR2(40 BYTE), 
UNIQUECARRIER VARCHAR2(20 BYTE), 
FLIGHTNUM VARCHAR2(40 BYTE), 
TAILNUM VARCHAR2(20 BYTE), 
ACTUALELAPSEDTIME VARCHAR2(20 BYTE), 
CRSELAPSEDTIME VARCHAR2(20 BYTE), 
AIRTIME VARCHAR2(20 BYTE), 
ARRDELAY VARCHAR2(20 BYTE), 
DEPDELAY VARCHAR2(20 BYTE), 
ORIGIN VARCHAR2(30 BYTE), 
DEST VARCHAR2(30 BYTE), 
DISTANCE VARCHAR2(30 BYTE), 
TAXIIN VARCHAR2(20 BYTE), 
TAXIOUT VARCHAR2(20 BYTE), 
CANCELLED VARCHAR2(10 BYTE), 
CANCELLATIONCODE VARCHAR2(20 BYTE), 
DIVERTED VARCHAR2(10 BYTE), 
CARRIERDELAY VARCHAR2(20 BYTE), 
WEATHERDELAY VARCHAR2(20 BYTE), 
NASDELAY VARCHAR2(20 BYTE), 
SECURITYDELAY VARCHAR2(20 BYTE), 
LATEAIRCRAFTDELAY VARCHAR2(20 BYTE), 
ID NUMBER
) TABLESPACE SOURCE ;


--------------------------------------------------------
-- SRC_V_F_WEATHER - to limit amount of data for each stage of loading
--------------------------------------------------------

CREATE OR REPLACE FORCE VIEW SOURCE.SRC_V_F_WEATHER (
STATION_ID
,WDATE
,WELEMENT
,DATA_VALUE
,M_FLAG
,Q_FLAG
,S_FLAG
,OBS_TIME
,WYEAR
) 
AS 
select 
*
from 
SOURCE.SRC_F_WEATHER 
where "YEAR" IN (1987);


CREATE TABLE SOURCE.F_WEATHER 
(	STATION_ID VARCHAR2(50 BYTE), 
"DATE" VARCHAR2(50 BYTE), 
ELEMENT VARCHAR2(50 BYTE), 
DATA_VALUE VARCHAR2(50 BYTE), 
M_FLAG VARCHAR2(1 BYTE), 
Q_FLAG VARCHAR2(1 BYTE), 
S_FLAG VARCHAR2(1 BYTE), 
OBS_TIME VARCHAR2(50 BYTE),
"YEAR" NUMBER
) TABLESPACE SOURCE ;



