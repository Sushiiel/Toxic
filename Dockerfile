FROM python:3.10-slim

# Install necessary dependencies for Chrome and ChromeDriver
RUN apt-get update && apt-get install -y \
    wget curl unzip gnupg2 libglib2.0-0 libnss3 libgconf-2-4 \
    libfontconfig1 libxss1 libappindicator3-1 libasound2 \
    xdg-utils fonts-liberation libatk-bridge2.0-0 libgtk-3-0 \
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome and ensure it installs properly
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P /tmp \
    && dpkg -i /tmp/google-chrome-stable_current_amd64.deb || apt-get -fy install \
    && rm -f /tmp/google-chrome-stable_current_amd64.deb

# Install missing dependencies and fix broken packages
RUN apt-get install -y --fix-missing

# Verify Chrome installation and extract version
RUN google-chrome-stable --version

# Install ChromeDriver dynamically based on Chrome version
RUN CHROME_VERSION=$(google-chrome-stable --version | awk '{print $3}' | cut -d '.' -f1-3) && \
    echo "Google Chrome Version: $CHROME_VERSION" && \
    DRIVER_VERSION=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION") && \
    echo "ChromeDriver Version: $DRIVER_VERSION" && \
    wget -O /tmp/chromedriver.zip "https://chromedriver.storage.googleapis.com/${DRIVER_VERSION}/chromedriver_linux64.zip" -P /tmp && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/chromedriver && \
    rm -f /tmp/chromedriver.zip

# Set display port to avoid crash (for headless Chrome)
ENV DISPLAY=:99

# Install XVFB for headless browser support
RUN apt-get install -y xvfb

# Set working directory
WORKDIR /app

# Copy and install requirements
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY . .

# Start the application
CMD ["streamlit", "run", "app.py", "--server.port=8000", "--server.enableCORS=false"]
