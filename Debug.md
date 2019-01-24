# Useful oneliners and debug information

## Send some test data to InfluxDB

while true; do r=$(( $RANDOM % 10 )); echo $r; curl -i -XPOST 'http://localhost:8086/write?db=mydb' --data-binary "switch_ping_time,name=switch01,type=ping value=${r}"; done
