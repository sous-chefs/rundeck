## Future
* Unknown

## 1.0.6
* Changed the database name to match the db deploy

## 1.0.5
* Added a cam_lite recipe to split the old stuff out. This will eventually go away

## 1.0.4
* removed camdb_user and change web.config to use Trusted_Connection
* changed service account to be ui_user
* gave ui_user modify access to install_dir, so logging can occur
* added db_name attib which defaults to wt_CamLite, but we should use wtCamLite to match systemdb naming convention.
* set CAM site folder to an empty folder at c:\inetpub\wwwroot, only CamService vApp uses install_dir

## 1.0.1:
* Change URL attribute to download_url to match other products

## 1.0.0:
* Initial release
