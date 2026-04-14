import sys
import os
import csv

# Add current directory to path for imports
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from flask import Flask
from routes.podcast_routes import podcast_bp
from routes.recommendation_routes import rec_bp
from routes.library_routes import library_bp

CSV_FILE_PATH = os.path.join(os.path.dirname(os.path.dirname(__file__)), "podcast_dataset.csv")
csv_data = []

def load_csv():
    global csv_data
    if not os.path.exists(CSV_FILE_PATH):
        print(f"Error: CSV file not found at {CSV_FILE_PATH}")
        return
    
    with open(CSV_FILE_PATH, mode='r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        for row in reader:
            csv_data.append(row)
    print(f"Loaded {len(csv_data)} records from CSV.")

app = Flask(__name__)

# Load data when app starts
load_csv()

# Enable CORS for Flutter app
@app.after_request
def after_request(response):
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', 'Content-Type')
    response.headers.add('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
    return response

app.register_blueprint(podcast_bp, url_prefix="/api/podcasts")
app.register_blueprint(rec_bp, url_prefix="/api/recommend")
app.register_blueprint(library_bp, url_prefix="/api/library")

if __name__ == "__main__":
    print("🚀 Starting Podwise Backend on http://0.0.0.0:8000")
    print("📊 Make sure podcast_dataset.csv exists in RS_Project folder")
    app.run(host="0.0.0.0", port=8000, debug=True)
