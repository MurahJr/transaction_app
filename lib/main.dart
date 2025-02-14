import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/transaction_screen.dart';
import 'screens/add_transaction_screen.dart';
import 'screens/edit_transaction_screen.dart';

void main() {
  runApp(const TransactionTrackerApp());
}

class TransactionTrackerApp extends StatelessWidget {
  const TransactionTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Transaction Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(), // Start with login first
    );
  }
}
