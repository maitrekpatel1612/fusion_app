import 'package:flutter/material.dart';
import 'package:fusion/screens/Complaint%20Management/complaint_dashboard.dart';
import '../../utils/gesture_sidebar.dart';
import '../../utils/bottom_bar.dart'; // Bottom bar import
import '../../utils/sidebar.dart' as sidebar;

class ViewUnresolved extends StatefulWidget {
  const ViewUnresolved({Key? key}) : super(key: key);

  @override
  State<ViewUnresolved> createState() => _ViewUnresolvedState();
}

class _ViewUnresolvedState extends State<ViewUnresolved> {
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
              'Unresolved Complaints',
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
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // First Card
                _complaintCard(
                  title: "Complaint",
                  date: "XX/XX/20XX",
                  location: "C-111",
                  complainant: "Xyz",
                  description:
                  "Not able to connect to internet because of Fault in Lan port.",
                ),

                const SizedBox(height: 12),

                // Second Card
                _complaintCard(
                  title: "Faulty Lan Port",
                  date: "12/03/2024",
                  location: "C-111",
                  complainant: "Xyz",
                  description:
                  "Not able to connect to internet because of Fault in Lan port.",
                ),

                const SizedBox(height: 12),

              ],
            ),
          ),
          bottomNavigationBar: const BottomBar(),
        )
    );
  }

  Widget _complaintCard({
    required String title,
    required String date,
    required String location,
    required String complainant,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.cyan[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text("Date: $date"),
          Text("Location: $location"),
          Text("Complainant: $complainant"),
          const Divider(height: 20),
          Text(description),
        ],
      ),
    );
  }
}