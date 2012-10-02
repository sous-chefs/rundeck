## Future

## 0.10.45
* Double decoding hm_url param since that's how it's being sent
* hm_url param is converted from "k1,v1,k2,v2" -> "k1=v1&k2=v2" so the resulting hash matches what a10 likes

## 0.10.44
* Removed the search for zookeeper nodes and creation of /etc/zookeeper file.  This is handled by hive cookbook.

## 0.10.43
* Added support for search alternate chef environment for data nodes.

## 0.10.41
* Added NRPE check

## 0.10.4
* Force encoding via a new map reduce file
* Initial release with a changelog
