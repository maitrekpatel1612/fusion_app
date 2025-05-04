import 'package:flutter/material.dart';
import '../utils/sidebar.dart';
import '../utils/gesture_sidebar.dart';
import '../utils/bottom_bar.dart';
import 'view_details_of_reviewapplications.dart'; // Import the details page

class ReviewApplicationPage extends StatefulWidget {
  const ReviewApplicationPage({super.key});

  @override
  State<ReviewApplicationPage> createState() => _ReviewApplicationPageState();
}

class _ReviewApplicationPageState extends State<ReviewApplicationPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, String>> reviewedApplications = [
    {
      "title": "Mobile Payment Security Protocol",
      "date": "20/10/2024 | 09:30:00",
      "token": "TKN003456",
      "appNo": "APP003456",
      "attorney": "JKL123456"
    },
    {
      "title": "Telemedicine Platform for Rural Areas",
      "date": "18/10/2024 | 11:15:00",
      "token": "TKN003457",
      "appNo": "APP003457",
      "attorney": "MNO987654"
    },
    {
      "title": "AI-Driven Personalized Learning System",
      "date": "15/10/2024 | 14:00:00",
      "token": "TKN003458",
      "appNo": "APP003458",
      "attorney": "PQR123456"
    },
    {
      "title": "Smart Waste Management System",
      "date": "12/10/2024 | 16:30:00",
      "token": "TKN003459",
      "appNo": "APP003459",
      "attorney": "STU654321"
    },
  ];

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
                title: const Text('Reviewed Applications'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: () {
                      // Optional: refresh logic
                    },
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Recently Reviewed',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: reviewedApplications
                            .map((app) => buildReviewCard(context, app))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const BottomBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildReviewCard(BuildContext context, Map<String, String> app) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(app["title"]!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 5),
          Text("Date: ${app["date"]}"),
          Text("Token No.: ${app["token"]}"),
          Text("Application No.: ${app["appNo"]}"),
          Text("Assigned Attorney: ${app["attorney"]}"),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Optional: review again logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Review Again",
                    style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ViewDetailsOfReviewApplications()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("View Details",
                    style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
