import 'package:flutter/material.dart';
import '../utils/sidebar.dart';
import '../utils/gesture_sidebar.dart';
import '../utils/bottom_bar.dart';
import 'newapplication.dart';
import 'reviewapplication.dart';
import 'notifications.dart';

class DirectorDashboard extends StatefulWidget {
  const DirectorDashboard({super.key});

  @override
  State<DirectorDashboard> createState() => _DirectorDashboardState();
}

class _DirectorDashboardState extends State<DirectorDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openFiltersBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            runSpacing: 20,
            children: [
              Row(
                children: [
                  const Icon(Icons.filter_list),
                  const SizedBox(width: 8),
                  const Text('Filters', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      // Reset logic
                    },
                    child: const Text("Reset Filters", style: TextStyle(color: Colors.red)),
                  )
                ],
              ),
              _buildFilterSection('Status', ['All', 'Read', 'Unread']),
              _buildFilterSection('Module', ['All', 'Examination', 'Patent', 'Library', 'Hostel']),
              _buildFilterSection('Date', ['All', 'Today', 'Yesterday', 'This Week', 'This Month', 'This Year']),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, minimumSize: const Size(double.infinity, 50)),
                child: const Text('Apply Filters'),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterSection(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: options.map((e) {
            return FilterChip(
              label: Text(e),
              selected: e == 'All',
              onSelected: (_) {},
              selectedColor: Colors.blue.shade100,
              labelStyle: TextStyle(color: e == 'All' ? Colors.blue : Colors.black),
            );
          }).toList(),
        ),
      ],
    );
  }

  TableRow buildTableRow(int index, String title) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text("$index."),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(title),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () {
              // TODO: Add download logic
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Center(
                child: Text("Download", style: TextStyle(color: Colors.blue)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildInfoCard(BuildContext context, String title, String description, String buttonText) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: title == "New application" || title == "Notifications" ? Colors.blue[50] : Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const Divider(),
          Text(description, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              if (title == "New application") {
                Navigator.push(context, MaterialPageRoute(builder: (_) => NewApplicationPage()));
              } else if (title == "Reviewed Application") {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ReviewApplicationPage()));
              } else if (title == "Notifications") {
                Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationsPage()));
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(buttonText, style: const TextStyle(color: Colors.blue)),
              ),
            ),
          ),
        ],
      ),
    );
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
                title: const Text('Director Dashboard'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list, color: Colors.white),
                    onPressed: () => _openFiltersBottomSheet(context),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Center(
                        child: Text('Director Dashboard', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "Welcome to the Director Dashboard. Here, you can manage and monitor the review process for patent applications. Access resources and track workflow progress to ensure smooth operation.",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text("Application Workflow", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(value: 0.5, backgroundColor: Colors.grey[300], color: Colors.blue),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("pending review", style: TextStyle(color: Colors.grey)),
                          Text("review", style: TextStyle(color: Colors.grey)),
                          Text("final decision", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text("Download Resources", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.blue[50],
                        ),
                        child: Table(
                          border: TableBorder.all(color: Colors.blue),
                          columnWidths: const {
                            0: FlexColumnWidth(0.3),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(0.7),
                          },
                          children: [
                            TableRow(
                              decoration: BoxDecoration(color: Colors.blue[100]),
                              children: const [
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text("S.No", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text("Document Title", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text("Download", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                                ),
                              ],
                            ),
                            buildTableRow(1, "Director Guidelines for Application view"),
                            buildTableRow(2, "Policy Document for Patent Filing"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      buildInfoCard(context, "New application", "View all applications forwarded by PCC Admin for your review.", "View Submitted Application"),
                      buildInfoCard(context, "Reviewed Application", "Access applications that have been reviewed.", "View Reviewed Applications"),
                      buildInfoCard(context, "Notifications", "View all Notifications for your review.", "View Notifications"),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              const BottomBar(), // Custom bottom nav bar
            ],
          ),
        ),
      ),
    );
  }
}
