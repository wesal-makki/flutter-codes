import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FeedbackPage extends StatefulWidget {
  final int userId;

  const FeedbackPage({super.key, required this.userId});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  TextEditingController commentController = TextEditingController();
  String joinAgain = "Yes";

  Future<void> submitFeedback() async {
    final url = Uri.parse("http://10.0.2.2/pwrs_backend/add_feedback.php");

    final response = await http.post(
      url,
      body: {
        "user_id": widget.userId.toString(),
        "comment": commentController.text,
        "join_again": joinAgain,
      },
    );

    print("RESPONSE: ${response.body}"); // Debug

    if (response.statusCode == 200) {
      final isSuccess = response.body.contains("success");

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(isSuccess ? "Success" : "Error"),
          content: Text(
            isSuccess
                ? "Thank you for your feedback!"
                : "Failed to submit feedback.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Feedback")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Write your feedback:"),

            TextField(
              controller: commentController,
              maxLines: 5,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),

            SizedBox(height: 20),

            Text("Would you join again?"),

            Row(
              children: [
                Radio(
                  value: "Yes",
                  groupValue: joinAgain,
                  onChanged: (value) {
                    setState(() => joinAgain = value!);
                  },
                ),
                Text("Yes"),

                Radio(
                  value: "No",
                  groupValue: joinAgain,
                  onChanged: (value) {
                    setState(() => joinAgain = value!);
                  },
                ),
                Text("No"),
              ],
            ),

            SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                onPressed: submitFeedback,
                child: Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
