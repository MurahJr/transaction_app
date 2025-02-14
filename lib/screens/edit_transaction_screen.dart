import 'package:flutter/material.dart';

class EditTransactionScreen extends StatefulWidget {
  const EditTransactionScreen({super.key});

  @override
  _EditTransactionScreenState createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  late int index;
  late Map<String, dynamic> transaction;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    transaction = args['transaction'];
    index = args['index'];

    _descriptionController.text = transaction['description'];
    _amountController.text = transaction['amount'].toString();
  }

  void _updateTransaction() {
    final updatedDescription = _descriptionController.text;
    final updatedAmount = double.tryParse(_amountController.text);

    if (updatedDescription.isEmpty || updatedAmount == null) return;

    Navigator.pop(context, {
      'description': updatedDescription,
      'amount': updatedAmount,
      'date': transaction['date'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Transaction")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateTransaction,
              child: const Text("Update Transaction"),
            ),
          ],
        ),
      ),
    );
  }
}
