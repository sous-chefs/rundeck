## Future

* Unknown

## 0.0.12
* Removed 'tarball' attribute as it is included in the download_url
* Externalized the java options 'java_opts'
* Externalized the java options 'jmx_port'

## 0.0.11
* Moved monitoring attributes to wt_monitoring

## 0.0.10
* Searches for zookeeper were made using nodes that apply the zookeeper recipe. In our environment we
* apply a zookeeper role instead tso the search was changed to look for the role

## 0.0.9
* Changed kafka properties to use zookeeper nodes taken from the nodes that use zookeeper recipe

## 0.0.6
* Fix file mode declarations (best practice)
* Use the chef defined temp directory not /tmp (best practice)
* Additional comments
* Attributes are references with strings not symbols (best practice)


## 0.0.5:
* Initial release with a changelog