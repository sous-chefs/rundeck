## 1.0.12
* Add cam.url as parameter in appsettings.config
* Remove dirty ugly hack section

## 1.0.11
* Add ELMAH config to appSettings.config template.
* Add wt_iis section to authorization databag. Includes machine key settings for validation and decryption.
* Add client credentials to streaming_viz databag.
* Configure forms auth cookie settings to match auth (_sauth cookie, .webtrends.com domain)

## 1.0.10
* Default to port 80 not port 85
* Remove attributes for SAPI/Sauth/proxy URLs.  Instead use environmental attributes that already exist
* Default to using a proxy server
* Foodcritic fixes

## 1.0.9
* Add web.config template
    * Includes settings for ELMAH, custom errors, and http proxy.
* Add attributes for elmah, custom errors and http proxy.

## 1.0.8
* Add template for log4net.config

## 1.0.7
* Grant IUSR read-only access to install dir.

## 1.0.6
* Remove app removal, set ignore_failure for site removal.

## 1.0.5
* Remove app creation. Set app_pool for site

## 1.0.4:
* Use right port variable from environment.

## 1.0.3:
* Add missing comma.

## 1.0.2:
* Include POD id in appsettings.config for the dirty hack.

## 1.0.1:
* Default port to 85.

## 1.0.0:
* Initial release
