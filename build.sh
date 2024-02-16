#!/bin/bash

# Update package information
apt-get update

# Install wget
apt-get -y install wget

# Install default JDK
apt-get -y install default-jdk

# Specify the URL for the OWASP ZAP weekly build
ZAP_URL="https://github.com/zaproxy/zaproxy/releases/download/w2024-02-12/ZAP_WEEKLY_D-2024-02-12.zip"

# Download OWASP ZAP
wget "$ZAP_URL" -O zap.zip

# Check if download was successful
if [ $? -ne 0 ]; then
    echo "Failed to download OWASP ZAP. Exiting."
    exit 1
fi

# Extract OWASP ZAP
unzip zap.zip -d zap

# Check if extraction was successful
if [ $? -ne 0 ]; then
    echo "Failed to extract OWASP ZAP. Exiting."
    exit 1
fi

# Change directory to the extracted ZAP directory
cd zap/ZAP_D-2024-02-12

# Run ZAP command
./zap.sh -cmd -quickurl https://bolly4u.wine -quickprogress -quickout ../zap_report.html

# Check if ZAP command was successful
if [ $? -ne 0 ]; then
    echo "Failed to run ZAP command. Exiting."
    exit 1
fi

# Change directory back to the original location
cd -

# Check if the report file was generated
if [ ! -f "zap_report.html" ]; then
    echo "ZAP report file not found. Exiting."
    exit 1
fi

# Copy report file to S3 bucket
aws s3 cp zap_report.html s3://pipelinezapout/

# Check if file copy was successful
if [ $? -ne 0 ]; then
    echo "Failed to copy report file to S3 bucket. Exiting."
    exit 1
fi

echo "ZAP scan and report generation completed successfully."
