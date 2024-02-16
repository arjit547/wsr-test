#!/bin/bash

# Update package information
apt-get update

# Install wget
apt-get -y install wget

# Install default JDK
apt-get -y install default-jdk

# Download ZAP
wget https://github.com/zaproxy/zaproxy/releases/download/v2.14.0/ZAP_2.14.0_Linux.tar.gz

# Extract ZAP
tar -xvf ZAP_2.14.0_Linux.tar.gz

# Change directory to ZAP
cd ZAP_2.14.0

# Run ZAP command
./zap.sh -cmd -quickurl https://www.example.com -quickprogress -quickout ../zap_report.html

# Delete previous items from S3 bucket
aws s3 rm s3://pipelinezapout/ --recursive

# Upload the new report to S3
aws s3 cp ../zap_report.html s3://pipelinezapout/
