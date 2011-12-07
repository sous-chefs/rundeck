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

execute bootmenutimeout do
	command "bcdedit /timeout 5"
	action: run
end

#Turn off IPv6
windows_registry 'HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters' do
  values 'DisabledComponents' => "0xffffffff"
end

#Auto reboot on system crashes, log the crash to the event log, and create a crash dump
windows_registry 'HKLM\SYSTEM\CurrentControlSet\Control\CrashControl'
  values 'AutoReboot' => "3"
  values 'LogEvent' => "3"
  values 'CrashDumpEnabled' => "3"
end

#Set the size of the system event log to 64MB
windows_registry 'HKLM\SYSTEM\CurrentControlSet\Services\EventLog\System'
  values 'MaxSize' => "65536"
end

#Set the size of the application event log to 64MB
windows_registry 'HKLM\SYSTEM\CurrentControlSet\Services\EventLog\Application'
  values 'MaxSize' => "65536"
end

#Set the size of the security event log to 64MB
windows_registry 'HKLM\SYSTEM\CurrentControlSet\Services\EventLog\Security'
  values 'MaxSize' => "65536"
end

#Set the organization name and owner name
windows_registry 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
  values 'RegisteredOrganization' => "Webtrends Inc."
  values 'RegisteredOwner' => "Webtrends Inc."
end

#Enable Remote Desktop Services
windows_registry 'HKLM\System\CurrentControlSet\Control\Terminal Server'
  values 'fDenyTSConnections' => "0"
  values 'MinEncryptionLevel' =>  "3"
  