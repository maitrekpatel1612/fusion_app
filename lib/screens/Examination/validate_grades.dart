import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'examination_dashboard.dart';
import '../../utils/sidebar.dart';
import '../../utils/gesture_sidebar.dart';
import '../../utils/bottom_bar.dart'; // Import the new bottom bar component

class ValidateGradesScreen extends StatefulWidget {
  const ValidateGradesScreen({super.key});

  @override
  State<ValidateGradesScreen> createState() => _ValidateGradesScreenState();
}

class _ValidateGradesScreenState extends State<ValidateGradesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _fileTextController = TextEditingController();
  String? _selectedCourse;
  String? _selectedAcademicYear;
  bool _isExcelUploaded = false;
  bool _isLoading = false;
  bool _showResults = false;
  PlatformFile? _selectedFile;
  String? _uploadStatus;

  final List<Map<String, String>> _mismatchedStudents = [
    {'Student ID': '22BCS101', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS101', 'Remarks': 'Mismatch', 'Grades in DB': 'A', 'Grades in CSV': 'A+'},
    {'Student ID': '22BCS103', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS101', 'Remarks': 'Mismatch', 'Grades in DB': 'B', 'Grades in CSV': 'B+'},
    {'Student ID': '22BCS105', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS101', 'Remarks': 'Mismatch', 'Grades in DB': 'C', 'Grades in CSV': 'C+'},
    {'Student ID': '22BCS107', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS101', 'Remarks': 'Mismatch', 'Grades in DB': 'C+', 'Grades in CSV': 'B'},
    {'Student ID': '22BCS109', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS101', 'Remarks': 'Mismatch', 'Grades in DB': 'F', 'Grades in CSV': 'D'},
    {'Student ID': '22BCS110', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS101', 'Remarks': 'Mismatch', 'Grades in DB': 'B+', 'Grades in CSV': 'A'},
    {'Student ID': '22BCS112', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS101', 'Remarks': 'Mismatch', 'Grades in DB': 'A', 'Grades in CSV': 'A+'},
    {'Student ID': '22BCS114', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS101', 'Remarks': 'Mismatch', 'Grades in DB': 'A+', 'Grades in CSV': 'A'},
    {'Student ID': '22BCS115', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS101', 'Remarks': 'Mismatch', 'Grades in DB': 'C', 'Grades in CSV': 'C+'},
    {'Student ID': '22BCS117', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS101', 'Remarks': 'Mismatch', 'Grades in DB': 'B', 'Grades in CSV': 'B+'},
    {'Student ID': '22BCS119', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS101', 'Remarks': 'Mismatch', 'Grades in DB': 'A', 'Grades in CSV': 'A+'},
    {'Student ID': '22BCS121', 'Batch': '2022', 'Semester': '1', 'Course ID': 'CS101', 'Remarks': 'Mismatch', 'Grades in DB': 'F', 'Grades in CSV': 'D+'},
  ];

  @override
  void dispose() {
    _fileTextController.dispose();
    super.dispose();
  }

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

  Future<void> _selectFile() async {
    try {
      setState(() {
        _isLoading = true;
      });

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls', 'csv'],
        allowMultiple: false,
        // Apply a blue theme to the file picker
        dialogTitle: 'Select a file',
        allowCompression: true,
      );

      setState(() {
        _isLoading = false;
      });

      if (result != null) {
        setState(() {
          _selectedFile = result.files.first;
          _isExcelUploaded = true;
          _fileTextController.text = _selectedFile!.name;
        });

        _showSnackBar('File selected: ${_selectedFile!.name}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      _showSnackBar('Error picking file: $e', isError: true);
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null || _selectedFile!.path == null) {
      _showSnackBar('No file selected or file path is not available', isError: true);
      return;
    }

    setState(() {
      _uploadStatus = 'Uploading...';
      _isLoading = true;
    });

    try {
      String uploadUrl = 'https://example.com/validate-grades';
      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
      request.fields['course'] = _selectedCourse ?? '';
      request.fields['academicYear'] = _selectedAcademicYear ?? '';
      request.files.add(
        await http.MultipartFile.fromPath(
          'gradeSheet',
          _selectedFile!.path!,
        ),
      );

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _uploadStatus = 'Validation complete!';
        _isLoading = false;
        _showResults = true;
      });
    } catch (e) {
      setState(() {
        _uploadStatus = 'Validation failed: $e';
        _isLoading = false;
      });

      _showSnackBar('Error validating grades: $e', isError: true);
    }
  }

  void _downloadTemplate() async {
    setState(() {
      _isLoading = true;
      _uploadStatus = 'Downloading template...';
    });

    try {
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _isLoading = false;
      });

      _showSnackBar('Template downloaded successfully');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      _showSnackBar('Error downloading template: $e', isError: true);
    }
  }

  void _validateGrades() async {
    if (_selectedCourse == null || _selectedAcademicYear == null) {
      _showSnackBar('Please select a course and academic year', isError: true);
      return;
    }

    if (!_isExcelUploaded || _selectedFile == null) {
      _showSnackBar('Please upload an Excel or CSV file', isError: true);
      return;
    }

    await _uploadFile();
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

  // Add a global theme function for form field decoration
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
            'Validate Grades',
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
            if (index == 6) {
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
                        decoration: getConsistentInputDecoration('Select Course'),
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
                        decoration: getConsistentInputDecoration('Select Academic Year'),
                        items: const [
                          DropdownMenuItem(value: '2022-2023', child: Text('2022-2023')),
                          DropdownMenuItem(value: '2023-2024', child: Text('2023-2024')),
                          DropdownMenuItem(value: '2024-2025', child: Text('2024-2025')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedAcademicYear = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFileUploadSection(),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _validateGrades,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text('Validate Grades'),
                      ),
                    ),
                    if (_showResults) ...[
                      const SizedBox(height: 30),
                      // Header Card
                      Card(
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.blue.shade300, width: 1.5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 24),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Mismatched Grades',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0, left: 46.0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.orange.shade300),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.error_outline, color: Colors.orange.shade800, size: 16),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${_mismatchedStudents.length} mismatches found',
                                        style: TextStyle(
                                          color: Colors.orange.shade800,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.blue.shade100),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Icon(Icons.info_outline, color: Colors.blue.shade700, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'The following grades have discrepancies between the database and the uploaded CSV file. Please review them carefully.',
                                        style: TextStyle(
                                          color: Colors.blue.shade700,
                                          fontSize: 13,
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
                      // Data Table Section
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.compare_arrows, color: Colors.blue.shade800, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Grade Comparison',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                  const Spacer(),
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      // Function to handle export or download
                                      _showSnackBar('Exporting results...');
                                    },
                                    icon: Icon(Icons.download, size: 16, color: Colors.blue.shade700),
                                    label: Text(
                                      'Export',
                                      style: TextStyle(color: Colors.blue.shade700),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      side: BorderSide(color: Colors.blue.shade300),
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
                                    dataTextStyle: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                    ),
                                    headingTextStyle: TextStyle(
                                      color: Colors.blue.shade800,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    headingRowColor: WidgetStateProperty.all(Colors.grey.shade100),
                                    columns: [
                                      DataColumn(
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: const Text('Student ID')
                                        )
                                      ),
                                      DataColumn(
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: const Text('Batch')
                                        )
                                      ),
                                      DataColumn(
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: const Text('Semester')
                                        )
                                      ),
                                      DataColumn(
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: const Text('Course ID')
                                        )
                                      ),
                                      DataColumn(
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: const Text('Remarks')
                                        )
                                      ),
                                      DataColumn(
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: const Text('Grades in DB')
                                        )
                                      ),
                                      DataColumn(
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: const Text('Grades in CSV')
                                        )
                                      ),
                                    ],
                                    rows: _mismatchedStudents
                                        .map(
                                          (data) => DataRow(
                                            cells: [
                                              DataCell(
                                                Center(
                                                  child: Text(data['Student ID'] ?? '')
                                                )
                                              ),
                                              DataCell(
                                                Center(
                                                  child: Text(data['Batch'] ?? '')
                                                )
                                              ),
                                              DataCell(
                                                Center(
                                                  child: Text(data['Semester'] ?? '')
                                                )
                                              ),
                                              DataCell(
                                                Center(
                                                  child: Text(data['Course ID'] ?? '')
                                                )
                                              ),
                                              DataCell(
                                                Center(
                                                  child: Text(data['Remarks'] ?? '')
                                                )
                                              ),
                                              DataCell(
                                                Center(
                                                  child: Text(data['Grades in DB'] ?? '')
                                                )
                                              ),
                                              DataCell(
                                                Center(
                                                  child: Text(data['Grades in CSV'] ?? '')
                                                )
                                              ),
                                            ],
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 20),
                          Text(
                            _uploadStatus ?? 'Processing...',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        // Replace with new BottomBar component
        bottomNavigationBar: const BottomBar(currentIndex: 0),
      ),
    );
  }

  Widget _buildFileUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload Excel Sheet*',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: _selectFile,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: Text(
                            _fileTextController.text.isEmpty
                                ? 'No file chosen'
                                : _fileTextController.text,
                            style: TextStyle(
                              color: _fileTextController.text.isEmpty
                                  ? Colors.grey.shade600
                                  : Colors.black,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(7.0),
                            bottomRight: Radius.circular(7.0),
                          ),
                        ),
                        child: TextButton(
                          onPressed: _selectFile,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue.shade700,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          child: Text(
                            'Browse',
                            style: TextStyle(color: Colors.blue.shade700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_isExcelUploaded)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.red.shade600),
                  onPressed: () {
                    setState(() {
                      _isExcelUploaded = false;
                      _fileTextController.text = '';
                      _selectedFile = null;
                    });
                  },
                  tooltip: 'Remove file',
                ),
              ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 12, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                'Accepts .xlsx, .xls or .csv files only',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _downloadTemplate,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Download Template',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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