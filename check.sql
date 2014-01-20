-- Acquire session information (2013.01.21)
set echo off
set feed off
set heading off
set pagesize 0
set linesize 200
set trimspool on
set termout off

select to_char(sysdate, 'yyyy/mm/dd hh24:mi:ss') from dual;


select round(avg(memory)*count(*)/2/1024/1024,3) PGA_MEM from (
 select s.sid,n.name,max(s.value) memory
   from v$sesstat s,v$statname n
   where n.statistic# = s.statistic#
   and   n.name in ('session pga memory','session pga memory max')
   group by n.name,s.sid
 );

SELECT SUM(V.BYTES)/1024/1024 FROM V$SGAINFO V
WHERE V.NAME IN(
'Shared Pool Size'
,'Buffer Cache Size'
,'Large Pool Size'
,'Java Pool Size'
,'Fixed SGA Size'
,'Redo Buffers'
,'Streams Pool Size'
)
union all
SELECT SUM(V.BYTES)/1024/1024 FROM V$SGAINFO V
WHERE V.NAME IN( 'Shared Pool Size')
union all
SELECT SUM(V.BYTES)/1024/1024 FROM V$SGAINFO V
WHERE V.NAME IN('Buffer Cache Size')
union all
SELECT SUM(V.BYTES)/1024/1024 FROM V$SGAINFO V
WHERE V.NAME IN('Large Pool Size')
union all
SELECT SUM(V.BYTES)/1024/1024 FROM V$SGAINFO V
WHERE V.NAME IN('Java Pool Size')
union all
SELECT SUM(V.BYTES)/1024/1024 FROM V$SGAINFO V
WHERE V.NAME IN(
'Fixed SGA Size'
,'Redo Buffers'
,'Streams Pool Size'
);

-- cache hit rate
SELECT (1-c.value/(a.value + b.value))*100 cache_hit_rate
FROM V$SYSSTAT a,V$SYSSTAT b,V$SYSSTAT c
WHERE a.name IN ('db block gets from cache') AND b.name IN ( 'consistent gets from cache') and c.name IN('physical reads cache');

-- sessions which status are active and not background process
SELECT COUNT(STATUS)
FROM V$SESSION
WHERE STATUS IN('ACTIVE','INACTIVE') AND TYPE='USER' AND USERNAME IS NOT NULL;
