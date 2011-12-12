#Make sure that this recipe only runs on Windows systems
if platform?("windows") 

	#This recipe needs providers included in the Windows cookbook
	include_recipe "windows::default"

	#Install SNMP feature
	windows_feature "SNMP" do
	  action :install
	end

        #Install .NET 3.5.1
        windows_feature "NetFx3" do
          action :install
        end

	#Install Powershell ISE feature
	windows_feature "MicrosoftWindowsPowerShellISE" do
	  action :install
	end
	
	#Install MSMQ server
	windows_feature "MSMQ-Server" do
	   action :install
	end
      
	#Turn off hibernation
	execute "powercfg-hibernation" do
	  command "powercfg.exe /h off"
	  action :run
	end

	#Set high performance power options
	execute "powercfg-performance" do
	  command "powercfg -s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
	  action :run
	end

=begin
	#Set boot menu timeout to 5 seconds
	execute "bootmenutimeout" do
	  command 'C:\windows\system32\bcdedit.exe /timeout 5'
	  action :run
	end
=end

	#Turn off IPv6
	windows_registry 'HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters' do
	  values 'DisabledComponents' => "0xffffffff"
	end

	#Auto reboot on system crashes, log the crash to the event log, and create a crash dump
	windows_registry 'HKLM\SYSTEM\CurrentControlSet\Control\CrashControl' do
	  values 'AutoReboot' => "3"
	  values 'LogEvent' => "3"
	  values 'CrashDumpEnabled' => "3"
	end

	#Set the size of the system event log to 64MB
	windows_registry 'HKLM\SYSTEM\CurrentControlSet\Services\EventLog\System' do
	  values 'MaxSize' => "65536"
	end

	#Set the size of the application event log to 64MB
	windows_registry 'HKLM\SYSTEM\CurrentControlSet\Services\EventLog\Application' do
	  values 'MaxSize' => "65536"
	end

	#Set the size of the security event log to 64MB
	windows_registry 'HKLM\SYSTEM\CurrentControlSet\Services\EventLog\Security' do
	  values 'MaxSize' => "65536"
	end

	#Set the organization name and owner name
	windows_registry 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion' do
	  values 'RegisteredOrganization' => "Webtrends Inc."
	  values 'RegisteredOwner' => "Webtrends Inc."
	end

	#Enable Remote Desktop Services
	windows_registry 'HKLM\System\CurrentControlSet\Control\Terminal Server' do
	  values 'fDenyTSConnections' => "0"
	  values 'MinEncryptionLevel' =>  "3"
	end

	#Set time zone
	windows_registry 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation' do
	  values 'Bias' => "00000000"
	  values 'DaylightBias' => "00000000"
	  values 'DaylightName' => "@tzres.dll,-262"
	  values 'DaylightStart' => "00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00"
	  values 'StandardBias' => "00000000"
	  values 'StandardName' => "@tzres.dll,-262"
	  values 'StandardStart' => "00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00"
	  values 'TimeZoneKeyName' => "GMT Standard Time"
	  values 'DynamicDaylightTimeDisabled' => "00000001"
	  values 'ActiveTimeBias' => "00000000"
	end
end
