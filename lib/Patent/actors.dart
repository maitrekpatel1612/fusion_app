import 'package:flutter/material.dart';
import '../../utils/sidebar.dart' as sidebar;
import '../../Patent/Applicant.dart';
import '../../Patent/PCC_Admin.dart';
import '../../Patent/Director.dart';

class ActorsPage extends StatefulWidget {
  const ActorsPage({super.key});

  @override
  _ActorsPageState createState() => _ActorsPageState();
}

class _ActorsPageState extends State<ActorsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _handleNavigation(int index) {
    switch (index) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ApplicantDashboard()));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const PatentDashboardPage()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const DirectorDashboard()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> dashboardOptions = [
      {'title': 'DASHBOARD', 'subtitle': 'Applicant'},
      {'title': 'DASHBOARD', 'subtitle': 'PCC Admin'},
      {'title': 'DASHBOARD', 'subtitle': 'Director'},
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Patent Management'),
        backgroundColor: Colors.blue[800],
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications),
          ),
        ],
      ),
      drawer: sidebar.Sidebar(onItemSelected: _handleNavigation),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dashboardOptions.length,
        itemBuilder: (context, index) {
          final option = dashboardOptions[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.blue[700]!, Colors.blue[400]!]),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                leading: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.dashboard, color: Colors.blue),
                ),
                title: Text(
                  option['title']!,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  option['subtitle']!,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                onTap: () => _handleNavigation(index),
              ),
            ),
          );
        },
      ),
    );
  }
}
