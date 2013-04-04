#!/usr/bin/python

""" unbound-stats.py:  collectd plugin for Unbound

    DESCRIPTION
	Executes 'unbound-control stats_noreset' and dispatches desired stats thru collectd

    Copyright 2013, Webtrends Inc.
    David Dvorak <david.dvorak@webtrends.com>
"""

import argparse
import subprocess

# verbose logging
VERBOSE = False

parser = argparse.ArgumentParser()
parser.add_argument('-d', '--display',  action="store_true", default=False, help='display stats (no collectd)')
args = parser.parse_args()

if not args.display:
	import collectd

def config_callback(conf):
	global VERBOSE
	for node in conf.children:
		if node.key == 'Interval':
			interval = int(node.values[0])
			collectd.register_read(read_callback, interval)
		elif node.key == 'Verbose':
			VERBOSE = bool(node.values[0])
		else:
			collectd.warning('unbound-stats: unknown config key: %s.' % node.key)
	log('configured interval: %s' % interval)

def get_stats():

	# get unbound stats
	stats_lines = (subprocess.check_output(['/usr/sbin/unbound-control', 'stats_noreset'])).splitlines()

	# parse the stats
	stats = {}
	for line in stats_lines:

		# we are not intested in individual threads
		if line.startswith('thread'):
			continue

		# histogram?
		if line.startswith('histogram'):
			continue

		key, val = line.split('=')
		stats[key] = val

	return stats

def dispatch_value(stats, key, epoch, type):
	if args.display:
		print "%s %s %s" % (key, stats[key], epoch)
	else:
		if key in stats:
			log('%s %s %s' % (key, stats[key], epoch))
			value = collectd.Values(plugin='unbound', time = epoch, type = type, type_instance = key, values = [stats[key]])
			value.dispatch()
	return

def read_callback():

	log('read_callback')
	stats = get_stats()

	if args.display:
		print stats

	# use time reported by unbound
	epoch = float(stats['time.now'])

	dispatch_value(stats, 'total.num.queries', epoch, 'dns_query')
	dispatch_value(stats, 'total.num.cachehits', epoch, 'dns_query')
	dispatch_value(stats, 'total.num.cachemiss', epoch, 'dns_query')
	dispatch_value(stats, 'total.num.prefetch', epoch, 'dns_query')
	dispatch_value(stats, 'total.num.recursivereplies', epoch, 'dns_query')
	dispatch_value(stats, 'total.requestlist.avg', epoch, 'gauge')
	dispatch_value(stats, 'total.requestlist.max', epoch, 'gauge')
	dispatch_value(stats, 'total.requestlist.overwritten', epoch, 'dns_query')
	dispatch_value(stats, 'total.requestlist.exceeded', epoch, 'dns_query')
	dispatch_value(stats, 'total.requestlist.current.all', epoch, 'gauge')
	dispatch_value(stats, 'total.requestlist.current.user', epoch, 'gauge')
	dispatch_value(stats, 'total.recursion.time.avg', epoch, 'gauge')
	dispatch_value(stats, 'total.recursion.time.median', epoch, 'gauge')

	# extended stats
	for key in stats:
		if key.startswith('mem.'):
			dispatch_value(stats, key, epoch, 'memory')
		if key.startswith('num.'):
			dispatch_value(stats, key, epoch, 'dns_query')
		if key.startswith('unwanted.'):
			dispatch_value(stats, key, epoch, 'dns_query')

def log(msg):
	if not VERBOSE:
		return
	collectd.info('unbound-stats: %s' % msg)

if args.display:
	read_callback()
else:
	collectd.register_config(config_callback)
