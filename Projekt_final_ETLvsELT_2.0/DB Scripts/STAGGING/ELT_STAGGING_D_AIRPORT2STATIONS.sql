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
DROP TABLE HD_STAGGING.STG_D_AIRPORT2STATIONS_TEMP  ;

CREATE TABLE HD_STAGGING.STG_D_AIRPORT2STATIONS_TEMP (  
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
DROP TABLE HD_STAGGING.STG_D_AIRT2STANS_SKEY_TEMP  ;

CREATE TABLE HD_STAGGING.STG_D_AIRT2STANS_SKEY_TEMP (  
DWH_SOURCE_KEY VARCHAR2(50)
,FK_STATION_ID NUMBER 
,FK_AIRPORT_ID NUMBER
,DISTANCE NUMBER
);

--------------------------------------------------------
--  Table STG_D_AIRPORT2STATIONS
--------------------------------------------------------
DROP TABLE HD_STAGGING.STG_D_AIRPORT2STATIONS;

CREATE TABLE HD_STAGGING.STG_D_AIRPORT2STATIONS (  
DWH_SOURCE_KEY VARCHAR2(50)
,DWH_DELETE_FLAG VARCHAR2(1)
,DWH_INSERT_FLAG VARCHAR2(1)
,DWH_VALID_FROM DATE
,FK_STATION_ID NUMBER 
,FK_AIRPORT_ID NUMBER
,DISTANCE NUMBER
);


-----------------------------------------------------------------
--    HD_STAGGING.STG_D_V_AIRPORT2STATNS_D_TEMP_L , join two tables, create skey
-----------------------------------------------------------------
CREATE OR REPLACE FORCE VIEW HD_STAGGING.STG_D_V_AIRT2STANS_SKEY_TEMP_L (
DWH_SOURCE_KEY
,FK_STATION_ID 
,FK_AIRPORT_ID
,DISTANCE
) AS
SELECT 
a.STATE_CODE||a.IATA||s.ID as DWH_SOURCE_KEY
,s.DWH_ID as FK_STATION_ID
,a.DWH_ID as FK_AIRPORT_ID
,round(distance(to_number(s.LATITUDE,'999.99999999'),to_number(s.LONGITUDE,'999.99999999'),to_number(a.LAT,'999.99999999'),to_number(a.LONGS,'999.99999999')),5) as DISTANCE
FROM HD2.D_AIRPORT a INNER JOIN HD2.D_STATIONS s ON a.STATE_CODE = s.STATE_CODE;

-----------------------------------------------------------------
--    HD_STAGGING.STG_D_V_AIRPORT2STATNS_D_TEMP_L , delta load
-----------------------------------------------------------------
CREATE OR REPLACE FORCE VIEW HD_STAGGING.STG_D_V_AIRT2STANS_L (
DWH_SOURCE_KEY
,DWH_DELETE_FLAG
,DWH_INSERT_FLAG
,DWH_VALID_FROM
,FK_STATION_ID 
,FK_AIRPORT_ID
,DISTANCE
) AS
SELECT 
nvl(new.DWH_SOURCE_KEY, old.DWH_SOURCE_KEY) as DWH_SOURCE_KEY 
,CASE WHEN new.DWH_SOURCE_KEY is null AND old.DWH_DELETE_FLAG='f' THEN 't' ELSE 'f' END DWH_DELETE_FLAG
,CASE WHEN new.DWH_SOURCE_KEY is not null AND old.DWH_SOURCE_KEY is null THEN 't' ELSE 'f' END DWH_INSERT_FLAG
,sysdate as DWH_VALID_FROM
,new.FK_STATION_ID
,new.FK_AIRPORT_ID 
,new.DISTANCE
FROM 
HD_STAGGING.STG_D_AIRT2STANS_SKEY_TEMP new FULL JOIN  HD_STAGGING.STG_D_AIRPORT2STATIONS old ON new.DWH_SOURCE_KEY = old.DWH_SOURCE_KEY
WHERE
new.DWH_SOURCE_KEY is null AND old.DWH_DELETE_FLAG='f' OR new.DWH_SOURCE_KEY is not null AND old.DWH_SOURCE_KEY is null;




-----------------------------------------------------------------
--    HD_STAGGING.STG_D_V_AIRPORT2STATNS_D_TEMP_L , find min distance between airport and station, load to hd2
-----------------------------------------------------------------
CREATE OR REPLACE FORCE VIEW HD_STAGGING.STG_D_V_AIRT2STANS_HD_L (
DWH_ID
,DWH_SOURCE_KEY
,DWH_DELETE_FLAG
,DWH_INSERT_FLAG
,DWH_VALID_FROM
,FK_STATION_ID 
,FK_AIRPORT_ID
,DISTANCE
) AS 
with
x as(
  select nvl(max(DWH_ID),0) x 
  from HD2.D_AIRPORT2STATIONS),
m as (
SELECT distinct
first_value(DWH_SOURCE_KEY ) over (partition by FK_AIRPORT_ID order by DISTANCE) as DWH_SOURCE_KEY
,DWH_DELETE_FLAG
,DWH_VALID_FROM
,first_value(FK_STATION_ID ) over (partition by FK_AIRPORT_ID order by DISTANCE) as FK_STATION_ID
,FK_AIRPORT_ID
,min(DISTANCE) over (partition by FK_AIRPORT_ID) as DISTANCE
FROM STG_D_AIRPORT2STATIONS
)
SELECT x+rownum as DWH_ID
,nvl(new.DWH_SOURCE_KEY, old.DWH_SOURCE_KEY) as DWH_SOURCE_KEY 
,CASE WHEN new.DWH_SOURCE_KEY is null AND old.DWH_DELETE_FLAG='f' THEN 't' ELSE 'f' END DWH_DELETE_FLAG
,CASE WHEN new.DWH_SOURCE_KEY is not null AND old.DWH_SOURCE_KEY is null THEN 't' ELSE 'f' END DWH_INSERT_FLAG
,sysdate as DWH_VALID_FROM
,new.FK_STATION_ID
,new.FK_AIRPORT_ID
,new.DISTANCE
from x cross join m new FULL JOIN HD2.D_AIRPORT2STATIONS old ON new.DWH_SOURCE_KEY = old.DWH_SOURCE_KEY
WHERE
new.DWH_SOURCE_KEY is null AND old.DWH_DELETE_FLAG='f' OR new.DWH_SOURCE_KEY is not null AND old.DWH_SOURCE_KEY is null;


