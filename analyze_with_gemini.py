import openai
from fpdf import FPDF

# ==== CONFIGURATION ====
GEMINI_API_KEY = "AIzaSyDTBHVgPnCzwvED2DXoZKKrOVgeHdk1djg"
openai.api_key = GEMINI_API_KEY

INPUT_FILE = "osint_output.txt"
PDF_REPORT = "osint_report.pdf"
PROMPT = "Analyze this OSINT data and provide a detailed, structured report including risk indicators and recommendations."
# ========================

# Read OSINT data
def read_osint_data():
    with open(INPUT_FILE, 'r') as file:
        return file.read()

# Call Gemini API
def analyze_with_gemini(content):
    response = openai.ChatCompletion.create(
        model="gpt-4o",  # Use "gpt-4o" or the model available to you
        messages=[
            {"role": "system", "content": "You are an expert OSINT analyst."},
            {"role": "user", "content": PROMPT + "\n\n" + content}
        ]
    )
    return response.choices[0].message.content

# Generate PDF Report
def generate_pdf(report_text):
    pdf = FPDF()
    pdf.add_page()
    pdf.set_font("Arial", size=12)

    for line in report_text.split('\n'):
        pdf.multi_cell(0, 10, line)

    pdf.output(PDF_REPORT)

# Main Process
def main():
    print("Reading OSINT data...")
    data = read_osint_data()

    print("Sending data to Gemini...")
    report = analyze_with_gemini(data)

    print("Generating PDF Report...")
    generate_pdf(report)

    print(f"PDF Report saved as {PDF_REPORT}")

if __name__ == "__main__":
    main()
