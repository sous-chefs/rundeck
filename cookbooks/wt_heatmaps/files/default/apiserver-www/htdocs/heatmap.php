<?php

require_once("/var/www/include/hbase.php");
require_once("/var/www/include/heatmap.php");

$stride = 200;

hbase_connect();


$columns = array();
$blk_begin = max((int)($_GET["top"]/100)-1,0);
$blk_end = max((int)(($_GET["top"]+$stride)/100),0);
for ($i=$blk_begin;$i<=$blk_end;++$i)
	$columns[] = "blk:$i";

$key_prefix = "$_GET[accountid];".$_GET["page"];
$start = "$key_prefix;$_GET[startd]";
$stop = "$key_prefix;$_GET[stopd]";

$ret = hbase_scanner("heatmap_reports",$start,$stop,$columns);

$r = implode($ret,",");

hbase_disconnect();

header("Content-type: image/png");
generate_heatmap($_GET, $r);


?>
