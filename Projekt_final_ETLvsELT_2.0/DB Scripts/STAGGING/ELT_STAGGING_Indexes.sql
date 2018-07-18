CREATE UNIQUE INDEX HD_STAGGING."STAT_ID_UNIQUE_IDX" ON HD_STAGGING."D_STATIONS" ("ID") 
TABLESPACE HD_STAGGING ;
CREATE BITMAP INDEX HD_STAGGING."STAT_STATE_BITMAP_IDX" ON HD_STAGGING."D_STATIONS" ("STATE") 
TABLESPACE HD_STAGGING ;

CREATE BITMAP INDEX HD_STAGGING."FL_UNIQUECARRIER_BITMAP_IDX" ON HD_STAGGING."F_FLIGHTS" ("UNIQUECARRIER") 
TABLESPACE HD_STAGGING ;
CREATE BITMAP INDEX HD_STAGGING."FL_ORIGIN_BITMAP_IDX" ON HD_STAGGING."F_FLIGHTS" ("ORIGIN") 
TABLESPACE HD_STAGGING ;
CREATE BITMAP INDEX HD_STAGGING."FL_DEST_BITMAP_IDX" ON HD_STAGGING."F_FLIGHTS" ("DEST") 
TABLESPACE HD_STAGGING ;
CREATE BITMAP INDEX HD_STAGGING."FL_YEAR_BITMAP_IDX" ON HD_STAGGING."F_FLIGHTS" ("YEAR") 
TABLESPACE HD_STAGGING ;
CREATE BITMAP INDEX HD_STAGGING."FL_TAILNUM_BITMAP_IDX" ON HD_STAGGING."F_FLIGHTS" ("TAILNUM") 
TABLESPACE HD_STAGGING ;

CREATE INDEX HD_STAGGING."W_STATION_ID_IDX" ON HD_STAGGING."F_WEATHER" ("STATION_ID") 
TABLESPACE HD_STAGGING ;
CREATE INDEX HD_STAGGING."W_DATE_IDX" ON HD_STAGGING."F_WEATHER" ("DATE") 
TABLESPACE HD_STAGGING ;




