truncate table ETL_STAGGING.STG_D_AIRPORT_TEMP;
truncate table ETL_STAGGING.STG_D_AIRPORT;

DROP TABLE ETL_STAGGING.STG_D_AIRPORT_TEMP;
DROP TABLE ETL_STAGGING.STG_D_AIRPORT;

--------------------------------------------------------
--  Table STG_D_AIRPORT_TEMP
--------------------------------------------------------

  CREATE TABLE ETL_STAGGING.STG_D_AIRPORT_TEMP
   (	
  IATA VARCHAR2(50)
	,AIRPORT VARCHAR2(50)
	,CITY VARCHAR2(50) 
	,STATE VARCHAR2(50)
	,COUNTRY VARCHAR2(50)
	,LAT VARCHAR2(50)
	,LONGS VARCHAR2(50)
   ) ;

--------------------------------------------------------
--  Table STG_D_AIRPORT
--------------------------------------------------------

  CREATE TABLE ETL_STAGGING.STG_D_AIRPORT
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