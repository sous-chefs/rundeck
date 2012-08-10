Description
===========

Setup up an apt and RPM repository on a system.  Installs reprepro for apt support and
create repo for RPM support.  Installs nfs-common and mounts a NFS volume to the repo path.
Apache is installed and configured and shares out that repo path.


Requirements
============

* Ubuntu / Debian system


Attributes
==========

* repo_path: System path where the repo will be mounted
* repo_mount: NFS volume to mount for the repo
* sysadmin_email: Contact e-mail for the repo administrator


Usage
=====

