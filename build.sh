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

# Extract OWASP ZAP
unzip zap.zip -d zap

# Change directory to the extracted ZAP directory
cd zap/ZAP_D-2024-02-12

# Run ZAP command
./zap.sh -cmd -quickurl https://www.example.com -quickprogress -quickout zap_report.html

# Move the report file to the correct location
mv zap_report.html ../../

# Change directory back to the original location
cd -

# Copy report file to S3 bucket
aws s3 cp zap_report.html s3://pipelinezapout/

echo "ZAP scan and report generation completed successfully."
