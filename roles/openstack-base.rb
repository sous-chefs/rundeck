name "iopenstack-base"
description "Base role for a server"
run_list(
  "recipe[apt]",
  "recipe[openssh]",
  "recipe[ntp]"
)
default_attributes(
  "ntp" => {
    "servers" => ["ntp.webtrends.corp"]
  },
  "authorization" => {
    "sudo" => {
      "include_sudoers_d" => true
    }
  }
)
