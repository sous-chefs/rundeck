default["mysql"]["services"]["db"]["scheme"] = "tcp"        # node_attribute
default["mysql"]["services"]["db"]["port"] = 3306           # node_attribute
default["mysql"]["services"]["db"]["network"] = "nova"      # node_attribute

case platform
when "fedora", "redhat", "centos", "scientific", "amazon"
  default["mysql"]["platform"] = {                          # node_attribute
    "mysql_service" => "mysqld"
  }
when "ubuntu", "debian"
  default["mysql"]["platform"] = {                          # node_attribute
    "mysql_service" => "mysql"
  }
end
