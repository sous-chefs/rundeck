name                "wt_actioncenter_dd_responsys"
maintainer          "Webtrends, Inc."
maintainer_email    "michael.parsons@webtrends.com"
license             "All rights reserved"
description         "Installs/Configures Webtrends Action Center Mangaement
Service"
long_description    IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version             "1.1.0"
depends             "java"
depends             "runit"
depends						  "wt_portfolio_harness", ">= 1.1.0"