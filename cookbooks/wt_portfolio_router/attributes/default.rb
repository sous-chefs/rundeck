#
# Cookbook Name:: wt_portfolio_router
# Attributes:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

default['wt_portfolio_router']['user']           = "webtrends"
default['wt_portfolio_router']['group']          = "webtrends"
default['wt_portfolio_router']['download_url']   = "http://teamcity.webtrends.corp/guestAuth/repository/download/bt337/.lastSuccessful/webtrends-portfolio-router-develop-SNAPSHOT-bin.tar.gz"
default['wt_portfolio_router']['java_opts']      = "-Xms1024m -XX:+UseG1GC -Djava.net.preferIPv4Stack=true"
default['wt_portfolio_router']['jmx_port']       = 9999
default['wt_portfolio_router']['log_dir']        = "/var/log/webtrends/router"
