default[:wt_actioncenter_ui][:auth_service_version] = "v1"
default[:wt_actioncenter_ui][:allow_http] = false
default[:wt_actioncenter_ui][:user] = "webtrends"
default[:wt_actioncenter_ui][:group] = "webtrends"
default[:wt_actioncenter_ui][:download_url] = "http://teamcity.webtrends.corp/guestAuth/repository/download/bt375/.lastSuccessful/action-center.tar.gz"
default[:wt_actioncenter_ui][:help_url] = "http://help.webtrends.com"
default[:wt_actioncenter_ui][:bundle_without] = %w(test development assets)
default[:wt_actioncenter_ui][:unicorn][:port] = 5000
default[:wt_actioncenter_ui][:unicorn][:options] = { :tcp_nodelay => true, :backlog => 100 }
default[:wt_actioncenter_ui][:unicorn][:worker_timeout] = 60
default[:wt_actioncenter_ui][:unicorn][:preload_app] = false
default[:wt_actioncenter_ui][:unicorn][:worker_processes] = [node[:cpu][:total].to_i * 4, 8].min
default[:wt_actioncenter_ui][:unicorn][:before_fork] = 'sleep 1'
