#!/bin/bash
#
# Use this script to poll a list of BlueArc NAS devices and then send the collected metrics to a graphite server.
#
#

# Graphite variables
CarbonServer="carbon.pdx.netiq.dmz"
CarbonPort="2003"
MetricRoot="common.storage"

# BlueArc cluster variables
SNMP_COMMUNITY="wtlive"
STORES=('pdxstore01.netiq.dmz' 'pdxstore02.netiq.dmz')

# Query store metrics
for STORE in ${STORES[@]}
do
  opsPerSecond=$(snmpget -On -v 2c -c $SNMP_COMMUNITY $STORE 1.3.6.1.4.1.11096.6.1.1.1.2.1.5.0 | awk '{print $4}')
  fileSystemLoadClient=$(snmpget -On -v 2c -c $SNMP_COMMUNITY $STORE 1.3.6.1.4.1.11096.6.1.1.1.2.1.6.0 | awk '{print $4}')
  fileSystemLoadSystem=$(snmpget -On -v 2c -c $SNMP_COMMUNITY $STORE 1.3.6.1.4.1.11096.6.1.1.1.2.1.7.0 | awk '{print $4}')
  tcpOpenConns=$(snmpget -On -v 2c -c $SNMP_COMMUNITY $STORE 1.3.6.1.4.1.11096.6.1.1.2.2.1.0 | awk '{print $4}')
  uptimeTicks=$(snmpget -On -v 2c -c $SNMP_COMMUNITY $STORE .1.3.6.1.2.1.1.3.0 | sed 's/.*[(]\([0-9]*\)[)].*/\1/')
  echo "$MetricRoot"."${STORE%%.*}".environment.opsPerSecond" $opsPerSecond `date +%s`" | nc ${CarbonServer} ${CarbonPort};
  echo "$MetricRoot"."${STORE%%.*}".environment.fileSystemLoadClient" $fileSystemLoadClient `date +%s`" | nc ${CarbonServer} ${CarbonPort};
  echo "$MetricRoot"."${STORE%%.*}".environment.fileSystemLoadSystem" $fileSystemLoadSystem `date +%s`" | nc ${CarbonServer} ${CarbonPort};
  echo "$MetricRoot"."${STORE%%.*}".environment.tcpOpenConns" $tcpOpenConns `date +%s`" | nc ${CarbonServer} ${CarbonPort};
  echo "$MetricRoot"."${STORE%%.*}".uptime.sec" $(($uptimeTicks/100)) `date +%s`" | nc ${CarbonServer} ${CarbonPort};
done
