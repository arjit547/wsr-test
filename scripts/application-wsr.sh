#!/bin/bash
if [ "$DEPLOYMENT_GROUP_NAME" == "main" ]; then
  cd /var/www/html/wsr-arjit
  sudo apt-get update
  # Perform actions for main branch
fi
