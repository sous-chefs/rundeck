#!/usr/bin/env python

import sys
from hbasetable import HBaseTable


class UidTable(HBaseTable):
	def table(self):
		return "uid"
	
	def create(self):
		return """
		{NAME => 'name', VERSIONS => 1,COMPRESSION => 'NONE'},
		{NAME => 'id',   VERSIONS => 1,COMPRESSION => 'NONE'}
		"""
	
	def validate(self, schema):
		return True


class DimensionHourTable(HBaseTable):
	def table(self):
		return "dimension-hour"

	def create(self):
		return """
		{NAME => 'md',  VERSIONS => 1, COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'}
		{NAME => 'ml',  VERSIONS => 1, COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'}
		{NAME => 'mc',  VERSIONS => 1, COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'}
		"""

	def validate(self, schema):
		if not("'ml'" in schema):
			self.alter("{NAME => 'ml',  VERSIONS => 1, COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'}")
		
		if not("'mc'" in schema):
			self.alter("{NAME => 'mc',  VERSIONS => 1, COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'}")

		return True


class DimensionDayTable(HBaseTable):
	def table(self):
		return "dimension-day"

	def create(self):
		return """
		{NAME => 'tc', VERSIONS => 1, COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'},
		{NAME => 'tl', VERSIONS => 1, COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'},
		{NAME => 'h',  VERSIONS => 1, COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'},
		{NAME => 'hc', VERSIONS => 1, COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'}
		"""

	def validate(self, schema):
		return True


class VisitorTable(HBaseTable):
	def table(self):
		return "visitor"

	def create(self):
		return """
		{NAME => 'i', VERSIONS => 1, COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'},
		{NAME => 's', VERSIONS => 1, COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'}
		"""

	def validate(self, schema):
		return True


class SessionTable(HBaseTable):
	def table(self):
		return "session"

	def create(self):
		return """
		{NAME => 'hp', VERSIONS => 1, COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'},
		{NAME => 'i',  VERSIONS => 1, COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'},
		{NAME => 'p',  VERSIONS => 1, COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'}
		"""

	def validate(self, schema):
		return True


class DcsidLookupTable(HBaseTable):
	def table(self):
		return "dcsid-lookup"

	def create(self):
		return """
		{NAME => 'id',   VERSIONS => 1, COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'},
		{NAME => 'name', VERSIONS => 1, COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'}
		"""

	def validate(self, schema):
		return True


class DimensionLookupTable(HBaseTable):
	def table(self):
		return "dimension-lookup"

	def create(self):
		return """
		{NAME => 'id',   VERSIONS => 1, COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'},
		{NAME => 'name', VERSIONS => 1, COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'}
		"""

	def validate(self, schema):
		return True


class NextIdTable(HBaseTable):
	def table(self):
		return "next-id"

	def create(self):
		return """
		{NAME => 'id', VERSIONS => 1, COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'}
		"""

	def validate(self, schema):
		return True



HBaseTable.manage(UidTable())
HBaseTable.manage(DimensionHourTable())
HBaseTable.manage(DimensionDayTable())
HBaseTable.manage(VisitorTable())
HBaseTable.manage(SessionTable())
HBaseTable.manage(DcsidLookupTable())
HBaseTable.manage(DimensionLookupTable())
HBaseTable.manage(NextIdTable())



if (len(sys.argv) != 3):
	print "usage:   ./create_tables.py <dc> <pod>"
	print "example: ./create_tables.py pdx V"
	sys.exit(-1)
	

HBaseTable.dc = sys.argv[1]
HBaseTable.pod = sys.argv[2]

print "dc: " + HBaseTable.dc
print "pod: " + HBaseTable.pod

sys.exit(0 if HBaseTable.validate() else -1)


