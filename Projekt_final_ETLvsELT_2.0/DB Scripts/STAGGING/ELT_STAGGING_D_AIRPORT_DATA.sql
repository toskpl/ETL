DROP TABLE HD_STAGGING.STG_D_AIRPORT_TEMP;
DROP TABLE HD_STAGGING.STG_D_AIRPORT_SKEY_TEMP;
DROP TABLE HD_STAGGING.STG_D_AIRPORT;

--------------------------------------------------------
--  Table SRC_D_AIRPORT_TEMP
--------------------------------------------------------

  CREATE TABLE HD_STAGGING.STG_D_AIRPORT_TEMP
   (	
  IATA VARCHAR2(50)
	,AIRPORT VARCHAR2(50)
	,CITY VARCHAR2(50) 
	,STATE VARCHAR2(50)
	,COUNTRY VARCHAR2(50)
	,LAT VARCHAR2(50)
	,LONGS VARCHAR2(50)
   ) ;

-----------------------------------------------------------------
--    STG_V_D_AIRPORT_TEMP_SKEY_L, dodanie Source Key do tablicy
-----------------------------------------------------------------

CREATE OR REPLACE FORCE VIEW HD_STAGGING.STG_V_D_AIRPORT_TEMP_SKEY_L 
(
DWH_SOURCE_KEY
,DWH_VALID_FROM
,IATA
,AIRPORT
,CITY 
,STATE_CODE
,STATE_NAME
,COUNTRY
,LAT
,LONGS
) AS SELECT 
 a.IATA as DWH_SOURCE_KEY
,sysdate as DWH_VALID_FROM
,a.IATA
,a.AIRPORT
,a.CITY 
,a.STATE
,s.NAME
,a.COUNTRY
,a.LAT
,a.LONGS
FROM HD_STAGGING.STG_D_AIRPORT_TEMP a LEFT JOIN HD_STAGGING.STG_D_STATES_TEMP s ON a.STATE = s.CODE;


--------------------------------------------------------
--  Table STG_D_AIRPORT
--------------------------------------------------------

  CREATE TABLE HD_STAGGING.STG_D_AIRPORT
   (	
   DWH_SOURCE_KEY VARCHAR2(50)
  ,DWH_DELETE_FLAG VARCHAR2(1)
  ,DWH_INSERT_FLAG VARCHAR2(1)
  ,DWH_VALID_FROM DATE
  ,IATA VARCHAR2(50)
	,AIRPORT VARCHAR2(50)
	,CITY VARCHAR2(50) 
  ,STATE_CODE VARCHAR2(50) 
  ,STATE_NAME VARCHAR2(50) 
	,COUNTRY VARCHAR2(50)
	,LAT VARCHAR2(50)
	,LONGS VARCHAR2(50)
   ) ;


-----------------------------------------------------------------
--    HD_STAGGING.STG_V_D_AIRPORT_TEMP_L, usuniecie duplikatow,delta
-----------------------------------------------------------------
CREATE OR REPLACE FORCE VIEW HD_STAGGING.STG_V_D_AIRPORT_TEMP_L 
(
 DWH_SOURCE_KEY
,DWH_DELETE_FLAG
,DWH_INSERT_FLAG
,DWH_VALID_FROM
,IATA
,AIRPORT
,CITY
,STATE_CODE
,STATE_NAME
,COUNTRY
,LAT
,LONGS
) AS
SELECT 
nvl(new.DWH_SOURCE_KEY, old.DWH_SOURCE_KEY) as DWH_SOURCE_KEY 
,CASE WHEN new.DWH_SOURCE_KEY is null AND old.DWH_DELETE_FLAG='f' THEN 't' ELSE 'f' END DWH_DELETE_FLAG
,CASE WHEN new.DWH_SOURCE_KEY is not null AND old.DWH_SOURCE_KEY is null THEN 't' ELSE 'f' END DWH_INSERT_FLAG
,new.DWH_VALID_FROM
,new.IATA
,new.AIRPORT
,new.CITY
,new.STATE_CODE
,new.STATE_NAME
,new.COUNTRY
,new.LAT
,new.LONGS
FROM 
HD_STAGGING.STG_V_D_AIRPORT_TEMP_SKEY_L new
FULL JOIN HD2.D_AIRPORT old ON new.DWH_SOURCE_KEY = old.DWH_SOURCE_KEY
WHERE
new.DWH_SOURCE_KEY is null AND old.DWH_DELETE_FLAG='f' OR new.DWH_SOURCE_KEY is not null AND old.DWH_SOURCE_KEY is null
group by -- remove duplicates
nvl(new.DWH_SOURCE_KEY, old.DWH_SOURCE_KEY)
,CASE WHEN new.DWH_SOURCE_KEY is null AND old.DWH_DELETE_FLAG='f' THEN 't' ELSE 'f' END
,CASE WHEN new.DWH_SOURCE_KEY is not null AND old.DWH_SOURCE_KEY is null THEN 't' ELSE 'f' END
,new.DWH_VALID_FROM
,new.IATA
,new.AIRPORT
,new.CITY
,new.STATE_CODE
,new.STATE_NAME
,new.COUNTRY
,new.LAT
,new.LONGS;


-----------------------------------------------------------------
--    HD_STAGGING.STG_V_D_AIRPORT_L, modifikacja attrybuow do postaci finalnej
-----------------------------------------------------------------

CREATE OR REPLACE FORCE VIEW HD_STAGGING.STG_V_D_AIRPORT_L 
(
DWH_ID
,DWH_SOURCE_KEY
,DWH_DELETE_FLAG
,DWH_VALID_FROM
,IATA
,AIRPORT
,CITY
,STATE_CODE
,STATE_NAME
,COUNTRY
,LAT
,LONGS
) AS
with 
x as(
  select nvl(max(DWH_ID),0) x 
  from HD2.D_AIRPORT),
m as (
SELECT 
DWH_SOURCE_KEY
,DWH_DELETE_FLAG
,DWH_VALID_FROM
,IATA
,AIRPORT
,CITY
,STATE_CODE
,STATE_NAME
,COUNTRY
,CASE WHEN REGEXP_LIKE(LAT,'[A-Z]') THEN null ELSE LAT END as LAT
,CASE WHEN REGEXP_LIKE(LONGS,'[A-Z]') THEN null ELSE LONGS END as LONGS
FROM 
HD_STAGGING.STG_D_AIRPORT
)
SELECT x+rownum as DWH_ID
,m.*
from x cross join m;






