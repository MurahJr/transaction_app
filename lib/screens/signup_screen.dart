import 'package:flutter/material.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  void _signUp() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      Future.delayed(Duration(seconds: 2), () {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Account Created Successfully!"),
              backgroundColor: Colors.green),
        );
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen()));
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
            colors: [Colors.purple.shade900, Colors.purple.shade500],
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
                  Icon(Icons.person_add, size: 80, color: Colors.white),
                  SizedBox(height: 20),
                  Text("Create Account",
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  SizedBox(height: 30),
                  _buildTextField(_nameController, Icons.person, "Full Name"),
                  SizedBox(height: 15),
                  _buildTextField(_emailController, Icons.email, "Email"),
                  SizedBox(height: 15),
                  _buildTextField(_passwordController, Icons.lock, "Password",
                      obscureText: true),
                  SizedBox(height: 15),
                  _buildTextField(_confirmPasswordController, Icons.lock,
                      "Confirm Password",
                      obscureText: true),
                  SizedBox(height: 20),
                  _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : _animatedButton("Create Account", _signUp),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen())),
                    child: Text("Already have an account? Login",
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
        if (labelText == "Confirm Password" &&
            value != _passwordController.text) return "Passwords do not match";
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
        foregroundColor: Colors.purple.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
      ),
      onPressed: onPressed,
      child: Text(text, style: TextStyle(fontSize: 18)),
    );
  }
}
