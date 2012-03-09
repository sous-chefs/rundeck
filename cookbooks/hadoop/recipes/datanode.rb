


include_recipe "hadoop"

=begin **** NOTE ****
Setup up dirs for data.  This is a staging specific hack.  In prod
there will be multiple drives and thus multiple data dirs on each drive. 
=end

%w[/data /data/hadoop /data/hadoop/hdfs /data/hadoop/hdfs/datanode /data/hadoop/mapred].each do |dir|
  directory "#{dir}" do
    owner "hadoop"
    group "hadoop"
    mode "0700"
  end
end
