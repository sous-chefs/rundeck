Description
===========
various apache server related resource provides (LWRP)

* `apache_fastcgi` - configure fastcgi server via apache name based virtual host, now only `external` mode available

Platfroms
=========

* gentoo
* ubuntu
   
Requirements
============

* apache2 cookbook - https://github.com/opscode/cookbooks/tree/master/apache2

Resource Attributes
===================

* obligatory 
    * `socket` - a socket to which fast cgi external server is binded
    * `server_name` - name of virtual host 
* optional
    * `server_alias` - Array, a list of server aliases, default value is  `[]`
    * `timeout` - Integer, a time to wait for fast cgi server response, in seconds, default value `180`
    * `access_log` - a path to apache access log file
    * `error_log` - a path to apache error log file
    * `start_service` - true|false, whether to try to restart apache when configuring is done, default value `true`    
* optional for ssl mode
    * `ssl` - true|false, make virtual host ssl enabled, default value false
    * `ssl_cipher_suite`
    * `ssl_certificate_file`
    * `ssl_certificate_key_file`

 
Usage
=====

    apache_fastcgi 'myserver' do 
     action 'install'
     socket '/var/run/fast-cgi-server/socket'
     server_name 'host.myserver.com'
    end


Links
=====

 * http://httpd.apache.org/docs/1.3/vhosts/
 * http://www.fastcgi.com/drupal/node/25

ToDo
====

 * test ssl mode for ubuntu
 * add more platforms support 
 * add more tests
 * add wiki and howtos
 
 
 
 
 