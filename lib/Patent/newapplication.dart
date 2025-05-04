import 'package:flutter/material.dart';
import '../utils/sidebar.dart';
import '../utils/gesture_sidebar.dart';
import '../utils/bottom_bar.dart';
import 'view_details_of_newapplications.dart'; // Details page

class NewApplicationPage extends StatefulWidget {
  const NewApplicationPage({super.key});

  @override
  State<NewApplicationPage> createState() => _NewApplicationPageState();
}

class _NewApplicationPageState extends State<NewApplicationPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, String>> applications = [
    {
      "title": "Patent Application 1",
      "date": "2024-11-15",
      "token": "T12345",
      "appNo": "A12345",
      "attorney": "John Doe"
    },
    {
      "title": "Patent Application 2",
      "date": "2024-11-16",
      "token": "T12346",
      "appNo": "A12346",
      "attorney": "Jane Smith"
    },
    {
      "title": "Patent Application 3",
      "date": "2024-11-17",
      "token": "T12347",
      "appNo": "A12347",
      "attorney": "Jonny"
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
                title: const Text('New Applications'),
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
                          'Applications Forwarded \nby PCC Admin',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: applications
                            .map((app) => buildApplicationCard(context, app))
                            .toList(),
                      ),
                    ],
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

  Widget buildApplicationCard(BuildContext context, Map<String, String> app) {
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
            offset: const Offset(0, 2),
          ),
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
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ViewNewApplicationDetails(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Center(
                child: Text(
                  "View Details",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
