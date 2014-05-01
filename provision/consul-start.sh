#!/bin/bash

nohup /usr/local/bin/consul agent -server -data-dir /tmp/consul $@ 2>&1 |tee /var/log/consul.log &
# Sleep so we see some output
sleep 5
