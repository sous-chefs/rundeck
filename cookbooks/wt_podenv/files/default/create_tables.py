#!/usr/bin/env python

import sys
from hbasetable import HBaseTable
from streaming import *



if (len(sys.argv) != 3):
	print "usage:   ./create_tables.py <dc> <pod>"
	print "example: ./create_tables.py pdx V"
	sys.exit(-1)
	

HBaseTable.dc = sys.argv[1]
HBaseTable.pod = sys.argv[2]

print "dc: " + HBaseTable.dc
print "pod: " + HBaseTable.pod

sys.exit(0 if HBaseTable.validate() else -1)
