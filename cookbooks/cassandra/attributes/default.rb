#
# Author:: David Dvorak (<david.dvorak@webtrends.com>)
# Cookbook Name:: cassandra
# Attribute:: default
#
# Copyright 2012, Webtrends Inc.
#

# Cassandra
default['cassandra']['build_uri'] = 'http://rpm.datastax.com/community/noarch/apache-cassandra1-1.0.9-1.noarch.rpm'
default['cassandra']['mx4j_url'] = 'http://sourceforge.net/projects/mx4j/files/MX4J%20Binary/3.0.2/mx4j-3.0.2.tar.gz/download'
default['cassandra']['jna_url'] = 'http://java.net/projects/jna/sources/svn/content/tags/3.3.0/jnalib/dist/jna.jar?rev=1208'