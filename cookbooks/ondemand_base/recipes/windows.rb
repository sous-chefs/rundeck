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