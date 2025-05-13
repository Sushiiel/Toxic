#!/bin/bash

# Update and install required tools
apt-get update && apt-get install -y wget unzip curl gnupg

# Install Google Chrome (Headless version)
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install -y ./google-chrome-stable_current_amd64.deb

# Create a directory for chromedriver
mkdir -p /tmp/chromedriver

# Download and unzip ChromeDriver into a subdirectory
wget https://storage.googleapis.com/chrome-for-testing-public/136.0.7103.92/linux64/chromedriver-linux64.zip -P /tmp
unzip /tmp/chromedriver-linux64.zip -d /tmp/chromedriver

# Set executable permission for the chromedriver binary
chmod +x /tmp/chromedriver/chromedriver-linux64/chromedriver

# Move the actual executable to the location your Python code expects
mv /tmp/chromedriver/chromedriver-linux64/chromedriver /tmp/chromedriver/chromedriver

# (Optional) Output path for debug
echo "✅ Chromedriver is ready at: /tmp/chromedriver/chromedriver"
