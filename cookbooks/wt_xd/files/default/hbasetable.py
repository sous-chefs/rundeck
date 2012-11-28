#!/usr/bin/env python

from subprocess import Popen, PIPE

class HBaseTable:
	
	tables = []
	dc = ""
	pod = ""
	
	def create(self):
		raise NotImplementedError("Please implement create()")
	
	def validate(self, schema):
		raise NotImplementedError("Please implement validate()")
			
	def table(self):
		raise NotImplementedError("Please implement table()")
		
	def check(self):
		print "Checking: " + self.name()
		if self.tableExists():
			print "Exists, validating: " + self.name()
			return self.validate(self.hbaseShell("describe '" + self.name() + "'"))
		
		print "Does not exist, Creating: " + self.name()
		self.hbaseShell("create '" + self.name() + "', " + self.create())
		return self.tableExists()
	
	def alter(self, stmt):
		print "Altering: " + self.name()
		return self.hbaseShell("disable '" + self.name() + "'\nalter '" + self.name() + "', " + stmt + "\nenable '" + self.name() + "'\n")
		
	def name(self):
		return HBaseTable.dc + "_" + HBaseTable.pod + "_" + self.table()
	
	def hbaseShell(self, cmd):
		p = Popen(['/usr/share/hbase/bin/hbase','shell'], bufsize=1, stdin=PIPE, stdout=PIPE)
		p.stdin.write(cmd+"\n")
		p.stdin.close()
		return p.stdout.read()
	
	def tableExists(self):
		return self.name() in self.hbaseShell("list").split("\n")
	
	@staticmethod
	def manage(hbaseTableInstance):
		HBaseTable.tables.append(hbaseTableInstance)
	
	@staticmethod
	def validate():
		for t in HBaseTable.tables:
			if t.check():
				print "PASS: " + t.name()
			else:
				print "FAIL: " + t.name()
				return False

		return True


