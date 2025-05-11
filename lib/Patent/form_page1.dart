import 'package:flutter/material.dart';
import 'form_page2.dart';
import '../../utils/sidebar.dart'; // Import your sidebar from utils
import '../../utils/bottom_bar.dart'; // Import your bottom bar from utils

class FormPage1 extends StatefulWidget {
  const FormPage1({super.key});

  @override
  _FormPage1State createState() => _FormPage1State();
}

class _FormPage1State extends State<FormPage1> {
  List<Widget> inventors = [];

  void addInventor() {
    setState(() {
      inventors.add(buildInventorField(inventors.length + 1));
    });
  }

  void removeInventor() {
    if (inventors.isNotEmpty) {
      setState(() {
        inventors.removeLast();
      });
    }
  }

  Widget buildInventorField(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Inventor-$index Name *", style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(decoration: InputDecoration(hintText: "Name of Inventor")),
        SizedBox(height: 10),
        Text("Email *", style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(decoration: InputDecoration(hintText: "Email ID of the inventor")),
        SizedBox(height: 10),
        Text("Contact Address *", style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(decoration: InputDecoration(hintText: "Address")),
        SizedBox(height: 10),
        Text("Mobile Number *", style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(decoration: InputDecoration(hintText: "Mobile number")),
        SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(), // Sidebar added
      appBar: AppBar(
        title: Text("Intellectual Property Filing Form", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue, // Top bar color
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      "Intellectual Property Filing Form",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "(Please use this form for all types of IP, including Patents, Copyright, Designs, Marks, and even Know-how)",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Section - I : (Administrative and Technical Details)",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    SizedBox(height: 20),
                    Text("Title of the Application *", style: TextStyle(fontWeight: FontWeight.bold)),
                    TextField(decoration: InputDecoration(hintText: "Enter the title of Application")),
                    SizedBox(height: 20),
                    Text(". Please list inventor(s) who have contributed in the main inventive step of the invention. (Inventor is a person who has actually participated in the inventive step, in case a person has worked under instructions, then he/she is not an inventor for the purpose of patent.)"),
                    SizedBox(height: 10),
                    Text("Note: Students should provide their permanent (personal) Email-ID", style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    buildInventorField(1),
                    ...inventors,
                    Row(
                      children: [
                        ElevatedButton(onPressed: removeInventor, child: Text("Remove")),
                        SizedBox(width: 10),
                        ElevatedButton(onPressed: addInventor, child: Text("Add Inventor")),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FormPage2()),
                        );
                      },
                      child: Text("Next"),
                    ),
                  ],
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
