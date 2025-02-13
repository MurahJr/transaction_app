import 'package:flutter/material.dart';
import 'transaction_screen.dart'; // Import transaction screen
import 'signup_screen.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Import the animation package

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false; // Loading indicator

  void _login() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulate a login delay (Replace this with real authentication)
      Future.delayed(Duration(seconds: 2), () {
        setState(() => _isLoading = false);

        if (_emailController.text == "test@email.com" &&
            _passwordController.text == "password123") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TransactionScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Invalid email or password"),
                backgroundColor: Colors.red),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.blue.shade500],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_balance_wallet_rounded,
                      size: 80, color: Colors.white),
                  SizedBox(height: 20),
                  Text("Welcome Back!",
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  SizedBox(height: 30),
                  _buildTextField(_emailController, Icons.email, "Email"),
                  SizedBox(height: 15),
                  _buildTextField(_passwordController, Icons.lock, "Password",
                      obscureText: true),
                  SizedBox(height: 20),
                  _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : _animatedButton("Login", _login),
                  SizedBox(height: 10),
                  TextButton(
                      onPressed: () {},
                      child: Text("Forgot Password?",
                          style: TextStyle(color: Colors.white, fontSize: 16))),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                    },
                    child: Text("Create New Account",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, IconData icon, String labelText,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.white),
      validator: (value) {
        if (value == null || value.isEmpty) return "Please enter $labelText";
        if (labelText == "Email" && !value.contains("@"))
          return "Enter a valid email";
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        prefixIcon: Icon(icon, color: Colors.white),
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none),
      ),
    );
  }

  Widget _animatedButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
      ),
      onPressed: onPressed,
      child: Text(text, style: TextStyle(fontSize: 18)),
    );
  }
}
