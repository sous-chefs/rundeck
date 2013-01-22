## 0.0.4
* Removed the un-deploy code from this cookbook since it only sets up the site and doesn actually deploy bits.
* Cleaned up some code

## 0.0.3
* Fix the deploy logging text
* Ungate the setup of Apache.  We should always be making sure Apache is configured
* Add a commented out creation of inproduction.html.  We'll use this at some point

## 0.0.2:
* Hook in deploy_build logic
* Create an uninstaller that removes everything in /var/www
* Disable the default site
* Create a new site from a template

## 0.0.1:

* Creation of a blank cookbook