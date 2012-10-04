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
import httplib
import urlparse
from collections import defaultdict
import cjson


# functions #####################################################################

account_ids = {}

def group(lst, n):
	"""group([0,3,4,10,2,3], 2) => [(0,3), (4,10), (2,3)]

	Group a list into consecutive n-tuples. Incomplete tuples are
	discarded e.g.

	>>> group(range(10), 3)
	[(0, 1, 2), (3, 4, 5), (6, 7, 8)]
	"""
	return zip(*[lst[i::n] for i in range(n)])


# functions #####################################################################

def sha1(str):
	h = hashlib.sha1()
	h.update(str)
	return h.hexdigest()


# body ##########################################################################

errors = defaultdict(int)
error_lines = {}

# pull config distributor url from argv[1]
config_distrib = sys.argv[1]
sys.stderr.write("Config Distributor: %s\n" % (config_distrib))

# rest/json request
conn = httplib.HTTPConnection(config_distrib)
conn.request("GET", "/Config/dcsid2account")
response = conn.getresponse()
if response.status != 200:
	sys.stderr.write("Bad http request status: %i %s\n" % (response.status, response.reason))
	exit(-1)

# parse dcsid -> account-id mappings
try:
	account_ids = cjson.decode(response.read())
except Exception, e:
	sys.stderr.write("Unable to parse json from http result\n")
	raise

# start sucking on the data
while True:
	try:
		line = sys.stdin.readline()
		if not line:
			break

		# get parameters (workflow #1)
		params = line.rstrip("\n").split("\t") # "json","ds","hr"
		tmp = cjson.decode(params[0])

		# convert WT.blah params to WT_blah
		obj = {
			"WT_hm_w": tmp["WT.hm_w"]
			, "WT_hm_h": tmp["WT.hm_h"]
			, "WT_hm_x": tmp["WT.hm_x"]
			, "WT_hm_y": tmp["WT.hm_y"]
			, "ds": params[1]
			, "hr": params[2]
			, "cs-uri-stem": tmp["cs-uri-stem"]
			, "dcs-id": tmp["dcs-id"]
			, "cs-host": tmp["cs-host"]
		}
		
		# only continue if we know the account-id for the dcs-id
		if not(tmp["dcs-id"] in account_ids):
			continue

		# the tag sends this param double encoded
		if "WT.hm_url" in tmp:
			tmp["WT.hm_url"] = urlparse.unquote(urlparse.unquote(tmp["WT.hm_url"]))

		# determine page hash (workflow #3)
		page_ident = tmp["cs-uri-stem"]
		if "WT.hm_url" in tmp:
			a = tmp["WT.hm_url"].split(",")
			if len(a) & 1 == 0: # make sure length is even
				page_ident += "?" + "&".join(map(lambda x: "%s=%s"%(x[0], x[1]), group(a, 2))) # convert "k1,v1,k2,v2" -> "k1=v1&k2=v2"

		# there may be multiple account-ids
		account_id = account_ids[tmp["dcs-id"]]
		for aid in account_id:
			obj["account-id"] = str(aid)
			obj["page_key"] = str(aid) + ";" + tmp["cs-host"] + ";" + sha1(page_ident)

			# emit (workflow #4)
			sys.stdout.write("%s\n" % (cjson.encode(obj)))
		
	except Exception, e:
		errors[str(e)] += 1
		if not(str(e) in error_lines):
			error_lines[str(e)] = line


# display error summary
for k,v in errors.items():
	sys.stderr.write("exception:\n")
	sys.stderr.write(" * field: %s %i times\n" % (k, v))
	sys.stderr.write(" * first-instance: %s\n\n" % (error_lines[k]))


