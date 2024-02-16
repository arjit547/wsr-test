#!/bin/bash

# Update package information
apt-get update

# Install wget
apt-get -y install wget

# Install default JDK
apt-get -y install default-jdk

# Specify the desired version or build identifier
ZAP_VERSION="w2024-02-12"

# Download the specified version of OWASP ZAP, bypassing certificate verification
wget --no-check-certificate "https://builds.apache.org/job/ZAP_WEEKLY_D/lastSuccessfulBuild/artifact/${ZAP_VERSION}.zip" -O zap.zip

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
