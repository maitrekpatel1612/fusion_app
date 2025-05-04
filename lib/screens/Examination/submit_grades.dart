import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'examination_dashboard.dart';
import '../../utils/sidebar.dart';
import '../../utils/gesture_sidebar.dart';
import '../../utils/bottom_bar.dart'; // Import the new bottom bar component

class SubmitGradesScreen extends StatefulWidget {
  const SubmitGradesScreen({super.key});

  @override
  State<SubmitGradesScreen> createState() => _SubmitGradesScreenState();
}

class _SubmitGradesScreenState extends State<SubmitGradesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _fileTextController = TextEditingController();
  String? _selectedCourse;
  String? _selectedYear;
  String? _selectedSemester;
  bool _isFileSelected = false;
  PlatformFile? _selectedFile;
  bool _isLoading = false;
  String? _uploadStatus;

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
          _isFileSelected = true;
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
      String uploadUrl = 'https://example.com/upload';
      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));
      request.fields['course'] = _selectedCourse ?? '';
      request.fields['academicYear'] = _selectedYear ?? '';
      request.fields['semester'] = _selectedSemester ?? '';
      request.files.add(
        await http.MultipartFile.fromPath(
          'gradeSheet',
          _selectedFile!.path!,
        ),
      );

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _uploadStatus = 'Upload successful!';
        _isLoading = false;
      });

      _showSubmissionConfirmation();
    } catch (e) {
      setState(() {
        _uploadStatus = 'Upload failed: $e';
        _isLoading = false;
      });

      _showSnackBar('Error uploading file: $e', isError: true);
    }
  }

  void _downloadTemplate() async {
    setState(() {
      _isLoading = true;
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

  void _submitGrades() async {
    if (_selectedCourse == null || _selectedYear == null || _selectedSemester == null) {
      _showSnackBar('Please fill all required fields', isError: true);
      return;
    }

    if (!_isFileSelected || _selectedFile == null) {
      _showSnackBar('Please select an Excel or CSV file', isError: true);
      return;
    }

    await _uploadFile();
  }

  void _showSubmissionConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green.shade500),
              const SizedBox(width: 8),
              const Text('Submission Successful'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'File: ${_selectedFile!.name}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Course: $_selectedCourse'),
              Text('Academic Year: $_selectedYear'),
              Text('Semester: $_selectedSemester'),
              const SizedBox(height: 16),
              const Text(
                'The grades have been successfully submitted. Faculty will review them shortly.',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CLOSE'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExaminationDashboard(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('GO TO DASHBOARD'),
            ),
          ],
        );
      },
    );
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

  // Add a helper method to create consistent input decorations
  InputDecoration getInputDecoration(String hint) {
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
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(
            'Submit Grades',
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
            if (index == 3) {
              // Already on Submit Grades screen
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
                        decoration: getInputDecoration('Select Course'),
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
                        icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade700),
                        dropdownColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Academic Year*',
                      child: DropdownButtonFormField<String>(
                        decoration: getInputDecoration('Select Academic Year'),
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
                        icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade700),
                        dropdownColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Semester*',
                      child: DropdownButtonFormField<String>(
                        decoration: getInputDecoration('Select Semester'),
                        items: const [
                          DropdownMenuItem(value: 'Fall', child: Text('Fall')),
                          DropdownMenuItem(value: 'Spring', child: Text('Spring')),
                          DropdownMenuItem(value: 'Summer', child: Text('Summer')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedSemester = value;
                          });
                        },
                        icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade700),
                        dropdownColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFormField(
                      label: 'Upload Excel Sheet*',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
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
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline, size: 12, color: Colors.grey.shade600),
                                const SizedBox(width: 4),
                                Text(
                                  'Accepts .xlsx, .xls or .csv files only',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_isFileSelected && _selectedFile != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                _getFileIcon(_selectedFile!.name),
                                color: _selectedFile!.name.endsWith('.csv')
                                    ? Colors.blue
                                    : Colors.green,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _selectedFile!.name,
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    Text(
                                      _formatFileSize(_selectedFile!.size),
                                      style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.close, color: Colors.red, size: 20),
                                onPressed: () {
                                  setState(() {
                                    _isFileSelected = false;
                                    _fileTextController.text = '';
                                    _selectedFile = null;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _downloadTemplate,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                side: BorderSide(color: Colors.blue.shade700, width: 1.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: const Text('Download Template'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _submitGrades,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                backgroundColor: Colors.blue.shade700,
                                foregroundColor: Colors.white,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: const Text('Submit Grades'),
                            ),
                          ),
                        ],
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

  IconData _getFileIcon(String fileName) {
    String extension = path.extension(fileName).toLowerCase();

    if (extension == '.csv') {
      return Icons.description;
    } else if (extension == '.xlsx' || extension == '.xls') {
      return Icons.table_chart;
    } else {
      return Icons.insert_drive_file;
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      double kb = bytes / 1024;
      return '${kb.toStringAsFixed(1)} KB';
    } else {
      double mb = bytes / (1024 * 1024);
      return '${mb.toStringAsFixed(1)} MB';
    }
  }
}