maintainer       "Webtrends, Inc."
maintainer_email "adam.sinnet@webtrends.com"
license          "All rights reserved"
description      "Collection of meta-recipes to include testing in other cookbooks."
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.3.0"

depends "chef_handler"
depends "unit-tests"
