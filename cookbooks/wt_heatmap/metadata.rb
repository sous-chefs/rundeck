maintainer        "Webtrends"
maintainer_email  "sean.mcnamara@webtrends.com"
license           "Apache 2.0"
description       "Installs heatmaps 0.8.0"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "10.3"
depends           "nginx"

recipe "apiserver", "Installs heatmap apiserver"
recipe "mapred", "Installs heatmap mapreduce scripts"


