import 'package:flutter/material.dart';
import 'package:fusion/screens/Complaint%20Management/complaint_dashboard.dart';
import '../../utils/gesture_sidebar.dart';
import '../../utils/bottom_bar.dart';
import '../../utils/sidebar.dart' as sidebar;
import 'feedback_form.dart';

class ViewFeedback extends StatefulWidget {
  const ViewFeedback({Key? key}) : super(key: key);

  @override
  State<ViewFeedback> createState() => _ViewFeedbackState();
}

class _ViewFeedbackState extends State<ViewFeedback> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, String>> feedbackData = [
    {
      "complaintId": "C12341",
      "date": "21feb,2024",
      "complain": "Electricity",
      "location": "Panini-B",
      "finishDate": "25feb,2024",
      "specificLocation": "Room 305",
      "caretakerComment": "Fixed fan",
    },
    {
      "complaintId": "C12342",
      "date": "15jan,2024",
      "complain": "Internet",
      "location": "Nagarjuna",
      "finishDate": "17jan,2024",
      "specificLocation": "Lab A",
      "caretakerComment": "WiFi router replaced",
    },
  ];

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

  final ScrollController _horizontalScroll = ScrollController();

  Widget _buildFeedbackTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightBlue[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Scrollbar(
        controller: _horizontalScroll,
        thumbVisibility: true,
        trackVisibility: true,
        interactive: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _horizontalScroll,
          child: DataTable(
            columnSpacing: 20,
            columns: const [
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Complain')),
              DataColumn(label: Text('Location')),
              DataColumn(label: Text('Feedback Given')),
            ],
            rows: List.generate(
              feedbackData.length,
                  (index) => DataRow(
                onSelectChanged: (_) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FeedbackForm(
                        complaintId: feedbackData[index]["complaintId"] ?? '',
                        registerDate: feedbackData[index]["date"] ?? '',
                        finishDate: feedbackData[index]["finishDate"] ?? '',
                        location: feedbackData[index]["location"] ?? '',
                        specificLocation: feedbackData[index]["specificLocation"] ?? '',
                        caretakerComment: feedbackData[index]["caretakerComment"] ?? '',
                      ),
                    ),
                  );
                },
                cells: [
                  DataCell(Text(feedbackData[index]['date'] ?? '')),
                  DataCell(Text(feedbackData[index]['complain'] ?? '')),
                  DataCell(Text(feedbackData[index]['location'] ?? '')),
                  DataCell(Text(feedbackData[index]['caretakerComment'] ?? '')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return GestureSidebar(
      scaffoldKey: _scaffoldKey,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(
            'View Feedback',
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
            if (index != 1 && index != 0) {
              _showSnackBar('Navigating to ${_getScreenName(index)}');
            }
          },
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFeedbackTable(),
              const SizedBox(height: 8),
            ],
          ),
        ),
        bottomNavigationBar: const BottomBar(),
      ),
    );
  }
}
