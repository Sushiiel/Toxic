#!/bin/bash

# Update and install required tools
apt-get update && apt-get install -y wget unzip curl gnupg

# Install Google Chrome (Headless version)
echo "Installing Google Chrome..."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome.deb
dpkg -i /tmp/google-chrome.deb
apt-get -f install -y  # This will fix missing dependencies if any

# Create a directory where chromedriver can be extracted (using /tmp)
mkdir -p /tmp/chromedriver

# Download and unzip ChromeDriver (Linux version) into /tmp
echo "Downloading ChromeDriver..."
wget https://storage.googleapis.com/chrome-for-testing-public/136.0.7103.92/linux64/chromedriver-linux64.zip -P /tmp
unzip /tmp/chromedriver-linux64.zip -d /tmp/chromedriver

# Set the proper permissions for chromedriver
chmod +x /tmp/chromedriver/chromedriver

# Optionally, output the extracted file path for debugging
echo "Chromedriver extracted to: /tmp/chromedriver/chromedriver"

# Check if the ChromeDriver file exists and is executable
if [ -x /tmp/chromedriver/chromedriver ]; then
    echo "Chromedriver is ready for use."
else
    echo "❌ Error: Chromedriver is not executable or not found."
    exit 1
fi

# Install additional dependencies (if necessary) for running Chrome in headless mode
echo "Installing additional dependencies for Chrome..."
apt-get install -y \
    libnss3 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libgdk-pixbuf2.0-0 \
    libgbm-dev \
    libasound2 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libglib2.0-0 \
    libappindicator3-1 \
    libcurl3 \
    fonts-liberation \
    xdg-utils \
    libxss1 \
    libxtst6 \
    lsb-release

# Clean up the downloaded .deb and .zip files to save space
rm /tmp/google-chrome.deb
rm /tmp/chromedriver-linux64.zip

echo "Setup completed."
