Description
===========
Deploys the Cam DB on a windows box, ensuring any previous cam db is
first dropped.

Requirements
============
This requires the database and windows cookbooks, as well as for the
tiny_tds gem to be installed. The later requires the ability to build on
windows.

Attributes
==========
THere are 4 attributes:
  port - The port the CAM DB MSSQL server listens on. Default is 1433.
  major_version and minor_version - versions of cam. Default is 1.0
  download_url - Where to find the deploy scripts. Default is
                 lastSuccesful build on webtrends teamcity server
Usage
=====

Add 'recipe['wt_cam_db']' to your role list

