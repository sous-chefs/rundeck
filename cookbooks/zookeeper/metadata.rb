maintainer        "Webtrends"
maintainer_email  "sean.mcnamara@webtrends.com"
license           "Apache 2.0"
description       "Installs Zookeeper"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "1.0.0"
depends           "java" ">= 1.5" 
depends           "runit"

recipe "Zookeeper", "Installs Apache Zookeeper"


