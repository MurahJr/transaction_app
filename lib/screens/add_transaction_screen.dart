import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddTransactionScreen extends StatefulWidget {
  final Function onTransactionAdded;

  const AddTransactionScreen({super.key, required this.onTransactionAdded});

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = pickedDate.toIso8601String().split('T')[0];
      });
    }
  }

  Future<void> _addTransaction() async {
    if (_descriptionController.text.isEmpty ||
        _amountController.text.isEmpty ||
        _dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    double? amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid amount")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    bool success = await ApiService.addTransaction(
      _descriptionController.text,
      amount,
      _dateController.text,
    );

    if (success) {
      widget.onTransactionAdded();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to add transaction")),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Transaction"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: "Description"),
          ),
          TextField(
            controller: _amountController,
            decoration: const InputDecoration(labelText: "Amount"),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _dateController,
            decoration: const InputDecoration(labelText: "Date"),
            readOnly: true,
            onTap: () => _selectDate(context),
          ),
          const SizedBox(height: 10),
          _isLoading
              ? const CircularProgressIndicator()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text("Cancel"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _addTransaction,
                      child: const Text("Add"),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

class ApiService {
  static const String baseUrl = "https://your-api-url.com";

  static Future<bool> addTransaction(
      String description, double amount, String date) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/transactions"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "description": description,
          "amount": amount,
          "date": date,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      print("API Error: $e");
      return false;
    }
  }
}
