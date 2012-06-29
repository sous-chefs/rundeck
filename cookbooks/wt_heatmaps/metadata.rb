maintainer        "Webtrends"
maintainer_email  "sean.mcnamara@webtrends.com"
license           "Apache 2.0"
description       "Installs Heatmaps"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.10.41"

recipe "apiserver", "Installs heatmaps apiserver"
recipe "mapred", "Installs heatmaps mapreduce scripts"
recipe "import", "Installs the import component"


