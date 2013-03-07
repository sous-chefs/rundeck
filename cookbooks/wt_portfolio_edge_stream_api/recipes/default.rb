#
# Cookbook Name:: wt_portfolio_edge_stream_api
# Recipe:: default
#
# Copyright 2012, Webtrends
#
# All rights reserved - Do Not Redistribute
#

if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so un-deploying first"
  include_recipe "wt_portfolio_edge_stream_api::undeploy"
else
  log "The deploy_build value is not set or is false so we will only update the configuration"
end

install_dir = File.join(node['wt_common']['install_dir_linux'], "edgeservice/modules/stream_api")
conf_dir = File.join(node['wt_common']['install_dir_linux'], "edgeservice/conf")
tarball      = node['wt_portfolio_edge_stream_api']['download_url'].split("/")[-1]
download_url = node['wt_portfolio_edge_stream_api']['download_url']
user = node['wt_portfolio_edge_stream_api']['user']
group = node['wt_portfolio_edge_stream_api']['group']

log "Install dir: #{install_dir}"

# create the install directory
directory "#{install_dir}" do
  owner "root"
  group "root"
  mode 00755
  recursive true
  action :create
end

if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so we will grab the tar ball and install"

  # download the application tarball
  remote_file "#{Chef::Config[:file_cache_path]}/#{tarball}" do
    source download_url
    mode 00644
  end

  # uncompress the application tarball into the install dir
  execute "tar" do
    user  "root"
    group "root"
    cwd install_dir
    command "tar zxf #{Chef::Config[:file_cache_path]}/#{tarball}"
  end

  proc_port = node['wt_stream_processor']['message_port']
  
  processors = Array.new
    if not Chef::Config.solo
      search(:node, "role:wt_stream_processor AND chef_environment:#{node.chef_environment}").each do |n|
        processors << n[:fqdn]
      end
    end

  i = 0
    while i < processors.size do
      processors[i] = "akka://StreamProcessor@".concat(processors[i]).concat(":#{proc_port}/user/processor")
      i += 1
  end
  
  %w[application.conf].each do | template_file|
    template "#{conf_dir}/#{template_file}" do
      source    "#{template_file}.erb"
      owner "root"
      group "root"
      mode  00644
      variables({processors => processors
      })
    end
  end  

  # delete the install tar ball
  execute "delete_install_source" do
    user "root"
    group "root"
    command "rm -f #{Chef::Config[:file_cache_path]}/#{tarball}"
    action :run
  end

else
end

