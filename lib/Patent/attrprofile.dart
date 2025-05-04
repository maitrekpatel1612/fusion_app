import 'package:flutter/material.dart';
import '../utils/sidebar.dart';
import '../utils/gesture_sidebar.dart';
import '../utils/bottom_bar.dart';

void main() {
  runApp(AttorneyProfileApp());
}

class AttorneyProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AttorneyProfilePage(),
    );
  }
}

class AttorneyProfilePage extends StatefulWidget {
  @override
  _AttorneyProfilePageState createState() => _AttorneyProfilePageState();
}

class _AttorneyProfilePageState extends State<AttorneyProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const Sidebar(),
      body: GestureSidebar(
        scaffoldKey: _scaffoldKey,
        child: SafeArea(
          child: Column(
            children: [
              /// AppBar
              AppBar(
                backgroundColor: Colors.blue,
                title: const Text('Attorney Profile'),
              ),

              /// Body Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      /// Close Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// Title
                      const Text(
                        "Attorney Profile",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// Profile Card
                      Container(
                        alignment: Alignment.center,
                        child: Container(
                          width: 320,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                spreadRadius: 1,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildAlignedDetailRow("Name", "Rajesh Kumar"),
                              buildAlignedDetailRow("Law Firm", "Kumar & Associates"),
                              buildAlignedDetailRow("Email", "rajesh.kumar@legalfirm.in"),
                              buildAlignedDetailRow("Phone", "+91 9876534210"),
                              buildAlignedDetailRow("Specialization", "Intellectual Property Law"),
                              buildAlignedDetailRow("Fee", "₹25,000"),
                              buildAlignedDetailRow("Status", "Reviewed"),
                              buildAlignedDetailRow("Review Status", "Completed"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Custom Bottom Bar
              const BottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAlignedDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}