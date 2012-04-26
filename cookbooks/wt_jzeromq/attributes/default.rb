# Version of JZMQ used in this cookbook. Version hash is from
# git clone https://github.com/nathanmarz/jzmq.git
# Cookbook is pinned to a specific commit needed for Storm.
default[:wt_jzeromq][:version] = "dd3327d620"

# Packages which need to be installed on the system
# to allow for compilation of JZMQ.
default[:wt_jzeromq][:build_pkgs] = ["build-essential","uuid-dev","autogen","pkg-config","libtool", "autoconf", "automake"]
