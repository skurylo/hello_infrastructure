#!/bin/bash

/usr/bin/daemon -n consul --env GOMAXPROCS=2 --output=/var/log/consul.log -- /usr/local/bin/consul agent -server -data-dir /tmp/consul $@
sleep 2
cat /var/log/consul.log
