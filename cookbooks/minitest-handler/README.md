Cookbook: minitest-handler  
Author: Adam Sinnett <adam.sinnett@webtrends.com>  
Copyright: 2012 Webtrends, Inc.  

Description
===========

This is a group of meta-recipes to enable running tests and/or specs in the post-handler step of a chef run.

This cookbook uses the minitest-chef-handler gem for its opperation, and minitest for it's test runner. Both these gems must be available for it's completion. (Note minitest is included with all Ruby 1.9+ installations.)

Usage
=====

You have a cookbook you would like to tests? Awesome, here's how:

First, add this cookbook as a depends in your cookbooks metadata, ie:

`depends     "minitest-handler"`

Second, include the appropriate minitest-handler recipe inside your own cookbook recipe. You currently have two choices, depending on the type of tests you would like to write (unit test or spec):

`include_recipe "minitest-handler::tests`

or 

`include_recipe "minitest-handler::spec`

Finally, for that recipe, include all the tests you've written in your files/<recipe>/tests or files/<recipe>/specs directory, depending on if you've written unit tests or specs, respectively.

All tests must be in the form <recipe_name>_<test_type>.

(for a default recipe, for instance, it would be <cookbook_dir>/files/default/default_test.rb
