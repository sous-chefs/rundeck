#
# Cookbook Name:: wt_openldap
# Provider:: config
#
# Copyright 2013, Webtrends Inc.
#
# All rights reserved - Do Not Redistribute
#

include Chef::Mixin::ShellOut

def load_current_resource

	@current_resource = Chef::Resource::WtOpenldapConfig.new(@new_resource.attribute)
	val = ldap_search(@new_resource.attribute, get_filter)
	if val.nil?
		@current_resource.exists = false
	else
		@current_resource.value(val)
		@current_resource.exists = true
	end

end

action :create do

	if @current_resource.exists
		if  @current_resource.value == @new_resource.value
			Chef::Log.info("no action required: #{@new_resource.attribute} = #{@new_resource.value} in dn: #{@new_resource.dn}")
		else
			ldap_replace
		end
	else
		ldap_add
	end

end

private

def ldap_search (attribute, filter = nil)

	cmd = 'ldapsearch -Q -Y EXTERNAL -H ldapi:/// -LLL -b "cn=config"'
	cmd << " \"(#{filter})\"" unless filter.nil?
	cmd << " \"#{attribute}\""

	p = shell_out!(cmd)

	Chef::Log.debug(cmd)
	Chef::Log.debug(p.stdout)

	is_array = false
	p.stdout.each_line do |line|
		if line =~ /^#{attribute}: {\d+}(.+)$/
			is_array = true
			return $1 if $1 == @new_resource.value
		end
		if !is_array
			val = line[/^#{attribute}: (.*)$/, 1]
			return val unless val.nil?
		end
	end

	return nil

end

def ldap_replace

	Chef::Log.info("ldap_replace: attribute => #{@new_resource.attribute}, current_value => #{@current_resource.value}, new_value => #{@new_resource.value}, dn => #{@new_resource.dn}")

	cmd = 'ldapmodify -Q -Y EXTERNAL -H ldapi:///'
	stdin = "dn: #{@new_resource.dn}\nreplace: #{@new_resource.attribute}\n#{@new_resource.attribute}: #{@new_resource.value}\n"

	Chef::Log.debug "input: #{stdin}"
	p = shell_out!(cmd, :input => stdin)
	Chef::Log.debug(p.stdout)

	@new_resource.updated_by_last_action(true)

end

def ldap_add

	Chef::Log.info("ldap_add: attribute => #{@new_resource.attribute}, value => #{@new_resource.value}, dn => #{@new_resource.dn}")

	cmd = 'ldapmodify -Q -Y EXTERNAL -H ldapi:///'
	stdin = "dn: #{@new_resource.dn}\nchangetype: modify\nadd: #{@new_resource.attribute}\n#{@new_resource.attribute}: #{@new_resource.value}\n"

	Chef::Log.debug "input: #{stdin}"
	p = shell_out!(cmd, :input => stdin)
	Chef::Log.debug(p.stdout)

	@new_resource.updated_by_last_action(true)

end

private

def get_filter
	@new_resource.dn[/^(.*),cn=config$/, 1]
end

