import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerUser() async {

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    try {
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Optional: update display name
      await userCredential.user!
          .updateDisplayName(nameController.text.trim());

      // Success → Go to HomeScreen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
      );

    } on FirebaseAuthException catch (e) {
      String message = "Registration Failed";

      if (e.code == 'email-already-in-use') {
        message = "Email already in use";
      } else if (e.code == 'weak-password') {
        message = "Password should be at least 6 characters";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(title: const Text("Register")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(Icons.person_add, size: 90, color: Colors.green),
              const SizedBox(height: 20),

              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: registerUser,
                  child: const Text("Register",
                      style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
