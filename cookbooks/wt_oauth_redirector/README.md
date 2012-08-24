Description
===========
This cookbook installs and configures the Webtrends OAuth Redirector

Attributes
==========
`node['wt_common']['log_dir_linux']` - Base install dir where the oauth_redirector folder gets placed under
`node['wt_common']['install_dir_linux']` - Directory where log files get written
`node['wt_oauth_redirector']['download_url']` - Http download url to the tar.gz file to deploy
`node['wt_oauth_redirector']['logname']` - Name of the log file to create
`node['wt_oauth_redirector']['port']` - Port to start the site on