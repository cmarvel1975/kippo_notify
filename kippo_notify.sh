#!/bin/bash

TOOLDIR=/usr/local/tools/analyze/
SENDMAIL=${TOOLDIR}sendmail.pl

HOSTNAME=svman

DATE=`date -d '1 days ago' '+%Y%m%d'`
#KIPPO=/etc/init.d/kippo
LOGDIR=/usr/local/kippo/log/
#LOGFILE=${LOGDIR}kippo.log
LOGARCHIVE=${LOGDIR}kippo.log.${DATE}

BODY=${TOOLDIR}kippo-body.txt

#zcat ${LOGARCHIVE} | grep CMD > ${BODY}

zcat ${LOGARCHIVE} |grep CMD|awk '{sub(/+/,",",$2);sub(/\]/,",",$10); printf $1","$2","$10; { for (i=11;i<=NF;i++) if (i!=11) printf("%s ",$i)} print ""}'|awk -F, '{print $2" "$6" # "$7}' > ${BODY}


LINE=`cat ${BODY} |wc -l`

if [ "$LINE" -eq "0" ]; then
  echo "no cmd log";
  exit 1
fi

${SENDMAIL} "${HOSTNAME}-kippo ${DATE}" "${BODY}"

