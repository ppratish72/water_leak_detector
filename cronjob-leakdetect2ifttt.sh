#!/bin/bash
status=3
pgrep -f "/bin/bash /home/johnd/prodscript/leakdetect2ifttt.sh" > /dev/null
status=$?

if  [ "$status" != "0" ]; then
	#echo "Status : #${status}#"
	#echo "Starting leakdetect2ifttt.sh"
        /home/johnd/prodscript/leakdetect2ifttt.sh &
        echo "Starting leakdetect2ifttt.sh"  >> /home/johnd/prodscript/cron-leakdetect.log
else
        echo "`date` : leakdetect2ifttt.sh on `hostname` is already running " >> /home/johnd/prodscript/cron-leakdetect.log
fi	
