import streamlit as st
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import google.generativeai as genai
import os
import chromedriver_autoinstaller

# Automatically install the correct chromedriver version for the current Chrome version
chromedriver_autoinstaller.install()

def get_form_text(form_url):
    try:
        # Path to the installed Chrome and ChromeDriver
        chrome_path = "/usr/bin/google-chrome-stable"  # Path to Chrome
        chromedriver_path = "/usr/local/bin/chromedriver"  # Path to ChromeDriver
        
        # Check if Chrome and ChromeDriver exist at the expected paths
        if not os.path.exists(chrome_path):
            return f"❌ Chrome not found at {chrome_path}. Please ensure Chrome is installed correctly."
        if not os.path.exists(chromedriver_path):
            return f"❌ ChromeDriver not found at {chromedriver_path}. Please ensure ChromeDriver is installed correctly."

        print(f"Chrome found at {chrome_path}")  # Log for debugging
        print(f"Chromedriver found at {chromedriver_path}")  # Log for debugging

        # Set up Chrome options
        options = Options()
        options.add_argument("--headless")  # Run in headless mode
        options.add_argument("--disable-gpu")
        options.binary_location = chrome_path  # Set the binary location for Chrome

        # Set up the WebDriver with custom chromedriver path
        service = Service(chromedriver_path)
        driver = webdriver.Chrome(service=service, options=options)

        # Load the Google Form
        driver.get(form_url)

        # Wait for the form to load and extract elements (example selector, adjust as needed)
        elements = driver.find_elements_by_css_selector(".o3Dpx")
        elements_text = [element.text for element in elements]

        driver.quit()
        return elements_text

    except Exception as e:
        return f"❌ Error loading form: {str(e)}"

def get_gemini_response(input_text):
    try:
        genai.configure(api_key=os.getenv("GEMINI_API_KEY"))
        model = genai.GenerativeModel("gemini-1.5-flash")
        response = model.generate_content(input_text)
        return response.text
    except Exception as e:
        return f"❌ Gemini API error: {str(e)}"

st.set_page_config(page_title="Google Form AI Assistant", layout="centered")
st.title("📄 Google Form Analyzer with Gemini AI")

form_url = st.text_input("Paste the Google Form URL below:")

if st.button("Analyze Form"):
    if form_url:
        with st.spinner("Loading and analyzing form..."):
            form_content = get_form_text(form_url)
            if isinstance(form_content, str) and form_content.startswith("❌"):
                st.error(form_content)
            else:
                gemini_output = get_gemini_response(form_content)
                st.subheader("✅ Extracted Form Text:")
                st.write(form_content)
                st.subheader("💡 Gemini's Analysis:")
                st.write(gemini_output)
    else:
        st.warning("Please enter a valid Google Form URL.")
