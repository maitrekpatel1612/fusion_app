import 'package:flutter/material.dart';
import '../../utils/sidebar.dart'; // Sidebar
import '../../utils/bottom_bar.dart'; // Bottom bar
import 'sviewapplication.dart'; // View Details Page
import 'PCC_Admin.dart'; // Dashboard Page

class StatusOfApplicationsPage extends StatelessWidget {
  final List<Map<String, String>> applications = [
    {
      "token": "IIITDM/IA001",
      "title": "Smart Irrigation System",
      "submittedBy": "Aarav Sharma",
      "designation": "Researcher",
      "department": "Agriculture",
      "date": "2024-10-06",
    },
    {
      "token": "IIITDM/IA002",
      "title": "AI-Based Healthcare",
      "submittedBy": "Meera Patel",
      "designation": "Professor",
      "department": "Medical Science",
      "date": "2024-09-18",
    },
    {
      "token": "IIITDM/IA003",
      "title": "Autonomous Drones",
      "submittedBy": "Rohit Verma",
      "designation": "Researcher",
      "department": "Aerospace",
      "date": "2024-08-25",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      drawer: const Sidebar(), // Sidebar
      appBar: AppBar(
        title: const Text(""),
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      bottomNavigationBar: const BottomBar(), // Bottom bar
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 10),

            // Title
            Center(
              child: Text(
                "Status of Applications",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Card
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Below is the list of recent patent applications with their current status. Click on 'View' for more details.",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 16),
                    if (!isMobile)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Table(
                          border: TableBorder.all(color: Colors.blue),
                          columnWidths: {
                            0: FixedColumnWidth(130),
                            1: FixedColumnWidth(180),
                            2: FixedColumnWidth(130),
                            3: FixedColumnWidth(130),
                            4: FixedColumnWidth(130),
                            5: FixedColumnWidth(100),
                            6: FixedColumnWidth(80),
                          },
                          children: [
                            _buildTableRow([
                              "TOKEN NO",
                              "PATENT TITLE",
                              "Submitted by",
                              "Designation",
                              "Department",
                              "Date-time",
                              "View"
                            ], isHeader: true, context: context),
                            ...applications.map((app) {
                              return _buildTableRow([
                                app["token"]!,
                                app["title"]!,
                                app["submittedBy"]!,
                                app["designation"]!,
                                app["department"]!,
                                app["date"]!,
                                "View"
                              ], context: context);
                            }).toList(),
                          ],
                        ),
                      )
                    else
                      Column(
                        children: applications.map((app) {
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildRow("Token: ", app['token']!),
                                  _buildRow("Title: ", app['title']!),
                                  _buildRow(
                                      "Submitted by: ", app['submittedBy']!),
                                  _buildRow(
                                      "Designation: ", app['designation']!),
                                  _buildRow(
                                      "Department: ", app['department']!),
                                  _buildRow("Date: ", app['date']!),
                                  SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                ViewDetailsOfReviewApplications(),
                                          ),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        side: BorderSide(color: Colors.blue),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                      child: Text("View",
                                          style:
                                              TextStyle(color: Colors.blue)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Bottom Button
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PatentDashboardPage()),
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.blue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text("Dashboard", style: TextStyle(color: Colors.blue)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Spacer(),
          Text(value, textAlign: TextAlign.right),
        ],
      ),
    );
  }

  TableRow _buildTableRow(List<String> cells,
      {bool isHeader = false, required BuildContext context}) {
    return TableRow(
      decoration:
          BoxDecoration(color: isHeader ? Colors.blue[100] : Colors.white),
      children: cells.map((cell) {
        return Padding(
          padding: EdgeInsets.all(8),
          child: (cell == "View" && !isHeader)
              ? TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ViewDetailsOfReviewApplications(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    side: BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(cell, style: TextStyle(color: Colors.blue)),
                )
              : Text(
                  cell,
                  style: TextStyle(
                      fontWeight:
                          isHeader ? FontWeight.bold : FontWeight.normal),
                ),
        );
      }).toList(),
    );
  }
}