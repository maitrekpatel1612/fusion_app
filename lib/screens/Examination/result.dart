import 'package:flutter/material.dart';
import 'examination_dashboard.dart';
import '../../utils/sidebar.dart';
import '../../utils/gesture_sidebar.dart';
import '../../utils/bottom_bar.dart'; // Import the new bottom bar component

class ResultScreen extends StatefulWidget {
  const ResultScreen({Key? key}) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _selectedSemester;
  bool _isLoading = false;

  final List<DropdownMenuItem<String>> _semesterItems = const [
    DropdownMenuItem(value: 'Semester 1', child: Text('Semester 1')),
    DropdownMenuItem(value: 'Semester 2', child: Text('Semester 2')),
    DropdownMenuItem(value: 'Semester 3', child: Text('Semester 3')),
    DropdownMenuItem(value: 'Semester 4', child: Text('Semester 4')),
    DropdownMenuItem(value: 'Semester 5', child: Text('Semester 5')),
    DropdownMenuItem(value: 'Semester 6', child: Text('Semester 6')),
    DropdownMenuItem(value: 'Semester 7', child: Text('Semester 7')),
    DropdownMenuItem(value: 'Semester 8', child: Text('Semester 8')),
  ];

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _viewResults() {
    if (_selectedSemester == null) {
      _showSnackBar('Please select a semester', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      // Navigate to a new screen displaying the results
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ResultPreviewScreen(semester: _selectedSemester!),
        ),
      );
    });
  }
  
  // Create consistent input decoration across the application
  InputDecoration getConsistentDecoration(String hint) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintText: hint,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      hintStyle: TextStyle(color: Colors.grey.shade500),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureSidebar(
      scaffoldKey: _scaffoldKey,
      edgeWidthFactor: 1.0, // Allow swipe from anywhere on screen
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(
            'Semester Results',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ExaminationDashboard(),
                ),
              );
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                _scaffoldKey.currentState!.openDrawer();
              },
            ),
          ],
        ),
        drawer: Sidebar(
          onItemSelected: (index) {
            Navigator.pop(context);
            if (index == 8) {
              // Already on Result screen
            } else {
              _showSnackBar('Navigating to another screen');
            }
          },
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormField(
                      label: 'Semester*',
                      child: DropdownButtonFormField<String>(
                        value: _selectedSemester,
                        decoration: getConsistentDecoration('Select Semester'),
                        items: _semesterItems,
                        onChanged: (value) {
                          setState(() {
                            _selectedSemester = value;
                          });
                        },
                        icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade700),
                        dropdownColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _viewResults,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text('View Results'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          Text(
                            'Loading Results...',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        bottomNavigationBar: const BottomBar(currentIndex: 0),
      ),
    );
  }

  Widget _buildFormField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class ResultPreviewScreen extends StatelessWidget {
  final String semester;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Add scaffold key

  // Update constructor to include key
  ResultPreviewScreen({Key? key, required this.semester}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureSidebar(
      scaffoldKey: _scaffoldKey,
      edgeWidthFactor: 1.0, // Allow swipe from anywhere on screen
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            '$semester Results',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.blue),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.download, color: Colors.blue),
              onPressed: () {
                // Download functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Downloading results...'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.share, color: Colors.blue),
              onPressed: () {
                // Share functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sharing results...'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
        drawer: Sidebar(
          onItemSelected: (index) {
            Navigator.pop(context);
            if (index == 8) {
              // Already on Result screen
            } else if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ExaminationDashboard(),
                ),
              );
            }
          },
        ),
        body: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Student Information Card
                  Card(
                    elevation: 3,
                    shadowColor: Colors.blue.shade200.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with title
                          Row(
                            children: [
                              Icon(Icons.person,
                                  color: Colors.blue.shade700, size: 24),
                              const SizedBox(width: 12),
                              Text(
                                'STUDENT INFORMATION',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),

                          // Student info
                          Column(
                            children: [
                              // First row - Student Name and ID
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildSimpleInfoItem(
                                      label: 'Student Name',
                                      value: 'Maitrek Patel',
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildSimpleInfoItem(
                                      label: 'Student ID',
                                      value: '22BCS184',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Second row - Program and Semester
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildSimpleInfoItem(
                                      label: 'Program',
                                      value: 'CSE',
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildSimpleInfoItem(
                                      label: 'Current Semester',
                                      value: semester,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Results Section Header
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade600, Colors.blue.shade400],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade200.withOpacity(0.6),
                          blurRadius: 8,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.assessment,
                              color: Colors.blue.shade700, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'SEMESTER RESULTS',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Course List
                  ...List.generate(5, (index) {
                    final List<String> courseNames = [
                      'Introduction to Programming',
                      'Data Structures and Algorithms',
                      'Linear Algebra',
                      'Physics for Computing',
                      'Technical Communication'
                    ];

                    final List<String> courseCodes = [
                      'CS101',
                      'CS201',
                      'ES202',
                      'PR101',
                      'CE203'
                    ];

                    final List<String> grades = ['A', 'A+', 'B+', 'A', 'B'];
                    final List<int> credits = [4, 3, 3, 4, 2];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 3,
                      shadowColor: Colors.blue.shade100.withOpacity(0.7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.grey.shade50],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200.withOpacity(0.5),
                              blurRadius: 4,
                              spreadRadius: 1,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade50,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                                color: Colors.blue.shade200),
                                          ),
                                          child: Text(
                                            courseCodes[index],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: Colors.blue.shade700,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                                color: Colors.grey.shade300),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.shade200
                                                    .withOpacity(0.5),
                                                blurRadius: 2,
                                                offset: const Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            '${credits[index]} Credits',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      courseNames[index],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      _getGradeColor(grades[index]),
                                      _getGradeColor(grades[index])
                                          .withOpacity(0.8),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _getGradeColor(grades[index])
                                          .withOpacity(0.4),
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.7),
                                    width: 1.5,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  grades[index],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 24),
                  // Summary Section
                  Card(
                    elevation: 3,
                    shadowColor: Colors.blue.shade200.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.summarize,
                                  color: Colors.blue.shade700, size: 24),
                              const SizedBox(width: 12),
                              Text(
                                'SEMESTER SUMMARY',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade800,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          // Summary cards in responsive layout
                          LayoutBuilder(
                            builder: (context, constraints) {
                              if (constraints.maxWidth < 500) {
                                return Column(
                                  children: [
                                    _buildSimpleSummaryCard(
                                        'Total Credits', '16', Icons.credit_card),
                                    const SizedBox(height: 12),
                                    _buildSimpleSummaryCard(
                                        'Semester SPI', '3.7', Icons.assessment),
                                    const SizedBox(height: 12),
                                    _buildSimpleSummaryCard(
                                        'CPI', '3.8', Icons.star),
                                    const SizedBox(height: 12),
                                    _buildSimpleSummaryCard(
                                        'SU', '14', Icons.check_circle),
                                    const SizedBox(height: 12),
                                    _buildSimpleSummaryCard(
                                        'TU', '18', Icons.assessment_outlined),
                                  ],
                                );
                              } else {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildSimpleSummaryCard(
                                              'Total Credits',
                                              '16',
                                              Icons.credit_card),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: _buildSimpleSummaryCard(
                                              'Semester SPI',
                                              '3.7',
                                              Icons.assessment),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: _buildSimpleSummaryCard(
                                              'CPI', '3.8', Icons.star),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildSimpleSummaryCard(
                                              'SU', '14', Icons.check_circle),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: _buildSimpleSummaryCard('TU',
                                              '18', Icons.assessment_outlined),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(child: Container()),
                                      ],
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const BottomBar(currentIndex: 0),
      ),
    );
  }

  Widget _buildSimpleInfoItem({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleSummaryCard(String label, String value, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue.shade700, size: 18),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blue.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade) {
      case 'A+':
        return Colors.green.shade700;
      case 'A':
        return Colors.green.shade600;
      case 'A-':
        return Colors.green.shade500;
      case 'B+':
        return Colors.blue.shade600;
      case 'B':
        return Colors.blue.shade500;
      case 'C+':
        return Colors.orange.shade600;
      case 'C':
        return Colors.orange.shade500;
      case 'D':
        return Colors.red.shade500;
      case 'F':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }
}
