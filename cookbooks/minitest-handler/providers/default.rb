action :run do
  %w{builder ci_reporter minitest minitest-chef-handler}.each do |gem|
    chef_gem gem do
      options :ignore_dependencies => true
      action :install
    end
  end
  require 'minitest-chef-handler'

  test_dir  = "#{new_resource.path}/cookbooks/#{new_resource.cookbook}/files/default/tests"

  test_files = new_resource.test_name.inject([]) do |memo, test|
    memo << "#{test}_#{new_resource.test_type}.rb" 
  end
  directory test_dir do
    owner     new_resource.owner
    group     new_resource.group
    mode      new_resource.mode
    recursive true
    action    :create
  end

  test_files.each do |test_file|
    cookbook_file "#{test_dir}/#{test_file}" do
      source "tests/#{test_file}"
      cookbook new_resource.cookbook
    end
  end

  chef_handler "MiniTest::Chef::Handler" do
    source    "minitest-chef-handler"
    arguments :path => "#{test_dir}/*_#{new_resource.test_type}.rb"
    action    :enable
  end
end

action :nothing do
end
