#
# Cookbook Name:: wt_actioncenter_ui
# Recipe:: default
#
# Copyright 2013, Webtrends
#
# All rights reserved - Do Not Redistribute
#

# Our artifact info
rel_version = node[:wt_actioncenter_ui][:release]
artifact_name = 'actioncenter-ui'
install_dir = File.join(node[:wt_common][:install_dir_linux], artifact_name)
log_dir = File.join(node[:wt_common][:log_dir_linux], artifact_name)
deploy_build = !!(ENV['deploy_build'] =~ /true/i)
ui_user = node[:wt_actioncenter_ui][:user]
ui_group = node[:wt_actioncenter_ui][:group]
user_data = data_bag_item('authorization', node.chef_environment)

log "install_dir: #{install_dir}"
log "log_dir: #{log_dir}"
log "deploy_build: #{deploy_build}"

gem_package "bundler" do
  gem_binary '/usr/bin/gem'
  version '1.2.2'
end

directory log_dir do
  owner ui_user
  group ui_user
  mode 00755
  recursive true
  action :create
end

# Clean up so we can properly force a deploy.
# Not really using the artifact versioning correctly, so we have to
# clear out the cached version.
if deploy_build
  my_artifact_cache = File.join(Chef::Config[:file_cache_path], "artifact_deploys", artifact_name)
  my_artifact_cache_version_path = File.join(my_artifact_cache, rel_version)
  my_artifact_filename = File.basename(node[:wt_actioncenter_ui][:download_url])
  my_cached_tar_path = File.join(my_artifact_cache_version_path, my_artifact_filename)
  log "Removing #{my_cached_tar_path} since deploy_build=true."
  file my_cached_tar_path do
    action :delete 
  end
end

artifact_deploy artifact_name do
  version rel_version
  deploy_to "#{install_dir}"
  artifact_location node[:wt_actioncenter_ui][:download_url]
  remove_top_level_directory true
  owner ui_user
  group ui_group
  environment({ 'RAILS_ENV' => 'production' })
  shared_directories %w(tmp pids)
  symlinks({ 'tmp' => 'tmp' })

  before_extract Proc.new {
    service artifact_name do
      action :stop
    end
    # For now, clean out the current release if we are running with deploy_build=true
    if deploy_build
      log "Cleaning out #{release_path} since deploy_build=true"
      directory release_path do
        recursive true
        action :delete 
      end
      # And recreate so tar doesn't barf later
      directory release_path do
        owner ui_user
        group ui_group
        mode '0755'
        recursive true
        action :create 
      end
    end
  }

  after_extract Proc.new {
    bundle_without = node[:wt_actioncenter_ui][:bundle_without].join(' ')
    log "Bundle version #{`bundle --version`}"
    execute "bundle install" do
      command "bundle install --local --path=vendor/bundle --without #{bundle_without} --binstubs --deployment"
      cwd release_path
      environment({'RAILS_ENV' => 'production'})
      user ui_user
      group ui_group
    end

    # Set up release/log -> log_dir
    link File.join(release_path, "log") do
      to log_dir
      owner ui_user
      group ui_group
    end
  }

  configure Proc.new {
    auth_base = node[:wt_sauth][:auth_service_url]
    auth_version = node[:wt_actioncenter_ui][:auth_service_version]

    template "#{release_path}/config/settings/production.yml" do
      source "production.yml.erb"
      variables(
        :allow_http => node[:wt_actioncenter_ui][:allow_http],
        :help_url => node[:wt_actioncenter_ui][:help_url],

        :actioncenter_url => node[:wt_actioncenter_management_api][:ac_management_url],
        # Auth
        :auth_url => "#{auth_base}/#{auth_version}",
        :client_id => user_data['wt_actioncenter_ui']['client_id'],
        :client_secret => user_data['wt_actioncenter_ui']['client_secret'],
        :http_proxy => node[:wt_common][:http_proxy_url],
        :cam_url => node[:wt_cam][:cam_service_url],
        :sms_url => node[:wt_streamingmanagementservice][:sms_service_url]
      )
    end

    unicorn_config "#{release_path}/config/unicorn.rb" do
      owner ui_user
      group ui_group
      listen({ node[:wt_actioncenter_ui][:unicorn][:port] => node[:wt_actioncenter_ui][:unicorn][:options] })
      # Current release path?
      working_directory File.join(install_dir, 'current')
      worker_timeout node[:wt_actioncenter_ui][:unicorn][:worker_timeout]
      preload_app node[:wt_actioncenter_ui][:unicorn][:preload_app]
      worker_processes node[:wt_actioncenter_ui][:unicorn][:worker_processes]
      before_fork node[:wt_actioncenter_ui][:unicorn][:before_fork]
      # Work around weird issue where unicorn doesn't find Gemfile when in symlinked dir
      #before_exec "ENV['BUNDLE_GEMFILE'] = '#{install_dir}/releases/#{rel_version}/Gemfile'"
    end 

    runit_service artifact_name do
      options(
        :install_dir => release_path,
        :user => ui_user,
        :group => ui_group,
        :environment => 'production'
      )
      action :enable
    end
  }

  restart Proc.new {
    service artifact_name do
      action :restart
    end
  }

  # map the deploy_build portion to force
  # since version and URL are not guaranteed to change
  force ENV["deploy_build"] == "true"
  action :deploy
end

web_app artifact_name do
  template "apache.conf.erb"
  server_name node['hostname']
  server_aliases [node['fqdn']]
  docroot File.join(install_dir, 'current', 'public')
  unicorn_port node[:wt_actioncenter_ui][:unicorn][:port]
end
