# Enable/Disable Distributed Search
# 1-n search heads <-> 1-n indexers
# See http://docs.splunk.com/Documentation/Splunk/latest/Deploy/Whatisdistributedsearch
default['splunk']['distributed_search']          = true

# The IP of the dedicated search master
default['splunk']['dedicated_search_master']     = "10.1.1.2"