## 1.0.4
* Create attribute for the healthcheck_port so this service can coexist with others that try to use 9000

## 1.0.3
* Added minitest-handler and a preliminary test that verifies healthcheck returns true

## 1.0.2
* Moved log config from code to cookbook.

## 1.0.1
* Remove the unused CAM DB connection string.  This has been replaced with the shared connection string

## 1.0.0
* Fix deploy logging
* Change jmx port and product port from a string to a int as it should be

## 0.0.15
* STR-187: Changed permissions on config.properties

## 0.0.14
* Created an attribute for the root logging level for log4j

## 0.0.13
* Removed the force-stop from undeploy.rb

## 0.0.12
* Removed authentication attributes from the attributes file since these come from the databag anyways
* Removed unused user attribute being passed to a template
* Removed Java Class attribute being passed since it was hardcoded text anyways.  No need to waste memory on this

## 0.0.11
* Find the hostname / db name for the On Demand master DB from wt_masterdb environmental attributes not from attributes in this cookbook
* Use the JMX port attribute in the cookbook and not the attribute from wt_monitoring

## 0.0.10
* Added shared connection string for new db schema

## 0.0.9
* Moved template section to bottom of recipe.

## 0.0.8
* Moved direction creations to the beginning

## 0.0.7
* Moved template updates to above the deploy gate. Removed call to processTemplates

## 0.0.6
* Address food critic warnings

## 0.0.5
* unknown

## 0.0.4
* Removed the use of a method to template configs as it only made the cookbook more complex
* Added all attributes to the attributes file
* Created default attributes for includeUnmappedAnalyticsIds, port, and camdbname since these won't change between pods

## 0.0.3
* Broke db connection strings into component parts

## 0.0.2:
* Added monitoring.properties.erb and changed the default recipe to support it
* Added collectd configuration
* Added Nagios support

## 0.0.1:
* Cookbook created
