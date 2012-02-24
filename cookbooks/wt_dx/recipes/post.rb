installdir = node['wt_common']['installdir']

execute "icacls" do
        command "icacls \"#{installdir}\\Data Extraction API\" /grant:r IUSR:(oi)(ci)(rx)"
        action :run
end

execute "icacls" do
        command "icacls \"#{installdir}\\OEM Data Extraction API\" /grant:r IUSR:(oi)(ci)(rx)"
        action :run
end

execute "aspnet_regiis" do
        command "%WINDIR%\\Microsoft.Net\\Framework64\\v4.0.30319\\aspnet_regiis -i -enable"
        action :run
end

execute "ServiceModelReg" do
        command "%WINDIR%\\Microsoft.Net\\Framework64\\v4.0.30319\\ServiceModelReg.exe -r"
        action :run
end        