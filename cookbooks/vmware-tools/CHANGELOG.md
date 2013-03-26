## 1.1.3
* change logic to use chef resouces instead of embedded bash script
* run vmware-uninstall-tools.pl in advance; sometimes vmware-install.pl will fail if it cannot find it
* changed default tools to VMwareTools-9.0.1-913578.tar.gz, which resolves issue of service failing to automatically start on centos
