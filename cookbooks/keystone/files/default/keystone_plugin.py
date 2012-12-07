#
# Copyright 2012, Rackspace US, Inc.
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

from keystoneclient.v2_0 import Client as KeystoneClient

import collectd

global NAME, OS_USERNAME, OS_PASSWORD, OS_TENANT_NAME, OS_AUTH_URL, VERBOSE_LOGGING

NAME = "keystone_plugin"
OS_USERNAME = "username"
OS_PASSWORD = "password"
OS_TENANT_NAME = "tenantname"
OS_AUTH_URL = "http://localhost:5000/v2.0"
VERBOSE_LOGGING = False


def get_stats(user, passwd, tenant, url):
    keystone = KeystoneClient(username=user, password=passwd, tenant_name=tenant, auth_url=url)
    data = dict()

    # Define list of keys to query for
    keys = ('tenants','users','roles','services','endpoints')
    for key in keys:
        data["openstack.keystone.%s.count" % key] = len(keystone.__getattribute__(key).list())

    tenant_list = keystone.tenants.list()
    for tenant in tenant_list:
        data["openstack.keystone.tenants.tenants.%s.users.count" % tenant.name] = len(keystone.tenants.list_users(tenant.id))

    ##########
    # debug
    #for key in data.keys():
    #    print "%s = %s" % (key, data[key])
    ##########

    return data

def configure_callback(conf):
    """Received configuration information"""
    global OS_USERNAME, OS_PASSWORD, OS_TENANT_NAME, OS_AUTH_URL, VERBOSE_LOGGING
    for node in conf.children:
        if node.key == "Username":
            OS_USERNAME = node.values[0]
        elif node.key == "Password":
            OS_PASSWORD = node.values[0]
        elif node.key == "TenantName":
            OS_TENANT_NAME = node.values[0]
        elif node.key == "AuthURL":
            OS_AUTH_URL = node.values[0]
        elif node.key == "Verbose":
            VERBOSE_LOGGING = node.values[0]
        else:
            logger("warn", "Unknown config key: %s" % node.key)


def read_callback():
    logger("verb", "read_callback")
    info = get_stats(OS_USERNAME, OS_PASSWORD, OS_TENANT_NAME, OS_AUTH_URL)

    if not info:
        logger("err", "No information received")
        return

    for key in info.keys():
        logger('verb', 'Dispatching %s : %i' % (key, int(info[key])))
        val = collectd.Values(plugin=key)
        val.type = 'gauge'
        val.values = [int(info[key])]
        val.dispatch()


def logger(t, msg):
    if t == 'err':
        collectd.error('%s: %s' % (NAME, msg))
    if t == 'warn':
        collectd.warning('%s: %s' % (NAME, msg))
    elif t == 'verb' and VERBOSE_LOGGING == True:
        collectd.info('%s: %s' % (NAME, msg))

collectd.register_config(configure_callback)
collectd.warning("Initializing keystone plugin")
collectd.register_read(read_callback)
