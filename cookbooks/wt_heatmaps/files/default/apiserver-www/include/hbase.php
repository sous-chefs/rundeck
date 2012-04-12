<?php

require_once("/var/lib/php5/thriftservers.php"); // for thrift_servers()

$GLOBALS['THRIFT_ROOT'] = '/var/lib/php5/thrift';

require_once($GLOBALS['THRIFT_ROOT'].'/Thrift.php');

require_once($GLOBALS['THRIFT_ROOT'].'/transport/TSocketPool.php');
require_once($GLOBALS['THRIFT_ROOT'].'/transport/TBufferedTransport.php');
require_once($GLOBALS['THRIFT_ROOT'].'/protocol/TBinaryProtocol.php');

require_once($GLOBALS['THRIFT_ROOT'].'/packages/Hbase/Hbase.php');

function hbase_connect()
{
	global $hbase_socket;
	global $hbase_transport;
	global $hbase_protocol;
	global $hbase_client;

	$hbase_socket = new TSocketPool(thrift_servers(),9090);
	
	// time in ms
	$send_timeout = 5000;
	$recv_timeout = 20000;
	
	$hbase_socket->setSendTimeout($send_timeout); // Ten seconds (too long for production, but this is just a demo ;)
	$hbase_socket->setRecvTimeout($recv_timeout); // Twenty seconds
	$hbase_transport = new TBufferedTransport($hbase_socket);
	$hbase_protocol = new TBinaryProtocol($hbase_transport);
	$hbase_client = new HbaseClient($hbase_protocol);
	$hbase_transport->open();
}

function hbase_disconnect()
{
	global $hbase_transport;
	$hbase_transport->close();	
}

function hbase_json_value($table, $row, $col)
{
	global $hbase_client;
	
	try
	{
		$raw = $hbase_client->get($table, $row, $col);
		if (empty($raw[0]->value))
			return "";

		return $raw[0]->value;
	} catch (Exception $e)
	{
		return "";
	}
}

function hbase_scanner($table,$start,$stop,$columns)
{
	global $hbase_client;
	
	$a = array();

	try
	{
		$id = $hbase_client->scannerOpenWithStop($table,$start,$stop,$columns);
		while ($d = $hbase_client->scannerGet($id))
			while (list($k, $v) = each($d[0]->columns))
				$a[] = $v->value;
		
		$hbase_client->scannerClose($id);
	} catch (Exception $e)
	{
		return array();
	}
	
	return $a;
}

?>
