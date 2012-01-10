#Make sure that this recipe only runs on Windows systems
if platform?("windows") 

	#This recipe needs providers included in the Windows cookbook
	include_recipe "windows::default"
      
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

end