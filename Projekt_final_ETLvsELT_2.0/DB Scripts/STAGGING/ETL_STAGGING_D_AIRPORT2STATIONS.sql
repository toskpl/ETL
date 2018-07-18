--------------------------------------------------------
--  Function - calculate distance between airport and stations, in KM
--------------------------------------------------------

CREATE OR REPLACE FUNCTION distance (Lat1 IN NUMBER,
                                     Lon1 IN NUMBER,
                                     Lat2 IN NUMBER,
                                     Lon2 IN NUMBER,
                                     Radius IN NUMBER DEFAULT 6387.7) RETURN NUMBER IS
 -- Convert degrees to radians
 DegToRad NUMBER := 57.29577951;

BEGIN
  RETURN(NVL(Radius,0) * ACOS((sin(NVL(Lat1,0) / DegToRad) * SIN(NVL(Lat2,0) / DegToRad)) +
        (COS(NVL(Lat1,0) / DegToRad) * COS(NVL(Lat2,0) / DegToRad) *
         COS(NVL(Lon2,0) / DegToRad - NVL(Lon1,0)/ DegToRad))));
END;
/

--------------------------------------------------------
--  Table STG_D_AIRPORT2STATIONS_TEMP 
--------------------------------------------------------
DROP TABLE ETL_STAGGING.STG_D_AIRPORT2STATIONS_TEMP;

CREATE TABLE ETL_STAGGING.STG_D_AIRPORT2STATIONS_TEMP (  
DWH_SOURCE_KEY VARCHAR2(50)
,DWH_DELETE_FLAG VARCHAR2(1)
,DWH_INSERT_FLAG VARCHAR2(1)
,DWH_VALID_FROM DATE
,FK_STATION_ID NUMBER 
,FK_AIRPORT_ID NUMBER
,DISTANCE VARCHAR2(30)
);

--------------------------------------------------------
--  Table STG_D_AIRT2STANS_SKEY_TEMP 
--------------------------------------------------------
DROP TABLE ETL_STAGGING.STG_D_AIRT2STANS_SKEY_TEMP  ;

CREATE TABLE ETL_STAGGING.STG_D_AIRT2STANS_SKEY_TEMP (  
DWH_SOURCE_KEY VARCHAR2(50)
,FK_STATION_ID NUMBER 
,FK_AIRPORT_ID NUMBER
,DISTANCE NUMBER
);

--------------------------------------------------------
--  Table STG_D_AIRT2STANS_SKEY_TEMP 
--------------------------------------------------------
DROP TABLE ETL_STAGGING.STG_D_AIRT2STANS  ;

CREATE TABLE ETL_STAGGING.STG_D_AIRT2STANS (  
DWH_SOURCE_KEY VARCHAR2(50)
,FK_STATION_ID NUMBER 
,FK_AIRPORT_ID NUMBER
,DISTANCE NUMBER
);