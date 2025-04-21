import "package:flutter/material.dart";
import "package:fusion/utils/gesture_sidebar.dart";
import "package:fusion/utils/sidebar.dart" as sidebar;

import "../../utils/bottom_bar.dart";
import "complaint_dashboard.dart";

class ViewDetails extends StatefulWidget {
  const ViewDetails({Key? key}) : super(key: key);

  @override
  State<ViewDetails> createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
              'Complaint History',
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
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.lightBlue[50],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 12),
                  const Text("Complaint ID : DIO2345",
                      style: TextStyle(fontWeight: FontWeight.bold)
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLabel("Register Date", "19 FEB 2025"),
                      _buildLabel("Finished Date", "12 MAR 2025"),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLabel("Location", "PANINI HOSTEL"),
                      _buildLabel("Specific Location", "ROOM 133"),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text("Complaint Details : ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                ],
              ),
            ),
          ),
          bottomNavigationBar: const BottomBar(),
        )
    );
  }

  Widget _buildLabel(String title, String value) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: RichText(
          text: TextSpan(
            text: "$title:\n",
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}