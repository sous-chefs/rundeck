# scala cookbook

Installs the Scala programming language language. [See the Scala homepage](http://www.scala-lang.org/)

# Requirements

* Chef 10
* Java

# Usage

Include the `scala::default` recipe to your run list or inside your cookbook.

# Attributes

The following attributes are set under the `scala` namespace:

* version  - The version to install.
* url      - The url to the Scala tgz.
* checksum - The SHA-256 of the Scala tgz.
* home     - The installation directory for Scala. 

# Recipes

* default

# Author

Author:: Kyle Allan (<kallan@riotgames.com>)