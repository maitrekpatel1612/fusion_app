import 'package:flutter/material.dart';
import '../../utils/sidebar.dart'; // Import your sidebar
import '../../utils/bottom_bar.dart'; // Import your bottom bar
import 'pviewapplication.dart';

class NewApplicationsPage extends StatelessWidget {
  final List<Map<String, String>> applications = const [
    {
      "TOKEN NO": "IIITDM/IA001",
      "PATENT TITLE": "Smart Irrigation System",
      "Submitted by": "Aarav Sharma",
      "Designation": "Researcher",
      "Department": "Agriculture",
      "Date-time": "2024-10-06",
    },
    {
      "TOKEN NO": "IIITDM/IA002",
      "PATENT TITLE": "AI-Powered Drone",
      "Submitted by": "Meera Patel",
      "Designation": "Professor",
      "Department": "Aerospace",
      "Date-time": "2024-10-08",
    },
    {
      "TOKEN NO": "IIITDM/IA003",
      "PATENT TITLE": "Solar-Powered Car",
      "Submitted by": "Rohan Verma",
      "Designation": "Scientist",
      "Department": "Mechanical",
      "Date-time": "2024-10-10",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      drawer: const Sidebar(),
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
        
        centerTitle: true,
      ),
      bottomNavigationBar: const BottomBar(),
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 12.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Center(
              child: Text(
                'New Applications',
                style: TextStyle(
                  fontSize: isMobile ? 20 : 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "The following is a list of new patent applications that require review. "
                      "Please examine the details and click on the 'View' button to see more information.",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    screenWidth > 600
                        ? buildTableView(context)
                        : buildCardView(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTableView(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.blue),
      columnWidths: const {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(2),
        4: FlexColumnWidth(2),
        5: FlexColumnWidth(2),
        6: FlexColumnWidth(1),
      },
      children: [
        buildTableRow([
          "TOKEN NO",
          "PATENT TITLE",
          "Submitted by",
          "Designation",
          "Department",
          "Date-time",
          "View"
        ], isHeader: true, context: context),
        ...applications.map((app) {
          return buildTableRow([
            app["TOKEN NO"]!,
            app["PATENT TITLE"]!,
            app["Submitted by"]!,
            app["Designation"]!,
            app["Department"]!,
            app["Date-time"]!,
            "View"
          ], context: context);
        }).toList(),
      ],
    );
  }

  Widget buildCardView(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: applications.length,
      itemBuilder: (context, index) {
        var app = applications[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.blue.shade100),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade50,
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildLabelValueRow("TOKEN NO:", app["TOKEN NO"]!),
              buildLabelValueRow("PATENT TITLE:", app["PATENT TITLE"]!),
              buildLabelValueRow("Submitted by:", app["Submitted by"]!),
              buildLabelValueRow("Designation:", app["Designation"]!),
              buildLabelValueRow("Department:", app["Department"]!),
              buildLabelValueRow("Date-time:", app["Date-time"]!),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: buildViewButton(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildLabelValueRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget buildViewButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewDetailsOfReviewApplications(),
          ),
        );
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.blue,
        side: const BorderSide(color: Colors.blue),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: const Text("View"),
    );
  }

  TableRow buildTableRow(List<String> cells,
      {bool isHeader = false, required BuildContext context}) {
    return TableRow(
      decoration:
          BoxDecoration(color: isHeader ? Colors.blue[100] : Colors.white),
      children: cells.map((cell) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: (cell == "View" && !isHeader)
              ? buildViewButton(context)
              : Text(
                  cell,
                  textAlign: (cell == "TOKEN NO" || cell == "View")
                      ? TextAlign.center
                      : TextAlign.left,
                  style: TextStyle(
                    fontSize: isHeader ? 14.5 : 13.5,
                    fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
        );
      }).toList(),
    );
  }
}
