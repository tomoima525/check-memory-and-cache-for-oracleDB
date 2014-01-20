#Summary

+ This is a time sequencial performance visualizing tool for Oracle Database.
AWR and Statspack are common ways to monitor memory and session information of Oracle DB. However in some cases, they are unable to use.
This shell script can acquire performance data from Oracle's dictionary tables.
+ You will get output with rows.
+ Use as-is.

#Tools

+ check_mem_cache.sh              A main shell script
+ check_mem.env                   An environment file
+ check.sql                       A list of sql that run from check_mem_cache.sh

#How to use

## Set values to variables in the environment file
###<Variable in check_mem_cache.sh>
ENV_DIR   A directory where check_mem.env exists


###<Variables in check_mem.env>
EXE_DIR   A directory where the shell runs and dumps a log file. check.sql should be in this directory.  
ORA_SCHEMA an oracle schema which runs sql. The schema needs SYSDBA privilege.  
ORA_PASSWORD   A schema passwork  
ORA_NET_SERVICE_NAME   Net service name. Set value that is in tnsnames.ora.  
ORACLE_BASE  
ORACLE_HOME  

### Place the shell script,environment file and sql on a server
Place check_mem_cache.sh,check_mem.env,check.sql on a directory with a user which runs the shell script. .


Give permission to check_mem_cache.sh,check_mem.env,check.sql  
chmod 755 check_mem_cache.sh,,check_mem.env,check.sql  


###<Execute by manual>
Run check_mem_cache.sh arguments.  
Run in a background is preferred, since it uses standard output. Run in a foreground if you want to check logs.  

argument1    time interval(sec)  
argument2    counts  
argument3    name of instance(SID)  

###Example
Aquiring performance data of instance db_1 30 minutes(180counts) with 10 seconds time interval   
$ nohup /home/hoge/check_mem_cache.sh 10 180 db_1 &   
[1]     53608702   




