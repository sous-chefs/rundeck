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