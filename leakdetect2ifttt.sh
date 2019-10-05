#!/bin/bash
TIMER1=0
TIMER2=0
TOPIC1="/basementleak1/leakdetect"
TOPIC2="test3/test3/leakstatus"
TOPIC=$TOPIC1
BROKERHOST="192.168.1.101"
LOGFILENAME="/home/johnd/leakdetect.log"
datecurr=`date`
TIMEOUT=30

echo "Starting ... $datecurr" >> $LOGFILENAME

run_cmd ()
{
  timeout $TIMEOUT $* > /dev/null
  return $?
}

check_pub_isUP ()
{
   
    #lets check if publisher(clients ) are publishing on this topic.
    # if they are not publishing than our sub commands won't get any answer and will run indefinately...wich is no good
    echo "checking if publisher is UP ?..." >> $LOGFILENAME
    run_cmd "/usr/bin/mosquitto_sub -h $BROKERHOST -t $TOPIC -C 1"
    status=$?

    if [ "$status" != "0" ]; then
        echo "`date` : check_pub_isUP : [ERROR] check if your clients are publshing atleast every <29 sec on topic $TOPIC" >> $LOGFILENAME
        echo "`date` : check_pub_isUP : [ERROR] exiting... : status was $status" >> $LOGFILENAME
        echo "`date` : check_pub_isUP : 14 - broker is down" >> $LOGFILENAME
        echo "`date` : check_pub_isUP : 124 - timeout - sensor is down!" >> $LOGFILENAME
        sleep 2
        exit 2
    fi
    
    echo "`date` : check_pub_isUP : [INFO] publisher is UP" >> $LOGFILENAME
}


# loop

while true
do
  
  check_pub_isUP

  leakdetect1=`mosquitto_sub -h $BROKERHOST -t $TOPIC -C 1`
  if [ $leakdetect1 -eq 1 ]; then
	  TIMER1=1
  fi	  
	   
  sleep 2

  leakdetect2=`mosquitto_sub -h $BROKERHOST -t $TOPIC -C 1`

  if [ $leakdetect1 -eq 1 ]; then
	  TIMER1=$((TIMER1+1))
  fi

  sleep 2
  
  leakdetect2=`mosquitto_sub -h $BROKERHOST -t $TOPIC -C 1`

  if [ $leakdetect2 -eq 1 ]; then
	  TIMER1=$((TIMER1+1))
  fi

  #if there is genuine leak, then at this point TIMER1 should be 3
     # we have genuin leak. 
     #lets turn on bedroom light
     #lets turn off auto-shutoff water main valve... 
     #or you can POST to ifttt webhooks, so that it can call you/email/sms etc...
     #or call your friend if you are not at vacation... possiblity is endless....
  #else
     # this is intermittent and lets reset TIMER1=0 and loop continues
  #fi

  if [ $TIMER1 -eq 3 ]; then
	  echo "we have a leake" >> $LOGFILENAME
	  #reset TIMER1 to 0, so that next iteration if we still have a leak, this will be true
	  #lets file a ifttt webhook, so that it calls my cellphone.
	  #curl "http://maker.ifttt.com/bla bla bla "
	  #curl -X POST https://maker.ifttt.com/trigger/basementleak1/with/key/<yourKey>

	  TIMER1=0
	  #lets wait for 2 min before we again test for a leak. 
	  #This will avoid mutliple calls to my phone in less than 1 sec !!!!
	  #i will get one call every 120sec till leak is resolved. That is fine.
	  sleep 120 

  else
          echo "No leak" >> $LOGFILENAME
          TIMER1=0
  fi
done
