#!/bin/bash

IPLIST=ggw_switches.txt

IFS=$'\n'
for line in $(cat $IPLIST)
do
  name=$(echo $line | cut -f1 -d" ")
  ip=$(echo $line | cut -f2 -d" ")

  #latency="$(ping -c 1 -w1 ${ip} | sed -ne '/.*time=/{;s///;s/\..*//;p;}')"
  latency="$(ping -c 1 -w1 ${ip} | tail -1| awk -F '/' '{print $5}' |cut -d"." -f1)"
  #debug
  # r=$(( $RANDOM % 50 ));
  # latency=$((latency + r))
  echo $latency

  if [ -z "$latency" ]
  then
        latency=999 #we set a high ping number if we don't get a reply withing 1 second
  fi

  #If ping is lower than 50ms we are okay.
  if [ ${latency} -gt 50 ]; then
      echo $ip DEAD! ${latency};
      else
      echo $ip OK! ${latency};
  fi

  curl -i -XPOST 'http://localhost:8086/write?db=mydb&u=admin&p=admin' --data-binary "switch_ping_time,name=${name} value=${latency}"
done


#Trouble ip: 10.1.11.12     -   a06-a.event.dreamhack.local
#while true;
#do r=$(( $RANDOM % 50 ));
#echo $r;
#curl -i -XPOST 'http://localhost:8086/write?db=mydb&u=admin&p=admin' --data-binary "switch_ping_time,name=ping_result_test,type=ping value=${r}"
#;sleep 5; done
