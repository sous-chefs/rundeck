#
# Author:: Michael Parsons(<michael.parsons@webtrends.com>)
# Cookbook Name:: wt_pdf_service
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

# build info
default['wt_pdf_service']['artifact'] = ''
default['wt_pdf_service']['tc_proj'] = 'PDFService'
default['wt_pdf_service']['download_url'] = ''


# install subfolder
default['wt_pdf_service']['install_dir'] = 'PDFService'

# iis settings
default['wt_pdf_service']['website_name'] = 'PDFService'
default['wt_pdf_service']['website_port'] = 8080
default['wt_pdf_service']['app_pool_name'] = 'pdfsvc'

default['wt_pdf_service']['app_pool'] = 'pdfsvc'

# app settings section

# log4net settings
default['wt_pdf_service']['log_level'] = 'INFO'


