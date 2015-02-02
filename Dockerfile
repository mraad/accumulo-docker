FROM sequenceiq/hadoop-docker

MAINTAINER @mraad <mraad@esri.com>

USER root

ENV PATH $PATH:$HADOOP_PREFIX/bin

RUN chown -R root:root $HADOOP_PREFIX

RUN echo -e "\n* soft nofile 65536\n* hard nofile 65536" >> /etc/security/limits.conf

RUN curl -s http://mirror.cc.columbia.edu/pub/software/apache/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz | tar -xz -C /usr/local
RUN ln -s /usr/local/zookeeper-3.4.6 /usr/local/zookeeper;\
 chown -R root:root /usr/local/zookeeper-3.4.6;\
 mkdir -p /var/zookeeper
ENV ZOOKEEPER_HOME /usr/local/zookeeper
ENV PATH $PATH:$ZOOKEEPER_HOME/bin
ADD zookeeper/* $ZOOKEEPER_HOME/conf/

RUN curl -s http://archive.apache.org/dist/accumulo/1.5.2/accumulo-1.5.2-bin.tar.gz | tar -xz -C /usr/local
RUN ln -s /usr/local/accumulo-1.5.2 /usr/local/accumulo;\
 chown -R root:root /usr/local/accumulo-1.5.2
ENV ACCUMULO_HOME /usr/local/accumulo
ENV PATH $PATH:$ACCUMULO_HOME/bin
ADD accumulo/* $ACCUMULO_HOME/conf/

ADD *-all.sh /etc/
RUN chown root:root /etc/*-all.sh;\
 chmod 700 /etc/*-all.sh

ADD init-accumulo.sh /tmp/
RUN /tmp/init-accumulo.sh

EXPOSE 2181 9000 50095
