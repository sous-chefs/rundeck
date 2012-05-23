#!/usr/bin/env python

# USAGE:
#   heatmaps.py <max_clicks_per_block>
#
# INPUT:
#   json
#
# INPUT ORDERING:
#   ds, hr, page_key, WT_hm_y (ASC)
#
# OUTPUT:
#   page_key, ds, hr, block_id, clicks
#
# WORKFLOW:
#   TODO: add
#
# DESCRIPTION:
#   Converts stream of ordered heatmap clicks into HBase format
#   that is summarized and blocked, aka ready to be inserted

import sys
import cjson
import codecs
sys.stdout = codecs.getwriter('utf8')(sys.stdout)

max_clicks_per_block = 0
vblock_stride = 100


watched_fields = ["ds", "hr", "page_key", "block_id"]
out = []
last = dict()

# functions #####################################################################

def flush():
	global out
	if len(out) == 0:
		return
	
	sys.stdout.write("%s\t%s\t%s\t%d\t" % (out[0]["page_key"], out[0]["ds"], out[0]["hr"], out[0]["block_id"]))
	
	cnt = 0
	for v in out:
		if cnt > 0:
			sys.stdout.write(",")
		
		sys.stdout.write("%s:%s:%s:%s" % (v["WT_hm_w"], v["WT_hm_h"], v["WT_hm_x"], v["WT_hm_y"]))
		cnt += 1
	
	sys.stdout.write("\n")
	
	out = []


# body ##########################################################################

if len(sys.argv) > 1:
	max_clicks_per_block = int(sys.argv[1])
	
try:
	while True:
		line = sys.stdin.readline()
		if not line:
			break

		obj = cjson.decode(line)

		try: # because some WT_hm_ fields are null, just ignore them and continue
			# determine block id
			obj["block_id"] = ((int((int(obj["WT_hm_y"]) + vblock_stride)/vblock_stride))*vblock_stride)/vblock_stride - 1
	
			# watch for field changes
			watched_values = dict((k, obj[k]) for k in watched_fields)
			if watched_values != last:
				flush()
				last = watched_values
	
			if len(out) < max_clicks_per_block or max_clicks_per_block == 0:
				out.append(obj)

		except Exception, e:
			pass
except Exception, e:
	sys.stderr.write("Died with line: %s\n" % (line))
	raise

flush()

