<?php


function hadoop_apply_dates($qry)
{
	global $argv;
	if (count($argv) == 1) // present
	{
		$begin_date = date("Y-m-d");
		$end_date = date("Y-m-d");
	} else if (count($argv) == 2) // date
	{
		$d = date("Y-m-d",strtotime($argv[1]));
		$begin_date = $d;
		$end_date = $d;
	} else if (count($argv) == 3) // range
	{
		$begin_date = date("Y-m-d",strtotime($argv[1]));
		$end_date = date("Y-m-d",strtotime($argv[2]));
	}

	$subs = array(	"#BEGIN_DATE"=>$begin_date
					, "#END_DATE"=>$end_date
	);

	return str_replace(array_keys($subs),array_values($subs),$qry);
}
function hadoop_query($qry)
{
	/*$process_user = posix_getpwuid(posix_geteuid());
	if ($process_user["name"] != "hadoop")
	{
		print "This script must be run as the hadoop user\n";
		return -1;
	}*/

	$start_date = preg_replace('/^([0-9]+-[0-9]+-[0-9]+T[0-9]+:[0-9]+:[0-9]+).*$/',"\\1",date("c"));

	$begin_time = time();

	$cmd = "cd /usr/local/hive/bin/ && /usr/local/hive/bin/hive --auxpath /usr/local/hive/lib/hbase-0.92.0.jar,/usr/local/hive/lib/zookeeper-3.3.1.jar,/usr/local/hive/lib/hive-hbase-handler-0.8.0.jar -hiveconf hbase.zookeeper.quorum=vnamenode01.staging.dmz -e \"" . str_replace("\"","\\\"",$qry) . "\" 2>&1";

	print "$cmd\n\n";

	$descriptorspec = array(
		0 => array("pipe", "r"),
		1 => array("pipe", "w"),
		2 => array("pipe", "a")
	);

	$handle = proc_open($cmd,$descriptorspec,$pipes);
	if (!is_resource($handle))
	{
		print "proc_open failed";
		return -1;
	}

	$buf = "";
	while (!feof($pipes[1]))
	{
		$tmp = fread($pipes[1],1024);
		$buf .= $tmp;
		print $tmp;
	}

	fclose($pipes[0]);
	fclose($pipes[1]);
	fclose($pipes[2]);

	$end_time = time();

	print "\n\nTotal time: " . ($end_time - $begin_time) . "\n\n";

	$status = proc_close($handle);

	if ($status != 0)
	{
		// an error occured
	}

	return $status;
}

?>