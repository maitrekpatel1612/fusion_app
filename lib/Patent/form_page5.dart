import 'package:flutter/material.dart';
import 'form_page4.dart';
import 'saved_drafts.dart';
import '../../utils/sidebar.dart'; // Import your sidebar
import '../../utils/bottom_bar.dart'; // Import your bottom bar

class FormPage5 extends StatefulWidget {
  const FormPage5({super.key});

  @override
  _FormPage5State createState() => _FormPage5State();
}

class _FormPage5State extends State<FormPage5> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, String>> companies = [
    {'name': '', 'person': '', 'contact': ''},
  ];

  void addCompany() {
    setState(() {
      companies.add({'name': '', 'person': '', 'contact': ''});
    });
  }

  void removeCompany(int index) {
    setState(() {
      companies.removeAt(index);
    });
  }

  bool isEmbryonic = false;
  bool isPartiallyDeveloped = false;
  bool isOffTheShelf = false;

  void navigateToSavedDrafts() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SavedDraftsPage()),
    );
  }

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
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      SizedBox(height: 20),
                      Text(
                        "Section - III : (Commercialization)",
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
                Text(
                  "1. Who are the Target companies, both in India or abroad?",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  "* Please give a specific list of companies and contact details of the concerned person who can be contacted for initiating Technology Licensing.",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: companies.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Name of the Company",
                            hintText: "Company Name",
                          ),
                          onChanged: (value) {
                            companies[index]['name'] = value;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Name of Concerned Person",
                            hintText: "Concerned Person",
                          ),
                          onChanged: (value) {
                            companies[index]['person'] = value;
                          },
                        ),
                        SizedBox(height: 10),
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Contact Number",
                            hintText: "Contact Number",
                          ),
                          keyboardType: TextInputType.phone,
                          onChanged: (value) {
                            companies[index]['contact'] = value;
                          },
                        ),
                        SizedBox(height: 10),
                        if (companies.length > 1)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton(
                              onPressed: () => removeCompany(index),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: Text("Remove"),
                            ),
                          ),
                        SizedBox(height: 10),
                      ],
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: addCompany,
                  child: Text("Add more Companies"),
                ),
                SizedBox(height: 20),
                Text(
                  "2. Development stage:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  "* In your opinion, which of the three best describes the current stage of development of the invention as it relates to its marketability:",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                CheckboxListTile(
                  title: Text("Embryonic (needs substantial work to bring to market)"),
                  value: isEmbryonic,
                  onChanged: (value) {
                    setState(() {
                      isEmbryonic = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text("Partially developed (could be brought to market with significant investment)"),
                  value: isPartiallyDeveloped,
                  onChanged: (value) {
                    setState(() {
                      isPartiallyDeveloped = value!;
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text("Off-the-shelf (could be brought to market with nominal investment)"),
                  value: isOffTheShelf,
                  onChanged: (value) {
                    setState(() {
                      isOffTheShelf = value!;
                    });
                  },
                ),
                SizedBox(height: 20),
                Text(
                  "Download the following form, duly fill and sign it, and upload it afterward.",
                  style: TextStyle(fontSize: 14),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle form download
                  },
                  child: Text("Download Form-III"),
                ),
                SizedBox(height: 10),
                Text(
                  "Please upload duly filled and signed Form-III",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Handle file upload
                  },
                  child: Text("Upload Here"),
                ),
                SizedBox(height: 20),
                Text(
                  "Undertaking: Intellectual Property is filing on the behalf of the Institute.",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const FormPage4()),
                        );
                      },
                      child: Text("Previous"),
                    ),
                    ElevatedButton(
                      onPressed: navigateToSavedDrafts,
                      child: Text("Save as Draft"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Handle form submission
                        }
                      },
                      child: Text("Submit"),
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
}
