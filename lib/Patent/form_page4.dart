import 'package:flutter/material.dart';
import 'form_page3.dart';
import 'form_page5.dart';
import '../../utils/sidebar.dart'; // Import your sidebar
import '../../utils/bottom_bar.dart'; // Import your bottom bar

class FormPage4 extends StatefulWidget {
  const FormPage4({super.key});

  @override
  _FormPage4State createState() => _FormPage4State();
}

class _FormPage4State extends State<FormPage4> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, String?>> inventors = [
    {'name': null, 'percentage': null}
  ];

  void addInventor() {
    setState(() {
      inventors.add({'name': null, 'percentage': null});
    });
  }

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
                      SizedBox(height: 10),
                      Text(
                        "(Please use this form for all types of IP, including Patents, Copyright, Designs, Marks, and even Know-how)",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Add Inventors Section
                Column(
                  children: [
                    ...inventors.map((inventor) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildInventorField("Inventor's Name", inventor['name'], (value) {
                            setState(() {
                              inventor['name'] = value;
                            });
                          }),
                          buildInventorField("Inventor's Contribution %", inventor['percentage'], (value) {
                            setState(() {
                              inventor['percentage'] = value;
                            });
                          }),
                          SizedBox(height: 20),
                        ],
                      );
                    }).toList(),
                    ElevatedButton(
                      onPressed: addInventor,
                      child: Text("Add Inventor"),
                    ),
                    SizedBox(height: 20),
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
                                    builder: (context) => FormPage3()),
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
                                    builder: (context) => FormPage5()),
                              );
                            },
                            child: Text("Next"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomBar(), // Bottom bar added
    );
  }

  Widget buildInventorField(String label, String? value, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          TextFormField(
            initialValue: value,
            decoration: InputDecoration(
              hintText: "Enter $label",
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
