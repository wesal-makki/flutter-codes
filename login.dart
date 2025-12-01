import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'signup.dart';
import 'main_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool loading = false;
  String apiUrl = "http://10.0.2.2/pwrs_backend/login.php";
  String? emailError;
  String? passError;

  bool validate() {
    setState(() {
      emailError = null;
      passError = null;
    });

    bool ok = true;
    if (email.text.trim().isEmpty) {
      emailError = "Please enter your email";
      ok = false;
    }
    if (password.text.isEmpty) {
      passError = "Please enter your password";
      ok = false;
    }
    setState(() {});
    return ok;
  }

  Future<void> login() async {
    if (loading) return;
    if (!validate()) return;

    setState(() {
      loading = true;
    });

    try {
      var res = await http.post(
        Uri.parse(apiUrl),
        body: {"user_email": email.text.trim(), "password": password.text},
      );

      var data = jsonDecode(res.body);

      if (!mounted) return;

      if (res.statusCode == 200 && data["success"] == true) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("${data['message']}")));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(
              userId: int.parse(data['user_id'].toString()),
              fullName: data['full_name'],
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("${data['message']}")));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  InputDecoration field(String label, String hint) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFFF7F7F7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF00B050)),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Log in to your account",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: email,
                  decoration: field("Email", "Enter your email"),
                  keyboardType: TextInputType.emailAddress,
                ),
                if (emailError != null)
                  Text(emailError!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 25),
                TextField(
                  controller: password,
                  obscureText: true,
                  decoration: field("Password", "Enter your password"),
                ),
                if (passError != null)
                  Text(passError!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 35),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00B050),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: loading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          )
                        : const Text(
                            "LOG IN",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don’t have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "SIGN UP",
                        style: TextStyle(
                          color: Color(0xFF00B050),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
