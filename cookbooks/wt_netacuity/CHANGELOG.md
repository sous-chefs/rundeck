## 1.0.13
* removed redundant internal attribute set in the netacuity service

## 1.0.12
* Remove old wt_netacuity_webui Nagios check.  This is no longer needed

## 1.0.11
* Update the nagios check to support both NetAcuity 5.X and 4.X versions
* Change the default version to 502 not 460
* Add name value to metadata

## 1.0.10
* switch to run as non-root user: netacuity
* changed data bag admin password, to be the password and not a password hash
* use NetAcuity provided init script
* when using proxy, also add param US_INCLUDE_HTTP_HEADER, as stated in addendum to Users Guide
* removed java dependency
* download_url is now full url, tarball name is not assumed

## 1.0.9
* Added an NRPE plugin that directly queries netacutiy for data and alerts if the query fails.

## 1.0.8
* Fix the attribute that keeps NetAcuity from trying to upgrade the base system.  This prevents random service restarts

## 1.0.7
* Don't use the deploy flag.  This breaks setups where NetAcuity sits with other WT services and wipes away the DBs / breaks NetAcuity for over and hour post deploy of the WT services
* Delete the init script on uninstall

## 1.0.6
* Address several food critic warnings

## 1.0.5
* Remove wt_base code.  There's no need for it
* Remove missing data bag catches that weren't working

## 1.0.4
* Wrap the recipe in a deploy flag since this recipe will never leave webtrends
* Template the password file from the authorization data bag

## 1.0.3
* Fix passing the version attribute into the template

## 1.0.2:
* Use NetAcuity 5.0 by default.  There's no reason to pin to 4.6 as was required in Optimize

## 1.0.1:
* Attempt to fix the gating

## 1.0.0:

* Initial transfer from Optimize
* Allow installing to any directory
* Move attributes out of databags an into environments
* Host NetAcuity in the repo and not as a cookbook file
* General cleanup to do things how they should be done
