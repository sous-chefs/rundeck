#
# Cookbook Name:: wt_actioncenter_ui
# Recipe:: default
#
# Copyright 2013, Webtrends
#
# All rights reserved - Do Not Redistribute
#
include_recipe "runit"

rel_version = "0.1.0"
user_data = data_bag_item('authorization', node.chef_environment)
install_dir = File.join(node[:wt_common][:install_dir_linux], 'actioncenter-ui')
log "install_dir: #{install_dir}"
log_dir = File.join(node[:wt_common][:log_dir_linux], 'actioncenter-ui')
log "log_dir: #{log_dir}"
ui_user = node[:wt_actioncenter_ui][:user]
ui_group = node[:wt_actioncenter_ui][:group]

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

artifact_deploy "actioncenter_ui" do
  version rel_version
  deploy_to "#{install_dir}"
  artifact_location node[:wt_actioncenter_ui][:download_url]
  remove_top_level_directory true
  owner ui_user
  group ui_group
  environment({ 'RAILS_ENV' => 'production' })
  shared_directories %w(log tmp pids)
  symlinks({ 'log' => 'log', 'tmp' => 'tmp' })

  before_extract Proc.new {
    service 'actioncenter-ui' do
      action :stop
    end
  }

  after_extract Proc.new {
    bundle_without = node[:wt_actioncenter_ui][:bundle_without].join(' ')
    execute "bundle install" do
      command "/usr/bin/bundle install --local --path=vendor/bundle --without #{bundle_without} --binstubs --deployment"
      cwd release_path
      environment({'RAILS_ENV' => 'production'})
      user ui_user
      group ui_group
    end
  }

  configure Proc.new {
    auth_base = node[:wt_sauth][:auth_service_url]
    auth_version = node[:wt_actioncenter_ui][:auth_service_version]
    template "#{release_path}/config/settings/production.yml" do
      source "production.yml.erb"
      variables(
        :help_url => node[:wt_actioncenter_ui][:help_url],
        # Auth
        :auth_url => "#{auth_base}/#{auth_version}",
        :client_id => user_data['wt_actioncenter_ui']['client_id'],
        :client_secret => user_data['wt_actioncenter_ui']['client_secret'],
        :http_proxy => node[:wt_common][:http_proxy_url],
        :cam_url => node[:wt_cam][:cam_service_url]
      )
    end

    unicorn_config "#{release_path}/config/unicorn.rb" do
      owner ui_user
      group ui_group
      listen({ node[:wt_actioncenter_ui][:port] => node[:wt_actioncenter_ui][:unicorn][:options] })
      # Current release path?
      working_directory File.join(install_dir, 'current')
      worker_timeout node[:wt_actioncenter_ui][:unicorn][:worker_timeout]
      preload_app node[:wt_actioncenter_ui][:unicorn][:preload_app]
      worker_processes node[:wt_actioncenter_ui][:unicorn][:worker_processes]
      before_fork node[:wt_actioncenter_ui][:unicorn][:before_fork]
      # Work around weird issue where unicorn doesn't find Gemfile when in symlinked dir
      #before_exec "ENV['BUNDLE_GEMFILE'] = '#{install_dir}/releases/#{rel_version}/Gemfile'"
    end 

    runit_service 'actioncenter-ui' do
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
    service 'actioncenter-ui' do
      action :restart
    end
  }

  # map the deploy_build portion to force
  # since version and URL are not guaranteed to change
  force ENV["deploy_build"] == "true"
  action :deploy
end
