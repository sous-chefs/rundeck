# Version of ZeroMQ used in this cookbook.
default[:wt_zeromq][:version] = "2.1.7"

# Packages which need to be installed on the system
# to allow for compilation of ZeroMQ.
default[:wt_zeromq][:build_pkgs] = ["build-essential","uuid-dev"]
