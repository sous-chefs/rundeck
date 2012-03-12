Description
===========

This cookbook provides a collection of common definitions, libraries, resources and providers to help simplify the deployment of Webtrends services and components.

Requirements
============

* apt
* yum

Attributes
==========

* `node['wt_base']['apt']` - An array of apt repositories
** `name` - Apt repository name
** `distribution` - Apt repository distribution
** `component` - Apt  repository distribution's components, i.e. main, stable, non-free etc.
** `url` - Apt repository source url

* `node['wt_base']['yum']` - An array of yum repositories
** `name` - Yum repository name
** `description` - Yum repository description
** `url` - Yum repository source url

Recipes
=======

* aptrepo - loops through the array `node['wt_base']['apt']` and configures repos under /etc/apt/sources.list.d
* yumrepo - loops through the array `node['wt_base']['yum']` and configures repos under /etc/yum.repos.d

Usage
=====

Put `recipe[wt_base::aptrepo]` or `recipe[wt_base::yumrepo]` first in your role's run list if you wish to have custom packages available to other recipes.
