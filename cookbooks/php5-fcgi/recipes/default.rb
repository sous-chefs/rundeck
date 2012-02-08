
 
package "php5-cgi"
package "spawn-fcgi"

execute "php-fastcgi-updaterc" do
  command "update-rc.d php-fastcgi defaults"
  user "root"
  group "root"
  action :nothing
end

cookbook_file "/etc/init.d/php-fastcgi" do
  source "php-fastcgi"
  owner "root"
  group "root"
  mode 0555
  notifies :run, resources(:execute => "php-fastcgi-updaterc")
end

template "/usr/bin/php-fastcgi" do
  source "php-fastcgi"
  owner "root"
  group "root"
  mode 0555
end



service "php-fastcgi" do
  supports :status => false, :restart => true, :reload => true
  status_command "ps aux | grep [p]hp5-cgi"
  action :start
end
