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
    && apt-get clean

# Download and install Google Chrome stable
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P /tmp \
    && dpkg -i /tmp/google-chrome-stable_current_amd64.deb \
    && apt-get install -f -y \
    && rm /tmp/google-chrome-stable_current_amd64.deb

# Install ChromeDriver by getting the version of the installed Chrome
RUN GOOGLE_CHROME_VERSION=$(google-chrome-stable --version | awk '{print $3}' | cut -d '.' -f1-3) \
    && DRIVER_VERSION=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_${GOOGLE_CHROME_VERSION}") \
    && wget -O /tmp/chromedriver.zip "https://chromedriver.storage.googleapis.com/${DRIVER_VERSION}/chromedriver_linux64.zip" -P /tmp \
    && unzip /tmp/chromedriver.zip -d /usr/local/bin/ \
    && chmod +x /usr/local/bin/chromedriver \
    && rm -f /tmp/chromedriver.zip

# Verify Chrome and ChromeDriver installation
RUN google-chrome-stable --version && chromedriver --version

# Set Chrome as the default browser (optional)
RUN ln -s /usr/bin/google-chrome-stable /usr/bin/google-chrome

# Set the working directory (optional)
WORKDIR /app

# Start a shell to interact with the container
CMD [ "bash" ]
