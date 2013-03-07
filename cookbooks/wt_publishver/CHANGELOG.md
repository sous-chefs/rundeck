# CHANGELOG for wt_publishver

This file is used to list changes made in each version of wt_publishver.

## 0.2.2
* removed support for ubuntu less than version 12, too many problems installing nokogiri

## 0.2.1
* fix handling hash returned from manifest for ruby 1.9
* add support for chef installed from omnibus installer, i.e. use chef's gem binary
* clear cookbook cache if chef/ruby versions changed from previous run, so gems are built with correct ruby version

## 0.2.0:
* changed publish_verison method to a LWRP (wt_publishver)
* add support for Ubuntu
* add more roles to publishing info

## 0.1.2:
* Add wt_sauth to windows publishing information.
* Add wt_streaming_viz to windows publishing information.

## 0.1.1:
* Add wt_logpreproc to windows publishing information.
* Change httpclient and logging gem version to match viewpoint-spws version constraints.
* Modified viewpoint-spws gem so it works with Pod Details page.  I've added the designation 'wt'
  to the version to indicate this gem was changed from the original by Webtrends.

## 0.1.0:

* Initial release of wt_publishver

- - - 
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.
