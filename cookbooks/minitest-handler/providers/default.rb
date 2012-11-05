action :run do
  %w{minitest minitest-chef-handler}.each do |gem|
    chef_gem gem do
      action :install
    end
  end
  require 'minitest-chef-handler'

  test_dir  = "#{new_resource.path}/cookbooks/#{new_resource.cookbook_name}/files/#{new_resource.recipe_name}/tests"
  test_file = "#{new_resource.recipe_name}_#{new_resource.recipe_type}.rb" 
  directory test_dir do
    owner     new_resource.owner
    group     new_resource.group
    mode      new_resource.mode
    recursive true
    action    :create
  end

  cookbook_file "#{test_dir}/#{test_file}" do
    source "tests/#{test_file}"
    cookbook new_resource.cookbook_name
  end

  chef_handler "MiniTest::Chef::Handler" do
    source    "minitest-chef-handler"
    arguments :path => "#{test_dir}/#{test_file}"
    action    :enable
  end
end

action :nothing do
end
