#!/bin/bash

: ${HADOOP_PREFIX:=/usr/local/hadoop}

$ACCUMULO_HOME/bin/stop-all.sh
$HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
$HADOOP_PREFIX/sbin/stop-yarn.sh
$HADOOP_PREFIX/sbin/stop-dfs.sh
$ZOOKEEPER_HOME/bin/zkServer.sh stop

service sshd stop
