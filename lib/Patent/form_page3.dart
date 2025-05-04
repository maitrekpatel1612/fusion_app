import 'package:flutter/material.dart';
import 'form_page2.dart';
import 'form_page4.dart';
import '../../utils/sidebar.dart'; // Import Sidebar
import '../../utils/bottom_bar.dart'; // Import BottomBar

class FormPage3 extends StatefulWidget {
  const FormPage3({super.key});

  @override
  _FormPage3State createState() => _FormPage3State();
}

class _FormPage3State extends State<FormPage3> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(), // Sidebar added
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open the drawer when the menu icon is tapped
            },
          ),
        ),
        title: Text(
          "",
          style: TextStyle(color: Colors.blue, fontSize: 24),
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
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Section - II : (IPR Ownership)",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),

                // Left-aligned content
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildQuestionField(
                        "1. Was the intellectual property created with the significant use of funds or facilities of IIITDM Jabalpur?",
                        "Describe the significant use of your invention",
                        true,
                      ),
                      buildQuestionField(
                        "2. Please describe the source of funding for the invention.",
                        "Enter the funding source",
                        true,
                      ),
                      Text(
                        "If yes, Name of the funding agency and copy of agreement, letter of intent, must be uploaded here.",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text("Upload Here"),
                      ),
                      SizedBox(height: 20),
                      buildQuestionField(
                        "3. Have you presented/published in any Journal/conference if yes, please give details?",
                        "Enter Presentation Details",
                        true,
                      ),
                      buildQuestionField(
                        "4. Was the intellectual property created in the course of or pursuant to a sponsored or a consultancy research agreement with IIITDM Jabalpur?",
                        "Enter MOU details",
                        true,
                      ),
                      Text(
                        "If yes, please upload a copy of MOU with concerned project.",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text("Upload Here"),
                      ),
                      SizedBox(height: 20),
                      buildQuestionField(
                        "5. Was the intellectual property created as a part of academic research leading towards a degree or otherwise?",
                        "Describe academic research involvement",
                        true,
                      ),
                      SizedBox(height: 30),

                      // Navigation Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                minimumSize: Size(double.infinity, 45),
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FormPage2()),
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
                                      builder: (context) => FormPage4()),
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

  Widget buildQuestionField(String question, String hintText, bool isRequired) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: question,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              children: isRequired
                  ? [
                      TextSpan(
                        text: " *",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    ]
                  : [],
            ),
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
            validator: isRequired
                ? (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
