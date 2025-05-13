#!/bin/bash

# Update and install required tools
apt-get update && apt-get install -y wget unzip curl gnupg

# Install Google Chrome (Headless version)
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install -y ./google-chrome-stable_current_amd64.deb

# Download and unzip ChromeDriver (Linux version)
wget https://storage.googleapis.com/chrome-for-testing-public/136.0.7103.92/linux64/chromedriver-linux64.zip
unzip chromedriver-linux64.zip -d /usr/local/bin/chromedriver

# Set the proper permissions
chmod +x /usr/local/bin/chromedriver/chromedriver

