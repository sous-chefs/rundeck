#!/usr/bin/env bash

# -- usage ----------------------------------------------------------
#
#  heatmaps.sh
#    * computes heatmaps for current day
#
#  heatmaps.sh YYYY-MM-DD
#    * computes heatmaps for YYYY-MM-DD
#
#  heatmaps.sh YYYY-MM-DD YYYY-MM-DD
#    * computes heatmaps for date range
#
#  If the last argument is "--", the HiveQL query will be printed
#  but not executed.
#


# -- variables ------------------------------------------------------

max_clicks_per_block=2000

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
add FILE /usr/local/mapred/reduce/dynamic_url_noconfig.py;
add FILE /usr/local/mapred/reduce/heatmaps.py;
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
    ) q1 SELECT TRANSFORM (json, ds, hr) USING 'python dynamic_url_noconfig.py $(cat /etc/config_distrib)' AS json
      DISTRIBUTE BY
        get_json_object(json, '$.page_key')
        , get_json_object(json, '$.ds')
        , get_json_object(json, '$.hr')
        , get_json_object(json, '$.WT_hm_y')
      SORT BY 
        get_json_object(json, '$.page_key') ASC
        , get_json_object(json, '$.ds') ASC
        , get_json_object(json, '$.hr') ASC
        , CAST(get_json_object(json, '$.WT_hm_y') AS int) ASC
  ) q2 SELECT TRANSFORM (json) USING 'python heatmaps.py $max_clicks_per_block' AS (page_key, ds, hr, block_id, clicks)
) q3 INSERT OVERWRITE TABLE heatmap_reports SELECT CONCAT(page_key,'\;',ds,'\;',hr), map(block_id, clicks)
;
HIVEQL
)


# -- job ------------------------------------------------------------

tmp="${@: -1}"
if [ "$tmp" == "--" ]
then
	echo "$query"
else
	/usr/local/hive/bin/hive \
	--auxpath /usr/local/hive/lib/hbase-0.92.0.jar,/usr/local/hive/lib/zookeeper-3.3.1.jar,/usr/local/hive/lib/hive-hbase-handler-0.8.1.jar \
	-hiveconf hbase.zookeeper.quorum=$(cat /etc/zookeeper | paste -s -d ',') \
	-e "$query" 2>&1
fi

exit $?