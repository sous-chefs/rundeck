
#
# make sure the package is isntalled
#
include_recipe "rsync"

case node['platform_family'] 
when "rhel"
  # redhat doens't provide an init script for rsyncd
  template "/etc/init.d/rsyncd" do 
    source "rsync-init.erb"
    owner "root"
    group "root"
    mode 0755
  end
when "debian"
  template "/etc/default/rsync" do
    source "rsync-defaults.erb"
    variables( 
      :ionice => node['rsyncd']['ionice'],
      :nice => node['rsyncd']['nice'],
      :config_file => node['rsyncd']['config'] 
    )
    owner "root"
    group "root"
    mode 0644
  end
end

service node['rsyncd']['service'] do
  action [ :enable, :start ]
  only_if do File.exists?( node['rsyncd']['config'] ) end
end


