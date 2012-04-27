# Version of Storm used in this cookbook.
default[:wt_storm][:version] = "0.7.1"

# Packages which need to be installed on the system
# to allow for running Storm.
default[:wt_storm][:build_pkgs] = ["unzip"]
