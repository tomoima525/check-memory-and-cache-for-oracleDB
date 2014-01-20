#!/bin/ksh
#**************************************************************************************
#* Oracle性能情報取得シェル
#* Created by Tomoaki Imai
#* $1 SLEEP_SEC 取得間隔
#* $2 LOOP 取得回数
#* $3 SID ORACLE_SID
#* created on 2012/1/12 新規
#* updated 2013/5/27 更新　LOOPとSLEEP_SECを引数化
#* updated 2013/8/30 更新　ORACLE_SIDを引数化
#*
#**************************************************************************************
#-------------------------------------------------------------------------------------
# Set Environment
#-------------------------------------------------------------------------------------
#環境ファイルディレクトリ
ENV_DIR=/home/oracle/tmp/mem_test2

#日付
DATE1=`date "+%Y%m%d"`

#取得間隔(引数を読み込み)
SLEEP_SEC=${1}
LOOP_MAX=${2}
SID=${3}
COUNT=0
#----------------------------------------------------------------------------------------
# Function
#----------------------------------------------------------------------------------------

function f_check
{
#引数チェック
if [[ -z $SLEEP_SEC ]] ; then
   echo "sleep sec is not set."
    exit 99
fi

if [[ -z $LOOP_MAX ]] ; then
   echo "loop count is not set."
    exit 99
fi

if [[ -z $SID ]] ; then
   echo "ORACLE_SID is not set."
    exit 99
fi



#設定ファイルチェック
_MSG_NOTFOUND="environment file not found"
_ENV_FILE=check_mem.env

if [ -f ${ENV_DIR}/${_ENV_FILE} ] ; then
    . ${ENV_DIR}/${_ENV_FILE}

if [[ -z $ORA_USER ]] ; then
   echo "oracle user is not set."
    exit 99
fi
if [[ ${ORA_USER} = "other" ]] ; then

if [[ -z $ORA_SCHEMA ]] ; then
   echo "ORA_SCHEMA is not set."
    exit 99
fi

if [[ -z $ORA_PASSWORD ]] ; then
   echo "ORA_PASSWORD is not set."
    exit 99
fi

if [[ -z $ORA_NET_SERVICE_NAME ]] ; then
   echo "ORA_NET_SERVICE_NAME is not set."
    exit 99
fi

fi
else
    echo ${_ENV_FILE} ${_MSG_NOTFOUND}
    exit 99
fi

return 0

}


#-------------------------------------------------------------------------------------
# Main Process
#-------------------------------------------------------------------------------------

# 起動チェック
f_check

export ORACLE_SID=${SID}
#実行ディレクトリに移動
cd ${EXE_DIR}
#mem_cache.logを生成する
if [ ! ${SID}_${DATE1}.log ]; then
touch ${SID}_${DATE1}.log
fi

if [[ ${ORA_USER} = "other" ]] ; then
CONN_MSG="conn ${ORA_SCHEMA}/${ORA_PASSWORD}@${ORA_NET_SERVICE_NAME}"
elif [[ ${ORA_USER} = "sys" ]] ; then
CONN_MSG="conn / as sysdba"
else
    echo "proper oracle user is not set."
    exit 99
fi

(

echo ${CONN_MSG}
while [ $COUNT -lt $LOOP_MAX ]
do
echo "spool mem_cache_tmp.log;"
echo "@check.sql"
echo "spool off;"

sleep $SLEEP_SEC
cat mem_cache_tmp.log >> ${SID}_${DATE1}.log
COUNT=`expr $COUNT+1`
done
) | ${ORACLE_HOME}/bin/sqlplus -s /nolog

echo "exit" | ${ORACLE_HOME}/bin/sqlplus -s /nolog

#tmpファイル削除
rm mem_cache_tmp.log

exit 0
