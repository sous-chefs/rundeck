#
# rename ssl files
#

# certificate common_name
common_name = node['wt_openldap']['common_name'] || node['fqdn']

# ssl files
csr = "/etc/ldap/#{common_name}.csr"
key = "/etc/ldap/#{common_name}.key"
crt = "/etc/ldap/#{common_name}.crt"

bash 'rename ssl files' do
	code <<-EOH
		mv /etc/ldap/CSR.csr #{csr}
		mv /etc/ldap/privateKey.key #{key}
		mv /etc/ldap/las.ldap.crt #{crt}
	EOH
end

#
# remove old cron job
#
cron 'backup_ldap' do
	action :delete
end

#
# remove old backup script
#
file '/usr/sbin/openldap_backup.sh' do
	action :delete
end
