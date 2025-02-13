import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransactionScreen extends StatefulWidget {
  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List<Map<String, dynamic>> transactions = [];

  void addTransaction(Map<String, dynamic> newTransaction) {
    setState(() {
      transactions.insert(0, newTransaction);
    });
  }

  void editTransaction(int index, Map<String, dynamic> updatedTransaction) {
    setState(() {
      transactions[index] = updatedTransaction;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transactions")),
      body: transactions.isEmpty
          ? Center(child: Text("No transactions available."))
          : ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                var transaction = transactions[index];
                bool isExpense = transaction['amount'] < 0;

                return Dismissible(
                  key: Key(transaction['description']),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      transactions.removeAt(index);
                    });
                  },
                  child: Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Icon(
                        isExpense ? Icons.arrow_downward : Icons.arrow_upward,
                        color: isExpense ? Colors.red : Colors.green,
                      ),
                      title: Text(
                        transaction['description'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(transaction['date']),
                      trailing: Text(
                        "\$${transaction['amount'].toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isExpense ? Colors.red : Colors.green,
                        ),
                      ),
                      onTap: () async {
                        Map<String, dynamic>? updatedTransaction =
                            await Navigator.pushNamed(
                                context, '/editTransaction', arguments: {
                          'transaction': transaction,
                          'index': index
                        }) as Map<String, dynamic>?;
                        if (updatedTransaction != null) {
                          editTransaction(index, updatedTransaction);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Map<String, dynamic>? newTransaction =
              await Navigator.pushNamed(context, '/addTransaction')
                  as Map<String, dynamic>?;
          if (newTransaction != null) {
            addTransaction(newTransaction);
          }
        },
      ),
    );
  }
}
