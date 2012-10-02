maintainer        "Webtrends"
maintainer_email  "sean.mcnamara@webtrends.com"
license           "Apache 2.0"
description       "Installs Hbase"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.1.3"
depends           "java"
depends           "hadoop"
depends           "zookeeper"

recipe "hbase", "Installs hbase"
