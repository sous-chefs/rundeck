Description
===========
Installs the edge server harness which currently only contains one component - RCS

Requirements
============

Attributes
==========

Environment attributes:

"wt_edge_server": {
            "download_url": "http://teamcity.webtrends.corp/guestAuth/repository/download/<branchid>/.lastSuccessful/<filename>-bin.tar.gz", 
            "port": 8081,
	    "config_service_rule_url_template":"https://rcs.configServer.host/rcs/v1/rule/{configid}",
	    "active_configs_url_template":"https://rcs.configServer.host/rcs/v1/activeRules/"
        },  

Cookbook attributes:

default['wt_edge_server']['user']         = "webtrends"
default['wt_edge_server']['group']        = "webtrends"
default['wt_edge_server']['download_url'] = ""
default['wt_edge_server']['port']         = 8081
default['wt_edge_server']['java_opts']    = "-Xms1024m -Djava.net.preferIPv4Stack=true"
default['wt_edge_server']['jmx_port']     = 10000
default['wt_edge_server']['log_level']     = "INFO"

Usage
=====

