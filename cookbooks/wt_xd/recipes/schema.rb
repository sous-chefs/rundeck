
# create dir
directory "/opt/webtrends/wt_xd" do
  mode 00755
  recursive true
end


# drop in templates
%w[hbasetable.py schema.py].each do |file|
  cookbook_file "/opt/webtrends/wt_xd/#{file}" do
    source "#{file}"
    owner "hadoop"
    group "hadoop"
    mode 00550
  end
end

