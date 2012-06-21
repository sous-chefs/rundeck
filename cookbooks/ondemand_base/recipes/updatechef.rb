if node['upgrade_chef'] == true
  node.set['upgrade_chef'] = false
  gem "chef" do
    action :install
  end

  if node.platform == "windows" then
    gem "ffi" do
      action :install
    end
  end
else
  log "Not upgrading chef"
end
