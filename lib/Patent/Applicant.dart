import 'package:flutter/material.dart';
import 'new_application_page.dart';
import 'saved_drafts.dart';
import 'view_applications.dart';
import '../../utils/sidebar.dart';
import '../../utils/bottom_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Applicant Dashboard',
      theme: ThemeData(
        primaryColor: Colors.blue,
        primarySwatch: Colors.blue,
      ),
      home: const ApplicantDashboard(),
    );
  }
}

class WorkflowStep {
  final String label;
  final bool isCompleted;

  WorkflowStep({
    required this.label,
    this.isCompleted = false,
  });
}

class WorkflowTimeline extends StatelessWidget {
  const WorkflowTimeline({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final steps = [
      WorkflowStep(label: 'Submitted', isCompleted: true),
      WorkflowStep(label: 'PCC Admin', isCompleted: true),
      WorkflowStep(label: 'Attorney Assignment', isCompleted: true),
      WorkflowStep(label: "Director's Approval", isCompleted: true),
      WorkflowStep(label: 'Patentability Check', isCompleted: false),
      WorkflowStep(label: 'Search Report', isCompleted: false),
      WorkflowStep(label: 'Patent Filed', isCompleted: false),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(steps.length * 2 - 1, (index) {
            if (index.isOdd) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(Icons.arrow_forward, color: Colors.grey),
              );
            } else {
              final step = steps[index ~/ 2];
              return Column(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: step.isCompleted ? Colors.green : Colors.grey.shade300,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: step.isCompleted
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 90,
                    child: Text(
                      step.label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              );
            }
          }),
        ),
      ),
    );
  }
}


class ApplicantDashboard extends StatelessWidget {
  const ApplicantDashboard({super.key});

  void navigateToSavedDrafts(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SavedDraftsPage()),
    );
  }

  void navigateToNewApplication(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewApplicationPage()),
    );
  }

  void navigateToViewApplications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewApplicationsPage()),
    );
  }

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
                      // Reset filters
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

  static Widget _buildFilterSection(String title, List<String> options) {
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
              onSelected: (val) {},
              selectedColor: Colors.blue.shade100,
              labelStyle: TextStyle(color: e == 'All' ? Colors.blue : Colors.black),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDashboardCard(
  BuildContext context,
  IconData icon,
  String title,
  void Function(BuildContext) onTap,
) {
  return GestureDetector(
    onTap: () => onTap(context),
    child: SizedBox(
      height: 40, // Reduced height
      width: 40,  // Optional: limit width too
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0), // Reduced padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: Theme.of(context).primaryColor), // Smaller icon
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600), // Smaller text
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Home', style: TextStyle(color: Colors.white)),
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
      bottomNavigationBar: const BottomBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Applicant Dashboard', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 8),
            const Text(
              'Welcome to the Applicant Dashboard. Here, you can manage your applications, track their status, and access important resources.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Workflow Timeline Section
            const Text('Application Workflow', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 10),
            const WorkflowTimeline(),
            const SizedBox(height: 20),

            // Download Forms and Documents Section
            const Text('Download Forms and Documents', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 12),
            DataTable(
              columns: const [
                DataColumn(label: Text('S.No', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Document Title', style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Download', style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: [
                DataRow(cells: [
                  const DataCell(Text('1')),
                  const DataCell(Text('Intellectual Property Filing Form')),
                  DataCell(TextButton(
                    onPressed: () {},
                    child: const Text('DOWNLOAD HERE', style: TextStyle(color: Colors.blue)),
                  )),
                ]),
                DataRow(cells: [
                  const DataCell(Text('2')),
                  const DataCell(Text('IPR Guidelines')),
                  DataCell(TextButton(
                    onPressed: () {},
                    child: const Text('DOWNLOAD HERE', style: TextStyle(color: Colors.blue)),
                  )),
                ]),
                DataRow(cells: [
                  const DataCell(Text('3')),
                  const DataCell(Text('Patent Submission Template')),
                  DataCell(TextButton(
                    onPressed: () {},
                    child: const Text('DOWNLOAD HERE', style: TextStyle(color: Colors.blue)),
                  )),
                ]),
              ],
            ),
            const SizedBox(height: 30),

            // Application Options Section
            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildDashboardCard(context, Icons.note_add, 'New Application', navigateToNewApplication),
                _buildDashboardCard(context, Icons.save, 'Saved Drafts', navigateToSavedDrafts),
                _buildDashboardCard(context, Icons.visibility, 'View Applications', navigateToViewApplications),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
