Cookbook: minitest-handler  
Author: Adam Sinnett <adam.sinnett@webtrends.com>  
Copyright: 2012 Webtrends, Inc.  

Description
===========

This is a LWRP to enable running tests and/or specs in the post-handler step of a chef run.

This cookbook uses the minitest-chef-handler gem for its opperation, and minitest for it's test runner. Both these gems must be available for it's completion. (Note minitest is included with all Ruby 1.9+ installations.)

Usage
=====

You have a cookbook you would like to tests? Awesome, here's how:

First, add this cookbook as a depends in your cookbooks metadata, ie:

`depends     "minitest-handler"`

Second, include the minitest-handler LWRP inside your own cookbook recipe. This will set a minitest-handler to run after the chef run, running all the tests for your recipe.

example:

`minitest_handler cookbook_name do
  recipe_name recipe_name
end`

Finally, for that recipe, include all the tests you've written in your files/default/tests.

(for a default recipe, for instance, it would be <cookbook_dir>/files/default/default\_test.rb

Attributes
=========

cookbook\_name | Name of the cookbook you are testing
recipe\_name   | Name of the recipe you are testing.
mode           | filemode to create test directories in (default 00755)
owner          | User to create test directories as (default root)
group          | Group to create test directories as (default root)
path           | where to store tests (default /tmp/chef/tests)
recipe\_type   | What type of tests to run (unit_test_ or _spec_s) (default test)
action         | What to do, :run or :nothin
