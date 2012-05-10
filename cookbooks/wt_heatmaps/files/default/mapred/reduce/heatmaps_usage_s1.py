#!/usr/bin/env python

import sys
import cjson


vblock_stride = 100

# body ##########################################################################

try:
	while True:
		line = sys.stdin.readline()
		if not line:
			break
		
		obj = cjson.decode(line)
		
		if not("WT_hm_y" in obj and obj["WT_hm_y"].isdigit()):
			continue
		
		obj["block_id"] = ((int((int(obj["WT_hm_y"]) + vblock_stride)/vblock_stride))*vblock_stride)/vblock_stride - 1
		for k in ["dcs-id","account-id","cs-host"]:
			obj["usage_key"] = k;
			obj["usage_value"] = obj[k]
			sys.stdout.write("%s\n" % (cjson.encode(obj)))

except Exception, e:
	sys.stderr.write("Died with line: %s\n" % (line))
	raise
	
	

