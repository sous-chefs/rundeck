# Webtrends Windows system setup

#Install SNMP feature
windows_feature "SNMP-Service"
  action :install
end

#Install Powershell feature
windows_feature "PowerShell-ISE"
  action :install
end

#Install .NET 3.5.1
windows_feature "NET-Framework-Core"
  action :install
end

#Install MSMQ
windows_feature "MSMQ-Server"
   action :install
end

#Turn off hibernation
execute powercfg do
	command "powercfg.exe /h off"
	action :run
end

#Set high performance power options
execute powercfg do
	command "powercfg -s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
	action :run
end

#Turn off IPv6
windows_registry 'HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters' do
  values 'DisabledComponents' => "0xffffffff"
end