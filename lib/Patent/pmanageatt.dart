import 'package:flutter/material.dart';
import '../../utils/sidebar.dart'; // Import Sidebar
import '../../utils/bottom_bar.dart'; // Import Bottom Bar

import 'attrprofile.dart';
import 'newattform.dart';
import 'removeatt.dart';
import 'PCC_Admin.dart';
import 'shared_data.dart';

class ManageAttorneyPage extends StatefulWidget {
  @override
  _ManageAttorneyPageState createState() => _ManageAttorneyPageState();
}

class _ManageAttorneyPageState extends State<ManageAttorneyPage> {
  int get nextId => sharedAttorneys.length + 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(), // Use Sidebar
      bottomNavigationBar: const BottomBar(), // Use Bottom Bar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF9F3FF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isMobile = constraints.maxWidth < 600;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Center(
                    child: Text(
                      'Manage Attorney Assignments',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Info Card + Data Section
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "View attorney details, assign applications, add new attorneys, reassign existing applications, and view feedback.",
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 16),

                          // Action Buttons
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              buildActionButton(
                                  context, "+Add New Attorney", Colors.blue),
                              buildActionButton(
                                  context, "Remove Attorney", Colors.red),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Responsive Display
                          isMobile ? buildMobileCards() : buildTableView(),
                        ],
                      ),
                    ),
                  ),

                  
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildActionButton(BuildContext context, String title, Color color) {
    return ElevatedButton(
      onPressed: () {
        if (title.contains("Add")) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NewAttorneyFormPage()));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => RemoveAttorneyPage()));
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(title, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget buildTableView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Table(
        border: TableBorder.all(color: Colors.blue),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: {
          0: FixedColumnWidth(60),
          1: FixedColumnWidth(150),
          2: FixedColumnWidth(150),
          3: FixedColumnWidth(130),
        },
        children: [
          buildTableRow(["S.NO", "Attorney Name", "Attorney ID", "Action"],
              isHeader: true),
          ...sharedAttorneys.asMap().entries.map((entry) {
            final i = entry.key;
            final data = entry.value;
            return buildTableRow([
              "${i + 1}",
              data["name"] ?? '',
              data["id"] ?? '',
              "View Details"
            ], context: context);
          }).toList(),
        ],
      ),
    );
  }

  Widget buildMobileCards() {
    return Column(
      children: sharedAttorneys.asMap().entries.map((entry) {
        final i = entry.key;
        final data = entry.value;
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                infoRow("S.NO", "${i + 1}"),
                infoRow("Attorney Name", data['name'] ?? ''),
                infoRow("Attorney ID", data['id'] ?? ''),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AttorneyProfilePage()),
                      );
                    },
                    child: const Text("View Details",
                        style: TextStyle(color: Colors.blue)),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(children: [
        Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
        const Spacer(),
        Text(value, textAlign: TextAlign.right),
      ]),
    );
  }

  TableRow buildTableRow(List<String> cells,
      {bool isHeader = false, BuildContext? context}) {
    return TableRow(
      decoration:
          BoxDecoration(color: isHeader ? Colors.blue[100] : Colors.white),
      children: cells.map((cell) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: cell == "View Details" && context != null
              ? TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AttorneyProfilePage()),
                    );
                  },
                  style: TextButton.styleFrom(
                    side: const BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  child: const Text("View Details",
                      style: TextStyle(color: Colors.blue)),
                )
              : Text(cell,
                  style: TextStyle(
                      fontWeight:
                          isHeader ? FontWeight.bold : FontWeight.normal)),
        );
      }).toList(),
    );
  }

  Widget buildNavButton(BuildContext context, String label) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => PatentDashboardPage()));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}
