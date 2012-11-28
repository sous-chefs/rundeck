Description
===========
Installs the edge server harness which currently only contains one component - RCS

Requirements
============

Attributes
==========

Environment attributes:

"wt_edge_server": {
            "active_configs_endpoint": "/rcs/v1/activeRules/",
            "config_service_rule_endpoint": "/rcs/v1/rule/{configid}",
            "download_url": "http://teamcity.webtrends.corp/guestAuth/repository/download/bt299/.lastSuccessful/Edge-Server-Distribution-wModules-all.tar.gz",
            "port": 8081,
	    "graphite_enabled":"true",
	    "graphite_interval":"5"
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

