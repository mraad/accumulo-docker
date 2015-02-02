#!/bin/bash

: ${HADOOP_PREFIX:=/usr/local/hadoop}

$HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

rm /tmp/*.pid

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd $HADOOP_PREFIX/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

sed "s/HOSTNAME/$HOSTNAME/g" /usr/local/hadoop/etc/hadoop/core-site.xml.template > /usr/local/hadoop/etc/hadoop/core-site.xml

sed "s/HOSTNAME/$HOSTNAME/g" /usr/local/accumulo/conf/accumulo-site-template.xml > /usr/local/accumulo/conf/accumulo-site.xml

echo $HOSTNAME > /usr/local/accumulo/conf/gc
echo $HOSTNAME > /usr/local/accumulo/conf/masters
echo $HOSTNAME > /usr/local/accumulo/conf/monitor
echo $HOSTNAME > /usr/local/accumulo/conf/slaves
echo $HOSTNAME > /usr/local/accumulo/conf/tracers

service sshd start

$ZOOKEEPER_HOME/bin/zkServer.sh start

$HADOOP_PREFIX/sbin/start-dfs.sh
$HADOOP_PREFIX/bin/hdfs dfsadmin -safemode wait
$HADOOP_PREFIX/sbin/start-yarn.sh

$ACCUMULO_HOME/bin/accumulo init --instance-name accumulo --password secret

$HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

$HADOOP_PREFIX/sbin/stop-yarn.sh
$HADOOP_PREFIX/sbin/stop-dfs.sh

$ZOOKEEPER_HOME/bin/zkServer.sh stop

service sshd stop
