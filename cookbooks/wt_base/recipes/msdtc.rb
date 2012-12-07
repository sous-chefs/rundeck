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

[
 "Distributed Transaction Coordinator (RPC)",
 "Distributed Transaction Coordinator (RPC-EPMAP)",
 "Distributed Transaction Coordinator (TCP-In)",
 "Distributed Transaction Coordinator (TCP-In)"
].each do |firewall|
  wt_base_firewall firewall do
    action :enable
  end
end

service "MSDTC" do
  action :nothing
end
