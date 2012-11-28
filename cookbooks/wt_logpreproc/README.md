Description
===========
Cookbook installs Webtrends Log Preprocessor.

Requirements
============
These need to be installed prior to this cookbook.
* Visual Studio 2010 Runtime libraries

Attributes
==========
* node['wt_common']['install_dir_windows'] - Base location for all windows products to be installed(ie. "D:\\wrs")
* node['wt_common']['ifr_locations'] - List of all IFR data locations in environment.
* node['wt_logpreproc']['netacuity_host'] - Name(s) of the NetAcuity server(s). Semi-colon delimited
* node['wt_logpreproc']['install_dir'] - Subdirectory to install to, such as "\\modules\\logpreproc"
* node['wt_logpreproc']['download_url'] - Http path to where the zip file to deploy is located
* node['wt_logpreproc']['debuglevel'] - Debug level.  3 is the normal debugging level is 3. 7 is the most intense debugging level.
* node['wt_logpreproc']['sleepinterval'] - Time to sleep between re-searching for files (in seconds)
* node['wt_logpreproc']['dnsenabled'] - Enable reverse DNS lookups (true/false)
* node['wt_logpreproc']['geotrendsenabled'] - Enable GeoTrends lookups (true/false)
* node['wt_logpreproc']['addgeofield'] - Add the Geotrends field to log files (true/false).  This setting is ignored if Geotrends is disabled.
* node['wt_logpreproc']['addgeoqueryparams'] - Add Geotrends values as query parameters (true/false).  This setting is ignored if Geotrends is disabled.
* node['wt_logpreproc']['geotrendsretrytimeout'] - Retry timeout when GeoTrends server is not installed or not responding (in seconds)
* node['wt_logpreproc']['logfilebatchsize'] - Number of files to process at a time
* node['wt_logpreproc']['debugmsgsbatchcount'] - At debug level 4 or higher, log stats every time we finish this number of batches
* node['wt_logpreproc']['wtlogpreproc1_label'] - Reference label for the logpreproc section
* node['wt_logpreproc']['wtlogpreproc1_fileextension'] = "*.log.gz.rt" - Pick up these file extensions
* node['wt_logpreproc']['wtlogpreproc1_doneextension'] = ".done" - File extension to be added to original files after processing, when deleteoriginallogs = false
* node['wt_logpreproc']['wtlogpreproc1_compresslogfile'] - Compress logs (true/false)
* node['wt_logpreproc']['wtlogpreproc1_compresslogfile_level'] - Compression level (only used if compresslogfile=true) can be from 1-9. See ENG 304856.
* node['wt_logpreproc']['wtlogpreproc1_deleteoriginallogs'] - Delete the orignal lfr logs when finished (true/false)
* node['wt_logpreproc']['wtlogpreproc1_webserver'] - Web Logs default to IIS Logs
* node['wt_logpreproc']['dns_serverlist'] - List of DNS server IP addresses (semi-colon delimited).  Use if you need to override the system default DNS server.
* node['wt_logpreproc']['dns_retrycount'] - DNS retry count
* node['wt_logpreproc']['dns_retrytimeout'] - DNS retry timeout
* node['wt_logpreproc']['dns_servermethod'] - DNS Server selection method (round robin=1, load balanced=2, ip affinity=3)
* node['wt_logpreproc']['dns_logfile'] - Filename to use for the DNS error log
* node['wt_logpreproc']['wtda_numthreads'] - Number of threads.  Currently should be 1
* node['wt_logpreproc']['wtda_compressedext'] - List of file extensions used for compressed files
* node['wt_logpreproc']['wtda_encryptedext'] - List of file extensions used for encrypted files
* node['wt_logpreproc']['readbuffersize'] - Read buffer size.  Should be 131072 * 2 for production
* node['wt_logpreproc']['wtda_maxconsecutiveinvalidentries'] - Maximum number of invalid records allowed in a logfile
* node['wt_logpreproc']['wtda_maxrecordqueuesize'] - Maximum outstanding DNS or Geotrends lookups
* node['wt_logpreproc']['auditlog_limitbysize'] - Limit audit log by size (true/false)
* node['wt_logpreproc']['auditlog_limitbysizemethod'] - Method by which to limit audit log size
* node['wt_logpreproc']['auditlog_maxsize'] - Maximum audit log size
* node['wt_logpreproc']['auditlog_trimsize'] - Audit log trim size
* node['wt_logpreproc']['auditlog_filenameprefix'] - Audit log filename prefix
* node['wt_logpreproc']['auditlog_filenameext'] - Audit log filename etension

Data Bag Items
===============
* authorization data bag should have a data bag item for every environment Search will be deployed to. It must contain the following values
	* `authorization['wt_common']['system_user']` - User that owns service
	* `authorization['wt_common']['system_pass']` - Password for system_user

Usage
=====
