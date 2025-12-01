import 'package:flutter/material.dart';
import 'package:pwrs_app/feedback_page.dart';
import 'package:pwrs_app/my_cases.dart';
import 'package:pwrs_app/my_donations.dart';
import 'package:pwrs_app/login.dart';

class ProfilePage extends StatelessWidget {
  final String fullName;
  final int userId;

  const ProfilePage({required this.fullName, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Profile"), centerTitle: true),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.lightBlueAccent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Icon(Icons.person, size: 60, color: Colors.white),
                ),
                SizedBox(height: 10),
                Text(
                  fullName,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.favorite_border),
                  title: Text("My Donations"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyDonationsPage(userId: userId),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.folder_shared),
                  title: Text("My Cases"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyCasesPage(userId: userId),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.feedback),
                  title: Text("Send Feedback"),
                  trailing: Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FeedbackPage(userId: userId),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text("Logout", style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
