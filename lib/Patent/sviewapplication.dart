import 'package:flutter/material.dart';
import '../../utils/sidebar.dart'; // Import your sidebar
import '../../utils/bottom_bar.dart'; // Import your bottom bar


import 'pstatus.dart';



Widget buildDetailRow(String title, String value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 160,
              child: Text("$title",
                  style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value)),
        ],
      ),
    );

Widget buildInventorDetails(
        String label, String name, String email, String phone) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Text("$label:", style: TextStyle(fontWeight: FontWeight.bold)),
        buildDetailRow("Name:", name),
        buildDetailRow("Email:", email),
        buildDetailRow("Phone:", phone),
      ],
    );

Widget buildProgressStep(String title, bool completed, bool visible,
        {bool isCurrent = false}) =>
    Visibility(
      visible: visible,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6),
        decoration: isCurrent
            ? BoxDecoration(
                border:
                    Border(left: BorderSide(color: Colors.orange, width: 4)))
            : null,
        child: Row(
          children: [
            Icon(
              completed ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isCurrent
                  ? Colors.orange
                  : (completed ? Colors.green : Colors.grey),
            ),
            SizedBox(width: 10),
            Text(title),
          ],
        ),
      ),
    );

class ViewDetailsOfReviewApplications extends StatefulWidget {
  const ViewDetailsOfReviewApplications({super.key});

  @override
  State<ViewDetailsOfReviewApplications> createState() =>
      _ViewDetailsOfReviewApplicationsState();
}

class _ViewDetailsOfReviewApplicationsState
    extends State<ViewDetailsOfReviewApplications>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  bool showForwardedCard = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(begin: Offset(1.5, 0.0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showFormIIIPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Form-III"),
          content: Text("Details of Form-III go here..."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget buildSection(String title, List<Widget> children, bool isMobile) {
    final content = Padding(
      padding: const EdgeInsets.all(16.0),
      child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );

    return isMobile
        ? ExpansionTile(
            tilePadding: EdgeInsets.symmetric(horizontal: 8),
            title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            children: [content],
          )
        : Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: Text(title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                content,
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Application Details",
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Colors.white,
      drawer: const Sidebar(), // Sidebar only as drawer
      bottomNavigationBar: BottomBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'Patent Application: Wireless Communication System for IOT Devices',
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 10),
                buildSection("Application Details", [
                  buildDetailRow("Date:", "12/09/2024"),
                  buildDetailRow("Application Number:", "APP001234"),
                  buildDetailRow("Token Number:", "TKN001234"),
                  buildDetailRow("Attorney Name:", "Jamnesh Dwivedi"),
                  buildDetailRow("Phone Number:", "555-987-6543"),
                  buildDetailRow("Email:", "attorney@example.com"),
                ], isMobile),
                buildSection("Section I: Administrative and Technical Details", [
                  buildDetailRow("Title of Application:", "AI-Based Disease Detection in Crops"),
                  buildInventorDetails("Inventor 1", "Dr. Rajesh Sharma",
                      "rajesh.sharma@iiitdmj.ac.in", "+91-9876543210"),
                  buildInventorDetails("Inventor 2", "Amit Kumar",
                      "amit.kumar@student.iiitdmj.ac.in", "+91-9123456780"),
                  buildDetailRow("Area of the invention:", "Agricultural Technology and AI"),
                  buildDetailRow("Problem in the area:", "Lack of efficient and affordable solutions."),
                  buildDetailRow("Objective of your invention:", "To develop an affordable AI model."),
                  buildDetailRow("Novelty:", "The first AI model for real-time crop disease detection."),
                ], isMobile),
                buildSection("Section II: IPR Ownership", [
                  buildDetailRow("Significant use of funds/facilities:", "Yes, using IIITDM Jabalpur's research facilities"),
                  buildDetailRow("Source of funding:", "Institute's research grant"),
                  buildDetailRow("Journal/Conference Presentation:", "Presented at AI & Agriculture 2024 Conference"),
                  buildDetailRow("MOU or Agreement Details:", "Sponsored under IIITDM Research Fund (MOU #12345)"),
                ], isMobile),
                buildSection("Section III: Commercialization", [
                  buildDetailRow("Target Companies:", "Monsanto India, Agrotech Pvt Ltd, and Agribots Inc."),
                  buildDetailRow("Development Stage:", "Partially developed"),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _showFormIIIPopup(context),
                    child: Text("View Form-III"),
                  ),
                ], isMobile),
                buildSection("Dates and Status", [
                  buildDetailRow("Submission Date:", "15 November 2024"),
                  buildDetailRow("Forwarded to Director:", "16 November 2024"),
                  buildDetailRow("Approved Date:", "17 November 2024"),
                  buildDetailRow("Attorney Assigned:", "18 November 2024"),
                  buildDetailRow("Report Generated:", "19 November 2024"),
                  buildDetailRow("Filed Date:", "20 November 2024"),
                ], isMobile),
                buildSection("Approximate Cost", [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Enter value in (INR)",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ], isMobile),
                buildSection("Application Progress", [
                  buildProgressStep("Patent Application Submission", true, true),
                  buildProgressStep("PCC Admin Review", true, true),
                  buildProgressStep("Attorney Assignment", true, true),
                  buildProgressStep("Director Initial Review", true, true, isCurrent: true),
                  buildProgressStep("Patentability Check", false, false),
                  buildProgressStep("Final Approval by Director", false, false),
                  buildProgressStep("Final Contract Completion", false, false),
                ], isMobile),
                SizedBox(height: 20),
                isMobile ? buildMobileButtons() : buildDesktopButtons(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }

  Widget buildMobileButtons() => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
         
          buildButton("Forward", () {
            _controller.forward();
            setState(() => showForwardedCard = true);
            _showSnackbar(context, "Application forwarded to Director.");
          }),
          buildButton("Back", () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => StatusOfApplicationsPage()),
            );
          }),
        
        ],
      );

  Widget buildDesktopButtons() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          
          buildButton("Forward", () {
            _controller.forward();
            setState(() => showForwardedCard = true);
            _showSnackbar(context, "Application forwarded to Director.");
          }),
          buildButton("Back", () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => StatusOfApplicationsPage()),
            );
          }),
        
        ],
      );
}
