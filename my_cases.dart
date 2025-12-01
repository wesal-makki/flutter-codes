import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyCasesPage extends StatefulWidget {
  final int userId;

  const MyCasesPage({required this.userId});

  @override
  _MyCasesPageState createState() => _MyCasesPageState();
}

class _MyCasesPageState extends State<MyCasesPage> {
  List cases = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchCases();
  }

  fetchCases() async {
    var url = Uri.parse("http://10.0.2.2/pwrs_backend/get_my_cases.php");

    var response = await http.post(
      url,
      body: {"user_id": widget.userId.toString()},
    );

    cases = jsonDecode(response.body);

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Cases")),

      body: loading
          ? Center(child: CircularProgressIndicator())
          // ⛔ إذا ما عنده ولا حالة
          : cases.isEmpty
          ? Center(
              child: Text(
                "You have no submitted cases yet.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: cases.length,
              itemBuilder: (context, index) {
                var c = cases[index];

                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(c["title"]),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Status: ${c["status"]}"),

                        // ✔️ عرض سبب الرفض إذا كانت الحالة Rejected
                        if (c["status"] == "Rejected" &&
                            c["reject_reason"] != null &&
                            c["reject_reason"].toString().trim().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              "Reason: ${c["reject_reason"]}",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
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
