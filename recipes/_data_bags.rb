# Store contents of each data bag item in node.run_state so data can be accessed
# by any recipe that needs it.

# share data between recipes using run_state
# create this as a recursive hash if it hasnt already been written to
node.run_state['rundeck'] = Hash.recursive unless node.run_state.key('rundeck')

bag_name = node['rundeck']['rundeck_databag']
if node['rundeck']['secret_file']
  secret = Chef::EncryptedDataBagItem.load_secret(node['rundeck']['secret_file']) # ~FC086
  node.run_state['rundeck']['data_bag']['secure'] = data_bag_item(
    bag_name,
    node['rundeck']['rundeck_databag_secure'],
    secret
  )
  node.run_state['rundeck']['data_bag']['users'] = data_bag_item(
    bag_name,
    node['rundeck']['rundeck_databag_users'],
    secret
  )
  node.run_state['rundeck']['data_bag']['rdbms'] = data_bag_item(
    bag_name,
    node['rundeck']['rundeck_databag_rdbms'],
    secret
  )
  node.run_state['rundeck']['data_bag']['ldap'] = begin
                                                    data_bag_item(
                                                      bag_name,
                                                      node['rundeck']['rundeck_databag_ldap'],
                                                      secret
                                                    )
                                                  rescue Net::HTTPServerException, Chef::Exceptions::InvalidDataBagPath
                                                    nil
                                                  end
else
  node.run_state['rundeck']['data_bag']['secure'] = data_bag_item(
    bag_name,
    node['rundeck']['rundeck_databag_secure']
  )
  node.run_state['rundeck']['data_bag']['users'] = data_bag_item(
    bag_name,
    node['rundeck']['rundeck_databag_users']
  )
  node.run_state['rundeck']['data_bag']['rdbms'] = data_bag_item(
    bag_name,
    node['rundeck']['rundeck_databag_rdbms']
  )
  node.run_state['rundeck']['data_bag']['ldap'] = begin
                                                    data_bag_item(
                                                      bag_name,
                                                      node['rundeck']['rundeck_databag_ldap']
                                                    )
                                                  rescue Net::HTTPServerException, Chef::Exceptions::InvalidDataBagPath
                                                    nil
                                                  end
end

if node['rundeck']['rundeck_databag_aclpolicies']
  node.run_state['rundeck']['data_bag']['aclpolicies'] = data_bag_item(
    bag_name,
    node['rundeck']['rundeck_databag_aclpolicies']
  )
end

bag_name = node['rundeck']['rundeck_projects_databag']
data_bag(bag_name).each do |project_name|
  Chef::Log.debug "Loading data bag item '#{bag_name} / #{project_name}'"
  node.run_state['rundeck']['projects'][project_name] = data_bag_item(
    bag_name,
    project_name
  )
end
