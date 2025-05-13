#!/bin/bash

# Update and install required tools
apt-get update && apt-get install -y wget unzip curl gnupg

# Install Google Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install -y ./google-chrome-stable_current_amd64.deb

# Create a persistent directory for chromedriver
mkdir -p /opt/chromedriver

# Download and unzip ChromeDriver into /opt
wget https://storage.googleapis.com/chrome-for-testing-public/136.0.7103.92/linux64/chromedriver-linux64.zip -P /opt
unzip /opt/chromedriver-linux64.zip -d /opt/chromedriver

# Set permissions and move chromedriver binary
chmod +x /opt/chromedriver/chromedriver-linux64/chromedriver
mv /opt/chromedriver/chromedriver-linux64/chromedriver /opt/chromedriver/chromedriver

# Confirm
echo "✅ Chromedriver is ready at: /opt/chromedriver/chromedriver"
