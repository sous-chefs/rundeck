#
# Cookbook Name:: wt_logpreproc
# Recipe:: default
# Author:: Jeremy Chartrand
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#
# This recipe installs the needed components to full setup/configure the Log Preprocessor service
#

if ENV["deploy_build"] == "true" then
  log "The deploy_build value is true so un-deploying first"
  include_recipe "wt_logpreproc::uninstall"
else
  log "The deploy_build value is not set or is false so we will only update the configuration"
end

# get parameters
download_url   = node['wt_logpreproc']['download_url']

# destinations
install_dir = File.join(node['wt_common']['install_dir_windows'], node['wt_logpreproc']['install_dir']).gsub(/[\\\/]+/,"\\")

# get data bag items
auth_data = data_bag_item('authorization', node.chef_environment)
svcuser = auth_data['wt_common']['system_user']
svcpass = auth_data['wt_common']['system_pass']

# create the install directory
directory install_dir do
  recursive true
  action :create
end

# grant service account access
wt_base_icacls node['wt_common']['install_dir_windows'] do
  user svcuser
  perm :modify
  action :grant
end

if ENV["deploy_build"] == "true" then

  log "Source URL: #{download_url}"

  # unzip the install package
  windows_zipfile install_dir do
    source download_url
    action :unzip
  end

  svcbin = "#{install_dir}\\wtlogpreproc.exe"
  execute 'wtlogpreproc.exe' do
    command "#{svcbin} --install startup=auto username=#{svcuser} password=\"#{svcpass}\""
    notifies :start, 'service[wtlogpreproc]'
  end

  share_wrs
end

template "#{install_dir}\\wtlogpreproc.ini" do
  source "wtlogpreproc.ini.erb"
  variables(
    :debuglevel            => node['wt_logpreproc']['debuglevel'],
    :sleepinterval         => node['wt_logpreproc']['sleepinterval'],
    :dnsenabled            => node['wt_logpreproc']['dnsenabled'],
    :geotrendsenabled      => node['wt_logpreproc']['geotrendsenabled'],
    :addgeofield           => node['wt_logpreproc']['addgeofield'],
    :addgeoqueryparams     => node['wt_logpreproc']['addgeoqueryparams'],
    :geotrendsretrytimeout => node['wt_logpreproc']['geotrendsretrytimeout'],
    :logfilebatchsize      => node['wt_logpreproc']['logfilebatchsize'],
    :debugmsgsbatchcount   => node['wt_logpreproc']['debugmsgsbatchcount'],

    :source_paths                        => node['wt_common']['ifr_locations'],
    :wtlogpreproc1_label                 => node['wt_logpreproc']['wtlogpreproc1_label'],
    :wtlogpreproc1_fileextension         => node['wt_logpreproc']['wtlogpreproc1_fileextension'],
    :wtlogpreproc1_doneextension         => node['wt_logpreproc']['wtlogpreproc1_doneextension'],
    :wtlogpreproc1_compresslogfile       => node['wt_logpreproc']['wtlogpreproc1_compresslogfile'],
    :wtlogpreproc1_compresslogfile_level => node['wt_logpreproc']['wtlogpreproc1_compresslogfile_level'],
    :wtlogpreproc1_deleteoriginallogs    => node['wt_logpreproc']['wtlogpreproc1_deleteoriginallogs'],

    :geo_maxcachedrecords  => node['wt_logpreproc']['geo_maxcachedrecords'],
    :geo_maxretries        => node['wt_logpreproc']['geo_maxretries'],
    :geo_timeoutlength     => node['wt_logpreproc']['geo_timeoutlength'],
    :geo_maxpending        => node['wt_logpreproc']['geo_maxpending'],
    :geo_server            => node['wt_netacuity']['geo_url'],

    :dns_serverlist   => node['wt_logpreproc']['dns_serverlist'],
    :dns_retrycount   => node['wt_logpreproc']['dns_retrycount'],
    :dns_retrytimeout => node['wt_logpreproc']['dns_retrytimeout'],
    :dns_servermethod => node['wt_logpreproc']['dns_servermethod'],
    :dns_logfile      => node['wt_logpreproc']['dns_logfile'],

    :wtda_numthreads                   => node['wt_logpreproc']['wtda_numthreads'],
    :wtda_compressedext                => node['wt_logpreproc']['wtda_compressedext'],
    :wtda_encryptedext                 => node['wt_logpreproc']['wtda_encryptedext'],
    :wtda_maxconsecutiveinvalidentries => node['wt_logpreproc']['wtda_maxconsecutiveinvalidentries'],

    :auditlog_limitbysize       => node['wt_logpreproc']['auditlog_limitbysize'],
    :auditlog_limitbysizemethod => node['wt_logpreproc']['auditlog_limitbysizemethod'],
    :auditlog_maxsize           => node['wt_logpreproc']['auditlog_maxsize'],
    :auditlog_trimsize          => node['wt_logpreproc']['auditlog_trimsize'],
    :auditlog_filenameprefix    => node['wt_logpreproc']['auditlog_filenameprefix'],
    :auditlog_filenameext       => node['wt_logpreproc']['auditlog_filenameext'],
  )
end

service 'wtlogpreproc' do
  supports :start => true, :restart => true
  subscribes :restart, resources(
    :template => "#{install_dir}\\wtlogpreproc.ini"
  )
  action :nothing
end
