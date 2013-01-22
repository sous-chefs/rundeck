


#Pull jar version out
ruby_block "Grep jar version" do
  block do
    wt_version = `jar xvf #{$install_dir}/lib/#{$jar_name} META-INF/MANIFEST.MF > /dev/null  && grep Implementation-Version: META-INF/MANIFEST.MF| sed s/Implementation-Version://g | tr -d '\r\n'`
    wt_build = `grep Implementation-Build: META-INF/MANIFEST.MF | sed s/Implementation-Build://g | tr -d '\r\n'`
    version_block = node['webtrends_server']['product_versions']
    version = "#{wt_version}-#{wt_build}".gsub(/\s/,'')
    version_block.each do |v|
      if v['name'] == $role_name
        v['version'] = version
      end
    end
    node.set['webtrends_server']['product_versions'] = version_block 
  end
end