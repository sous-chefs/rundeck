## 1.1.18
* moved hard-coded help_url to attribute and updated with value per STR-872

## 1.1.17
* set a default errorRedirect in the web.config template

## 1.1.16
* replaced missing comma in recipe

## 1.1.15
* added the sms_url attribute to the appSettings.config template
## 1.1.14
* Add current node domain to proxy bypass list
## 1.1.13
* Added share_wrs
## 1.1.12
* Add bindingRedierect for Autofac

## 1.1.11
* Add compatibilityMode attribute for machineKey in web.config
* Remove formsAuthentication credentials

## 1.1.10
* Remove unnecessary "pod" attribute

## 1.1.9
* Add application/x-javascript to httpCompression section in web.config template

## 1.1.8
* Add httpCompression section to web.config template

## 1.1.7
* Fixed log4net to use the log_dir variable not the install_log_dir
* Remove extra "logs" directory in the log4net template

## 1.1.6
* Add attribute wt_streaming_viz.auth_service_version = "v1"
* Build base url from auth_service_url/auth_service_version

## 1.1.5
* Revert auth base url

## 1.1.4
* Update auth base url

## 1.1.3
* Updated auth url
* Fixed note -> node typo

## 1.1.2
* Add appSettings references for help, account, and streams urls.

## 1.1.1
* Includes 1.1.0 and 1.0.14 changes because merge.

## 1.1.0
* Changed [wt_cam][auth_service_url] to [wt_sauth][auth_service_url]
* Fixed spacing
* Moved templates to outside deploy gate

## 1.0.14
* Make new appSettings parameter auth.url.base with new environment setting to match.
* Make new appSettings parameter cam.url.base with new environment setting to match.

## 1.0.13
* Missing comma

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
