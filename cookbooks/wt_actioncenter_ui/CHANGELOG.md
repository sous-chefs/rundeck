## 1.0.3
* Move logs to /var/log/webtrends/actioncenter-ui

## 1.0.2
* Added the correct help_url to the attributes

## 1.0.1
* Changed template Application_key to actioncenter

## 1.0.0
* Changed management URL to pull from management block 

## 0.9.5:
* Fixes for consistency

## 0.9.4:
* Configure endpoints in the production.yml

## 0.9.3:

* Configure sms.endpoint to wt_streamingmanagementservice.sms_service_url

## 0.9.2:

* Clean out artifact_deploy cache for artifact if deploy_build=true.
  Work around the fact that our artifacts from teamcity always have the same name.
* Clean out release_path whend deploy_build=true
  Work around the fact that our artifacts from teamcity always have the same version.
* Map release version to node[:wt_actioncenter_ui][:release]

## 0.9.1:

* Configure apache to front unicorn instances and serve static content.
* Miscellaneous bug fixes.

## 0.9.0:

* Initial release of wt_actioncenter_ui
