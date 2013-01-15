#
# Cookbook Name:: wt_portfolio_edgeservice
# Attributes:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

default['wt_portfolio_edgeservice']['user']           = "webtrends"
default['wt_portfolio_edgeservice']['group']          = "webtrends"
default['wt_portfolio_edgeservice']['download_url']   = ""
default['wt_portfolio_edgeservice']['port']           = 8080
default['wt_portfolio_edgeservice']['java_opts']      = "-Xms1024m -XX:+UseG1GC -Djava.net.preferIPv4Stack=true"
default['wt_portfolio_edgeservice']['jmx_port']       = 9999
default['wt_portfolio_edgeservice']['log_dir']        = "/var/log/webtrends/edgeservice"
default['wt_portfolio_edgeservice']['router_uri']     = "tcp://localhost:5761"
