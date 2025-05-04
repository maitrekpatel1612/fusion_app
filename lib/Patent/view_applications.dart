import 'package:flutter/material.dart';
import '../../utils/sidebar.dart'; // Import your sidebar
import '../../utils/bottom_bar.dart'; // Import your bottom bar

class ViewApplicationsPage extends StatelessWidget {
  final List<Map<String, String>> applications = [
    {
      'id': '1',
      'appliedOn': '12/09/2024 | 14:30:45',
      'position': 'Software Engineer',
      'status': 'Pending'
    },
    {
      'id': '2',
      'appliedOn': '11/09/2024 | 10:15:30',
      'position': 'Data Scientist',
      'status': 'Under Review'
    },
    {
      'id': '3',
      'appliedOn': '10/09/2024 | 16:50:12',
      'position': 'Product Manager',
      'status': 'Accepted'
    },
  ];

  ViewApplicationsPage({super.key});  // Remove 'const' here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(), // Sidebar added
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open the drawer when the menu icon is tapped
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Applications Submitted',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 24),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: applications.length,
                itemBuilder: (context, index) {
                  final application = applications[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: index % 2 == 0 ? Colors.white : Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Application - ${application['id']}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Applied on: ${application['appliedOn']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Position: ${application['position']}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Status: ${application['status']}',
                              style: TextStyle(
                                fontSize: 16,
                                color: application['status'] == 'Accepted'
                                    ? Colors.green
                                    : application['status'] == 'Under Review'
                                        ? Colors.orange
                                        : Colors.red,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.blue),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'View Application',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomBar(), // Bottom bar added
    );
  }
}
