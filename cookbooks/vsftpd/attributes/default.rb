#
# Cookbook Name:: vsftpd
# Attribute File:: sudoers
#
# Copyright 2010 Robert J. Berger
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
default[:vsftpd][:chroot_local_user] = "YES"
default[:vsftpd][:chroot_users] = Array.new 
default[:vsftpd][:use_ssl_certs_from_cookbook] = true
default[:vsftpd][:ssl_cert_path] = "/etc/ssl/certs"
default[:vsftpd][:ssl_private_key_path] = "/etc/ssl/private"
default[:vsftpd][:ssl_certs_basename] = "ftp.example.com"
