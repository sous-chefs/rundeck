#
# Cookbook Name:: wt_base
# Recipe:: msdtc
#
# Copyright 2012, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

windows_registry 'HKLM\SOFTWARE\Microsoft\MSDTC' do
  values 'TurnOffRpcSecurity' => 1, 'FallbackToUnsecureRPCIfNecessary' => 0, 'AllowOnlySecureRpcCalls' => 0
  notifies :restart, "service[MSDTC]"
end

windows_registry 'HKLM\SOFTWARE\Microsoft\MSDTC\Security' do
  values 'NetworkDtcAccessInbound' => 1, 'NetworkDtcAccess' => 1, 'NetworkDtcAccessOutbound' => 1, 'NetworkDtcAccessClients' => 1, 'NetworkDtcAccessTransactions' => 1
  notifies :restart, "service[MSDTC]", :immediately
end

wt_base_firewall "Distributed Transaction Coordinator (RPC)" do
  action :enable
end

wt_base_firewall "Distributed Transaction Coordinator (RPC-EPMAP)" do
  action :enable
end

wt_base_firewall "Distributed Transaction Coordinator (TCP-In)" do
  action :enable
end

wt_base_firewall "Distributed Transaction Coordinator (TCP-In)" do
  action :enable
end

service "MSDTC" do
  action :nothing
end