--------------------------------------------------------
--  Table STG_D_STATIONS_TEMP 
--------------------------------------------------------
DROP TABLE HD_STAGGING.STG_D_STATIONS_TEMP  ;

CREATE TABLE HD_STAGGING.STG_D_STATIONS_TEMP (  
ID VARCHAR2(11), 
LATITUDE VARCHAR2(10), 
LONGITUDE VARCHAR2(15), 
ELEVATION VARCHAR2(15), 
STATE VARCHAR2(2), 
NAME VARCHAR2(30), 
GSNFLAG VARCHAR2(3), 
HCNFLAG VARCHAR2(3), 
WMOID VARCHAR2(5)
);


-----------------------------------------------------------------
--    STG_V_D_STATIONS_TEMP_SKEY_L, dodanie Source Key do tablicy
-----------------------------------------------------------------

CREATE OR REPLACE FORCE VIEW HD_STAGGING.STG_V_D_STATIONS_TEMP_SKEY_L (
DWH_SOURCE_KEY
,DWH_VALID_FROM
,ID
,LATITUDE
,LONGITUDE
,ELEVATION 
,STATE_CODE
,STATE_NAME
,NAME 
,GSNFLAG
,HCNFLAG
,WMOID
) AS SELECT 
 a.ID as DWH_SOURCE_KEY
,sysdate as DWH_VALID_FROM
,a.ID
,a.LATITUDE
,a.LONGITUDE
,a.ELEVATION 
,a.STATE
,s.NAME
,a.NAME 
,a.GSNFLAG
,a.HCNFLAG
,a.WMOID
FROM HD_STAGGING.STG_D_STATIONS_TEMP a LEFT JOIN HD_STAGGING.STG_D_STATES_TEMP s ON a.STATE = s.CODE;


--------------------------------------------------------
--  Table STG_D_STATIONS
--------------------------------------------------------
DROP TABLE HD_STAGGING.STG_D_STATIONS;

CREATE TABLE HD_STAGGING.STG_D_STATIONS (	
DWH_SOURCE_KEY VARCHAR2(50)
,DWH_DELETE_FLAG VARCHAR2(1)
,DWH_INSERT_FLAG VARCHAR2(1)
,DWH_VALID_FROM DATE
,ID VARCHAR2(11)
,LATITUDE VARCHAR2(15)
,LONGITUDE VARCHAR2(15)
,ELEVATION VARCHAR2(10)
,STATE_CODE VARCHAR2(2)
,STATE_NAME VARCHAR2(30)
,NAME VARCHAR2(30) 
,GSNFLAG VARCHAR2(3)
,HCNFLAG VARCHAR2(3)
,WMOID VARCHAR2(5)
) ;




-----------------------------------------------------------------
--    HD_STAGGING.STG_V_D_STATIONS_TEMP_L, usuniecie duplikatow,delta
-----------------------------------------------------------------
CREATE OR REPLACE FORCE VIEW HD_STAGGING.STG_V_D_STATIONS_TEMP_L 
(
 DWH_SOURCE_KEY
,DWH_DELETE_FLAG
,DWH_INSERT_FLAG
,DWH_VALID_FROM
,ID
,LATITUDE
,LONGITUDE
,ELEVATION 
,STATE_CODE
,STATE_NAME
,NAME 
,GSNFLAG
,HCNFLAG
,WMOID
) AS
SELECT 
nvl(new.DWH_SOURCE_KEY, old.DWH_SOURCE_KEY) as DWH_SOURCE_KEY 
,CASE WHEN new.DWH_SOURCE_KEY is null AND old.DWH_DELETE_FLAG='f' THEN 't' ELSE 'f' END DWH_DELETE_FLAG
,CASE WHEN new.DWH_SOURCE_KEY is not null AND old.DWH_SOURCE_KEY is null THEN 't' ELSE 'f' END DWH_INSERT_FLAG
,new.DWH_VALID_FROM
,new.ID
,new.LATITUDE
,new.LONGITUDE
,new.ELEVATION 
,new.STATE_CODE
,new.STATE_NAME
,new.NAME 
,new.GSNFLAG
,new.HCNFLAG
,new.WMOID
FROM 
HD_STAGGING.STG_V_D_STATIONS_TEMP_SKEY_L new
FULL JOIN HD2.D_STATIONS old ON new.DWH_SOURCE_KEY = old.DWH_SOURCE_KEY
WHERE
new.DWH_SOURCE_KEY is null AND old.DWH_DELETE_FLAG='f' OR new.DWH_SOURCE_KEY is not null AND old.DWH_SOURCE_KEY is null
group by -- remove duplicates
nvl(new.DWH_SOURCE_KEY, old.DWH_SOURCE_KEY) 
,CASE WHEN new.DWH_SOURCE_KEY is null AND old.DWH_DELETE_FLAG='f' THEN 't' ELSE 'f' END
,CASE WHEN new.DWH_SOURCE_KEY is not null AND old.DWH_SOURCE_KEY is null THEN 't' ELSE 'f' END
,new.DWH_VALID_FROM
,new.ID
,new.LATITUDE
,new.LONGITUDE
,new.ELEVATION 
,new.STATE_CODE
,new.STATE_NAME
,new.NAME 
,new.GSNFLAG
,new.HCNFLAG
,new.WMOID;




-----------------------------------------------------------------
--    HD_STAGGING.STG_V_D_STATIONS_L, modifikacja attrybuow do postaci finalnej
-----------------------------------------------------------------

CREATE OR REPLACE FORCE VIEW HD_STAGGING.STG_V_D_STATIONS_L 
(
DWH_ID
,DWH_SOURCE_KEY
,DWH_DELETE_FLAG
,DWH_VALID_FROM
,ID
,LATITUDE
,LONGITUDE
,ELEVATION 
,STATE_CODE
,STATE_NAME
,NAME 
,GSNFLAG
,HCNFLAG
,WMOID
) AS
with 
x as(
  select nvl(max(DWH_ID),0) x 
  from HD2.D_STATIONS),
m as (
SELECT 
DWH_SOURCE_KEY
,DWH_DELETE_FLAG
,DWH_VALID_FROM
,ID
,CASE WHEN REGEXP_LIKE(LATITUDE,'[A-Z]') THEN null ELSE LATITUDE END as LATITUDE
,CASE WHEN REGEXP_LIKE(LONGITUDE,'[A-Z]') THEN null ELSE LONGITUDE END as LONGITUDE
,ELEVATION
,STATE_CODE
,STATE_NAME
,NAME 
,GSNFLAG
,HCNFLAG
,WMOID
FROM 
HD_STAGGING.STG_D_STATIONS
)
SELECT x+rownum as DWH_ID
,m.*
from x cross join m;
 
