<?php

function generate_heatmap($params, $r, $calc=false)
{
	$descriptorspec = array(
		0 => array('pipe', 'r'), // stdin
		1 => array('pipe', 'w'), // stdout
		2 => array('pipe', 'w') // stderr
	);


	$cwd = "/usr/bin";
	$cmd = "$cwd/heatmap --width=" . escapeshellarg($params["w"])
			. " --height=" . escapeshellarg($params["h"])
			. " --top=" . escapeshellarg($params["top"])
			. " --dot-size=" . escapeshellarg($params["dot"])
			. " --filter=/var/www/htdocs/filters/" . escapeshellarg($params["filter"]) . ".png"
			. ($calc ? " --calc-coef" : "") . (isset($params["coef"]) ? " --coef=" . escapeshellarg($params["coef"]) : "");

	$process = proc_open($cmd, $descriptorspec, $pipes, $cwd);
	if (is_resource($process))
	{
		// write to proc
		fwrite($pipes[0], $r);
		fclose($pipes[0]);

		if (!$calc)
			fpassthru($pipes[1]);
		else
			$out = stream_get_contents($pipes[1]);
		fclose($pipes[1]);

		$err = stream_get_contents($pipes[2]);
		fclose($pipes[2]);

		$ret = proc_close($process);

		if ($ret != 0)
			$out["error"] = $err;

		if (isset($out))
			return $out;
	} else
	{
		print "Unable to open proc\n";
	}
}

?>