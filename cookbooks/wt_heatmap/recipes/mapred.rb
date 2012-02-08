
package "php-cli"

remote_directory "/usr/local/mapred" do
  source "mapred"
  owner "hadoop"
  group "hadoop"
  files_owner "hadoop"
  files_group "hadoop"
  files_mode "0744"
  mode "0744"
end

