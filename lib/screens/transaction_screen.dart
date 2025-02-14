import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

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
  Future<void> addTransaction(
      String description, double amount, String date) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/transactions'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'amount': amount,
          'description': description,
          'date': date,
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

  // Show a dialog to enter a new transaction
  void _showAddTransactionDialog() {
    TextEditingController descriptionController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    TextEditingController dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Transaction"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: dateController,
                decoration:
                    const InputDecoration(labelText: "Date (YYYY-MM-DD)"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                String description = descriptionController.text;
                double amount = double.tryParse(amountController.text) ?? 0.0;
                String date = dateController.text;

                if (description.isNotEmpty && amount > 0 && date.isNotEmpty) {
                  addTransaction(description, amount, date);
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Transactions")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
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
        onPressed: _showAddTransactionDialog, // Open the Add Transaction Dialog
        child: const Icon(Icons.add),
      ),
    );
  }

  void _editTransaction(Transaction transaction) {
    // Open Edit Transaction screen with the selected transaction
    print('Editing: ${transaction.id}');
  }

  void _deleteTransaction(int transactionId) {
    // Handle delete logic
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

  const TransactionItem({
    super.key,
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
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.transaction.date),
            Text('\$${widget.transaction.amount.toStringAsFixed(2)}'),
          ],
        ),
        subtitle: Text(widget.transaction.description),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => widget.onEdit(widget.transaction),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
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
