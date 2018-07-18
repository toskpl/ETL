--------------------------------------------------------
--  DDL for Table STG_F_WEATHER_TEMP
--------------------------------------------------------
drop table stg_f_weather_temp;

  CREATE TABLE HD_STAGGING.STG_F_WEATHER_TEMP (	
   STATION_ID VARCHAR2(50)
	,WDATE VARCHAR2(50)
	,WELEMENT VARCHAR2(50) 
	,DATA_VALUE VARCHAR2(50)
	,M_FLAG VARCHAR2(1)
	,Q_FLAG VARCHAR2(1)
	,S_FLAG VARCHAR2(1)
	,OBS_TIME VARCHAR2(50)
	,WYEAR NUMBER
   );
   

-----------------------------------------------------------------
--    STG_V_STG_F_WEATHER_SKEY_L, add Source Key to table
-----------------------------------------------------------------

CREATE OR REPLACE FORCE VIEW HD_STAGGING.STG_V_F_WEATHER_SKEY_L 
(
DWH_SOURCE_KEY
,DWH_VALID_FROM
,STATION_ID
,WDATE
,WELEMENT
,DATA_VALUE
,M_FLAG
,Q_FLAG
,S_FLAG
,OBS_TIME
,WYEAR 
) AS SELECT 
 STATION_ID || WELEMENT || WDATE as DWH_SOURCE_KEY
,sysdate as DWH_VALID_FROM
,STATION_ID
,WDATE
,WELEMENT
,DATA_VALUE
,M_FLAG
,Q_FLAG
,S_FLAG
,OBS_TIME
,WYEAR 
FROM HD_STAGGING.STG_F_WEATHER_TEMP;




-----------------------------------------------------------------
--    STG_V_F_WEATHER_L, remove duplicates, delta to table
-----------------------------------------------------------------

CREATE OR REPLACE FORCE VIEW HD_STAGGING.STG_V_F_WEATHER_L 
(
 DWH_SOURCE_KEY
,DWH_DELETE_FLAG
,DWH_INSERT_FLAG
,DWH_VALID_FROM
,STATION_ID
,WDATE
,WELEMENT
,DATA_VALUE
,M_FLAG
,Q_FLAG
,S_FLAG
,OBS_TIME
,WYEAR 
) AS SELECT 
nvl(new.DWH_SOURCE_KEY, old.DWH_SOURCE_KEY) as DWH_SOURCE_KEY 
,CASE WHEN new.DWH_SOURCE_KEY is null AND old.DWH_DELETE_FLAG='f' THEN 't' ELSE 'f' END DWH_DELETE_FLAG
,CASE WHEN new.DWH_SOURCE_KEY is not null AND old.DWH_SOURCE_KEY is null THEN 't' ELSE 'f' END DWH_INSERT_FLAG
,new.DWH_VALID_FROM
,new.STATION_ID
,new.WDATE
,new.WELEMENT
,new.DATA_VALUE
,new.M_FLAG
,new.Q_FLAG
,new.S_FLAG
,new.OBS_TIME
,new.WYEAR 
FROM HD_STAGGING.STG_V_F_WEATHER_SKEY_L new FULL JOIN HD2.F_WEATHER old ON new.DWH_SOURCE_KEY = old.DWH_SOURCE_KEY
WHERE
new.DWH_SOURCE_KEY is null AND old.DWH_DELETE_FLAG='f' OR new.DWH_SOURCE_KEY is not null AND old.DWH_SOURCE_KEY is null
group by -- remove duplicates
nvl(new.DWH_SOURCE_KEY, old.DWH_SOURCE_KEY)
,CASE WHEN new.DWH_SOURCE_KEY is null AND old.DWH_DELETE_FLAG='f' THEN 't' ELSE 'f' END
,CASE WHEN new.DWH_SOURCE_KEY is not null AND old.DWH_SOURCE_KEY is null THEN 't' ELSE 'f' END
,new.DWH_VALID_FROM
,new.STATION_ID
,new.WDATE
,new.WELEMENT
,new.DATA_VALUE
,new.M_FLAG
,new.Q_FLAG
,new.S_FLAG
,new.OBS_TIME
,new.WYEAR;



--------------------------------------------------------
--  DDL for Table STG_F_WEATHER
--------------------------------------------------------
drop table HD_STAGGING.STG_F_WEATHER;

  CREATE TABLE HD_STAGGING.STG_F_WEATHER (	
   DWH_SOURCE_KEY VARCHAR2(50)
  ,DWH_DELETE_FLAG VARCHAR2(1)
  ,DWH_INSERT_FLAG VARCHAR2(1)
  ,DWH_VALID_FROM DATE
  ,STATION_ID VARCHAR2(50)
	,WDATE VARCHAR2(50)
	,WELEMENT VARCHAR2(50) 
	,DATA_VALUE VARCHAR2(50)
	,M_FLAG VARCHAR2(1)
	,Q_FLAG VARCHAR2(1)
	,S_FLAG VARCHAR2(1)
	,OBS_TIME VARCHAR2(50)
	,WYEAR NUMBER
   );
   

-----------------------------------------------------------------
--    HD_STAGGING.STG_V_F_WEATHER_L, FK, modify attributes to final shape
-----------------------------------------------------------------

CREATE OR REPLACE FORCE VIEW HD_STAGGING.STG_V_F_WEATHER_HD_L 
(
DWH_ID
,DWH_SOURCE_KEY
,DWH_DELETE_FLAG
,DWH_VALID_FROM
,FK_STATION_ID
,FK_OBS_TIME
,STATION_ID
,WDATE
,WELEMENT
,DATA_VALUE
,M_FLAG
,Q_FLAG
,S_FLAG
,OBS_TIME
,WYEAR 
) AS
with 
x as(
  select nvl(max(DWH_ID),0) x 
  from HD2.F_WEATHER),
m as (
SELECT 
f.DWH_SOURCE_KEY
,f.DWH_DELETE_FLAG
,f.DWH_VALID_FROM
,d.DWH_ID FK_STATION_ID
,to_number(f.WDATE) as FK_OBS_TIME
,f.STATION_ID
,f.WDATE
,f.WELEMENT
,f.DATA_VALUE
,f.M_FLAG
,f.Q_FLAG
,f.S_FLAG
,f.OBS_TIME
,f.WYEAR 
FROM 
HD_STAGGING.STG_F_WEATHER f LEFT JOIN HD2.D_STATIONS d ON f.STATION_ID = d.ID
)
SELECT x+rownum as DWH_ID
,m.*
from x cross join m;
 
 
 


   