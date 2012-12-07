Description
===========
Installs the edge server harness which currently only contains one component - RCS

Requirements
============

Attributes
==========

Environment attributes:

"wt_edge_server": {
            "download_url": "http://teamcity.webtrends.corp/guestAuth/repository/download/bt299/.lastSuccessful/Edge-Server-Distribution-wModules-all.tar.gz"
        },

Cookbook attributes:

default['wt_edge_server']['user']         = "webtrends"
default['wt_edge_server']['group']        = "webtrends"
default['wt_edge_server']['download_url'] = ""
default['wt_edge_server']['port']         = 8081
default['wt_edge_server']['java_opts']    = "-Xms1024m -Djava.net.preferIPv4Stack=true"
default['wt_edge_server']['jmx_port']     = 10000
default['wt_edge_server']['log_level']     = "INFO"

default['wt_edge_server']['active_configs_endpoint'] = "/v1/rulesdata/"
default['wt_edge_server']['config_service_rule_endpoint'] = "/v1/rulesdata/{configid}"
default['wt_edge_server']['graphite_enabled'] = "true"
default['wt_edge_server']['graphite_interval'] = "5"

Usage
=====
