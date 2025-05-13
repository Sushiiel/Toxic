import streamlit as st
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import google.generativeai as genai
import time
import os
from webdriver_manager.chrome import ChromeDriverManager

def get_form_text(form_url):
    try:
        # Configure Chrome options for Render
        options = Options()
        options.add_argument("--headless")
        options.add_argument("--no-sandbox")
        options.add_argument("--disable-dev-shm-usage")
        options.add_argument("--disable-gpu")

        # Set up the Chrome driver
        service = Service(ChromeDriverManager().install())
        driver = webdriver.Chrome(service=service, options=options)

        # Load the Google Form
        driver.get(form_url)

        # Wait for the form to load and extract text
        wait = WebDriverWait(driver, 10)
        elements = wait.until(EC.presence_of_all_elements_located((By.CSS_SELECTOR, ".o3Dpx")))
        elements_text = [element.text for element in elements]

        driver.quit()
        return elements_text

    except Exception as e:
        return f"❌ Error loading form: {str(e)}"

def get_gemini_response(input_text):
    try:
        genai.configure(api_key=os.getenv("AIzaSyAfO8S5sipCLNhMgt70HtpFDrpuI7nanfw"))  # Use env variable
        model = genai.GenerativeModel("gemini-1.5-flash")
        response = model.generate_content(input_text)
        return response.text
    except Exception as e:
        return f"❌ Gemini API error: {str(e)}"

# Streamlit App UI
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
