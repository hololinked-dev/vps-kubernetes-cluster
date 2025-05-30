#!/bin/sh

set -a && source .env && set +a
scp "$1" root@${MAIN_NODE_IP}:~/