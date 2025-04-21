import 'package:flutter/material.dart';
import 'package:fusion/screens/Complaint%20Management/complaint_history.dart';
import 'package:fusion/utils/gesture_sidebar.dart';
import '../../utils/bottom_bar.dart';
import '../../utils/sidebar.dart' as sidebar;
import 'complaint_dashboard.dart';


class DeclinedComplaints extends StatefulWidget {
  const DeclinedComplaints({Key? key}) : super(key: key);

  @override
  State<DeclinedComplaints> createState() => _DeclinedComplaintsState();
}

class _DeclinedComplaintsState extends State<DeclinedComplaints> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  String _getScreenName(int index) {
    const screens = [
      'Dashboard',
      'Lodge a Complaint',
      'View Feedback',
      'Complaint History',
      'Resolved Complaints',
      'Unresolved Complaints'
    ];
    return index >= 0 && index < screens.length ? screens[index] : 'Unknown';
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
                  builder: (context) => const ViewHistory(),
                ),
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.blue),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
          ],
        ),
        drawer: sidebar.Sidebar(
          onItemSelected: (index) {
            Navigator.pop(context);
            if (index != 1 && index != 0) {
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
              const Text(
                "DECLINED COMPLAINTS",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),

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
      ),
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