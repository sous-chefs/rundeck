
# create dir
directory "/opt/podenv" do
  mode 00755
  recursive true
end


# drop in templates
%w[hbasetable.py streaming.py create_tables.py].each do |file|
  cookbook_file "/opt/podenv/#{file}" do
    source "#{file}"
    owner "hadoop"
    group "hadoop"
    mode 00550
  end
end

# run create table scrips
node[:wt_podenv][:environments].each do |env|
  env.each do |dc, pods|
    pods.each do |pod|
      # create_table.py dc pod   would be called here for each env
    end
  end
end

