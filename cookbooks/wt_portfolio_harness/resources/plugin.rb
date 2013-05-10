#
# Cookbook Name:: wt_portfolio_harness
# Resources:: plugin
#
# Copyright 2013, Webtrends Inc
# Do not redistribute

actions :create

attribute :name, :kind_of 						 => String, :name_attribute => true
attribute :download_url, :kind_of 		 => String, :required => true
attribute :user, :kind_of 						 => String
attribute :group, :kind_of 						 => String
attribute :install_dir, :kind_of			 => String
attribute :conf_dir, :kind_of				   => String
attribute :configure,    :kind_of      => Proc
attribute :after_deploy, :kind_of			 => Proc
attribute :restart, :kind_of			     => Proc
attribute :force_deploy, :kind_of      => [ TrueClass, FalseClass ], :default => false

def initialize(*args)
  super
  @action 	   = :create
  @install_dir = IO::File.join(node['wt_portfolio_harness']['plugin_dir'], @name)
  @conf_dir 	 = IO::File.join(@install_dir, "conf")
  @user        = node['wt_portfolio_harness']['user']
  @group        = node['wt_portfolio_harness']['group']
  if @restart == nil
  	@restart = Proc.new {
  		service "harness" do
      	action :restart
    	end
  	}
  end
end
