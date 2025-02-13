#Transaction Tracker

A mobile application for tracking transactions, built with Flutter (Dart) for the frontend and Flask (Python) for the backend.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


Table of Contents

    Features
    Tech Stack
    Installation
    Backend Setup
    Frontend Setup
    Running the Application
    API Endpoints
    Troubleshooting

    Features

✅ User authentication (Login, Signup)
✅ Add, edit, and delete transactions
✅ View transaction history
✅ Visual representation of expenses & income

Tech Stack
Frontend (Flutter/Dart)

    Flutter (latest stable version)
    State Management: Provider
    HTTP package for API calls

Backend (Flask/Python)

    Flask (Micro web framework)
    Flask-RESTful for API structure
    SQLite or PostgreSQL for database
    Flask-CORS for handling cross-origin requests

  Installation
Backend Setup

1️⃣ Clone the repository: 
git clone https://github.com/MurahJr/transaction_app.git
cd transaction-tracker/backend

2️⃣ Create a virtual environment:
python -m venv venv
source venv/bin/activate  # Mac/Linux
venv\Scripts\activate  # Windows

3️⃣ Install dependencies:
pip install -r requirements.txt

4️⃣ Run the Flask server:
python app.py

The backend should now be running at: http://127.0.0.1:5000/

Frontend Setup
1️⃣ Go to the frontend directory:
cd ../frontend

2️⃣ Ensure you have Flutter installed:
Check by running:
flutter --version

3️⃣ Install dependencies:
flutter pub get

4️⃣ Run the app on an emulator or connected device:
flutter run

Running the Application

    Backend: python app.py
    Frontend: flutter run

API Endpoints
Method	Endpoint	Description
GET	/transactions	Get all transactions
POST	/transactions	Add a new transaction
PUT	/transactions/<id>	Edit a transaction
DELETE	/transactions/<id>	Delete a transaction


Troubleshooting

💡 Port Conflicts?

    Change the backend port by editing app.py:

    app.run(debug=True, port=5001)

💡 Issues with Flutter dependencies?

    Run:

    flutter clean
    flutter pub get

💡 Backend not connecting to frontend?

    Ensure CORS is enabled in Flask:

from flask_cors import CORS
CORS(app)
