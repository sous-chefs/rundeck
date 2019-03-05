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
property :jvm_mem, String, default: ' -Xmx1024m -Xms256m'
property :rundeckgroup, String,
         default: 'rundeck' # 'The user account that rundeck will operate as'
property :rundeckuser, String,
         default: 'rundeck' # 'The group that rundeck will operate as'
property :ldap_provider, String
property :ldap_binddn, String
property :ldap_bindpwd, String
property :ldap_authenticationmethod, String
property :ldap_forcebindinglogin, String
property :ldap_userbasedn, String
property :ldap_userrdnattribute, String
property :ldap_useridattribute, String
property :ldap_userpasswordattribute, String
property :ldap_userobjectclass, String
property :ldap_rolebasedn, String
property :ldap_rolenameattribute, String
property :ldap_rolememberattribute, String
property :ldap_roleobjectclass, String
property :ldap_roleprefix, String
property :ldap_cachedurationmillis, String
property :ldap_reportstatistics, String
property :log_level, %w(ERR WARN INFO VERBOSE DEBUG), default: 'INFO'
property :mail_email, String
property :mail_enable, [true, false], default: false
property :mail_host, String
property :mail_password, String, sensitive: true
property :mail_port, String
property :mail_user, String
property :port, Integer, default: 4440
property :private_key, [nil, String], default: nil, sensitive: true
property :quartz_threadPoolCount, Integer, default: 10
property :rdbms_dbname, String
property :rdbms_dialect, String
property :rdbms_enable, [true, false], default: false
property :rdbms_location, String
property :rdbms_password, String, sensitive: true
property :rdbms_port, Integer
property :rdbms_type, %w(mysql oracle)
property :rdbms_user, String
property :restart_on_config_change, [true, false], default: false
property :rss_enabled, [true, false], default: false
property :rundeckgroup, String, default: 'rundeck'
property :rundeckuser, String, default: 'rundeck'
property :rundeck_users, Hash, default: {}, sensitive: true
property :security_roles, Hash, default: {}
property :session_timeout, Integer, default: 30
property :ssl_port, Integer, default: 4443
property :setup_repo, [true, false], default: true
property :tempdir, String, default: '/tmp/rundeck'
property :tokens_file, String
property :truststore_type, String, default: 'jks'
property :use_inbuilt_ssl, [true, false], default: false
property :use_ssl, [true, false], default: false
property :uuid, String, default: lazy { generateuuid }
property :version, String, default: '3.0.8.20181029-1.201810292220'
property :webcontext, String, default: '/'

action :install do
  apt_update '' if node['platform_family'] == 'debian'

  node.default['java']['jdk_version'] = '8'
  include_recipe 'java'

  rundeck_repository 'public' do
    only_if { new_resource.setup_repo }
  end

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
    notifies (new_resource.restart_on_config_change ? :restart : :nothing), 'service[rundeckd]', :delayed
  end

  file "#{new_resource.basedir}/.ssh/id_rsa" do
    owner new_resource.rundeckuser
    group new_resource.rundeckgroup
    mode '0600'
    backup false
    content new_resource.private_key
    sensitive true
    not_if { new_resource.private_key.nil? }
    notifies (new_resource.restart_on_config_change ? :restart : :nothing), 'service[rundeckd]', :delayed
  end

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
    notifies (new_resource.restart_on_config_change ? :restart : :nothing), 'service[rundeckd]', :delayed
  end

  template "#{new_resource.configdir}/rundeck-config.properties" do
    cookbook 'rundeck'
    owner new_resource.rundeckuser
    group new_resource.rundeckgroup
    source 'rundeck-config.properties.erb'
    sensitive true
    variables(
      configdir: new_resource.configdir,
      custom_rundeck_config: new_resource.custom_rundeck_config,
      grails_port: new_resource.grails_port,
      grails_server_url: new_resource.grails_server_url,
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
    notifies (new_resource.restart_on_config_change ? :restart : :nothing), 'service[rundeckd]', :delayed
  end

  template '/etc/init/rundeckd.conf' do
    cookbook 'rundeck'
    owner 'root'
    group 'root'
    source 'rundeck-upstart.conf.erb'
    variables(
      configdir: new_resource.configdir
    )
    notifies (new_resource.restart_on_config_change ? :restart : :nothing), 'service[rundeckd]', :delayed
    only_if { node['platform_family'] == 'debian' }
  end

  template "#{new_resource.configdir}/framework.properties" do
    cookbook 'rundeck'
    owner new_resource.rundeckuser
    group new_resource.rundeckgroup
    source 'framework.properties.erb'
    sensitive true
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
      uuid: new_resource.uuid
    )
    notifies (new_resource.restart_on_config_change ? :restart : :nothing), 'service[rundeckd]', :delayed
  end

  template "#{new_resource.configdir}/realm.properties" do
    cookbook 'rundeck'
    owner new_resource.rundeckuser
    group new_resource.rundeckgroup
    sensitive true
    source 'realm.properties.erb'
    variables(
      rundeck_users: new_resource.rundeck_users
    )
  end

  template "#{new_resource.configdir}/jaas-activedirectory.conf" do
    cookbook 'rundeck'
    owner new_resource.rundeckuser
    group new_resource.rundeckgroup
    source 'jaas-activedirectory.conf.erb'
    variables(
      configdir: new_resource.configdir,
      ldap_provider: new_resource.ldap_provider,
      ldap_binddn: new_resource.ldap_binddn,
      ldap_bindpwd: new_resource.ldap_bindpwd,
      ldap_authenticationmethod: new_resource.ldap_authenticationmethod,
      ldap_forcebindinglogin: new_resource.ldap_forcebindinglogin,
      ldap_userbasedn: new_resource.ldap_userbasedn,
      ldap_userrdnattribute: new_resource.ldap_userrdnattribute,
      ldap_useridattribute: new_resource.ldap_useridattribute,
      ldap_userpasswordattribute: new_resource.ldap_userpasswordattribute,
      ldap_userobjectclass: new_resource.ldap_userobjectclass,
      ldap_rolebasedn: new_resource.ldap_rolebasedn,
      ldap_rolenameattribute: new_resource.ldap_rolenameattribute,
      ldap_rolememberattribute: new_resource.ldap_rolememberattribute,
      ldap_roleobjectclass: new_resource.ldap_roleobjectclass,
      ldap_roleprefix: new_resource.ldap_roleprefix,
      ldap_cachedurationmillis: new_resource.ldap_cachedurationmillis,
      ldap_reportstatistics: new_resource.ldap_reportstatistics,
      rundeck_version: new_resource.version
    )
    notifies (new_resource.restart_on_config_change ? :restart : :nothing), 'service[rundeckd]', :delayed
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

  Chef::Log.info { "chef-rundeck url: #{new_resource.chef_url}" }

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
end

action_class do
  include RundeckCookbook::Helpers
end
