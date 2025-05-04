import 'package:flutter/material.dart';
import '../../utils/sidebar.dart'; // Import your sidebar
import '../../utils/bottom_bar.dart'; // Import your bottom bar
import 'pnewapplication.dart';
import 'pmanageatt.dart';
import 'pstatus.dart';
import 'pdownloadform.dart';
import 'package:fl_chart/fl_chart.dart';
class PatentDashboardPage extends StatefulWidget {
  const PatentDashboardPage({super.key});

  @override
  State<PatentDashboardPage> createState() => _PatentDashboardPageState();
}

class _PatentDashboardPageState extends State<PatentDashboardPage>
    with SingleTickerProviderStateMixin {
  double _opacity = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        _opacity = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    const submittedCount = 100;
    const approvedCount = 70;
    const underReviewCount = 30;

    return Scaffold(
      drawer: const Sidebar(), // Sidebar added here
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context)
                  .openDrawer(); // Open the drawer when the menu icon is tapped
            },
          ),
        ),
      ),
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: Duration(milliseconds: 600),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 12.0 : 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with avatar, name, and menu button

              SizedBox(height: 24),

              // Title
              Center(
                child: Text(
                  'Patent & Copyright Cell Dashboard',
                  style: TextStyle(
                    fontSize: isMobile ? 20 : 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Description Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isMobile ? 12 : 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade100.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "IIITDM Jabalpur's Patent Management System (PMS)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 14 : 16,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "The Patent Management System at IIITDM Jabalpur focuses on fostering research and development activities...",
                      style: TextStyle(fontSize: isMobile ? 13 : 14),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Applications Overview
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 14 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Applications Overview",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isMobile ? 15 : 16,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "View the statistics of applications for that year. You can also download the data as a CSV file for further analysis.",
                        style: TextStyle(fontSize: isMobile ? 13 : 14),
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: SizedBox(
                          height: isMobile ? 180 : 200,
                          width: isMobile ? 180 : 200,
                          child: PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  value: 50,
                                  color: Colors.blue,
                                  title: '50%',
                                  titleStyle:
                                      TextStyle(fontSize: isMobile ? 12 : 16),
                                ),
                                PieChartSectionData(
                                  value: 35,
                                  color: Colors.green,
                                  title: '35%',
                                  titleStyle:
                                      TextStyle(fontSize: isMobile ? 12 : 16),
                                ),
                                PieChartSectionData(
                                  value: 15,
                                  color: Colors.red,
                                  title: '15%',
                                  titleStyle:
                                      TextStyle(fontSize: isMobile ? 12 : 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Column(
                        children: [
                          _buildLegendRow("Submitted", Colors.blue),
                          _buildLegendRow("Approved", Colors.green),
                          _buildLegendRow("Under Review", Colors.red),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24),

              // Navigation Buttons
              Align(
                alignment: isMobile ? Alignment.center : Alignment.centerLeft,
                child: Wrap(
                  spacing: isMobile ? 12 : 20,
                  runSpacing: isMobile ? 12 : 20,
                  alignment:
                      isMobile ? WrapAlignment.center : WrapAlignment.start,
                  children: [
                    buildNavButton(context, "New Application",
                        NewApplicationsPage(), Icons.note_add),
                    buildNavButton(context, "Manage Attorney",
                        ManageAttorneyPage(), Icons.group),
                    buildNavButton(context, "Status Application",
                        StatusOfApplicationsPage(), Icons.assignment_turned_in),
                    buildNavButton(
                        context, "Downloads", DownloadPage(), Icons.download),
                  ],
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomBar(), // Bottom bar added here
    );
  }

  Widget _buildLegendRow(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20,
            height: 20,
            color: color,
          ),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  ElevatedButton buildNavButton(
      BuildContext context, String label, Widget page, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        backgroundColor: const Color.fromARGB(
            255, 105, 179, 239), // Updated to backgroundColor
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
