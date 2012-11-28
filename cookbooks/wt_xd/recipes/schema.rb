#
# Cookbook Name:: wt_xd
# Recipe:: schema
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

install_dir = File.join(node['wt_common']['install_dir_linux'], 'wt_xd')

# create dir
directory install_dir do
	mode 00755
	recursive true
end

# drop in templates
%w[hbasetable.py schema.py].each do |file|
  cookbook_file "#{install_dir}/#{file}" do
    source "#{file}"
    owner 'hadoop'
    group 'hadoop'
    mode 00550
  end
end