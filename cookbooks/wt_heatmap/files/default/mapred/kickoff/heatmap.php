<?php

date_default_timezone_set("GMT0");
set_time_limit(0);

require_once "include/init.php";

$max_clicks_per_block = 2000;


$qry =<<<QUERY
add FILE /usr/local/mapred/reduce/dynamic_url.py;
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
        ds >= '#BEGIN_DATE'
        AND ds <= '#END_DATE'
    ) q1 SELECT TRANSFORM (json, ds, hr) USING 'python dynamic_url.py' AS json
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
QUERY;


$qry = hadoop_apply_dates($qry);

exit(hadoop_query($qry));


?>