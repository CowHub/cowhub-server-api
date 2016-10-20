#!/bin/bash

echo -e "DEPLOYING...\n\n\n"
ssh root@cloud-vm-server-api-01 "/bin/bash -c /deploy.sh"
