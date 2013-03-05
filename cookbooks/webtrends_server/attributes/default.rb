case node['platform_family']
	when 'windows'
	default['wt_common']['install_dir'] = "/etc/webtrends/"
	default['wt_common']['install_log_dir'] = "/var/log/webtrends/install"
	default['wt_common']['log_dir'] = "/var/webtrends"
  else
	default['wt_common']['install_dir'] = "/etc/webtrends/"
	default['wt_common']['install_log_dir'] = "/var/log/webtrends/install"
	default['wt_common']['log_dir'] = "/var/webtrends"
end