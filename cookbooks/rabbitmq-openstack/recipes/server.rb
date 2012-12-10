
include_recipe "osops-utils"
platform_options = node["rabbitmq"]["platform"]

# Lookup endpoint info, and properly set rabbit attributes
rabbit_info = get_bind_endpoint("rabbitmq", "queue")
node.set["rabbitmq"]["port"] = rabbit_info["port"]
node.set["rabbitmq"]["address"] = rabbit_info["host"]

# TODO(shep): Using the 'guest' user because it gets special permissions
#             we should probably setup different users for nova and glance
# TODO(shep): Should probably use Opscode::OpenSSL::Password for default_password

include_recipe "rabbitmq::default"

# TODO - this needs to be templated out
rabbitmq_user "guest" do
  password "guest"
  action :add
end

rabbitmq_user "guest" do
  vhost "/"
  permissions "\".*\" \".*\" \".*\""
  action :set_permissions
end
