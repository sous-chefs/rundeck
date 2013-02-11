## 1.1.12
* Add oauth2 configuration items to web.config template.

## 1.1.11
* Remove unused url_base parameters from attributes, replace with proper config values.

## 1.1.10
* Add node domain to http proxy bypass list.

## 1.1.9
* Added share_wrs

## 1.1.8
* Add compatibilityMode attribute for machineKey in web.config
* Remove formsAuthentication credentials

## 1.1.7:
* Change log4net template to use correct log location.

## 1.1.6:
* Add new attribute wt_portfolio_admin.auth_service_version
* Build auth url from auth_service_url/auth_service_version

## 1.1.5:
* Revert lack of v1 in auth base url

## 1.1.4:
* Change default auth base uri to match with new auth service uri

## 1.1.3:
* Added missing Autofac config

## 1.1.2:
* Fixed note -> node typo

## 1.1.1:
* Add appSettings references for help, account, and streams urls.

## 1.1.0:
* Changed [wt_cam][auth_service_url] to [wt_sauth][auth_service_url]
* Fixed spacing
* Moved templates to outside deploy gate

## 1.0.0:
* Initial release
