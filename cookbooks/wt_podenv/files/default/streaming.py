#!/usr/bin/env python

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
		{NAME => 'uc',  VERSIONS => 1, COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'},  
		{NAME => 'ul',  VERSIONS => 1, COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'},
		{NAME => 'nuc', VERSIONS => 1, COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'},
		{NAME => 'nul', VERSIONS => 1, COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'},
		{NAME => 'md',  VERSIONS => 1, COMPRESSION => 'NONE', BLOOMFILTER => 'ROW'}
		"""

	def validate(self, schema):
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

