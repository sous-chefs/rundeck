#
# Author: Jeff Berger (<jeff.berger@webtrends.com>)
# Cookbook Name:: wt_kafka_mm
# Recipe:: default
#
# Copyright 2012, Webtrends
#

log "Deploy build is #{ENV["deploy_build"]}"
if ENV["deploy_build"] == "true" then 
    log "The deploy_build value is true so un-deploy first"
else
    log "The deploy_build value is not set or is false so we will only update the configuration"
end

log_dir = "#{node['wt_common']['log_dir_linux']}/mirrormaker"
install_dir = "#{node['wt_common']['install_dir_linux']}/mirrormaker"

user = node['wt_mirrormaker']['user']
group = node['wt_mirrormaker']['group']

java_home = node['java']['java_home']
java_opts = node['wt_mirrormaker']['java_opts']

#Get the zookeeper instances in the specified environment
def getZookeeperPairs(node, env)
	
	# get the correct environment for the zookeeper nodes
	zookeeper_port = node['zookeeper']['client_port']
	  
	# grab the zookeeper nodes that are currently available
	zookeeper_pairs = Array.new
	if not Chef::Config.solo
		search(:node, "role:zookeeper AND chef_environment:#{env}").each do |n|
			zookeeper_pairs << n[:fqdn]
		end
	end
	
	log "#{zookeeper_pairs.size} instances of zookeeper found found in #{env}"

	# fall back to attribs if search doesn't come up with any zookeeper roles
	# if zookeeper_pairs.count == 0
	#	node[:zookeeper][:quorum].each do |i|
	#		zookeeper_pairs << i
	#	end
	# end

	# append the zookeeper client port (defaults to 2181)

	i = 0
	while i < zookeeper_pairs.size do
		zookeeper_pairs[i] = zookeeper_pairs[i].concat(":#{zookeeper_port}")
		i += 1
	end

	return zookeeper_pairs
end

#update the config files
def processConfTemplates (install_dir, node, log_dir)
 
    	zookeeper_pairs_target = getZookeeperPairs(node, node.chef_environment)                       
	
# 	Assumes that a node has wt_mirrormaker/sources attribute 
#  	"wt_mirrormaker": {
#      		"sources": {
#        		"collectionEnv1": "dc1",
#			"collectionEnv1": "dc2"
#			}
#	}
#	Where collectionEnv1 and collectionEnv2 are names of the chef environments to mirror
#	And dc1 and dc2 are the datacenters of those environments
	
	node['wt_mirrormaker']['sources'].each { |src_env_o|	                                         
	                                          
		src_env = src_env_o[0]
		src_dc = src_env_o[1]
		#src_dc = node['wt_mirrormaker']['sources']['#{src_env}']

		#No idea why this is pulled from wt_realtime_hadoop but following pattern from streaming collection
		tgt_env = node[:wt_realtime_hadoop][:pod]
		tgt_dc = node[:wt_realtime_hadoop][:datacenter]

	   	# grab the zookeeper nodes that are currently available in the source environment
	    	zookeeper_pairs_src = getZookeeperPairs(node, src_env)
		kafka_chroot_suffix = node[:kafka][:chroot_suffix]

		# create the conf directory
		directory "#{install_dir}/conf/#{src_env}" do
			owner "root"
			group "root"
			mode 00755
			recursive true
			action :create
		end

	    	# Set up the consumer config - The zookeepers in the source environment
	    	template "#{install_dir}/conf/#{src_env}/consumer.config" do
	    		source  "consumer.config.erb"
	    		owner   "root"
			group   "root"
			mode    00644
			variables({
				:zkconnect => zookeeper_pairs_src,
				:kafka_chroot => "/#{src_dc}_#{src_env}_#{kafka_chroot_suffix}", 
				:conn_timeout => "10000",
				:groupid => "mm_#{src_env}"
	    		})
	    	end

	    	# Set up the producer config - The zookeepers in the target environment
	    	template "#{install_dir}/conf/#{src_env}/producer.config" do
			source  "producer.config.erb"
			owner   "root"
			group   "root"
			mode    00644
			variables({
				:zkconnect => zookeeper_pairs_target, 
				:kafka_chroot => "/#{tgt_dc}_#{tgt_env}_#{kafka_chroot_suffix}"
			})
	    	end

		# log4j
	    	template "#{install_dir}/conf/#{src_env}/log4j.properties" do
	    		source  "log4j.properties.erb"
			owner   "root"
			group   "root"
			mode    00644
			variables({
				:log_file => "#{log_dir}/mirrormaker_#{src_env}.log"
	    		})
	    	end
	}
end

#Pull Kafka from the repository and copy necessary files to lib directory
def getLib(lib_dir)

	tarball = "kafka-#{node[:kafka][:version]}.tar.gz"
	download_file = "#{node[:kafka][:download_url]}/#{tarball}"
	install_tmp = "#{Chef::Config[:file_cache_path]}/kafka_mm_install"
	
	#download the tar to temp directory
	remote_file "#{Chef::Config[:file_cache_path]}/#{tarball}" do
		source download_file
		mode 00644
		action :create_if_missing
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

	#copy necessary files to /lib
    	execute "mv" do
      		user  "root"
      		group "root"
      		command "mv #{install_tmp}/lib/*.jar #{lib_dir}"
    	end

	#Clean up
	execute "delete_install_source" do
    		user "root"
    		group "root"
    		command "rm -rf #{Chef::Config[:file_cache_path]}/#{tarball} #{install_tmp}"
    		action :run
	end
end

############################
# Perform actual deploy
if ENV["deploy_build"] == "true" then 

	# create the log directory
	directory "#{log_dir}" do
		owner   user
		group   group
		mode    00755
		recursive true
		action :create
	end

	# create the install directory
	directory "#{install_dir}/bin" do
		owner "root"
		group "root"
		mode 00755
		recursive true
		action :create
	end

	# create the lib directory
	directory "#{install_dir}/lib" do
		owner "root"
		group "root"
		mode 00755
		recursive true
		action :create
	end

	#pull down the mirror maker dependencies and copy to /lib
	getLib("#{install_dir}/lib")	

	#Set up the control script
	template "#{install_dir}/bin/service-control" do
	    	source  "service-control.erb"
		owner "root"
		group "root"
		mode  00755
		variables({
			:log_dir => log_dir,
			:install_dir => install_dir,
			:java_home => java_home,
			:user => user,
			:java_class => "kafka.tools.MirrorMaker",
			:java_jmx_port => node['wt_mirrormaker']['jmx_port'],
			:java_opts => java_opts,
			:topic_white_list => node['wt_mirrormaker']['topic_white_list']
		})
	end

	#create a runit service for each mirrored data center 
	node['wt_mirrormaker']['sources'].each { |src_env|

		runit_service "mirrormaker_#{src_env[0]}" do
			template_name "mirrormaker"	#/templates/sv-mirrormaker-run.erb
		    	options({
				:install_dir => install_dir,
				:user => user,
				:src_env => src_env[0]
		    	})
	    	end
	}
end

#Do this in all situations
processConfTemplates(install_dir, node, log_dir)
