import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  String? gender;
  DateTime? birthdate;

  bool loading = false;

  String apiUrl = "http://10.0.2.2/pwrs_backend/signup.php";

  String? nameError;
  String? emailError;
  String? passError;
  String? dateError;
  String? genderError;

  Future<void> pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        birthdate = date;
        dateError = null;
      });
    }
  }

  bool validate() {
    setState(() {
      nameError = null;
      emailError = null;
      passError = null;
      genderError = null;
      dateError = null;
    });

    bool ok = true;

    if (name.text.trim().isEmpty) {
      nameError = "Please enter your full name";
      ok = false;
    } else if (!name.text.contains(" ")) {
      nameError = "Enter at least two names";
      ok = false;
    }

    if (email.text.trim().isEmpty) {
      emailError = "Please enter your email";
      ok = false;
    } else if (!email.text.contains("@") || !email.text.contains(".")) {
      emailError = "Enter a valid email";
      ok = false;
    }

    if (password.text.isEmpty) {
      passError = "Please enter your password";
      ok = false;
    } else if (password.text.length < 8) {
      passError = "Password must be at least 8 characters";
      ok = false;
    }

    if (gender == null) {
      genderError = "Please select gender";
      ok = false;
    }

    if (birthdate == null) {
      dateError = "Please select birthdate";
      ok = false;
    }

    setState(() {});
    return ok;
  }

  Future<void> signup() async {
    if (loading) return;
    if (!validate()) return;

    setState(() {
      loading = true;
    });

    try {
      var res = await http.post(
        Uri.parse(apiUrl),
        body: {
          "full_name": name.text.trim(),
          "user_email": email.text.trim(),
          "password": password.text,
          "gender": gender!,
          "birthdate": DateFormat('yyyy-MM-dd').format(birthdate!),
        },
      );

      var data = jsonDecode(res.body);

      if (!mounted) return;

      if (res.statusCode == 200 && data["success"] == true) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("${data['message']}")));
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
                    "Create your account",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 30),

                TextField(
                  controller: name,
                  decoration: field("Full Name", "Enter your full name"),
                ),
                if (nameError != null)
                  Text(
                    nameError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                const SizedBox(height: 20),

                TextField(
                  controller: email,
                  decoration: field("Email", "Enter your email"),
                  keyboardType: TextInputType.emailAddress,
                ),
                if (emailError != null)
                  Text(
                    emailError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                const SizedBox(height: 20),

                TextField(
                  controller: password,
                  obscureText: true,
                  decoration: field("Password", "Enter your password"),
                ),
                if (passError != null)
                  Text(
                    passError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                const SizedBox(height: 20),

                const Text(
                  "Gender",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        title: const Text("Male"),
                        value: "Male",
                        groupValue: gender,
                        onChanged: (val) {
                          setState(() {
                            gender = val;
                            genderError = null;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        title: const Text("Female"),
                        value: "Female",
                        groupValue: gender,
                        onChanged: (val) {
                          setState(() {
                            gender = val;
                            genderError = null;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                if (genderError != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      genderError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 15),

                GestureDetector(
                  onTap: pickDate,
                  child: AbsorbPointer(
                    child: TextField(
                      controller: TextEditingController(
                        text: birthdate == null
                            ? ""
                            : DateFormat('yyyy-MM-dd').format(birthdate!),
                      ),
                      decoration: field("Birthdate", "Select your birthdate"),
                    ),
                  ),
                ),
                if (dateError != null)
                  Text(
                    dateError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: signup,
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
                            "SIGN UP",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "LOGIN",
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
