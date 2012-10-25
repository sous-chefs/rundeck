#!/bin/bash
#
# Use this script to poll each node in an Isilon cluster that uses OneFS filesystem and then send the collectd
# metrics to a graphite server.
#
#

# Graphite variables
CarbonServer="carbon.pdx.netiq.dmz"
CarbonPort="2003"
MetricRoot="common.storage"

# Isilon cluster variables
SNMP_COMMUNITY="public"
STORE="pdxstore09"
NODES=('pdxst09cl-1a.netiq.dmz' 'pdxst09cl-2a.netiq.dmz' 'pdxst09cl-3a.netiq.dmz' 'pdxst09cl-4a.netiq.dmz' 'pdxst09cl-5a.netiq.dmz' 'pdxst09cl-6a.netiq.dmz' 'pdxst09cl-7a.netiq.dmz')

# Query node metrics
for NODE in ${NODES[@]}
do
  load1=$(snmpget -On -v 2c -c $SNMP_COMMUNITY $NODE 1.3.6.1.4.1.2021.10.1.3.1 | awk '{print $4}')
  load5=$(snmpget -On -v 2c -c $SNMP_COMMUNITY $NODE 1.3.6.1.4.1.2021.10.1.3.2 | awk '{print $4}')
  load15=$(snmpget -On -v 2c -c $SNMP_COMMUNITY $NODE 1.3.6.1.4.1.2021.10.1.3.3 | awk '{print $4}')
  totRAMkb=$(snmpget -On -v 2c -c $SNMP_COMMUNITY $NODE 1.3.6.1.4.1.2021.4.5.0 | awk '{print $4}')
  usedRAMkb=$(snmpget -On -v 2c -c $SNMP_COMMUNITY $NODE 1.3.6.1.4.1.2021.4.6.0 | awk '{print $4}')
  freeRAMkb=$(snmpget -On -v 2c -c $SNMP_COMMUNITY $NODE 1.3.6.1.4.1.2021.4.11.0 | awk '{print $4}')
  sharedRAMkb=$(snmpget -On -v 2c -c $SNMP_COMMUNITY $NODE 1.3.6.1.4.1.2021.4.13.0 | awk '{print $4}')
  uptimeTicks=$(snmpget -On -v 2c -c $SNMP_COMMUNITY $NODE .1.3.6.1.2.1.25.1.1.0 | sed 's/.*[(]\([0-9]*\)[)].*/\1/')
  echo "$MetricRoot"."$STORE"."${NODE%%.*}".load.1min" $load1 `date +%s`" | nc ${CarbonServer} ${CarbonPort};
  echo "$MetricRoot"."$STORE"."${NODE%%.*}".load.5min" $load5 `date +%s`" | nc ${CarbonServer} ${CarbonPort};
  echo "$MetricRoot"."$STORE"."${NODE%%.*}".load.15min" $load15 `date +%s`" | nc ${CarbonServer} ${CarbonPort};
  echo "$MetricRoot"."$STORE"."${NODE%%.*}".memory.total-kb" $totRAMkb `date +%s`" | nc ${CarbonServer} ${CarbonPort};
  echo "$MetricRoot"."$STORE"."${NODE%%.*}".memory.used-kb" $usedRAMkb `date +%s`" | nc ${CarbonServer} ${CarbonPort};
  echo "$MetricRoot"."$STORE"."${NODE%%.*}".memory.free-kb" $freeRAMkb `date +%s`" | nc ${CarbonServer} ${CarbonPort};
  echo "$MetricRoot"."$STORE"."${NODE%%.*}".memory.shared-kb" $sharedRAMkb `date +%s`" | nc ${CarbonServer} ${CarbonPort};
  echo "$MetricRoot"."$STORE"."${NODE%%.*}".uptime.sec" $(($uptimeTicks/100)) `date +%s`" | nc ${CarbonServer} ${CarbonPort};
done

# Query cluster metrics
nodeCount=$(snmpwalk -On -v 2c -c $SNMP_COMMUNITY $STORE .1.3.6.1.4.1.12124.1.1.4 | awk '{print $4}')
ifsInBytes=$(snmpwalk -On -v 2c -c $SNMP_COMMUNITY $STORE .1.3.6.1.4.1.12124.1.2.1.1 | awk '{print $4}')
ifsOutBytes=$(snmpwalk -On -v 2c -c $SNMP_COMMUNITY $STORE .1.3.6.1.4.1.12124.1.2.1.3 | awk '{print $4}')
networkInBytes=$(snmpwalk -On -v 2c -c $SNMP_COMMUNITY $STORE .1.3.6.1.4.1.12124.1.2.2.1 | awk '{print $4}')
networkOutBytes=$(snmpwalk -On -v 2c -c $SNMP_COMMUNITY $STORE .1.3.6.1.4.1.12124.1.2.2.3 | awk '{print $4}')
ifsTotalBytes=$(snmpwalk -On -v 2c -c $SNMP_COMMUNITY $STORE .1.3.6.1.4.1.12124.1.3.1 | awk '{print $4}')
ifsUsedBytes=$(snmpwalk -On -v 2c -c $SNMP_COMMUNITY $STORE .1.3.6.1.4.1.12124.1.3.2 | awk '{print $4}')
ifsAvailableBytes=$(snmpwalk -On -v 2c -c $SNMP_COMMUNITY $STORE .1.3.6.1.4.1.12124.1.3.3 | awk '{print $4}')
echo "$MetricRoot"."$STORE".cluster.nodeCount" $nodeCount `date +%s`" | nc ${CarbonServer} ${CarbonPort};
echo "$MetricRoot"."$STORE".cluster.ifsInBytes" $ifsInBytes `date +%s`" | nc ${CarbonServer} ${CarbonPort};
echo "$MetricRoot"."$STORE".cluster.ifsOutBytes" $ifsOutBytes `date +%s`" | nc ${CarbonServer} ${CarbonPort};
echo "$MetricRoot"."$STORE".cluster.networkInBytes" $networkInBytes `date +%s`" | nc ${CarbonServer} ${CarbonPort};
echo "$MetricRoot"."$STORE".cluster.networkOutBytes" $networkOutBytes `date +%s`" | nc ${CarbonServer} ${CarbonPort};
echo "$MetricRoot"."$STORE".cluster.ifsTotalBytes" $ifsTotalBytes `date +%s`" | nc ${CarbonServer} ${CarbonPort};
echo "$MetricRoot"."$STORE".cluster.ifsUsedBytes" $ifsUsedBytes `date +%s`" | nc ${CarbonServer} ${CarbonPort};
echo "$MetricRoot"."$STORE".cluster.ifsAvailableBytes" $ifsAvailableBytes `date +%s`" | nc ${CarbonServer} ${CarbonPort};
