import 'package:flutter/material.dart';
import '../utils/sidebar.dart';
import '../utils/gesture_sidebar.dart';
import '../utils/bottom_bar.dart';

class ViewNewApplicationDetails extends StatelessWidget {
  const ViewNewApplicationDetails({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a GlobalKey to manage the Scaffold state and handle opening/closing of the sidebar
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      drawer: const Sidebar(), // Custom Sidebar
      body: GestureSidebar(
        scaffoldKey: _scaffoldKey, // Using the key to control the sidebar
        child: SafeArea(
          child: SingleChildScrollView( // To avoid overflow
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title of Patent Application
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Title of Patent Application",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Prototype for Visually Impaired",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Patent Application Details
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      detailRow("Date:", "12/09/2024"),
                      detailRow("Applicant Name:", "Ashish Kumar Bhoi"),
                      detailRow("Application No.:", "234567"),
                      detailRow("Token No.:", "TKNO01234"),
                      detailRow("Attorney Name:", "Lisa Monroe"),
                      detailRow("Phone No.:", "555-987-6543"),
                      detailRow("Email ID:", "attorney@example.com"),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Details of All Inventors Heading
                Text(
                  "Details of All Inventors:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 10),

                // Table with Inventors Details
                Table(
                  border: TableBorder.all(color: Colors.blue),
                  columnWidths: {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(3),
                    2: FlexColumnWidth(2),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.blue[100]),
                      children: [
                        tableHeader("Inventor’s Name"),
                        tableHeader("Email ID"),
                        tableHeader("Phone No."),
                      ],
                    ),
                    tableRow("Ashish Kumar Bhoi", "ashish@gmail.com", "98765-54321"),
                    tableRow("Shreyas Katkar", "shreyas@gmail.com", "98745-66321"),
                    tableRow("Aman Kheria", "aman@gmail.com", "89754-46231"),
                  ],
                ),

                SizedBox(height: 20),

                // Previous Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("Previous", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // Custom Bottom Navigation Bar
      bottomNavigationBar: const BottomBar(),
    );
  }

  // Function to create a row for details section
  Widget detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          SizedBox(width: 10),
          Expanded(
            child: Text(value, style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  // Table Headers
  Widget tableHeader(String title) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Table Rows
  TableRow tableRow(String name, String email, String phone) {
    return TableRow(
      children: [
        tableCell(name),
        tableCell(email),
        tableCell(phone),
      ],
    );
  }

  // Table Cell Widget
  Widget tableCell(String text) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }
}
