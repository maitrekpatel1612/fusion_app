import 'package:flutter/material.dart';
import 'form_page1.dart'; // Ensure this file exists and is correctly imported
import '../../utils/sidebar.dart'; // Import the sidebar from your utils
import '../../utils/bottom_bar.dart'; // Import the bottom bar from your utils

class NewApplicationPage extends StatelessWidget {
  const NewApplicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(), // Sidebar added
      appBar: AppBar(
        title: const Text('New Application'),
        elevation: 0, // Removes default shadow to maintain cleaner look
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Arrow placed below Sidebar
              Padding(
                padding: const EdgeInsets.only(top: 16.0), // Padding for back arrow
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 24, // Reduced size of the arrow
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Go back to the previous screen
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "New Patent Application",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[50],
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Intellectual Property Filing Form",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Complete this form to initiate a new patent filing. Please ensure all necessary details are accurate before submission. This form will help streamline your application process and ensure compliance with institutional guidelines.",
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 12),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FormPage1()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text("Submit New Application"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomBar(), // Bottom bar added
    );
  }
}
