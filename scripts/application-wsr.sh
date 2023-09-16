#!/bin/bash
if [ ""$DEPLOYMENT_GROUP_NAME" == "wsr" ]; then
  cd /var/www/html/wsr-arjit
  sudo apt-get update
  # Perform actions for main branch
fi
