import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'examination_dashboard.dart';
import '../../utils/sidebar.dart';
import '../../utils/gesture_sidebar.dart';
import '../../utils/bottom_bar.dart'; // Import the new bottom bar component

class VerifyGradesScreen extends StatefulWidget {
  const VerifyGradesScreen({Key? key}) : super(key: key);

  @override
  State<VerifyGradesScreen> createState() => _VerifyGradesScreenState();
}

class _VerifyGradesScreenState extends State<VerifyGradesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _selectedCourse;
  String? _selectedYear;
  String? _selectedSemester;
  bool _isLoading = false;
  bool _showResults = false;

  final List<Map<String, String>> _dummyData = [
    {'Student ID': '22BCS184', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'A+'},
    {'Student ID': '22BCS188', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'A+'},
    {'Student ID': '22BCS201', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'B+'},
    {'Student ID': '22BCS001', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'C+'},
    {'Student ID': '22BCS202', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'F'},
    {'Student ID': '22BCS101', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'A'},
    {'Student ID': '22BCS102', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'B'},
    {'Student ID': '22BCS103', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'C'},
    {'Student ID': '22BCS104', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'D'},
    {'Student ID': '22BCS105', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'D+'},
    {'Student ID': '22BCS106', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'CD', 'Grades': 'CD'},
    {'Student ID': '22BCS107', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'A'},
    {'Student ID': '22BCS108', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'B+'},
    {'Student ID': '22BCS109', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'A+'},
    {'Student ID': '22BCS110', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'B'},
    {'Student ID': '22BCS111', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'C+'},
    {'Student ID': '22BCS112', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'C'},
    {'Student ID': '22BCS113', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'D+'},
    {'Student ID': '22BCS114', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'A'},
    {'Student ID': '22BCS115', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'B'},
    {'Student ID': '22BCS116', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'CD', 'Grades': 'CD'},
    {'Student ID': '22BCS117', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'A+'},
    {'Student ID': '22BCS118', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'B+'},
    {'Student ID': '22BCS119', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'C+'},
    {'Student ID': '22BCS120', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'D'},
    {'Student ID': '22BCS121', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'F'},
    {'Student ID': '22BCS122', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'A'},
    {'Student ID': '22BCS123', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'B'},
    {'Student ID': '22BCS124', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'C'},
    {'Student ID': '22BCS125', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'A+'},
    {'Student ID': '22BCS126', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'B+'},
    {'Student ID': '22BCS127', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'CD', 'Grades': 'CD'},
    {'Student ID': '22BCS128', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'D+'},
    {'Student ID': '22BCS129', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'C'},
    {'Student ID': '22BCS130', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS2003', 'Remarks': 'S', 'Grades': 'F'},
  ];

  final List<Map<String, dynamic>> _gradeDistribution = [
    {'grade': 'A+', 'count': 5, 'color': Colors.blue.shade800, 'percentage': 14},
    {'grade': 'A', 'count': 4, 'color': Colors.blue.shade600, 'percentage': 11},
    {'grade': 'B+', 'count': 5, 'color': Colors.green.shade700, 'percentage': 14},
    {'grade': 'B', 'count': 4, 'color': Colors.green.shade600, 'percentage': 11},
    {'grade': 'C+', 'count': 3, 'color': Colors.yellow.shade700, 'percentage': 9},
    {'grade': 'C', 'count': 4, 'color': Colors.orange.shade600, 'percentage': 11},
    {'grade': 'D+', 'count': 3, 'color': Colors.orange.shade800, 'percentage': 9},
    {'grade': 'D', 'count': 2, 'color': Colors.deepOrange.shade600, 'percentage': 6},
    {'grade': 'F', 'count': 3, 'color': Colors.red.shade600, 'percentage': 9},
    {'grade': 'CD', 'count': 3, 'color': Colors.grey.shade600, 'percentage': 9},
  ];

  int _touchedIndex = -1;

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

  void _searchGrades() {
    if (_selectedCourse == null || _selectedYear == null || _selectedSemester == null) {
      _showSnackBar('Please fill all required fields', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
        _showResults = true;
      });
    });
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
        return 'Profile';
      case 7:
        return 'Settings';
      case 8:
        return 'Help';
      case 9:
        return 'Log out';
      default:
        return 'Unknown';
    }
  }

  String _calculateAverageGrade() {
    Map<String, double> gradeValues = {
      'A+': 10.0, 'A': 9.0, 'B+': 8.0, 'B': 7.0, 'C+': 6.0, 
      'C': 5.0, 'D+': 4.0, 'D': 3.0, 'F': 0.0, 'CD': 0.0
    };
    
    double totalPoints = 0;
    int validGrades = 0;
    
    for (var student in _dummyData) {
      String grade = student['Grades'] ?? '';
      if (grade != 'CD') {
        totalPoints += gradeValues[grade] ?? 0;
        validGrades++;
      }
    }
    
    double average = validGrades > 0 ? totalPoints / validGrades : 0;
    return average.toStringAsFixed(1);
  }
  
  int _calculateFailedStudents() {
    return _dummyData.where((student) => 
      student['Grades'] == 'F' || student['Grades'] == 'CD'
    ).length;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;

    return GestureSidebar(
      scaffoldKey: _scaffoldKey,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(
            'Verify Grades',
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
            if (index == 4) {
              // Already on Verify Grades screen
            } else if (index == 0) {
              Navigator.pop(context);
            } else {
              _showSnackBar('Navigating to ${_getScreenName(index)}');
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          hintText: 'Select Course',
                        ),
                        items: const [
                          DropdownMenuItem(value: 'CS101', child: Text('CS101 - Introduction to Programming')),
                          DropdownMenuItem(value: 'CS201', child: Text('CS201 - Data Structures')),
                          DropdownMenuItem(value: 'CS301', child: Text('CS301 - Database Systems')),
                          DropdownMenuItem(value: 'CS401', child: Text('CS401 - Machine Learning')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCourse = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Academic Year*',
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          hintText: 'Select Academic Year',
                        ),
                        items: const [
                          DropdownMenuItem(value: '2022-2023', child: Text('2022-2023')),
                          DropdownMenuItem(value: '2023-2024', child: Text('2023-2024')),
                          DropdownMenuItem(value: '2024-2025', child: Text('2024-2025')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedYear = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Semester*',
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          hintText: 'Select Semester',
                        ),
                        items: const [
                          DropdownMenuItem(value: '1', child: Text('Semester 1')),
                          DropdownMenuItem(value: '2', child: Text('Semester 2')),
                          DropdownMenuItem(value: '3', child: Text('Semester 3')),
                          DropdownMenuItem(value: '4', child: Text('Semester 4')),
                          DropdownMenuItem(value: '5', child: Text('Semester 5')),
                          DropdownMenuItem(value: '6', child: Text('Semester 6')),
                          DropdownMenuItem(value: '7', child: Text('Semester 7')),
                          DropdownMenuItem(value: '8', child: Text('Semester 8')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedSemester = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _searchGrades,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text('Search Grades'),
                      ),
                    ),
                    if (_showResults) ...[
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          const Text(
                            'Grade Results',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          OutlinedButton.icon(
                            onPressed: () {
                              _showSnackBar('Exporting results to Excel');
                            },
                            icon: const Icon(Icons.download),
                            label: const Text('Export'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: WidgetStateProperty.all(Colors.grey.shade100),
                            columns: const [
                              DataColumn(label: Text('Student ID', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                              DataColumn(label: Text('Batch', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                              DataColumn(label: Text('Semester', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                              DataColumn(label: Text('Course ID', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                              DataColumn(label: Text('Remarks', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                              DataColumn(label: Text('Grades', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                            ],
                            rows: _dummyData
                                .map(
                                  (data) => DataRow(
                                    cells: [
                                      DataCell(Text(data['Student ID'] ?? '', textAlign: TextAlign.center)),
                                      DataCell(Text(data['Batch'] ?? '', textAlign: TextAlign.center)),
                                      DataCell(Text(data['Semester'] ?? '', textAlign: TextAlign.center)),
                                      DataCell(Text(data['Course ID'] ?? '', textAlign: TextAlign.center)),
                                      DataCell(Text(data['Remarks'] ?? '', textAlign: TextAlign.center)),
                                      DataCell(
                                        _buildGradeTag(data['Grades'] ?? ''),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Icon(Icons.pie_chart, color: Colors.blue.shade700),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Grade Distribution',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                return isSmallScreen 
                                  ? _buildVerticalChartLayout()
                                  : _buildHorizontalChartLayout();
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.blue.shade50, Colors.white],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Icon(Icons.analytics, color: Colors.blue.shade700),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Grade Statistics',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildEnhancedStatCard(
                                          'Batch Average', 
                                          _calculateAverageGrade(), 
                                          Icons.grade, 
                                          Colors.indigo.shade600
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: _buildEnhancedStatCard(
                                          'Passing Rate', 
                                          '83%', 
                                          Icons.check_circle, 
                                          Colors.green.shade600
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildEnhancedStatCard(
                                          'Total Students', 
                                          '${_dummyData.length}', 
                                          Icons.people, 
                                          Colors.blue.shade700
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: _buildEnhancedStatCard(
                                          'Total Failed', 
                                          '${_calculateFailedStudents()}', 
                                          Icons.warning, 
                                          Colors.red.shade600
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
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
                            'Searching...',
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



  Widget _buildHorizontalChartLayout() {
    return SizedBox(
      height: 350,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: _buildPieChart(),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildGradeTable(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalChartLayout() {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: _buildPieChart(),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildGradeTable(),
        ),
      ],
    );
  }

  Widget _buildPieChart() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  _touchedIndex = -1;
                  return;
                }
                _touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          sectionsSpace: 2,
          centerSpaceRadius: 40,
          sections: showingSections(),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(_gradeDistribution.length, (i) {
      final isTouched = i == _touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;

      return PieChartSectionData(
        color: _gradeDistribution[i]['color'],
        value: _gradeDistribution[i]['percentage'].toDouble(),
        title: '${_gradeDistribution[i]['percentage']}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        badgeWidget: _Badge(
          _gradeDistribution[i]['grade'],
          size: widgetSize,
          borderColor: _gradeDistribution[i]['color'],
        ),
        badgePositionPercentageOffset: .98,
      );
    });
  }

  Widget _buildGradeTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Grade Summary',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            const TableRow(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Grade',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  'Count',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Percentage',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            ..._gradeDistribution.map((grade) {
              return TableRow(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: grade['color'],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(grade['grade'], textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                  Text(grade['count'].toString(), textAlign: TextAlign.center),
                  Text('${grade['percentage']}%', textAlign: TextAlign.center),
                ],
              );
            }).toList(),
          ],
        ),
      ],
    );
  }

  Widget _buildEnhancedStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 24,
                color: color,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getGradeColor(String grade) {
    if (grade.contains('A+')) {
      return Colors.blue.shade800;
    } else if (grade == 'A') {
      return Colors.blue.shade600;
    } else if (grade.contains('B+')) {
      return Colors.green.shade700;
    } else if (grade == 'B') {
      return Colors.green.shade600;
    } else if (grade.contains('C+')) {
      return Colors.yellow.shade700;
    } else if (grade == 'C') {
      return Colors.orange.shade600;
    } else if (grade.contains('D+')) {
      return Colors.orange.shade800;
    } else if (grade == 'D') {
      return Colors.deepOrange.shade600;
    } else if (grade == 'CD') {
      return Colors.grey.shade600;
    } else {
      return Colors.red.shade600;
    }
  }

  Widget _buildGradeTag(String grade) {
    final Color primaryColor = _getGradeColor(grade);
    final Color secondaryColor = primaryColor.withOpacity(0.8);
    final String gradeDescription = _getGradeDescription(grade);
    
    return Tooltip(
      message: gradeDescription,
      child: Container(
        constraints: const BoxConstraints(minWidth: 50),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          grade,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  String _getGradeDescription(String grade) {
    switch (grade) {
      case 'A+': return 'Outstanding - 10 points';
      case 'A': return 'Excellent - 9 points';
      case 'B+': return 'Very Good - 8 points';
      case 'B': return 'Good - 7 points';
      case 'C+': return 'Above Average - 6 points';
      case 'C': return 'Average - 5 points';
      case 'D+': return 'Below Average - 4 points';
      case 'D': return 'Pass - 3 points';
      case 'F': return 'Fail - 0 points';
      case 'CD': return 'Course Dropped';
      default: return 'Unknown Grade';
    }
  }
}

class _Badge extends StatelessWidget {
  final String grade;
  final double size;
  final Color borderColor;

  const _Badge(
    this.grade, {
    required this.size,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(
        child: Text(
          grade,
          style: TextStyle(
            fontSize: size * .4,
            fontWeight: FontWeight.bold,
            color: borderColor,
          ),
        ),
      ),
    );
  }
}