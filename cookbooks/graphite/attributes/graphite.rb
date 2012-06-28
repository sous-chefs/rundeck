version = node[:graphite][:version]
series = node[:graphite][:version].split(".").first(2).join(".")

default[:graphite][:version] = "0.9.10"

default[:graphite][:carbon][:uri] = "https://launchpad.net/graphite/#{series}/#{version}/+download/carbon-#{version}.tar.gz"
default[:graphite][:carbon][:checksum] = "4f37e00595b5b"

default[:graphite][:whisper][:uri] = "https://launchpad.net/graphite/#{series}/#{version}/+download/whisper-#{version}.tar.gz"
default[:graphite][:whisper][:checksum] = "36b5fa9175262"

default[:graphite][:graphite_web][:uri] = "https://launchpad.net/graphite/#{series}/#{version}/+download/graphite-web-#{version}.tar.gz"
default[:graphite][:graphite_web][:checksum] = "4fd1d16cac398"

default[:graphite][:carbon][:line_receiver_interface] =   "127.0.0.1"
default[:graphite][:carbon][:pickle_receiver_interface] = "127.0.0.1"
default[:graphite][:carbon][:cache_query_interface] =     "127.0.0.1"

default[:graphite][:password] = "change_me"
default[:graphite][:url] = "graphite"
