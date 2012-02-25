Description
===========

This cookbook provides a collection of common definitions, libraries, resources and provides simplify the deployment of Webtrends services and components.

Requirements
============

* yum

Attributes
==========

* `node['wt_base']['yum']` - An array of yum repositories
** `name` - Yum repository name
** `description` - Yum repository description
** `url` - Yum repository source url

Recipes
=======

* yumrepo - loops through array `node['wt_base']['yum']` and configures repos under /etc/yum.repos.d

Usage
=====

Put `recipe[wt_base::yumrepo]` first in your role's run list if you want to use custom rpm packages in other recipes.
