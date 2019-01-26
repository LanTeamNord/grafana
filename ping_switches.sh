#!/bin/bash

IPLIST=ggw_switches.txt

IFS=$'\n'
for line in $(cat $IPLIST)
do
  name=$(echo $line | cut -f1 -d" ")
  ip=$(echo $line | cut -f2 -d" ")

  #latency="$(ping -c 1 -w1 ${ip} | sed -ne '/.*time=/{;s///;s/\..*//;p;}')"
  latency="$(ping -c1 -w1 ${ip} | tail -1| awk -F '/' '{print $5}' |cut -d"." -f1)"

  if [ -z "$latency" ]
  then
        latency=999 #we set a high ping number if we don't get a reply withing 1 second
  fi

  #debug
  #r=$(( $RANDOM % 50 ));
  #latency=$((latency + r))

  #If ping is lower than 50ms we are okay.
  if [ ${latency} -gt 50 ]; then
      echo ${name} ${ip} - DEAD! ${latency};
      else
      echo ${name} ${ip} - OK! ${latency};
  fi

  #Dev to localhost
  #curl --silent --output /dev/null -i -XPOST 'http://localhost:8086/write?db=mydb&u=admin&p=admin' --data-binary "swoopdk_switch_latency,name=${name} latency=${latency}
  #Production
  curl --silent --output /dev/null -i -XPOST 'http://10.0.0.234:8086/write?db=mydb&u=admin&p=admin' --data-binary "swoopdk_switch_latency,name=${name},ip=${ip} latency=${latency}"
done

#Trouble ip: 10.1.11.12     -   a06-a.event.dreamhack.local
#while true;
#do r=$(( $RANDOM % 50 ));
#echo $r;
#curl -i -XPOST 'http://localhost:8086/write?db=mydb&u=admin&p=admin' --data-binary "switch_ping_time,name=ping_result_test,type=ping value=${r}"
#;sleep 5; done
