## Future
* Unknown

## 1.0.11
* Removed the cookbook file and added logic to download the tarball from the repo
* Took the build packages out of the attributes file.  This should just be in the recipe
* Added zeromq as a dependency since there's a recipe include for it
* Now using the Chef defined file cache path to store the temp files not /tmp

## 1.0.10:
* Initial release with a changelog