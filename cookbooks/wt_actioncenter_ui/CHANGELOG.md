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
