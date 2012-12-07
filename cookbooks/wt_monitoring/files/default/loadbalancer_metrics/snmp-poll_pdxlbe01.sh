#!/bin/bash
# F5 Script
#http://www.oidview.com/mibs/3375/F5-BIGIP-LOCAL-MIB.html
#
# IMPORTANT!!
# THIS SCRIPT MUST BE RAN ON 5 MINUTE INTERVALS VIA CRON!!!  It samples the difference in total connections over 5 minutes to get a per second rate
#

#Graphite variables
CarbonServer="carbon.pdx.netiq.dmz"
CarbonPort="2003"

MetricRoot="common.loadbalancers"
Host="pdxlbe01"
HostIP="10.90.19.253"

#SNMP Polling for Gauge type counters
vsvrFullName=( $(snmpwalk -On -v 2c -c wtlive $HostIP 1.3.6.1.4.1.3375.2.2.10.2.3.1.1 | sed 's/.*"\(.*\)"[^"]*$/\1/;s/\./\_/g;s/_208//')) 

#SNMP Polling for "Counter" type counters
COUNT_IN=/var/lib/webtrends/loadbalancer_metrics/$Host-vsvrRequestRate-F5.snmp
SNMP_IN=($(snmpwalk -On -v 2c -c wtlive $HostIP 1.3.6.1.4.1.3375.2.2.10.2.3.1.11 | awk '{print $4}'))
LAST_VALUE=($(cat $COUNT_IN))

#Echo output to graphite from Walked metrics above.
for (( i=0; i<${#vsvrFullName[*]}; i=i+1 )); do
  echo "$MetricRoot"."$Host".VServers."${vsvrFullName[$i]}".vsvrRequestRate" $(( $((${SNMP_IN[$i]}-${LAST_VALUE[$i]}))/300)) `date +%s`" | nc ${CarbonServer} ${CarbonPort};
done

#Write our snmp walked metrics array out to our file.
for j in "${SNMP_IN[@]}"
do
  echo $j 
done >$COUNT_IN

