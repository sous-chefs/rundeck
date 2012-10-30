## 1.0.0:
* Add NRPE check

## 0.0.17:
* Add the checksum to kafka.  This matches what we did in the Kafka cookbook
* Add download_url attribute to the attributes file

## 0.0.16:
* Adding attributes for monitoring

## 0.0.15:
* Add mirror monitor recipe

## 0.0.14:
* STR-127: Expose Log4J logging level as an attribute
* Cookbook review cleanup
* Switch to using File.join
* Add source and target attribute entries to cookbook attributes

## 0.0.13:
* Removed zookeeper kafka prefixing
* Simplified format of node attribute since we no longer need to
  * specify the zk path
    New Format:

    "wt_kafka_mm": {
      "sources": [
        "G",
        "M"
      ],
      "target": "H"
    },


## 0.0.8:
* Initial release with a changelog
* Resolve food critic warnings