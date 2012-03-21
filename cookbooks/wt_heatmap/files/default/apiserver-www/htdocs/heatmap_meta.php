<?php

include "/var/www/include/hbase.php";
include "/var/www/include/heatmap.php";





$debug = false;

hbase_connect();


$result = array();
$result["y_max"] = 0;
$result["n"] = 0;



$key_prefix = "$_GET[accountid];".$_GET["page"];

$start = "$key_prefix;$_GET[startd]";
$stop = "$key_prefix;$_GET[stopd]";


// DEBUG

/*$_GET["w"] = 800;
$_GET["startd"] = "2012-02-01";
$_GET["stopd"] = "2012-02-02";
$_GET["page"] = "webtrends.com;42099b4af021e53fd8fd4e056c2568d7c2e3ffa8";*/

//

$r = "";
$cnt=0;
try
{
	$id = $hbase_client->scannerOpenWithStop("heatmap_reports",$start,$stop,array());
	while ($d = $hbase_client->scannerGet($id))
	{
		while (list($k, $v) = each($d[0]->columns))
		{
			foreach (explode(",",$v->value) as $w)
			{
				$a = explode(":",$w);
				if ((int)$a[3] > $result["y_max"])
					$result["y_max"] = (int)$a[3];

				++$result["n"];
				$vbuckets[(int)($a[3]/50)*50]++;
			}

			if ($cnt > 0)
				$r .= ",".$v->value;
			else
				$r = $v->value;
			++$cnt;
		}
	}

	$hbase_client->scannerClose($id);
} catch (Exception $e)
{
	print "scanner error";
	exit(-1);
}


hbase_disconnect();


$avg = 0;
if (count($vbuckets) > 1)
	$avg = floor(array_sum($vbuckets)/count($vbuckets));

$thresh = $avg/10;

asort($vbuckets,SORT_NUMERIC);

$safe_vbuckets = array();
foreach ($vbuckets as $k => $v)
	if ($v > $thresh)
		$safe_vbuckets[$k] = $v;

$estimated_height = count($safe_vbuckets) > 0 ? max(array_keys($safe_vbuckets)) : 0;


$_GET["h"] = $result["y_max"];
if ($_GET["h"] > 1500)
	$_GET["h"] = 1500;


if ($debug)
{
	header("Content-type: image/png");
	generate_heatmap($_GET, $r, false);
	exit;
}

$result["coef"] = generate_heatmap($_GET, $r, true);

if (isset($_GET["callback"]))
	print $_GET["callback"] . "(";



unset($result["n"]);
if ($result["y_max"] == 0)
	print json_encode(array("error"=>"no data"));
else
	print json_encode($result);

if (isset($_GET["callback"]))
	print ");";



?>
