import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:fusion/screens/Complaint%20Management/complaint_dashboard.dart';
// import 'complaint_management_dashboard.dart';
import '../../utils/gesture_sidebar.dart';
import '../../utils/bottom_bar.dart'; // Bottom bar import
import '../../utils/sidebar.dart' as sidebar;

class AddComplaintPage extends StatefulWidget {
  const AddComplaintPage({Key? key}) : super(key: key);

  @override
  State<AddComplaintPage> createState() => _AddComplaintPageState();
}

class _AddComplaintPageState extends State<AddComplaintPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? complaintType;
  String? location;
  String? specificLocation;
  String? complaintDetails;
  String? fileName;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpeg', 'jpg', 'png'],
    );

    if (result != null) {
      setState(() {
        fileName = result.files.single.name;
      });
    }
  }

  void submitComplaint() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complaint Submitted')),
      );
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _getScreenName(int index) {
    switch (index) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Lodge a Complaint';
      case 2:
        return 'View Feedback';
      case 3:
        return 'Complaint History';
      case 4:
        return 'Resolved Complaints';
      case 5:
        return 'Unresolved Complaints';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureSidebar(
        scaffoldKey: _scaffoldKey,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: const Text(
              'Lodge a Complaint',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.blue),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ComplaintDashboard(),
                  ),
                );
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.blue),
                onPressed: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
              ),
            ],
          ),
          drawer: sidebar.Sidebar(
            onItemSelected: (index) {
              Navigator.pop(context);
              if (index == 1) {
                // Already on Submit Grades screen
              } else if (index == 0) {
                Navigator.pop(context);
              } else {
                _showSnackBar('Navigating to ${_getScreenName(index)}');
              }
            },
          ),
          bottomNavigationBar: const BottomBar(),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Complaint Type'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: complaintType,
                    items: ['Water Issue', 'Electricity Issue', 'Garbage Issue', 'Other']
                        .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                        .toList(),
                    onChanged: (value) => setState(() => complaintType = value),
                    validator: (value) => value == null ? 'Please select a complaint type' : null,
                  ),
                  const SizedBox(height: 16),

                  const Text('Location'),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter location',
                    ),
                    onSaved: (value) => location = value,
                    validator: (value) => value == null || value.isEmpty ? 'Please enter location' : null,
                  ),
                  const SizedBox(height: 16),

                  const Text('Specific Location'),
                  const SizedBox(height: 8),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter specific location',
                    ),
                    onSaved: (value) => specificLocation = value,
                  ),
                  const SizedBox(height: 16),

                  const Text('Complaint Details'),
                  const SizedBox(height: 8),
                  TextFormField(
                    maxLines: 4,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter complaint details',
                    ),
                    onSaved: (value) => complaintDetails = value,
                    validator: (value) => value == null || value.isEmpty ? 'Please enter complaint details' : null,
                  ),
                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: pickFile,
                    child: const Text('Upload File'),
                  ),
                  if (fileName != null) ...[
                    const SizedBox(height: 8),
                    Text('Selected File: $fileName'),
                  ],
                  const SizedBox(height: 24),

                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Submit button color blue
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      onPressed: submitComplaint,
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
