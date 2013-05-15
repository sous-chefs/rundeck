case node['platform_family']
	when 'windows'
		default['wt_common']['install_dir'] = "d:\\wrs"
		default['wt_common']['install_log_dir'] = "d:\\logs"
		default['wt_common']['log_dir'] = "d:\\wrs\\logs"
  else
		default['wt_common']['install_dir'] = "/opt/webtrends/"
		default['wt_common']['config_dir'] = "/etc/webtrends/"
		default['wt_common']['install_log_dir'] = "/var/log/webtrends/install"
		default['wt_common']['log_dir'] = "/var/log/webtrends"
end
