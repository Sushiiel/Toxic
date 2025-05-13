#!/bin/bash

# Update and install required tools
apt-get update && apt-get install -y wget unzip curl gnupg

# Install Google Chrome (Headless version)
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install -y ./google-chrome-stable_current_amd64.deb

# Create a directory for chromedriver
mkdir -p /tmp/chromedriver

# Download and unzip ChromeDriver into /tmp
wget https://storage.googleapis.com/chrome-for-testing-public/136.0.7103.92/linux64/chromedriver-linux64.zip -P /tmp
unzip /tmp/chromedriver-linux64.zip -d /tmp/chromedriver

# Check the contents of /tmp/chromedriver directory to ensure chromedriver is extracted
echo "Contents of /tmp/chromedriver:"
ls -l /tmp/chromedriver

# Set executable permission for the chromedriver binary
chmod +x /tmp/chromedriver/chromedriver-linux64/chromedriver

# Move the chromedriver to the expected location
mv /tmp/chromedriver/chromedriver-linux64/chromedriver /tmp/chromedriver/chromedriver

# (Optional) Output path for debugging
echo "✅ Chromedriver is ready at: /tmp/chromedriver/chromedriver"
