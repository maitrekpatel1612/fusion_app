import 'package:flutter/material.dart';
import '../../utils/sidebar.dart' as sidebar;
import 'announcement_screen.dart';
import 'submit_grades.dart';
import 'verify_grades.dart';
import 'update_grades.dart'; // Import the UpdateGradesScreen
import 'generate_transcript.dart';
import 'result.dart'; // Import the ResultScreen
import 'validate_grades.dart'; // Import the ValidateGradesScreen
import '../../utils/gesture_sidebar.dart';
import '../../utils/profile.dart'; // Import the new ProfileScreen
// Import the new SearchScreen
import '../../utils/home.dart'; // Import HomeScreen for navigation
import '../../utils/bottom_bar.dart'; // Import the BottomBar widget

class ExaminationDashboard extends StatefulWidget {
  const ExaminationDashboard({super.key});

  @override
  State<ExaminationDashboard> createState() => _ExaminationDashboardState();
}

class _ExaminationDashboardState extends State<ExaminationDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _handleNavigation(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AnnouncementScreen()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SubmitGradesScreen()),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VerifyGradesScreen()),
      );
    } else if (index == 5) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const GenerateTranscriptScreen()),
      );
    } else if (index == 6) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ValidateGradesScreen()),
      );
    } else if (index == 7) {
      // Handle Update Grades navigation
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UpdateGradesScreen()),
      );
    } else if (index == 8) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ResultScreen()),
      );
    } else if (index == 9) {
      // Navigate to Profile screen when selected from sidebar
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Navigating to ${_getScreenName(index)}'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  String _getScreenName(int index) {
    switch (index) {
      case 0:
        return 'Dashboard';
      case 1:
        return 'Orders';
      case 2:
        return 'Announcement';
      case 3:
        return 'Submit Grades';
      case 4:
        return 'Verify Grades';
      case 5:
        return 'Generate Transcript';
      case 6:
        return 'Validate Grades';
      case 7:
        return 'Update Grades';
      case 8:
        return 'Result';
      case 9:
        return 'Profile';
      case 10:
        return 'Settings';
      case 11:
        return 'Help';
      case 12:
        return 'Log out';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          // Navigate to home screen
          await Future.delayed(Duration.zero); // Add small delay to prevent navigation conflicts
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          }
        }
      },
      child: GestureSidebar(
        scaffoldKey: _scaffoldKey,
        edgeWidthFactor: 1.0, // Allow swipe from anywhere on screen
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: const Text(
              'Examination',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            elevation: 0,
            backgroundColor: Colors.blue.shade700,
            leading: IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () {
                  // Navigate to home screen when notification bell is clicked
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
          drawer: sidebar.Sidebar(onItemSelected: _handleNavigation),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(80),
                    bottomRight: Radius.circular(80),
                  ),
                ),
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 6.0, top: 10.0),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    physics: const BouncingScrollPhysics(), // Added smooth scrolling
                    children: [
                      _buildDashboardCard(
                        icon: Icons.campaign,
                        label: 'Announcement',
                        color: Colors.orange,
                        onTap: () => _handleNavigation(2),
                      ),
                      const SizedBox(height: 16.0), // Consistent spacing between cards
                      _buildDashboardCard(
                        icon: Icons.grade,
                        label: 'Submit Grades',
                        color: Colors.green,
                        onTap: () => _handleNavigation(3),
                      ),
                      const SizedBox(height: 16.0), // Consistent spacing between cards
                      _buildDashboardCard(
                        icon: Icons.check_circle,
                        label: 'Verify Grades',
                        color: Colors.purple,
                        onTap: () => _handleNavigation(4),
                      ),
                      const SizedBox(height: 16.0), // Consistent spacing between cards
                      _buildDashboardCard(
                        icon: Icons.calendar_today,
                        label: 'Generate Transcript',
                        color: Colors.blue,
                        onTap: () => _handleNavigation(5),
                      ),
                      const SizedBox(height: 16.0), // Consistent spacing between cards
                      _buildDashboardCard(
                        icon: Icons.verified_user,
                        label: 'Validate Grades',
                        color: Colors.red,
                        onTap: () => _handleNavigation(6),
                      ),
                      const SizedBox(height: 16.0), // Consistent spacing between cards
                      _buildDashboardCard(
                        icon: Icons.update,
                        label: 'Update Grades',
                        color: Colors.teal,
                        onTap: () => _handleNavigation(7),
                      ),
                      const SizedBox(height: 16.0), // Consistent spacing between cards
                      _buildDashboardCard(
                        icon: Icons.assessment,
                        label: 'Result',
                        color: Colors.indigo,
                        onTap: () => _handleNavigation(8),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: const BottomBar(), // Added BottomBar widget
        ),
      ),
    );
  }

  Widget _buildDashboardCard({
    required IconData icon,
    required String label,
    required Color color, // This parameter will no longer be used for color
    required VoidCallback onTap,
  }) {
    // Using the specific blue shade for all cards and icons
    Color cardColor = Colors.blue.shade700;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100, // Fixed height for rectangle cards
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              cardColor,
              cardColor.withOpacity(0.7),
            ],
          ),
          // Removed boxShadow property to eliminate shadow
        ),
        child: Stack(
          children: [
            // Background decorative elements
            Positioned(
              right: -15,
              bottom: -15,
              child: Icon(
                icon,
                size: 100,
                color: Colors.white.withOpacity(0.15),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  // Icon in circle
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      // Removed boxShadow property to eliminate shadow
                    ),
                    child: Icon(
                      icon,
                      size: 30.0,
                      color: cardColor, // Changed to use cardColor instead of color
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  // Text content
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withOpacity(0.7),
                    size: 20.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
