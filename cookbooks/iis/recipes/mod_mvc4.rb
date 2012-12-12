uthor:: Marcus Vincent (<marcus.vincent@webtrends.com>)
# Cookbook Name:: iis
# Recipe:: mod_aspnet_mvc4
 
include_recipe "iis"
 
webpi_product "MVC4" do
 accept_eula node['iis']['accept_eula']
 action :install
end
