# Set Hadoop-specific environment variables here.

# The only required environment variable is JAVA_HOME. All others are
# optional. When running a distributed configuration it is best to
# set JAVA_HOME in this file, so that it is correctly defined on
# remote nodes.

# The java implementation to use.
export JAVA_HOME=<%= @java_home %>
export HADOOP_CONF_DIR=${HADOOP_CONF_DIR:-"/etc/hadoop"}

# The maximum amount of heap to use, in MB. Default is 1000.
export HADOOP_HEAPSIZE=<%= node.hadoop_attrib(:env, :HADOOP_HEAPSIZE) %>
#export HADOOP_NAMENODE_INIT_HEAPSIZE=""

# Extra Java runtime options. Empty by default.
export HADOOP_OPTS="-Djava.net.preferIPv4Stack=<%= node.hadoop_attrib(:env, :java_net_preferIPv4Stack) %> -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"

# Command specific options appended to HADOOP_OPTS when specified
export HADOOP_NAMENODE_OPTS="-Dhadoop.security.logger=INFO,DRFAS -Dhdfs.audit.logger=INFO,DRFAAUDIT $HADOOP_NAMENODE_OPTS -Dcom.sun.management.jmxremote.port=8004 <%= node.hadoop_attrib(:env, :HADOOP_OPTS) %>"
HADOOP_JOBTRACKER_OPTS="-Dhadoop.security.logger=INFO,DRFAS -Dmapred.audit.logger=INFO,MRAUDIT -Dhadoop.mapreduce.jobsummary.logger=INFO,JSA $HADOOP_JOBTRACKER_OPTS -Dcom.sun.management.jmxremote.port=8008 <%= node.hadoop_attrib(:env, :HADOOP_OPTS) %>"
HADOOP_TASKTRACKER_OPTS="-Dhadoop.security.logger=ERROR,console -Dcom.sun.management.jmxremote.port=8007 -Dmapred.audit.logger=ERROR,console $HADOOP_TASKTRACKER_OPTS <%= node.hadoop_attrib(:env, :HADOOP_OPTS) %>"
HADOOP_DATANODE_OPTS="-Dhadoop.security.logger=ERROR,DRFAS $HADOOP_DATANODE_OPTS -Dcom.sun.management.jmxremote.port=8006 <%= node.hadoop_attrib(:env, :HADOOP_OPTS) %>"

export HADOOP_SECONDARYNAMENODE_OPTS="-Dhadoop.security.logger=INFO,DRFAS -Dhdfs.audit.logger=INFO,DRFAAUDIT $HADOOP_SECONDARYNAMENODE_OPTS  -Dcom.sun.management.jmxremote.port=8005 <%= node.hadoop_attrib(:env, :HADOOP_OPTS) %>"

# The following applies to multiple commands (fs, dfs, fsck, distcp etc)
export HADOOP_CLIENT_OPTS="-Xmx128m $HADOOP_CLIENT_OPTS"
#HADOOP_JAVA_PLATFORM_OPTS="-XX:-UsePerfData $HADOOP_JAVA_PLATFORM_OPTS"

# On secure datanodes, user to run the datanode as after dropping privileges
export HADOOP_SECURE_DN_USER=

# Where log files are stored. $HADOOP_HOME/logs by default.
export HADOOP_LOG_DIR=/var/log/hadoop/

# Where log files are stored in the secure data environment.
export HADOOP_SECURE_DN_LOG_DIR=/var/log/hadoop/hdfs

# The directory where pid files are stored. /tmp by default.
export HADOOP_PID_DIR=/var/run/hadoop
export HADOOP_SECURE_DN_PID_DIR=/var/run/hadoop

# A string representing this instance of hadoop. $USER by default.
export HADOOP_IDENT_STRING=$USER

# Because subprojects use HADOOP_HOME
export HADOOP_HOME_WARN_SUPPRESS="TRUE"
