#!/usr/bin/env python

# returns:
# metric_key, ds, hr, cf, metric


import sys
import cjson
import hashlib
import operator
from collections import defaultdict



max_pages = 5000
top_pagers_per_hour = 100


watched_fields = ["ds", "hr", "usage_key", "usage_value"]
last = dict()
last_page = ""
out = {}


# functions #####################################################################

def sha1(str):
	h = hashlib.sha1()
	h.update(str)
	return h.hexdigest()

def reset():
	global out, last_page
	last_page = ""
	out = {
		"site_clicks": 0
		, "num_pages": 0
		, "pages": defaultdict(int)
	}

def flush():
	global out
	if out["site_clicks"] == 0:
		return

	# site clicks
	sys.stdout.write("%s;%s\t%s\t%s\t%s\t%i\n" % (last["usage_key"], last["usage_value"], last["ds"], last["hr"], "site_clicks", out["site_clicks"]))

	# page clicks
	for k,v in out["pages"].iteritems():
		sys.stdout.write("%s;%s;%s\t%s\t%s\t%s\t%i\n" % (last["usage_key"], last["usage_value"], sha1(k), last["ds"], last["hr"], "page_clicks", v))

	# top pages
	top_pages = cjson.encode(dict(sorted(out["pages"].items(), key=operator.itemgetter(1), reverse=True)[0:top_pagers_per_hour]))
	sys.stdout.write("%s;%s\t%s\t%s\t%s\t%s\n" % (last["usage_key"], last["usage_value"], last["ds"], last["hr"], "top_pages", top_pages))
	
	reset()


# body ##########################################################################

reset()

try:
	while True:
		line = sys.stdin.readline()
		if not line:
			break

		obj = cjson.decode(line)

		# watch for field changes
		watched_values = dict((k, obj[k]) for k in watched_fields)
		if watched_values != last:
			flush()
			last = watched_values
		
		# count number of pages
		if last_page != obj["cs-uri-stem"]:
			last_page = obj["cs-uri-stem"]
			out["num_pages"] += 1
		
		# bean counters
		out["site_clicks"] += 1;
		
		# track up to max_pages (smaller length cs-uri-stems come first)
		if len(out["pages"]) < max_pages or obj["cs-uri-stem"] in out["pages"]:
			out["pages"][obj["cs-uri-stem"]] += 1
		else:
			out["pages"]["other"] += 1

	
except Exception, e:
	sys.stderr.write("Died with line: %s\n" % (line))
	raise

flush()
