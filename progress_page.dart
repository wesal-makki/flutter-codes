import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProgressPage extends StatefulWidget {
  final int caseId;
  final String caseTitle;

  const ProgressPage({
    super.key,
    required this.caseId,
    required this.caseTitle,
  });

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  List<dynamic> updates = [];
  bool isLoading = true;

  Future<void> fetchProgress() async {
    final url = Uri.parse(
      "http://10.0.2.2/pwrs_backend/get_progress_updates.php?case_id=${widget.caseId}",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        updates = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load progress updates")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Progress - ${widget.caseTitle}"),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : updates.isEmpty
          ? const Center(child: Text("No progress updates yet"))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: updates.length,
                itemBuilder: (context, index) {
                  bool isLast = index == updates.length - 1;
                  final item = updates[index];

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: const BoxDecoration(
                              color: Colors.teal,
                              shape: BoxShape.circle,
                            ),
                          ),

                          if (!isLast)
                            Container(width: 3, height: 60, color: Colors.teal),
                        ],
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["date"] ?? "",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item["description"] ?? "",
                                style: const TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }
}
