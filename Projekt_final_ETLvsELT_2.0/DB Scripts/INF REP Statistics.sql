-----------------------------------------------------------------
--    export WF statistics from Informatica repository
-----------------------------------------------------------------
with a as (
  select max(WORKFLOW_RUN_ID) as maxWORKFLOW_RUN_ID from REP_SESS_LOG
)
select 
WORKFLOW_RUN_ID as WF_RUN_ID
,WORKFLOW_NAME as WF
,wl.TASK_NAME as WL_NAME
,SESSION_NAME as TASK_NAME
--,ACTUAL_START as START_TIME
--,SESSION_TIMESTAMP as END_TIME
,SUCCESSFUL_SOURCE_ROWS as SOURCE_SUCC_ROWS
,SUCCESSFUL_ROWS as TARGET_SUCC_ROWS
,wljoin.TASK_ID
,round((SESSION_TIMESTAMP-ACTUAL_START)*24*60*60,4) as "JOB_TIME (s)"
,round((SESSION_TIMESTAMP-ACTUAL_START)*24*60,2) as "JOB_TIME (m)"

from REP_SESS_LOG m cross join a left join opb_task wljoin on wljoin.TASK_ID = SESSION_ID left join opb_task wl on wljoin.RU_PARENT_ID = wl.TASK_ID
where 
WORKFLOW_NAME IN ('WF_ETL','WF_ELT')
and WORKFLOW_RUN_ID = a.maxWORKFLOW_RUN_ID
order by WORKFLOW_RUN_ID,WORKLET_RUN_ID,INSTANCE_ID;



-----------------------------------------------------------------
--    export WF statistics from Informatica repository, grouped on Worklet
----------------------------------------------------------------- 
with a as (
  select max(WORKFLOW_RUN_ID) as maxWORKFLOW_RUN_ID from REP_SESS_LOG
)
select 
WORKFLOW_RUN_ID as WF_RUN_ID
,WORKFLOW_NAME as WF
,wl.TASK_NAME as WL_NAME
--,SESSION_NAME as TASK_NAME
--,ACTUAL_START as START_TIME
--,SESSION_TIMESTAMP as END_TIME
--,min(ACTUAL_START ) as START_TIME
--,max(SESSION_TIMESTAMP) as END_TIME
,SUM(SUCCESSFUL_SOURCE_ROWS) as SOURCE_SUCC_ROWS
,SUM(SUCCESSFUL_ROWS) as TARGET_SUCC_ROWS
,sum(round((SESSION_TIMESTAMP-ACTUAL_START)*24*60*60,4)) as "JOB_TIME (s)"
,sum(round((SESSION_TIMESTAMP-ACTUAL_START)*24*60,2)) as "JOB_TIME (m)"

from REP_SESS_LOG m cross join a left join opb_task wljoin on wljoin.TASK_ID = SESSION_ID left join opb_task wl on wljoin.RU_PARENT_ID = wl.TASK_ID
where 
WORKFLOW_NAME IN ('WF_ETL','WF_ELT')
and WORKFLOW_RUN_ID = a.maxWORKFLOW_RUN_ID
GROUP BY
WORKFLOW_NAME
,wl.TASK_NAME;



---------
--ETL
--1. I Flow, where year=1987


