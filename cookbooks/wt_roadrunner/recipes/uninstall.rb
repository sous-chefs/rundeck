sc_cmd = "\"%WINDIR%\\System32\\sc.exe delete WebtrendsRoadRunnerService"
netsh_cmd = "netsh http delete urlacl url=http://+:8097/"

service "WebtrendsRoadRunnerService" do
	action :stop
	ignore_failure true
end

execute "sc" do
	command sc_cmd
	ignore_failure true
end

execute "netsh" do
	command netsh_cmd
	ignore_failure true
end

ruby_block "install_flag" do
	block do
		node.delete('rr_installed')
		node.save
	end
	action :create
	ignore_failure true
end