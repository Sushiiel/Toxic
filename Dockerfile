# Use an official base image
FROM ubuntu:20.04

# Set non-interactive installation to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies for Chrome and ChromeDriver
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    libvulkan1 \
    curl \
    gnupg2 \
    ca-certificates \
    libx11-xcb1 \
    libglu1-mesa \
    libxcomposite1 \
    libxrandr2 \
    libgdk-pixbuf2.0-0 \
    libnss3 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libx11-6 \
    libxshmfence1 \
    libasound2 \
    libnspr4 \
    libxdamage1 \
    libappindicator3-1 \
    libdbusmenu-glib4 \
    libdbusmenu-gtk3-4 \
    fonts-liberation \
    xdg-utils \
    lsb-release \
    libgbm1 \
    && apt-get clean

# Download and install Google Chrome stable
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P /tmp \
    && dpkg -i /tmp/google-chrome-stable_current_amd64.deb \
    && apt-get install -f -y \
    && rm /tmp/google-chrome-stable_current_amd64.deb

# Set a fixed ChromeDriver version (113.0.5672.63)
RUN wget -O /tmp/chromedriver.zip "https://chromedriver.storage.googleapis.com/113.0.5672.63/chromedriver_linux64.zip" -P /tmp && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/chromedriver && \
    rm -f /tmp/chromedriver.zip

# Verify Chrome and ChromeDriver installation
RUN google-chrome-stable --version && chromedriver --version

# Remove any existing symbolic link for google-chrome and create a new one
RUN rm -f /usr/bin/google-chrome && ln -s /usr/bin/google-chrome-stable /usr/bin/google-chrome

# Set the working directory (optional)
WORKDIR /app

# Start a shell to interact with the container
CMD [ "bash" ]
