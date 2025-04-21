import 'package:flutter/material.dart';
import 'package:fusion/screens/Complaint%20Management/complaint_dashboard.dart';
import 'package:fusion/screens/Complaint%20Management/declined_complaints.dart';
import 'package:fusion/screens/Complaint%20Management/resolved_complaints.dart';
import '../../utils/gesture_sidebar.dart';
import '../../utils/bottom_bar.dart';
import '../../utils/sidebar.dart' as sidebar;
import 'pending_complaints.dart';

class ViewHistory extends StatefulWidget {
  const ViewHistory({Key? key}) : super(key: key);

  @override
  State<ViewHistory> createState() => _ViewHistoryState();
}

class _ViewHistoryState extends State<ViewHistory> {
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
                  builder: (context) => const ComplaintDashboard(),
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
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "COMPLAINTS HISTORY",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 20),
              ...[
                _buildStatusRow("PENDING COMPLAINTS", 5),
                _buildStatusRow("RESOLVED COMPLAINTS", 7),
                _buildStatusRow("DECLINED COMPLAINTS", 4),
              ],
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlue[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Complain')),
                    DataColumn(label: Text('Location')),
                  ],
                  rows: const [
                    DataRow(cells: [
                      DataCell(Text("2 Feb, 2024")),
                      DataCell(Text("Electricity")),
                      DataCell(Text("Panini-B")),
                    ]),
                    DataRow(cells: [
                      DataCell(Text("15 Jan, 2024")),
                      DataCell(Text("Internet")),
                      DataCell(Text("Nagarjuna")),
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        bottomNavigationBar: const BottomBar(),
      ),
    );
  }

  Widget _buildStatusRow(String label, int count) {
    return InkWell(
      onTap: () {
        if (label == "PENDING COMPLAINTS") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PendingComplaints(),
            ),
          );
        } else if (label == "RESOLVED COMPLAINTS") {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ViewResolved(),
              )
          );
        } else if (label == "DECLINED COMPLAINTS") {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const DeclinedComplaints()
            )
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            const Icon(Icons.keyboard_arrow_right, size: 18),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: Colors.blue[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
