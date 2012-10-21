#
# Cookbook Name:: wt_realtime_hadoop
# Recipe:: schema
# Author:: Sean McNamara
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute

# create dir
directory "#{node['wt_common']['install_dir_linux']}/wt_realtime_hadoop" do
  mode 00755
  recursive true
end

# drop in templates
%w[hbasetable.py schema.py].each do |file|
  cookbook_file "#{node['wt_common']['install_dir_linux']}/wt_realtime_hadoop/#{file}" do
    source "#{file}"
    owner "hadoop"
    group "hadoop"
    mode 00550
  end
end
