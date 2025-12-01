import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class DonationPage extends StatefulWidget {
  final int userId;
  final int? caseId;
  final int? campId;

  const DonationPage({Key? key, required this.userId, this.caseId, this.campId})
    : super(key: key);

  @override
  _DonationPageState createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _transactionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  File? _receiptImage;

  Future<void> _pickReceipt() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _receiptImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitDonation() async {
    if (_formKey.currentState!.validate() && _receiptImage != null) {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.0.2.2/pwrs_backend/donation.php'),
      );
      request.fields['user_id'] = widget.userId.toString();
      request.fields['case_id'] = widget.caseId?.toString() ?? '';
      request.fields['camp_id'] = widget.campId?.toString() ?? '';
      request.fields['amount'] = _amountController.text;
      request.fields['transaction_id'] = _transactionController.text;
      request.fields['transfer_date'] = _dateController.text;

      request.files.add(
        await http.MultipartFile.fromPath('receipt', _receiptImage!.path),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Donation submitted successfully!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit donation')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all fields and upload receipt'),
        ),
      );
    }
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Donation',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Please make your transfer to the account below using Bankak. Upload your receipt after the transfer.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Account Number: 1768052',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Donation Amount'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter donation amount' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _transactionController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Transaction / Reference Number',
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Enter transaction ID' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Transfer Date',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickDate,
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Select transfer date' : null,
              ),
              const SizedBox(height: 12),
              const Text('Upload Receipt'),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickReceipt,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _receiptImage == null
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.upload_file,
                                size: 40,
                                color: Colors.grey,
                              ),
                              Text('Click here to upload receipt'),
                            ],
                          ),
                        )
                      : Image.file(_receiptImage!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitDonation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Submit Donation',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
