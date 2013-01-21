Description
===========
This cookbook installs and configures Webtrends PDF Service

Requirements
============
The following recipes must be included in the wt_pdf_service role prior to
running this cookbooks default recipe
* `recipe[vc2010]`
* `recipe[ms_dotnet4]`
* `role[iis]`
* `recipe[iis::mod_compress_dynamic]`
* `recipe[iis::mod_aspnet]`

Attributes
==========

Data Bag Items
===============
* authorization data bag should have a data bag item for every environment Analytics will be deployed to. It must contain the following values
* `authorization['wt_common']['ui_user']` - User that owns the app pool and
* site in IIS
* `authorization['wt_common']['ui_pass']` - Password for ui_user

Usage
=====

