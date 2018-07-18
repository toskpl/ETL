Create table D_CALENDAR as (
SELECT TO_NUMBER (TO_CHAR (mydate, 'yyyymmdd')) AS date_key,
       mydate AS date_time_start,
       mydate + 1 - 1/86400 AS date_time_end,
       TO_CHAR (mydate, 'dd-MON-yyyy') AS date_value,
       TO_NUMBER (TO_CHAR (mydate, 'D')) AS day_of_week_number,
       TO_CHAR (mydate, 'Day') AS day_of_week_desc,
       TO_CHAR (mydate, 'DY') AS day_of_week_sdesc,
       CASE WHEN TO_NUMBER (TO_CHAR (mydate, 'D')) IN (1, 7) THEN 1
            ELSE 0
       END AS weekend_flag,
       TO_NUMBER (TO_CHAR (mydate, 'W')) AS week_in_month_number,
       TO_NUMBER (TO_CHAR (mydate, 'WW')) AS week_in_year_number,
       TRUNC(mydate, 'w') AS week_start_date,
       TRUNC(mydate, 'w') + 7 - 1/86400 AS week_end_date,
       TO_NUMBER (TO_CHAR (mydate, 'IW')) AS iso_week_number,
       TRUNC(mydate, 'iw') AS iso_week_start_date,
       TRUNC(mydate, 'iw') + 7 - 1/86400 AS iso_week_end_date,
       TO_NUMBER (TO_CHAR (mydate, 'DD')) AS day_of_month_number,
       TO_CHAR (mydate, 'MM') AS month_value,
       TO_CHAR (mydate, 'Month') AS month_desc,
       TO_CHAR (mydate, 'MON') AS month_sdesc,
       TRUNC (mydate, 'mm') AS month_start_date,
       LAST_DAY (TRUNC (mydate, 'mm')) + 1 - 1/86400 AS month_end_date,
       TO_NUMBER ( TO_CHAR( LAST_DAY (TRUNC (mydate, 'mm')), 'DD')) AS days_in_month,
       CASE WHEN mydate = LAST_DAY (TRUNC (mydate, 'mm')) THEN 1
            ELSE 0
       END AS last_day_of_month_flag,
       TRUNC (mydate) - TRUNC (mydate, 'Q') + 1 AS day_of_quarter_number,
       TO_CHAR (mydate, 'Q') AS quarter_value,
       'Q' || TO_CHAR (mydate, 'Q') AS quarter_desc,
       TRUNC (mydate, 'Q') AS quarter_start_date,
       ADD_MONTHS (TRUNC (mydate, 'Q'), 3) - 1/86400 AS quarter_end_date,
       ADD_MONTHS (TRUNC (mydate, 'Q'), 3) - TRUNC (mydate, 'Q') AS days_in_quarter,
       CASE WHEN mydate = ADD_MONTHS (TRUNC (mydate, 'Q'), 3) - 1 THEN 1
            ELSE 0
       END AS last_day_of_quarter_flag,
       TO_NUMBER (TO_CHAR (mydate, 'DDD')) AS day_of_year_number,
       TO_CHAR (mydate, 'yyyy') AS year_value,
       'YR' || TO_CHAR (mydate, 'yyyy') AS year_desc,
       'YR' || TO_CHAR (mydate, 'yy') AS year_sdesc,
       TRUNC (mydate, 'Y') AS year_start_date,
       ADD_MONTHS (TRUNC (mydate, 'Y'), 12) - 1/86400 AS year_end_date,
       ADD_MONTHS (TRUNC (mydate, 'Y'), 12) - TRUNC (mydate, 'Y') AS days_in_year
  FROM ( SELECT TRUNC (ADD_MONTHS (SYSDATE, -324), 'yy') - 1 + LEVEL AS mydate
           FROM dual
         CONNECT BY LEVEL <= 18200
       ));
