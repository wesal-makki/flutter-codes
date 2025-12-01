import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddVolunteerPage extends StatefulWidget {
  final int eventId;
  const AddVolunteerPage({super.key, required this.eventId});

  @override
  State<AddVolunteerPage> createState() => _AddVolunteerPageState();
}

class _AddVolunteerPageState extends State<AddVolunteerPage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  String? gender;
  String? area;
  String? volunteeredBefore;
  final genders = ["Male", "Female"];
  final areas = ["Khartoum", "Bahri", "Omdurman"];
  final volunteeredOptions = ["Yes", "No"];
  bool isSubmitting = false;

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isSubmitting = true);

    final url = Uri.parse(
      "http://10.0.2.2/pwrs_backend/admin_dashboard/complete_volunteer_registration.php",
    );
    final response = await http.post(
      url,
      body: {
        "event_id": widget.eventId.toString(),
        "full_name": nameController.text,
        "phone": phoneController.text,
        "email": emailController.text,
        "gender": gender!,
        "area": area!,
        "volunteered_before": volunteeredBefore!,
      },
    );

    if (!mounted) return;

    setState(() => isSubmitting = false);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['message']),
          backgroundColor: data['status'] == "success"
              ? Colors.blue
              : const Color.fromARGB(255, 71, 70, 69),
        ),
      );
      if (data['status'] == "success") {
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Server error")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Volunteer Form"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Enter your name" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Enter phone number" : null,
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Enter email" : null,
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField(
                value: gender,
                items: genders
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (v) => setState(() => gender = v),
                decoration: const InputDecoration(
                  labelText: "Gender",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null ? "Select gender" : null,
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField(
                value: area,
                items: areas
                    .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                    .toList(),
                onChanged: (v) => setState(() => area = v),
                decoration: const InputDecoration(
                  labelText: "Area",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null ? "Select area" : null,
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField(
                value: volunteeredBefore,
                items: volunteeredOptions
                    .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                    .toList(),
                onChanged: (v) => setState(() => volunteeredBefore = v),
                decoration: const InputDecoration(
                  labelText: "Have you volunteered before?",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null ? "Select Yes or No" : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : submitForm,
                  child: isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Submit"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
