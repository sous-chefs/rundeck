
# Author:: Kendrick Martin(<kendrick.martin@webtrends.com>)
# Cookbook Name:: wt_portfolio_admin
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

default['wt_portfolio_manager']['app_pool'] = "PortfolioManager"
default['wt_portfolio_manager']['download_url'] = ""
default['wt_portfolio_manager']['port'] = 80
default['wt_portfolio_manager']['log_level'] = "INFO"
default['wt_portfolio_manager']['elmah_remote_access'] = "no"
default['wt_portfolio_manager']['custom_errors'] = "On"
default['wt_portfolio_manager']['proxy_enabled'] = "true"
default['wt_portfolio_manager']['cam_service_url_base'] = ""
default['wt_portfolio_manager']['manager_ui_url'] = ""
default['wt_portfolio_manager']['portmgr_group_admin']="PortMgr.Admin"
default['wt_portfolio_manager']['portmgr_group_user']="PortMgr.User"
default['wt_portfolio_manager']['portmgr_injected_user']=""
default['wt_portfolio_manager']['portmgr_domain']="NETIQDMZ"
