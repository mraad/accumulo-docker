# Single Node [Accumulo](https://accumulo.apache.org/) Instance On Docker

This work is base on [https://github.com/medined/docker-accumulo](https://github.com/medined/docker-accumulo) - Thanks :-)

If you are using [boot2docker](http://boot2docker.io/) you might want to up the memory and storage space.

```shell
boot2docker init -m 8192 -s 32768
```

On Windows, the `C:` drive is mounted on the linux host as `/c`. Copy this folder onto your `C:` drive so you can `cd /c/accumulo-docker`

### vm.swappiness and docker

The `vm.swappiness` system parameter has to be set in the docker host OS to be inherited by the Accumulo container.

If you are using boot2docker then `boot2docker ssh` to login to the host OS.

```shell
sudo sysctl -w vm.swappiness=0
sudo sysctl -w net.ipv6.conf.lo.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
```

Check the value using:
```shell
sysctl vm.swappiness
```

### Build the container image

```shell
docker build -t mraad/accumulo .
```

### Run the container

```shell
docker run --name accumulo -i -t -P mraad/accumulo /bin/bash
```

### Start Zookeeper, YARN, HDFS and Accumulo

```shell
/etc/start-all.sh
```

### Stop Accumulo, HDFS, YARN and Zookeeper

```shell
/etc/stop-all.sh
```

### See all exposed ports

```shell
docker port accumulo | sort -t / -n
```


In this line sample `50070/tcp -> 0.0.0.0:49161`, the internal port `50070` is mapped to `49161` on the host OS.

If you are using boot2docker, get the host OS IP using `boot2docker ip`

SERVICE  |URL                             |
---------|--------------------------------|
YARN     | http://docker-ip:exposed-8088  |
HDFS     | http://docker-ip:exposed-50070 |
ACCUMULO | http://docker-ip:exposed-50095 |


### Sample Accumulo session in the container

```shell
bash-4.1# accumulo shell -u root -p secret

Shell - Apache Accumulo Interactive Shell
-
- version: 1.5.2
- instance name: accumulo
- instance id: 57fdffe2-5a38-48dd-934f-5d2db507027d
-
- type 'help' for a list of available commands
-
root@accumulo> createtable mytable
root@accumulo mytable> tables
!METADATA
mytable
trace
root@accumulo mytable> insert row1 colf colq value1
root@accumulo mytable> scan
row1 colf:colq []    value1
root@accumulo mytable> exit
```

### Extra References

* http://stackoverflow.com/questions/25767224/change-swappiness-for-docker-container
* http://en.wikipedia.org/wiki/Swappiness
* http://www.incrediblemolk.com/sharing-a-windows-folder-with-the-boot2docker-vm/
