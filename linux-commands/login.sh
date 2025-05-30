#!/bin/sh

set -a && source .env && set +a
ssh root@${MAIN_NODE_IP} -p ${MAIN_NODE_SSH_PORT}
read -p "Press Enter to continue...