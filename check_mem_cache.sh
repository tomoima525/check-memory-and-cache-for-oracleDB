#!/bin/ksh
#**************************************************************************************
#* Oracle���\���擾�V�F��
#* Created by Tomoaki Imai
#* $1 SLEEP_SEC �擾�Ԋu
#* $2 LOOP �擾��
#* $3 SID ORACLE_SID
#* created on 2012/1/12 �V�K
#* updated 2013/5/27 �X�V�@LOOP��SLEEP_SEC��������
#* updated 2013/8/30 �X�V�@ORACLE_SID��������
#*
#**************************************************************************************
#-------------------------------------------------------------------------------------
# Set Environment
#-------------------------------------------------------------------------------------
#���t�@�C���f�B���N�g��
ENV_DIR=/home/oracle/tmp/mem_test2

#���t
DATE1=`date "+%Y%m%d"`

#�擾�Ԋu(������ǂݍ���)
SLEEP_SEC=${1}
LOOP_MAX=${2}
SID=${3}
COUNT=0
#----------------------------------------------------------------------------------------
# Function
#----------------------------------------------------------------------------------------

function f_check
{
#�����`�F�b�N
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



#�ݒ�t�@�C���`�F�b�N
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

# �N���`�F�b�N
f_check

export ORACLE_SID=${SID}
#���s�f�B���N�g���Ɉړ�
cd ${EXE_DIR}
#mem_cache.log�𐶐�����
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

#tmp�t�@�C���폜
rm mem_cache_tmp.log

exit 0