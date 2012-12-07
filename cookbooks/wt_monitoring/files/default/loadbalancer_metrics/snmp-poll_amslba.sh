#!/bin/bash
# http://support.citrix.com/article/CTX128676/


#Graphite variables
CarbonServer="carbon.pdx.netiq.dmz"
CarbonPort="2003"

MetricRoot="common.loadbalancers"
Host="amslba01"
HostIP="10.92.15.250"

#SNMP Polling for Gauge type counters
vsvrFullName=( $(snmpwalk -On -v 2c -c wtlive $HostIP 1.3.6.1.4.1.5951.4.1.3.1.1.59 | sed 's/.*"\(.*\)"[^"]*$/\1/;s/\./\_/g') )
vsvrRequestRate=( $(snmpwalk -On -v 2c -c wtlive $HostIP 1.3.6.1.4.1.5951.4.1.3.1.1.43 | sed 's/.*"\(.*\)"[^"]*$/\1/') )
vsvrCurClntConnections=( $(snmpwalk -On -v 2c -c wtlive $HostIP 1.3.6.1.4.1.5951.4.1.3.1.1.7 | awk '{print $4}') )
vsvrCurSrvrConnections=( $(snmpwalk -On -v 2c -c wtlive $HostIP 1.3.6.1.4.1.5951.4.1.3.1.1.8 | awk '{print $4}') )
sslSessionsPerSec=$(snmpget -On -v 2c -c wtlive $HostIP .1.3.6.1.4.1.5951.4.1.1.47.3.0 | awk '{print $4}')
resCpuUsag=$(snmpwalk -On -v 2c -c wtlive $HostIP 1.3.6.1.4.1.5951.4.1.1.41.1 | awk '{print $4}')
resMemUsage=$(snmpwalk -On -v 2c -c wtlive $HostIP 1.3.6.1.4.1.5951.4.1.1.41.2 | awk '{print $4}')
sysUpTime=$(snmpwalk -On -v 2c -c wtlive $HostIP 1.3.6.1.2.1.1.3 | sed 's/.*[(]\([0-9]*\)[)].*/\1/')

#Echo output to graphite from Walked metrics above.
for (( i=0; i<${#vsvrFullName[*]}; i=i+1 )); do
  echo "$MetricRoot"."$Host".VServers."${vsvrFullName[$i]}".vsvrRequestRate" ${vsvrRequestRate[$i]} `date +%s`" | nc ${CarbonServer} ${CarbonPort};
  echo "$MetricRoot"."$Host".VServers."${vsvrFullName[$i]}".vsvrCurClntConnections" ${vsvrCurClntConnections[$i]} `date +%s`" | nc ${CarbonServer} ${CarbonPort};
  echo "$MetricRoot"."$Host".VServers."${vsvrFullName[$i]}".vsvrCurSrvrConnections" ${vsvrCurSrvrConnections[$i]} `date +%s`" | nc ${CarbonServer} ${CarbonPort};
done
echo "$MetricRoot"."$Host".SSL.sslSessionsPerSec" $sslSessionsPerSec `date +%s`" | nc ${CarbonServer} ${CarbonPort};
echo "$MetricRoot"."$Host".SysHealth.resCpuUsag" $resCpuUsag `date +%s`" | nc ${CarbonServer} ${CarbonPort};
echo "$MetricRoot"."$Host".SysHealth.resMemUsage" $resMemUsage `date +%s`" | nc ${CarbonServer} ${CarbonPort};
echo "$MetricRoot"."$Host".SysHealth.sysUpTime" $sysUpTime `date +%s`" | nc ${CarbonServer} ${CarbonPort};

#SNMP Polling for Counter type counters
COUNT_IN=/var/lib/webtrends/loadbalancer_metrics/$Host-sslTotTransactions.snmp
SNMP_IN=$(snmpwalk -On -v 2c -c wtlive $HostIP 1.3.6.1.4.1.5951.4.1.1.47.200 | awk '{print $4}')
SNMPFILEIN=`cat $COUNT_IN`
if [[ $SNMP_IN -lt $SNMPFILEIN ]] #Check to see if the counter has reset since last poll
then
  echo "$MetricRoot"."$Host".SSL.sslTotTransactions" $SNMP_IN `date +%s`" | nc ${CarbonServer} ${CarbonPort};
else
  let SNMPSUB=$SNMP_IN-$SNMPFILEIN #Take the difference
  echo "$MetricRoot"."$Host".SSL.sslTotTransactions" $SNMPSUB `date +%s`" | nc ${CarbonServer} ${CarbonPort};
fi
echo $SNMP_IN > $COUNT_IN #Echo the newly polled value back into our file.

