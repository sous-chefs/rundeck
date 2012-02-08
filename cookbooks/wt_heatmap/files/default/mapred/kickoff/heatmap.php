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


/*
$qry =<<<QUERY
add FILE /usr/local/mapred/reduce/heatmaps.py;
INSERT OVERWRITE TABLE heatmap_reports
SELECT CONCAT(dcsid,'\;',page,'\;',ds), map(blk, summary) FROM
(
  FROM
  (
    SELECT
      get_json_object(json, '$.dcsid') AS dcsid
      , CONCAT('http://webtrends.com', get_json_object(json, '$.dcsuri')) AS page
      , CAST(get_json_object(json, '$.WT_hm_x') AS int) AS x
      , CAST(get_json_object(json, '$.WT_hm_y') AS int) AS y
      , CAST(get_json_object(json, '$.WT_hm_w') AS int) AS w
      , CAST(get_json_object(json, '$.WT_hm_h') AS int) AS h
      , ds
    FROM heatmap_events
    WHERE
      ds >= '#BEGIN_DATE'
      AND ds <= '#END_DATE'
      AND get_json_object(json, '$.WT_hm_x') IS NOT NULL
      AND get_json_object(json, '$.WT_hm_y') IS NOT NULL
      AND get_json_object(json, '$.WT_hm_w') IS NOT NULL
      AND get_json_object(json, '$.WT_hm_h') IS NOT NULL
    DISTRIBUTE BY dcsid SORT BY dcsid ASC, page ASC, y ASC
  ) t2 SELECT TRANSFORM (dcsid, page, ds, w, h, x, y) USING 'python heatmaps.py $max_pages_per_site $max_clicks_per_page_per_day' AS dcsid, page, ds, blk, summary DISTRIBUTE BY dcsid, page, ds
) t3
;
QUERY;
*/
$qry = hadoop_apply_dates($qry);

exit(hadoop_query($qry));


?>