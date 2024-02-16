#!/bin/bash

# Update package information
apt-get update

# Install wget
apt-get -y install wget

# Install default JDK
apt-get -y install default-jdk

# Download ZAP
wget https://github.com/zaproxy/zaproxy/releases/download/v2.11.1/ZAP_2.11.1_Linux.tar.gz -O zap.tar.gz

# Check if download was successful
if [ $? -ne 0 ]; then
    echo "Failed to download ZAP. Exiting."
    exit 1
fi

# Extract ZAP
tar -xvf zap.tar.gz

# Check if extraction was successful
if [ $? -ne 0 ]; then
    echo "Failed to extract ZAP. Exiting."
    exit 1
fi

# Change directory to ZAP
cd ZAP_2.11.1

# Run ZAP command
./zap.sh -cmd -quickurl https://bolly4u.wine -quickprogress -quickout ../zap_report.html

# Check if ZAP command was successful
if [ $? -ne 0 ]; then
    echo "Failed to run ZAP command. Exiting."
    exit 1
fi

# Check if the report file was generated
if [ ! -f "../zap_report.html" ]; then
    echo "ZAP report file not found. Exiting."
    exit 1
fi

# Copy report file to S3 bucket
aws s3 cp ../zap_report.html s3://pipelinezapout/

# Check if file copy was successful
if [ $? -ne 0 ]; then
    echo "Failed to copy report file to S3 bucket. Exiting."
    exit 1
fi

echo "ZAP scan and report generation completed successfully."
