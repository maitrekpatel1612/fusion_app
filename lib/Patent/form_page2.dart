import 'package:flutter/material.dart';
import 'form_page1.dart';
import 'form_page3.dart';
import '../../utils/sidebar.dart'; // Import your sidebar from utils
import '../../utils/bottom_bar.dart'; // Import your bottom bar from utils

class FormPage2 extends StatefulWidget {
  const FormPage2({super.key});

  @override
  _FormPage2State createState() => _FormPage2State();
}

class _FormPage2State extends State<FormPage2> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(), // Sidebar added
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer when the menu icon is tapped
              },
            );
          },
        ),
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Centered Title Section
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Intellectual Property Filing Form",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Section - I : (Administrative and Technical Details)",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),

                // Left-aligned content
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildQuestionField("2. What is the area of the invention? *",
                          "Enter the area of invention"),
                      buildQuestionField("3. What is the problem in the area? *",
                          "Enter the problem in the area"),
                      buildQuestionField(
                          "4. What is the objective of your invention? *",
                          "Enter the objective of the invention"),
                      buildQuestionField("5. What is the Novelty? *",
                          "Enter the novelty of the invention"),
                      buildQuestionField(
                        "6. What is the utility (advantages) of the present invention over comparable inventors available in literature including patents? *",
                        "Describe the advantages over comparable inventors",
                      ),
                      buildQuestionField(
                          "7. Has the invention been tested experimentally? *",
                          "Proof-of-concept/Prototype details"),

                      SizedBox(height: 8),
                      Text(
                        "If yes, please upload the details of the proof-of-concept/Prototype *",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () {
                          // Implement file upload functionality
                        },
                        child: Text("Upload Here"),
                      ),
                      SizedBox(height: 15),

                      buildQuestionField(
                          "8. Can you think of applications of your invention? *",
                          "List down applications of your invention"),
                      SizedBox(height: 25),

                      // Navigation Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 45),
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FormPage1()),
                                );
                              },
                              child: Text("Previous"),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 45),
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FormPage3()),
                                );
                              },
                              child: Text("Next"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomBar(), // Bottom bar added here as well
    );
  }

  Widget buildQuestionField(String question, String hintText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 4),
          TextFormField(
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey.shade400),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
