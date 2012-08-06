del c:\chef\run.log
set deploy_build=true
chef-client.bat -L c:\chef\run.log >nul
return 0
