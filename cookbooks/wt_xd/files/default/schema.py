#!/usr/bin/env python

import sys
from hbasetable import HBaseTable


class ExternalRawTable(HBaseTable):
	def table(self):
		return "ExternalRaw"
	
	def create(self):
		return """
		{NAME => 'data', VERSIONS => 1,COMPRESSION => 'NONE'}
		"""
	
	def validate(self, schema):
		return True


class JobInfoTable(HBaseTable):
	def table(self):
		return "JobInfo"
	
	def create(self):
		return """
		{NAME => 'info', VERSIONS => 1,COMPRESSION => 'NONE'}
		"""
	
	def validate(self, schema):
		return True


class ExternalMetricsTable(HBaseTable):
	def table(self):
		return "ExternalMetrics"

	def create(self):
		return """
		{NAME => 'a',  VERSIONS => 1, COMPRESSION => 'NONE'}
		{NAME => 'm',  VERSIONS => 1, COMPRESSION => 'NONE'}
		"""

	def validate(self, schema):
		return True


class ExternalCommentsTable(HBaseTable):
	def table(self):
		return "ExternalComments"

	def create(self):
		return """
		{NAME => 'c', VERSIONS => 1, COMPRESSION => 'NONE'}
		"""

	def validate(self, schema):
		return True


HBaseTable.manage(ExternalRawTable())
HBaseTable.manage(JobInfoTable())
HBaseTable.manage(ExternalMetricsTable())
HBaseTable.manage(ExternalCommentsTable())



if (len(sys.argv) != 3):
	print "usage:   ./create_tables.py <dc> <pod>"
	print "example: ./create_tables.py pdx V"
	sys.exit(-1)
	

HBaseTable.dc = sys.argv[1]
HBaseTable.pod = sys.argv[2]

print "dc: " + HBaseTable.dc
print "pod: " + HBaseTable.pod

sys.exit(0 if HBaseTable.validate() else -1)


