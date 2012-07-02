version = node[:graphite][:version]

remote_file "/usr/src/whisper-#{version}.tar.gz" do
  source node[:graphite][:whisper][:uri]
  checksum node[:graphite][:whisper][:checksum]
end

execute "untar whisper" do
  command "tar xzf whisper-#{version}.tar.gz"
  creates "/usr/src/whisper-#{version}"
  cwd "/usr/src"
end

# CentOS/RH 
if platform?("redhat", "centos")
  execute "install whisper" do
    command "python setup.py install"
    creates "/usr/lib/python2.6/site-packages/whisper-#{version}-py2.6.egg-info"
    cwd "/usr/src/whisper-#{version}"
  end
end

# Debian/Ubuntu 
if platform?("debian","ubuntu")
  execute "install whisper" do
    command "python setup.py install"
    creates "/usr/local/lib/python2.6/dist-packages/whisper-#{version}.egg-info"
    cwd "/usr/src/whisper-#{version}"
  end
end
