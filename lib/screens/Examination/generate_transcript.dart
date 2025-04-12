import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'examination_dashboard.dart';
import '../../utils/sidebar.dart';
import '../../utils/gesture_sidebar.dart';
import '../../utils/bottom_bar.dart'; // Import the new bottom bar component

class GenerateTranscriptScreen extends StatefulWidget {
  const GenerateTranscriptScreen({Key? key}) : super(key: key);

  @override
  State<GenerateTranscriptScreen> createState() =>
      _GenerateTranscriptScreenState();
}

class _GenerateTranscriptScreenState extends State<GenerateTranscriptScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _selectedCourse;
  String? _selectedYear;
  File? _excelFile;
  String? _fileName;
  bool _isLoading = false;

  final List<DropdownMenuItem<String>> _courseItems = const [
    DropdownMenuItem(
        value: 'CS101', child: Text('CS101 - Introduction to Programming')),
    DropdownMenuItem(value: 'CS201', child: Text('CS201 - Data Structures')),
    DropdownMenuItem(value: 'CS301', child: Text('CS301 - Database Systems')),
    DropdownMenuItem(value: 'CS401', child: Text('CS401 - Machine Learning')),
  ];

  final List<DropdownMenuItem<String>> _yearItems = const [
    DropdownMenuItem(value: '2022-2023', child: Text('2022-2023')),
    DropdownMenuItem(value: '2023-2024', child: Text('2023-2024')),
    DropdownMenuItem(value: '2024-2025', child: Text('2024-2025')),
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

  Future<void> _pickExcelFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls', 'csv'],
        // Apply a blue theme to the file picker
        dialogTitle: 'Select Excel File',
        allowCompression: true,
      );

      if (result != null) {
        setState(() {
          _fileName = result.files.single.name;
          _excelFile = File(result.files.single.path!);
        });
        _showSnackBar('File selected: $_fileName');
      }
    } catch (e) {
      _showSnackBar('Error picking file: $e', isError: true);
    }
  }

  void _generateTranscript() {
    if (_selectedCourse == null ||
        _selectedYear == null ||
        _excelFile == null) {
      _showSnackBar('Please fill all required fields and upload an Excel file',
          isError: true);
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

      // Navigate to a new screen displaying the table
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TranscriptTableScreen(),
        ),
      );
    });
  }

  // Add helper method to create consistent input decoration
  InputDecoration getConsistentInputDecoration(String hintText) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintText: hintText,
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
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(
            'Generate Transcript',
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
            if (index == 5) {
              // Already on Generate Transcript screen
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
                      label: 'Course*',
                      child: DropdownButtonFormField<String>(
                        value: _selectedCourse,
                        decoration: getConsistentInputDecoration('Select Course'),
                        items: _courseItems,
                        onChanged: (value) {
                          setState(() {
                            _selectedCourse = value;
                          });
                        },
                        icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade700),
                        dropdownColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Academic Year*',
                      child: DropdownButtonFormField<String>(
                        value: _selectedYear,
                        decoration: getConsistentInputDecoration('Select Academic Year'),
                        items: _yearItems,
                        onChanged: (value) {
                          setState(() {
                            _selectedYear = value;
                          });
                        },
                        icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade700),
                        dropdownColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Excel File Upload*',
                      child: InkWell(
                        onTap: _pickExcelFile,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.upload_file,
                                  color: Colors.blue.shade700,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _fileName ?? 
                                        'Choose Excel File (.xlsx, .xls, .csv)',
                                    style: TextStyle(
                                      color: _fileName == null
                                          ? Colors.grey.shade600
                                          : Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  Icons.cloud_upload_outlined,
                                  color: Colors.blue.shade700,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (_fileName != null)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.green.shade100),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'File selected: $_fileName',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _fileName = null;
                                  _excelFile = null;
                                });
                              },
                              child: const Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _generateTranscript,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text('Generate Transcript'),
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
                            'Generating...',
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

class TranscriptTableScreen extends StatelessWidget {
  const TranscriptTableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Generated Transcript',
          style: TextStyle(fontWeight: FontWeight.bold),
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
            icon: const Icon(Icons.menu, color: Colors.blue),
            onPressed: () {
              scaffoldKey.currentState!.openDrawer();
            },
          ),
        ],
      ),
      drawer: Sidebar(
        onItemSelected: (index) {
          Navigator.pop(context);
          if (index == 5) {
            // Already on Generate Transcript screen
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Expanded(
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  Colors.grey.shade100,
                ),
                columnSpacing: 30,
                horizontalMargin: 16,
                columns: const [
                  DataColumn(
                    label: Text(
                      'Student ID',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Actions',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                rows: List<DataRow>.generate(
                  10,
                  (index) => DataRow(
                    cells: [
                      DataCell(
                        Text(
                          '22BCS${184 + index}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(Icons.download, size: 16),
                              label: const Text('Download'),
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 0),
                                minimumSize: const Size(40, 36),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton.icon(
                              icon: const Icon(Icons.visibility, size: 16),
                              label: const Text('Preview'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const TranscriptPreviewScreen(),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.blue,
                                side: const BorderSide(color: Colors.blue),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 0),
                                minimumSize: const Size(40, 36),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomBar(currentIndex: 0),
    );
  }
}

class TranscriptPreviewScreen extends StatelessWidget {
  const TranscriptPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Transcript Preview',
          style: TextStyle(fontWeight: FontWeight.bold),
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
            },
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.blue),
            onPressed: () {
              // Share functionality
            },
          ),
        ],
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
                            Icon(Icons.person, color: Colors.blue.shade700, size: 24),
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
                                    value: 'Alex Johnson',
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
                            
                            // Second row - Program and Academic Year
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
                                    label: 'Academic Year',
                                    value: '2023-2024',
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

                // Academic Record Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
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
                        child: Icon(Icons.school, color: Colors.blue.shade700, size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'ACADEMIC RECORD',
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
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: Colors.blue.shade200),
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
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: Colors.grey.shade300),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade200.withOpacity(0.5),
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
                                    _getGradeColor(grades[index]).withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: _getGradeColor(grades[index]).withOpacity(0.4),
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
                            Icon(Icons.summarize, color: Colors.blue.shade700, size: 24),
                            const SizedBox(width: 12),
                            Text(
                              'ACADEMIC SUMMARY',
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
                                      'Term SPI', '3.7', Icons.assessment),
                                  const SizedBox(height: 12),
                                  _buildSimpleSummaryCard('CPI', '3.8', Icons.star),
                                ],
                              );
                            } else {
                              return Row(
                                children: [
                                  Expanded(
                                    child: _buildSimpleSummaryCard(
                                        'Total Credits', '16', Icons.credit_card),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildSimpleSummaryCard(
                                        'Term SPI', '3.7', Icons.assessment),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildSimpleSummaryCard(
                                        'CPI', '3.8', Icons.star),
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
