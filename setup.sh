#!/bin/bash

# Update and install unzip + Chrome
apt-get update && apt-get install -y wget unzip curl gnupg

# Install Google Chrome (headless)
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install -y ./google-chrome-stable_current_amd64.deb

# Download and unzip ChromeDriver (version 136.0.7103.92 for Linux)
mkdir -p /usr/local/bin/chromedriver
cd /usr/local/bin/chromedriver
wget https://storage.googleapis.com/chrome-for-testing-public/136.0.7103.92/linux64/chromedriver-linux64.zip
unzip chromedriver-linux64.zip
mv chromedriver /usr/local/bin/chromedriver
chmod +x /usr/local/bin/chromedriver
