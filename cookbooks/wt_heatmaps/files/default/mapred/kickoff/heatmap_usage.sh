#!/usr/bin/env bash


# CREATE TABLE heatmap_usage(key string, value map<string,string>) 
# STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
# WITH SERDEPROPERTIES (
# "hbase.columns.mapping" = ":key,data:"
# );





# -- variables ------------------------------------------------------

if [ "$2" ]
then
	begin_date=$1
	end_date=$2
else
	if [ "$1" ]
	then
		begin_date="$1"
		end_date="$1"
	else
		begin_date=$(date -u -d now +"%Y-%m-%d")
		end_date=$(date -u -d now +"%Y-%m-%d")
	fi
fi


# -- query ----------------------------------------------------------

query=$(cat <<HIVEQL
set mapred.reduce.tasks=$(cat /etc/heatmap_reducers);
add FILE /usr/local/mapred/reduce/dynamic_url.py;
add FILE /usr/local/mapred/reduce/heatmaps_usage_s1.py;
add FILE /usr/local/mapred/reduce/heatmaps_usage_s2.py;
FROM
(
  FROM
  (
    FROM
    (
      FROM
      (
        SELECT
          json
          , ds
          , hr
        FROM logs
        WHERE
          ds >= '$begin_date'
          AND ds <= '$end_date'
      ) q1 SELECT TRANSFORM (json, ds, hr) USING 'python dynamic_url.py $(cat /etc/config_distrib)' AS json
    ) q2 SELECT TRANSFORM (json) USING 'python heatmaps_usage_s1.py' AS json
      DISTRIBUTE BY
        get_json_object(json, '$.dcs-id')
        , get_json_object(json, '$.ds')
        , get_json_object(json, '$.hr')
      SORT BY 
        get_json_object(json, '$.ds') ASC
        , get_json_object(json, '$.hr') ASC
        , get_json_object(json, '$.usage_key') ASC
        , get_json_object(json, '$.usage_value') ASC
        , LENGTH(get_json_object(json, '$.cs-uri-stem')) ASC
        , get_json_object(json, '$.cs-uri-stem') ASC
        , get_json_object(json, '$.block_id') ASC
  ) q3 SELECT TRANSFORM (json) USING 'python heatmaps_usage_s2.py' AS (metric_key, ds, hr, cf, metric)
) q4 INSERT OVERWRITE TABLE heatmap_usage SELECT CONCAT(metric_key,'\;',ds,'\;',hr), map(cf, metric)
;
HIVEQL
)


# -- job ------------------------------------------------------------

tmp="${@: -1}"
if [ "$tmp" == "--" ]
then
	echo "$query"
else
	echo "-- query -------------------------------"
	echo "$query"
	echo "-- job ---------------------------------"
	/usr/local/hive/bin/hive \
	--auxpath /usr/local/hive/lib/hbase-0.92.0.jar,/usr/local/hive/lib/zookeeper-3.3.1.jar,/usr/local/hive/lib/hive-hbase-handler-0.8.1.jar \
	-hiveconf hbase.zookeeper.quorum=$(cat /etc/zookeeper | paste -s -d ',') \
	-e "$query" 2>&1
fi

exit $?
