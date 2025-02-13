import 'package:flutter/material.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  void _submitTransaction() {
    final description = _descriptionController.text;
    final amount = double.tryParse(_amountController.text);

    if (description.isEmpty || amount == null) return;

    Navigator.pop(context, {
      'description': description,
      'amount': amount,
      'date': DateTime.now().toString().substring(0, 10),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Transaction")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitTransaction,
              child: Text("Add Transaction"),
            ),
          ],
        ),
      ),
    );
  }
}
