
include_recipe "storm"


#############################################################################
# Storm jars

# May make sense to move this into realtime_deploy.rb and streaming_deploy.rb
# if the jar dependencies for each storm cluster diverge.

# Before adding a jar here make sure it's in the repo (i.e.-
# http://repo.staging.dmz/repo/linux/storm/jars/), otherwise the run
# of chef-client will fail

download_url = node['wt_storm']['download_url']
install_tmp = '/tmp/wt_storm_install'
tarball = 'streaming-analysis-bin.tar.gz'

if ENV["deploy_build"] == "true" then
    log "The deploy_build value is true so we will grab the tar ball and install"

    # grab the source file
    remote_file "#{Chef::Config[:file_cache_path]}/#{tarball}" do
      source download_url
      mode 00644
    end

    # create the install TEMP dirctory
    directory install_tmp do
      owner "root"
      group "root"
      mode 00755
      recursive true
    end

    # extract the source file into TEMP directory
    execute "tar" do
      user  "root"
      group "root"
      cwd install_tmp
      creates "#{install_tmp}/lib"
      command "tar zxvf #{Chef::Config[:file_cache_path]}/#{tarball}"
    end

    execute "mv" do
      user  "root"
      group "root"
      command "mv #{install_tmp}/lib/webtrends*.jar #{node['storm']['install_dir']}/storm-#{node['storm']['version']}/lib/"
    end
    execute "chown" do
      user  "root"
      group "root"
      command "chown storm:storm #{node['storm']['install_dir']}/storm-#{node['storm']['version']}/lib/webtrends*.jar"
    end

%w{
activation-1.1.jar
aopalliance-1.0.jar
avro-1.5.3.jar
avro-ipc-1.5.3.jar
commons-cli-1.2.jar
commons-collections-3.2.1.jar
commons-configuration-1.6.jar
commons-el-1.0.jar
commons-httpclient-3.1.jar
commons-math-2.1.jar
commons-net-1.4.1.jar
curator-framework-1.0.1.jar
curator-recipes-1.1.10.jar
fastutil-6.4.4.jar
groovy-all-1.7.6.jar
guice-3.0.jar
hadoop-core-1.0.0.jar
hamcrest-core-1.1.jar
hbase-0.92.0.jar
high-scale-lib-1.1.1.jar
jackson-core-asl-1.9.3.jar
jackson-jaxrs-1.5.5.jar
jackson-mapper-asl-1.9.3.jar
jackson-xc-1.5.5.jar
JavaEWAH-0.5.0.jar
javax.inject-1.jar
jdom-1.1.jar
jersey-core-1.4.jar
jersey-json-1.4.jar
jersey-server-1.4.jar
jettison-1.1.jar
jopt-simple-3.2.jar
jsp-2.1-6.1.14.jar
jsp-api-2.1-6.1.14.jar
kafka-0.7.0.jar
libthrift-0.7.0.jar
netty-3.3.0.Final.jar
plexus-utils-1.5.6.jar
protobuf-java-2.4.0a.jar
regexp-1.3.jar
scala-library-2.8.0.jar
snappy-java-1.0.3.2.jar
stax-api-1.0.1.jar
storm-kafka-0.7.2-snaptmp8.jar
streaming-analysis.jar
UserAgentUtils-1.2.4.jar
wurfl-1.4.0.1.jar
xmlenc-0.52.jar
zkclient-0.1.jar
}.each do |jar|
      execute "mv" do
        user  "root"
        group "root"
        command "mv #{install_tmp}/lib/#{jar} #{node['storm']['install_dir']}/storm-#{node['storm']['version']}/lib/#{jar}"
      end
      execute "chown" do
        user  "root"
        group "root"
        command "chown storm:storm #{node['storm']['install_dir']}/storm-#{node['storm']['version']}/lib/#{jar}"
      end
    end
	
    # create the log directory
    directory "/var/log/storm" do
      action :create
      owner "storm"
      group "storm"
      mode 00755
    end
    
    # delete the unused storm log directory
    file "#{node['storm']['install_dir']}/current/logs" do
      action :delete
    end

    # template out the log4j config with our customer logging settings
    template "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}/log4j/storm.log.properties" do
      source  "storm.log.properties.erb"
      owner "storm"
      group "storm"
      mode  00644
      variables({
      })
    end

    # storm looks for storm.yaml in ~/.storm/storm.yaml
    link "/home/storm/.storm" do
      to "#{node['storm']['install_dir']}/storm-#{node['storm']['version']}/conf"
    end

    directory install_tmp do
      action :delete
      recursive true
    end

end
