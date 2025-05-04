import 'package:flutter/material.dart';
import '../utils/sidebar.dart';
import '../utils/gesture_sidebar.dart';
import '../utils/bottom_bar.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, String>> notifications = [
    {
      "title": "Patent - Smart Home Security",
      "status": "Rejected",
      "date": "2024-10-23 | 14:30:00",
      "message": "Application rejected by PCC Admin due to missing details."
    },
    {
      "title": "Patent - Renewable Energy Storage",
      "status": "Rejected",
      "date": "2024-10-20 | 16:20:45",
      "message": "Application rejected by Director during final approval step."
    },
    {
      "title": "Patent - Quantum Computing",
      "status": "Accepted",
      "date": "2024-10-21 | 09:45:00",
      "message":
          "Application approved by Director and sent to Attorney for Patentability check."
    },
    {
      "title": "Patent - AI Driven Agriculture",
      "status": "Accepted",
      "date": "2024-10-22 | 10:15:30",
      "message":
          "Application accepted by PCC Admin and forwarded to Director for initial review."
    },
  ];

  void removeNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
  }

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
              AppBar(
                backgroundColor: Colors.blue,
                title: const Text('Notifications'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: () {
                      // Optional refresh logic
                    },
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: notifications.isEmpty
                      ? const Center(
                          child: Text(
                            "No new notifications",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            return buildNotificationCard(notifications[index], index);
                          },
                        ),
                ),
              ),
              const BottomBar(), // Custom bottom bar
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNotificationCard(Map<String, String> notification, int index) {
    bool isAccepted = notification["status"] == "Accepted";
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isAccepted ? Colors.green[50] : Colors.red[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isAccepted ? Colors.green : Colors.red),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification["title"]!,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            notification["status"]!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isAccepted ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            notification["date"]!,
            style: TextStyle(fontSize: 12, color: Colors.grey[700]),
          ),
          const SizedBox(height: 4),
          Text(
            notification["message"]!,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () => removeNotification(index),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text("Mark as Read", style: TextStyle(color: Colors.blue)),
            ),
          ),
        ],
      ),
    );
  }
}
