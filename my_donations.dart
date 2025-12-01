import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'progress_page.dart';

class MyDonationsPage extends StatefulWidget {
  final int userId;

  const MyDonationsPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<MyDonationsPage> createState() => _MyDonationsPageState();
}

class _MyDonationsPageState extends State<MyDonationsPage> {
  List<dynamic> donations = [];
  bool isLoading = true;

  Future<void> fetchDonations() async {
    final response = await http.get(
      Uri.parse(
        "http://10.0.2.2/pwrs_backend/get_my_donations.php?user_id=${widget.userId}",
      ),
    );

    if (response.statusCode == 200) {
      setState(() {
        donations = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to load donations")));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDonations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Donations",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : donations.isEmpty
          ? const Center(child: Text("No approved donations yet"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: donations.length,
              itemBuilder: (context, index) {
                final d = donations[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          d['case_title'] ?? "Case",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text("Amount: ${d['amount']} SDG"),
                        Text("Date: ${d['transfer_date']}"),
                        Text("Transaction: ${d['transaction_id']}"),
                        Text("Status: ${d['status']}"),
                        const SizedBox(height: 10),
                        if (d['status'] == "Approved")
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProgressPage(
                                      caseId: int.parse(d['case_id']),
                                      caseTitle: d['case_title'] ?? "",
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                              ),
                              child: const Text("View Progress"),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
