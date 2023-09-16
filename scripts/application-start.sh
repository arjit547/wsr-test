#!/bin/bash
if [ "$DEPLOYMENT_GROUP_NAME" == "wsr" ]; then
  cd /var/www/html/wsr-arjit-uni
  sudo apt-get update
  # Perform actions for upload branch
fi
