#
# Cookbook Name:: wt_opt_ots
# Attribute File:: default
#
# Copyright 2012, Webtrends, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['wt_opt_ots']['frontend_url'] = ""
default['wt_opt_ots']['geolocation_server'] = ""
default['wt_opt_ots']['memcache_servers'] = []

default['wt_opt_ots']['javaopts'] = "-server -Xms2048m -Xmx2048m -XX:MaxPermSize=384m"
default['wt_opt_ots']['multicast_address'] =
default['wt_opt_ots']['ssl'] = false
default['wt_opt_ots']['pod_id'] =
default['wt_opt_ots']['log_level'] = "INFO"

default['wt_opt_ots']['install_dir'] = "/opt/webtrends"
default['wt_opt_ots']['mount_dir_prefix'] = "/srv/otsdata"
default['wt_opt_ots']['nfs_mount'] = ""

default['wt_opt_ots']['jboss_uid'] = 1001
default['wt_opt_ots']['jboss_gid'] = 1001


default['wt_opt_ots']['apache']['mpm'] = "worker"