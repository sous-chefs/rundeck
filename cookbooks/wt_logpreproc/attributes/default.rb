#
# Cookbook Name:: wt_logpreproc
# Attribute:: default
# Author:: Jeremy Chartrand
#
# Copyright 2012, Webtrends Inc.
#

default['wt_logpreproc']['service_binary'] = 'wtlogpreproc.exe'
default['wt_logpreproc']['service_name'] = 'wtlogpreproc'
default['wt_logpreproc']['install_dir'] = 'modules\\logpreproc'
default['wt_logpreproc']['log_dir'] = 'logs'
default['wt_logpreproc']['download_url'] = ''
default['wt_logpreproc']['netacuity_host'] = 'localhost'

# 3 is the normal debugging level is 3. 7 is the most intense debugging level
default['wt_logpreproc']['debuglevel'] = '3'

# Time to sleep between re-searching for files (in seconds)
default['wt_logpreproc']['sleepinterval'] = '20'

# Enable reverse DNS lookups
default['wt_logpreproc']['dnsenabled'] = 'true'

# Enable GeoTrends lookups
default['wt_logpreproc']['geotrendsenabled'] = 'true'

# Add the Geotrends field to log files.  This setting is ignored if Geotrends is disabled.
default['wt_logpreproc']['addgeofield'] = 'true'

# Add Geotrends values as query parameters.  This setting is ignored if Geotrends is disabled.
default['wt_logpreproc']['addgeoqueryparams'] = 'true'

# Retry timeout when GeoTrends server is not installed or not responding (in seconds)
default['wt_logpreproc']['geotrendsretrytimeout'] = '600'

# Number of files to process at a time
default['wt_logpreproc']['logfilebatchsize'] = '30'

# At debug level 4, log stats every time we finish this number of batches
default['wt_logpreproc']['debugmsgsbatchcount'] = '10'

# Label for reference
default['wt_logpreproc']['wtlogpreproc1_label'] = 'defaultlogpreproc'

# Pick up these file extensions
default['wt_logpreproc']['wtlogpreproc1_fileextension'] = '*.log.gz.rt'

# File extension for files output by this tool
default['wt_logpreproc']['wtlogpreproc1_doneextension'] = '.log.gz.rt.pp'

# Source path(s)
default['wt_logpreproc']['wtlogpreproc1_sourcepath'] = nil
default['wt_logpreproc']['wtlogpreproc1_sourcepath1'] = nil

# Compress Logs. Compression level (only used if compresslogfile=true) can be from 1-9. See ENG 304856.
#     1 - Maximum speed, no lazy matches. Default used by most LumberJack 7.1 tools (except LogCat).
#     4 - Lazy matches
#     5 - Default used in DynaZip. Default used by LumberJack 8.0 LogCat.
#     6 - Default used in CryptoPP. See BASE_Shared\crypto\zdeflate.h, Deflator::enum {DEFAULT_DEFLATE_LEVEL}
#     9 - Maximum compression
default['wt_logpreproc']['wtlogpreproc1_compresslogfile'] = 'true'
default['wt_logpreproc']['wtlogpreproc1_compresslogfile_level'] = '1'

# Delete the orignal lfr logs when finished
default['wt_logpreproc']['wtlogpreproc1_deleteoriginallogs'] = 'false'

# List of DNS server IP addresses (semi-colon delimited) 
# Use if you need to override the system default DNS server.
default['wt_logpreproc']['dns_serverlist'] = '10.164.0.5;10.164.0.6'

# DNS Lookup Retry count
default['wt_logpreproc']['dns_retrycount'] = '0'

# Retry timeout (in milliseconds)
default['wt_logpreproc']['dns_retrytimeout'] = '2000'

# Server selection method (round robin=1, load balanced=2, ip affinity=3)
# ip affinity is recommended for best performance. 
# If you configure multiple instances of LPP, ip affinity performance needs the DNS server list in the same order for all instances.
default['wt_logpreproc']['dns_servermethod'] = '3'

# DNS log file
default['wt_logpreproc']['dns_logfile'] = 'wt_dns.log'

# Numthreads should be 1 for LPP 
default['wt_logpreproc']['wtda_numthreads'] = '1'

# compressed filename extensions (comma separated list)
# Any 'fileextension' values which are in this list are compressed files:
default['wt_logpreproc']['wtda_compressedext'] = '.log.gz,.log.gz.rt,.log.gz.pp,.log.gz.pp.rt,.log.gz.rt.pp'

# encrypted filename extensions (comma separated list)
# Any 'fileextension' values which are in this list are encrypted files:
default['wt_logpreproc']['wtda_encryptedext'] = '.log.gpg,.log.asc'

# Maximum number of invalid records allowed in a logfile
default['wt_logpreproc']['wtda_maxconsecutiveinvalidentries'] = '100'

# maximum number of LPP records with outstanding Geo or DNS lookups
default['wt_logpreproc']['wtda_maxrecordqueuesize'] = '50000'

# Audit log trimming configuration
default['wt_logpreproc']['auditlog_limitbysize'] = 'true'
default['wt_logpreproc']['auditlog_limitbysizemethod'] = 'rotate'
default['wt_logpreproc']['auditlog_maxsize'] = '1000'
default['wt_logpreproc']['auditlog_trimsize'] = '10'

# Audit log filename and extension
default['wt_logpreproc']['auditlog_filenameprefix'] = 'logpreproc'
default['wt_logpreproc']['auditlog_filenameext'] = 'audit'

