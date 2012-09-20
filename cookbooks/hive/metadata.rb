maintainer        "Webtrends"
maintainer_email  "sean.mcnamara@webtrends.com"
license           "Apache 2.0"
description       "Installs Hive"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.1.0"
depends           "java"
depends           "hadoop"
depends           "hbase"
depends           "zookeeper"

recipe "hive", "Installs hive"
