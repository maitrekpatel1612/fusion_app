import 'package:flutter/material.dart';
import 'shared_data.dart';
import '../../utils/sidebar.dart'; // Import your sidebar
import '../../utils/bottom_bar.dart'; // Import your bottom bar

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NewAttorneyFormPage(),
    );
  }
}

class NewAttorneyFormPage extends StatefulWidget {
  @override
  _NewAttorneyFormPageState createState() => _NewAttorneyFormPageState();
}

class _NewAttorneyFormPageState extends State<NewAttorneyFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lawFirmController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController specializationController =
      TextEditingController();
  final TextEditingController feeController = TextEditingController();
  final TextEditingController applicationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(), // Sidebar added
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("New Attorney Form", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open the drawer when the menu icon is tapped
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile and Menu Button
              

              SizedBox(height: 16),

              // Title
              Center(
                child: Text(
                  'New Attorney Form',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
              ),

              SizedBox(height: 16),

              // Form Card
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildInputField("Attorney Name", nameController,
                          icon: Icons.person),
                      buildInputField("Law Firm", lawFirmController,
                          icon: Icons.business),
                      buildInputField("Email", emailController,
                          isEmail: true, icon: Icons.email),
                      buildInputField("Phone Number", phoneController,
                          isPhone: true, icon: Icons.phone),
                      buildInputField(
                          "Specialization", specializationController,
                          icon: Icons.text_fields),
                      buildInputField("Attorney Fee", feeController,
                          isNumeric: true, icon: Icons.attach_money),
                      buildInputField(
                          "Assign to Application", applicationController,
                          icon: Icons.assignment),

                      SizedBox(height: 16),

                      // Submit Button
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Create a new attorney entry
                              final newAttorney = {
                                'id': DateTime.now().millisecondsSinceEpoch.toString(), // unique id
                                'name': nameController.text,
                                'law_firm': lawFirmController.text,
                                'email': emailController.text,
                                'phone': phoneController.text,
                                'specialization': specializationController.text,
                                'fee': feeController.text,
                                'application': applicationController.text,
                                'selected': false, // for removeatt.dart
                              };

                              Navigator.pop(context, {
                                'name': nameController.text,
                              });

                              setState(() {}); // Add this line to refresh the UI of manageatt.dart
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Text("Submit",
                              style: TextStyle(color: Colors.white)),
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

  Widget buildInputField(String label, TextEditingController controller,
      {bool isNumeric = false,
      bool isEmail = false,
      bool isPhone = false,
      IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) Icon(icon, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 4),
          TextFormField(
            controller: controller,
            keyboardType: isNumeric
                ? TextInputType.number
                : isEmail
                    ? TextInputType.emailAddress
                    : isPhone
                        ? TextInputType.phone
                        : TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade300,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter $label";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}