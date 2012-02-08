#!/usr/bin/env python

# USAGE:
#   dynamic_url.py
#
# INPUT:
#   json, ds, hr
#
# INPUT ORDERING:
#   none
#
# OUTPUT:
#   json
#
# WORKFLOW:
#   1. accept 3 fields (json string, date string, hour string)
#   2. merge into single json object
#   3. determine page_key, append to json object
#   4. emit json object
#
# DESCRIPTION:
#   Simple decorator pattern. This scripts accepts json logs out of hive
#   with a date and hour partition. It determines the "dynamic url" of the
#   event, appeds the value and emits for any downstream source.

import sys
import hashlib

try: import simplejson as json
except ImportError: import json

# functions #####################################################################

def sha1(str):
	h = hashlib.sha1()
	h.update(str)
	return h.hexdigest()


# body ##########################################################################

while True:
	try:
		line = sys.stdin.readline()
		if not line:
			break

		# get parameters (workflow #1)
		params = dict(zip(["json","ds","hr"],line.rstrip("\n").split("\t")))
		obj = json.loads(params["json"])

		# convert WT.blah params to WT_blah
		obj = dict((k.replace('.','_'), obj[k]) for k in obj)
		
		# makes it easy to watch these fields (workflow #2)
		obj["ds"] = params["ds"]
		obj["hr"] = params["hr"]

		# determine page hash (workflow #3)
		page_ident = obj["cs-uri-stem"]
		if "WT_hm_url" in obj:
			page_ident += "?" + obj["WT_hm_url"]

		obj["page_ident"] = page_ident
		obj["page_key"] = obj["cs-host"] + ";" + sha1(page_ident)
		
		# emit (workflow #4)
		sys.stdout.write("%s\n" % (json.dumps(obj)))

	except Exception, e:
		sys.stderr.write("Bad line: %s\n" % (line))

