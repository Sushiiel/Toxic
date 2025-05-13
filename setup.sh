#!/bin/bash

# Update and install required tools
apt-get update && apt-get install -y wget unzip curl gnupg

# Install Google Chrome (Headless version)
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install -y ./google-chrome-stable_current_amd64.deb

# Create a directory where chromedriver can be extracted (using /tmp)
mkdir -p /tmp/chromedriver

# Download and unzip ChromeDriver (Linux version) into /tmp
wget https://storage.googleapis.com/chrome-for-testing-public/136.0.7103.92/linux64/chromedriver-linux64.zip -P /tmp
unzip /tmp/chromedriver-linux64.zip -d /tmp/chromedriver

# Set the proper permissions for chromedriver
chmod +x /tmp/chromedriver/chromedriver

# Optionally, output the extracted file path for debugging
echo "Chromedriver extracted to: /tmp/chromedriver/chromedriver"

# No need to create a symlink if we set the chromedriver path in the application
