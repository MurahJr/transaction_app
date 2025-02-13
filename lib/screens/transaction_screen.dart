import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List<Transaction> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  // Fetch all transactions from Flask API
  Future<void> fetchTransactions() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:5000/transactions'));

      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        setState(() {
          transactions =
              data.map((item) => Transaction.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      print('Error fetching transactions: $e');
    }
  }

  // Add a new transaction to the Flask API
  Future<void> addTransaction(Transaction transaction) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/transactions'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'amount': transaction.amount,
          'description': transaction.description,
          'date': transaction.date,
        }),
      );

      if (response.statusCode == 201) {
        final newTransaction = Transaction.fromJson(json.decode(response.body));
        setState(() {
          transactions.add(newTransaction);
        });
      } else {
        throw Exception('Failed to add transaction');
      }
    } catch (e) {
      print('Error adding transaction: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transactions")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return TransactionItem(
                  transaction: transaction,
                  onEdit: _editTransaction,
                  onDelete: _deleteTransaction,
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTransaction = Transaction(
            id: transactions.length + 1, // Just for ID simulation
            date: '2025-02-13', // Static date for testing
            amount: 20.0,
            description: 'New Transaction',
          );
          await addTransaction(newTransaction); // Add transaction
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _editTransaction(Transaction transaction) {
    // Open Edit Transaction screen with the selected transaction
    // For now, this can just print out the transaction details
    print('Editing: ${transaction.id}');
  }

  void _deleteTransaction(int transactionId) {
    // Handle delete logic here
    // For now, just removing from the list
    setState(() {
      transactions.removeWhere((t) => t.id == transactionId);
    });
  }
}

class Transaction {
  final int id;
  final String date;
  final double amount;
  final String description;

  Transaction({
    required this.id,
    required this.date,
    required this.amount,
    required this.description,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? 0, // Optional fallback for transaction ID
      date: json['date'],
      amount: json['amount'].toDouble(),
      description: json['description'],
    );
  }
}

class TransactionItem extends StatefulWidget {
  final Transaction transaction;
  final Function(Transaction) onEdit;
  final Function(int) onDelete;

  TransactionItem({
    required this.transaction,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.transaction.date),
            Text('\$${widget.transaction.amount.toStringAsFixed(2)}'),
          ],
        ),
        subtitle: isExpanded ? Text(widget.transaction.description) : null,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => widget.onEdit(widget.transaction),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => widget.onDelete(widget.transaction.id),
              ),
            ],
          ),
        ],
        onExpansionChanged: (bool expanded) {
          setState(() {
            isExpanded = expanded;
          });
        },
      ),
    );
  }
}
