maintainer        "Webtrends"
maintainer_email  "sean.mcnamara@webtrends.com"
license           "Apache 2.0"
description       "Installs heatmaps 0.8.0"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.10.4"
depends           "nginx"

recipe "apiserver", "Installs heatmaps apiserver"
recipe "mapred", "Installs heatmaps mapreduce scripts"


