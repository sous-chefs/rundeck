Description
===========

Setup up an apt and yum repository on a system.  Installs reprepro for apt support and
create repo for yum support.  Installs nfs-common and mounts a NFS volume to the repo path.
Apache is installed and configured and shares out that repo path.

The optional environment_publish.rb recipe will publish your chef environments folder
folder on your repo webserver.  This is useful for environments where access to modify
environment files needs to be restricted by separate repositories, but access to view
repositories is still desired.  This requires your chef repository be on the same system
as your repository

Requirements
============

* Ubuntu / Debian system


Attributes
==========

* repo_path: System path where the repo will be mounted
* repo_mount: NFS volume to mount for the repo
* sysadmin_email: Contact e-mail for the repo administrator
* chef_repo_path: Local path to the repository

Usage
=====

