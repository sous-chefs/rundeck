


include_recipe "hadoop"


%w[/var/lib/hadoop /var/lib/hadoop/mapred].each do |dir|
  directory "#{dir}" do
    owner "hadoop"
    group "hadoop"
    mode "0700"
  end
end

