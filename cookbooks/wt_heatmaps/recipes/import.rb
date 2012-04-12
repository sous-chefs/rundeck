
# log dir
directory "/home/hadoop/log-drop" do
  owner "hadoop"
  group "hadoop"
  mode "0755"
end

# script to import data into hive
cookbook_file "/usr/local/bin/logs2hive.sh" do
  source "import/logs2hive.sh"
  owner "hadoop"
  group "hadoop"
  mode "0500"
end


cron "logs2hivecron" do
  command "/usr/local/bin/logs2hive.sh"
  user "hadoop"
end
