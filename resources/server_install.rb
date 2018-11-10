# frozen_string_literal: true
#
# Cookbook:: rundeck
# Resource:: server_install
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include RundeckCookbook::Helpers

property :acl_policies, Hash, default: {}
property :admin_password, String, default: 'admin', sensitive: true
property :basedir, String, default: '/var/lib/rundeck'
property :chef_url, String, default: "https://chef.#{node['domain']}"
property :configdir, String, default: '/etc/rundeck'
property :custom_framework_config, Hash, default: {}
property :custom_jvm_properties, String
property :custom_rundeck_config, Hash, default: {}
property :datadir, String, default: '/var/rundeck'
property :default_role, String, default: 'user'
property :exec_logdir, String, default: lazy { "#{basedir}/logs" }
property :extra_wait, Integer, default: 120
property :framework_properties, Hash, default: {}
property :grails_port, Integer, default: lazy { use_ssl ? 443 : 80 }
property :grails_server_url, String, default: lazy { "#{use_inbuilt_ssl ? 'https' : 'http'}://#{hostname}" }
property :hostname, String, default: "rundeck.#{node['domain']}"
property :jaas, String, default: 'internal'
property :jvm_mem, String, default: ' -XX:MaxPermSize=256m -Xmx1024m -Xms256m'
property :log_level, ['ERR', 'WARN', 'INFO', 'VERBOSE', 'DEBUG'], default: 'INFO'
property :mail_email, String
property :mail_enable,  [true, false], default: false
property :mail_host, String
property :mail_password, String, sensitive: true
property :mail_port, String
property :mail_user, String
property :plugins, Hash
property :port, Integer, default: 4440
property :private_key, String, sensitive: true
property :quartz_threadPoolCount, Integer, default: 10
property :rdbms_dbname, String
property :rdbms_dialect, String
property :rdbms_dialect, String
property :rdbms_enable, [true, false], default: false
property :rdbms_location, String
property :rdbms_password, String, sensitive: true
property :rdbms_port, Integer
property :rdbms_type, ['mysql', 'oracle']
property :rdbms_user, String
property :restart_on_config_change, [true, false], default: false
property :rss_enabled, [true, false], default: false
property :rundeckgroup, String, default: 'rundeck'
property :rundeckuser, String, default: 'rundeck'
property :rundeck_users, Hash, default: {}, sensitive: true
property :security_roles, Hash, default: {}
property :service_retries, Integer, default: 60
property :service_retry_delay, Integer, default: 5
property :session_timeout, Integer, default: 30
property :ssl_port, Integer, default: 4443
property :tempdir, String, default: '/tmp/rundeck'
property :tokens_file, String
property :truststore_type, String, default: 'jks'
property :use_inbuilt_ssl, [true, false], default: false
property :use_ssl, [true, false], default: false
property :uuid, String, default: lazy { generateuuid }
property :version, String, default: '3.0.8.20181029'
property :webcontext, String, default: '/'
property :windows_winrm_auth_type, String, default: 'basic'
property :windows_winrm_cert_trust, String, default: 'all'
property :windows_winrm_hostname_trust, String, default: 'all'
property :windows_winrm_protocol, String, default: 'https'
property :windows_winrm_timeout, String, default: 'PT60.000S'


action :install do
  node.default['java']['jdk_version'] = '8'
  include_recipe 'java'

  rundeck_repository 'public'

  package 'rundeck' do
    version new_resource.version
    action :install
  end

  case node['platform_family']
  when 'rhel'
    yum_package 'which'

    yum_package 'rundeck-config' do
      version new_resource.version
      allow_downgrade true
      action :install
    end

  else
    package 'uuid-runtime'
    package 'openssh-client'
  end

  directory new_resource.basedir do
    owner new_resource.rundeckuser
    group new_resource.rundeckgroup
    recursive true
  end

  directory new_resource.exec_logdir do
    owner new_resource.rundeckuser
    group new_resource.rundeckgroup
    recursive true
  end

  directory "#{new_resource.basedir}/projects" do
    owner new_resource.rundeckuser
    group new_resource.rundeckgroup
    recursive true
  end

  directory "#{new_resource.basedir}/.chef" do
    owner new_resource.rundeckuser
    group new_resource.rundeckgroup
    recursive true
    mode '0700'
  end

  directory "#{new_resource.basedir}/.ssh" do
    owner new_resource.rundeckuser
    group new_resource.rundeckgroup
    recursive true
    mode '0700'
  end

  template "#{new_resource.basedir}/.chef/knife.rb" do
    cookbook 'rundeck'
    owner new_resource.rundeckuser
    group new_resource.rundeckgroup
    source 'knife.rb.erb'
    variables(
      user_home: new_resource.basedir,
      node_name: new_resource.rundeckuser,
      chef_server_url: new_resource.chef_url
    )
    # notifies (new_resource.restart_on_config_change ? :restart : :nothing), 'service[rundeckd]', :delayed
  end

  file "#{new_resource.basedir}/.ssh/id_rsa" do
    owner new_resource.rundeckuser
    group new_resource.rundeckgroup
    mode '0600'
    backup false
    content new_resource.private_key
    only_if { new_resource.private_key }
  #  notifies (new_resource.restart_on_config_change ? :restart : :nothing), 'service[rundeckd]', :delayed
  end

  # remote_file "#{new_resource.basedir}/libext/#{node['rundeck']['plugins']['winrm']['url'].match(%r{[^/]+$})}" do
  #   source node['rundeck']['plugins']['winrm']['url']
  #   owner node['rundeck']['user']
  #   group node['rundeck']['group']
  #   mode '0644'
  #   backup false
  #   checksum node['rundeck']['plugins']['winrm']['checksum']
  #   notifies (node['rundeck']['restart_on_config_change'] ? :restart : :nothing), 'service[rundeckd]', :delayed
  # end

  # ==== Removed for v3
  # template "#{new_resource.basedir}/exp/webapp/WEB-INF/web.xml" do
  #   cookbook 'rundeck'
  #   owner new_resource.rundeckuser
  #   group new_resource.rundeckgroup
  #   variables(
  #     rundeck_version: new_resource.version,
  #     default_role: new_resource.default_role,
  #     security_roles: new_resource.security_roles,
  #     session_timeout: new_resource.session_timeout
  #   )
  #   source 'web.xml.erb'
  #   # notifies (new_resource.restart_on_config_change ? :restart : :nothing), 'service[rundeckd]', :delayed
  # end

  template "#{new_resource.configdir}/profile" do
    cookbook 'rundeck'
    owner new_resource.rundeckuser
    group new_resource.rundeckgroup
    source 'profile.erb'
    variables(
      basedir: new_resource.basedir,
      configdir: new_resource.configdir,
      tempdir: new_resource.tempdir,
      exec_logdir: new_resource.exec_logdir,
      jvm_mem: new_resource.jvm_mem,
      truststore_type: new_resource.truststore_type,
      port: new_resource.port,
      ssl_port: new_resource.ssl_port,
      jaas: new_resource.jaas,
      webcontext: new_resource.webcontext,
      custom_jvm_properties: new_resource.custom_jvm_properties,
      use_inbuilt_ssl: new_resource.use_inbuilt_ssl
    )
    # notifies (new_resource.restart_on_config_change ? :restart : :nothing), 'service[rundeckd]', :delayed
  end

  template "#{new_resource.configdir}/rundeck-config.properties" do
    cookbook 'rundeck'
    owner new_resource.rundeckuser
    group new_resource.rundeckgroup
    source 'rundeck-config.properties.erb'
    variables(
      custom_rundeck_config: new_resource.custom_rundeck_config,
      grails_port: new_resource.grails_port,
      grails_server_url:  new_resource.grails_server_url,
      log_level: new_resource.log_level,
      mail_email: new_resource.mail_email,
      mail_host: new_resource.mail_host,
      mail_password: new_resource.mail_password,
      mail_port: new_resource.mail_port,
      mail_user: new_resource.mail_user,
      quartz_threadPoolCount: new_resource.quartz_threadPoolCount,
      rdbms_dbname: new_resource.rdbms_dbname,
      rdbms_dialect: new_resource.rdbms_dialect,
      rdbms_enable: new_resource.rdbms_enable,
      rdbms_location: new_resource.rdbms_location,
      rdbms_password: new_resource.rdbms_password,
      rdbms_port: new_resource.rdbms_port,
      rdbms_type: new_resource.rdbms_type,
      rdbms_user: new_resource.rdbms_user,
      rss_enabled: new_resource.rss_enabled
    )
    # notifies (new_resource.restart_on_config_change ? :restart : :nothing), 'service[rundeckd]', :delayed
  end

  template '/etc/init/rundeckd.conf' do
      cookbook 'rundeck'
      owner 'root'
      group 'root'
      source 'rundeck-upstart.conf.erb'
      variables(
        configdir: new_resource.configdir
      )
    # notifies (new_resource.restart_on_config_change ? :restart : :nothing), 'service[rundeckd]', :delayed
      only_if { node['platform_family'] == 'debian' }
    end


  template "#{new_resource.configdir}/framework.properties" do
    cookbook 'rundeck'
    owner new_resource.rundeckuser
    group new_resource.rundeckgroup
    source 'framework.properties.erb'
    variables(
      admin_password: new_resource.admin_password,
      basedir: new_resource.basedir,
      configdir: new_resource.configdir,
      custom_framework_config: new_resource.custom_framework_config,
      datadir: new_resource.datadir,
      exec_logdir: new_resource.exec_logdir,
      framework_properties: new_resource.framework_properties.to_java_properties_hash,
      hostname: new_resource.hostname,
      mail_email: new_resource.mail_email,
      mail_host: new_resource.mail_host,
      mail_password: new_resource.mail_password,
      mail_port: new_resource.mail_port,
      mail_user: new_resource.mail_user,
      port: new_resource.port,
      ssl_port: new_resource.ssl_port,
      tokens_file: new_resource.tokens_file,
      use_inbuilt_ssl: new_resource.use_inbuilt_ssl,
      user: new_resource.rundeckuser,
      uuid: new_resource.uuid,
      windows_winrm_auth_type: new_resource.windows_winrm_auth_type,
      windows_winrm_cert_trust: new_resource.windows_winrm_cert_trust,
      windows_winrm_hostname_trust: new_resource.windows_winrm_hostname_trust,
      windows_winrm_protocol: new_resource.windows_winrm_protocol,
      windows_winrm_timeout: new_resource.windows_winrm_timeout
    )
    # notifies (new_resource.restart_on_config_change ? :restart : :nothing), 'service[rundeckd]', :delayed
  end

  template "#{new_resource.configdir}/realm.properties" do
    cookbook 'rundeck'
    owner new_resource.rundeckuser
    group new_resource.rundeckgroup
    source 'realm.properties.erb'
    variables(
      rundeck_users: new_resource.rundeck_users
    )
  end

  if new_resource.acl_policies
    new_resource.acl_policies.each do |name, policy|
      template "#{new_resource.configdir}/#{name}.aclpolicy" do
        cookbook 'rundeck'
        owner new_resource.rundeckuser
        group new_resource.rundeckgroup
        source 'user.aclpolicy.erb'
        variables(
          aclpolicy: policy
        )
      end
    end
  end

    # bash 'own rundeck' do
  #   user 'root'
  #   code <<-EOH
  #   chown -R #{node['rundeck']['user']}:#{node['rundeck']['group']} #{node['rundeck']['basedir']}
  #   EOH
  # end
  Chef::Log.info { "chef-rundeck url: #{new_resource.chef_url}" }


  # Assuming node['rundeck']['plugins'] is a hash containing name=>attributes
  # unless new_resource.plugins.nil?
  #   new_resource.plugins.each do |plugin_name, plugin_attrs|
  #     rundeck_plugin plugin_name do
  #       url plugin_attrs['url']
  #       checksum plugin_attrs['checksum']
  #       action :create
  #     end
  #   end
  # end

  service 'rundeckd' do
    case node['platform']
    when 'ubuntu'
      if node['platform_version'].to_f >= 16.04
        provider Chef::Provider::Service::Systemd
      else
        provider Chef::Provider::Service::Upstart
      end
    end
    action [:start, :enable]
    # notifies :run, 'ruby_block[wait for rundeckd startup]', :immediately
  end

  ruby_block 'wait for rundeckd startup' do
    action :nothing
    block do
      # test connection to the authentication endpoint
      require 'uri'
      require 'net/http'
      uri = URI("#{new_resource.grails_server_url}:#{new_resource.grails_port}")
      uri.path = ::File.join(new_resource.webcontext, '/j_security_check')
      res = Net::HTTP.get_response(uri)
      unless (200..399).cover?(res.code.to_i)
        Chef::Log.warn { "#{res.uri} not responding healthy. #{res.code}" }
        Chef::Log.debug { res.body }
        raise
      end
      Chef::Log.info { 'wait a little longer for Rundeck startup' }
      sleep new_resource.extra_wait
    end
    retries new_resource.service_retries
    retry_delay new_resource.service_retry_delay
  end
end

action_class do
  include RundeckCookbook::Helpers
end
