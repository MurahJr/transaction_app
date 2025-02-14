from flask import Flask, request, jsonify
from datetime import datetime

app = Flask(__name__)

# In-memory storage for transactions
transactions = []

# Get all transactions
@app.route('/transactions', methods=['GET'])
def get_transactions():
    # You can dynamically add transactions to this list if needed
    return jsonify(transactions), 200

# Add a new transaction
@app.route('/transactions', methods=['POST'])
def add_transaction():
    data = request.get_json()

    new_transaction = {
        'amount': data['amount'],
        'description': data['description'],
        'date': data['date'],
    }
    
    transactions.append(new_transaction)
    return jsonify(new_transaction), 201

if __name__ == '__main__':
    app.run(debug=True)
