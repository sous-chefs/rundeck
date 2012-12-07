## 1.0.12
* introduced template for cassandra-env.sh
* restart service if cassandra-env.sh changes

## 1.0.11
* Added cron based backup system to the backup recipe

## 1.0.10:
* Nagios monitors and collectd plugin applied from the monitors recipe

## 1.0.9:
* Initial release with a changelog
* Updated the default recipe to create a collectd java/JMX plugin
* Created a templates folder and .erb file for the collectd plugin
* Simplify the install process to install via the repo only
* Include the full set of attributes needed to get us to a install and configure state
