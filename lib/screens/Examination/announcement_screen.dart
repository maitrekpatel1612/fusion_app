import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import '../../utils/sidebar.dart';
import 'examination_dashboard.dart';
import '../../utils/gesture_sidebar.dart';
import '../../utils/bottom_bar.dart'; // Import the new bottom bar component

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({super.key});

  @override
  State<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _fileTextController = TextEditingController();
  final List<UploadFile> _selectedFiles = [];
  final ImagePicker _picker = ImagePicker();
  bool _isBrowseMode = false;
  PlatformFile? _selectedFile;
  bool _isFileSelected = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (!mounted) return;

      if (pickedFile != null) {
        setState(() {
          final file = UploadFile(
            file: File(pickedFile.path),
            name: path.basename(pickedFile.path),
            type: 'image',
          );
          _selectedFiles.add(file);
          _updateFileTextController();
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Image selected: ${path.basename(pickedFile.path)}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
        allowMultiple: false,
      );

      if (!mounted) return;

      if (result != null) {
        PlatformFile platformFile = result.files.first;
        File file = File(platformFile.path!);

        setState(() {
          final uploadFile = UploadFile(
            file: file,
            name: platformFile.name,
            type: 'document',
          );
          _selectedFiles.add(uploadFile);
          _updateFileTextController();
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Document selected: ${platformFile.name}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking document: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _selectFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls', 'csv'],
        allowMultiple: false,
        // Apply a blue theme to the file picker
        dialogTitle: 'Select Excel File',
        allowCompression: true,
      );

      if (result != null) {
        setState(() {
          _selectedFile = result.files.first;
          _isFileSelected = true;
          _fileTextController.text = _selectedFile!.name;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File selected: ${_selectedFile!.name}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking file: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickMultipleFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
      );

      if (!mounted) return;

      if (result != null) {
        setState(() {
          for (PlatformFile platformFile in result.files) {
            // Determine file type based on extension
            String fileType = 'document';
            final extension = platformFile.extension?.toLowerCase() ?? '';
            if (['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(extension)) {
              fileType = 'image';
            } else if (['pdf', 'doc', 'docx', 'txt'].contains(extension)) {
              fileType = 'document';
            }

            final uploadFile = UploadFile(
              file: File(platformFile.path!),
              name: platformFile.name,
              type: fileType,
            );
            _selectedFiles.add(uploadFile);
          }
          _updateFileTextController();
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${result.files.length} file(s) selected'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking files: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _updateFileTextController() {
    if (_selectedFiles.isEmpty) {
      _fileTextController.text = '';
    } else if (_selectedFiles.length == 1) {
      _fileTextController.text = _selectedFiles.first.name;
    } else {
      _fileTextController.text = '${_selectedFiles.length} files selected';
    }
  }

  void _showFilePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: const Text('Document'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickDocument();
                },
              ),
              ListTile(
                leading: const Icon(Icons.file_upload),
                title: const Text('Select Multiple Files'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickMultipleFiles();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _toggleMode() {
    setState(() {
      _isBrowseMode = !_isBrowseMode;
    });
  }

  @override
  void dispose() {
    _fileTextController.dispose();
    super.dispose();
  }

  // Add helper method to create consistent input decoration
  InputDecoration getConsistentInputDecoration(String hintText) {
    return InputDecoration(
      border: const OutlineInputBorder(),
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

  // Show announcement details in bottom sheet
  void _showAnnouncementDetails(AnnouncementItem announcement) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 12),
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),

                  // Header with module badge
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.indigo.shade200),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.campaign_outlined,
                                size: 16,
                                color: Colors.indigo.shade700,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                announcement.department,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.indigo.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          announcement.date,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Title
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    child: Text(
                      announcement.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                  ),

                  const Divider(),

                  // Content - scrollable
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            announcement.description,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade800,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),

                          if (announcement.hasAttachment)
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.blue.shade100),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.attach_file,
                                      size: 20,
                                      color: Colors.blue.shade900,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Attachment.pdf',
                                          style: TextStyle(
                                            color: Colors.blue.shade900,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          '245 KB',
                                          style: TextStyle(
                                            color: Colors.grey.shade800,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Downloading...'),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade900,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      textStyle: const TextStyle(
                                          fontWeight: FontWeight.w500, fontSize: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Download'),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
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
            'Announcements',
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
            if (index == 2) {
              // Already on Announcement screen
            } else if (index == 0) {
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Navigating to ${_getScreenName(index)}'),
                  duration: const Duration(seconds: 1),
                ),
              );
            }
          },
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_isBrowseMode) {
                          _toggleMode();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isBrowseMode ? Colors.blue.shade50 : Colors.blue,
                        foregroundColor:
                            _isBrowseMode ? Colors.blue : Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.notifications,
                            color: _isBrowseMode ? Colors.blue : Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Make New',
                            style: TextStyle(
                              color: _isBrowseMode ? Colors.blue : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _toggleMode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _isBrowseMode ? Colors.blue : Colors.blue.shade50,
                        foregroundColor:
                            _isBrowseMode ? Colors.white : Colors.blue,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.folder_open,
                            color: _isBrowseMode ? Colors.white : Colors.blue,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Browse',
                            style: TextStyle(
                              color: _isBrowseMode ? Colors.white : Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (!_isBrowseMode) ...[
                  _buildFormField(
                    label: 'Programme*',
                    child: DropdownButtonFormField<String>(
                      items: const [
                        DropdownMenuItem(
                            value: 'Programme 1', child: Text('Programme 1')),
                        DropdownMenuItem(
                            value: 'Programme 2', child: Text('Programme 2')),
                      ],
                      onChanged: (value) {},
                      decoration: getConsistentInputDecoration('Select Programme'),
                      icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade700),
                      dropdownColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    label: 'Batch*',
                    child: DropdownButtonFormField<String>(
                      items: const [
                        DropdownMenuItem(
                            value: 'Batch 1', child: Text('Batch 1')),
                        DropdownMenuItem(
                            value: 'Batch 2', child: Text('Batch 2')),
                      ],
                      onChanged: (value) {},
                      decoration: getConsistentInputDecoration('Select Batch'),
                      icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade700),
                      dropdownColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    label: 'Department*',
                    child: DropdownButtonFormField<String>(
                      items: const [
                        DropdownMenuItem(
                            value: 'Department 1', child: Text('Department 1')),
                        DropdownMenuItem(
                            value: 'Department 2', child: Text('Department 2')),
                      ],
                      onChanged: (value) {},
                      decoration: getConsistentInputDecoration('Select Department'),
                      icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade700),
                      dropdownColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    label: 'Description',
                    child: TextField(
                      maxLines: 5,
                      decoration: getConsistentInputDecoration('Write here...'),
                      cursorColor: Colors.blue.shade700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFormField(
                    label: 'Attach Files',
                    child: TextField(
                      controller: _fileTextController,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        hintText: 'Upload Files (PDF, JPEG, PNG, JPG)',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.upload_file, color: Colors.blue.shade700),
                          onPressed: _showFilePickerOptions,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                      ),
                      onTap: _showFilePickerOptions,
                      cursorColor: Colors.blue.shade700,
                    ),
                  ),
                  if (_selectedFiles.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Selected Files:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: _selectedFiles
                                  .map((file) => _buildFileItem(file))
                                  .toList(),
                            ),
                          ),
                        ],
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 16),
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                    ),
                                    child: Text(
                                      'Browse',
                                      style: TextStyle(
                                          color: Colors.blue.shade700),
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
                              Icon(Icons.info_outline,
                                  size: 12, color: Colors.grey.shade600),
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.insert_drive_file,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedFile!.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  Text(
                                    '${(_selectedFile!.size / 1024).toStringAsFixed(1)} KB',
                                    style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.close,
                                  color: Colors.red, size: 20),
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
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_selectedFiles.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Files uploaded successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Announcement published!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Publish',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _dummyAnnouncements.length,
                    itemBuilder: (context, index) {
                      final announcement = _dummyAnnouncements[index];
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300.withOpacity(0.5),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              _showAnnouncementDetails(announcement);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.campaign_outlined,
                                                size: 12, color: Colors.blue.shade700),
                                            const SizedBox(width: 4),
                                            Text(
                                              announcement.department,
                                              style: TextStyle(
                                                color: Colors.blue.shade700,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        announcement.date,
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    announcement.title,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    announcement.description,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade800,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (announcement.hasAttachment)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.attach_file,
                                            size: 14,
                                            color: Colors.blue.shade700,
                                          ),
                                          const SizedBox(width: 3),
                                          Text(
                                            'Attachment',
                                            style: TextStyle(
                                              color: Colors.blue.shade700,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11,
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
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
        bottomNavigationBar: const BottomBar(currentIndex: 0),
      ),
    );
  }

  Widget _buildFileItem(UploadFile file) {
    IconData fileIcon;
    Color iconColor;

    if (file.type == 'document') {
      fileIcon = Icons.picture_as_pdf;
      iconColor = Colors.red;
    } else {
      fileIcon = Icons.image;
      iconColor = Colors.blue;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(fileIcon, color: iconColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
                if (file.file != null)
                  Text(
                    'Size: ${(file.file!.lengthSync() / 1024).toStringAsFixed(1)} KB',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18, color: Colors.red),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              setState(() {
                _selectedFiles.remove(file);
                _updateFileTextController();
              });
            },
          ),
          if (file.file != null && file.type == 'image')
            IconButton(
              icon: const Icon(Icons.visibility, size: 18, color: Colors.blue),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                _showImagePreview(file);
              },
            ),
        ],
      ),
    );
  }

  void _showImagePreview(UploadFile file) {
    if (file.file == null) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: Text(file.name),
              elevation: 0,
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Image.file(
              file.file!,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
          ],
        ),
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

  Widget _buildAnnouncementLogo(String sender) {
    final int hash = sender.hashCode;
    final List<String> logoImages = [
      'https://picsum.photos/id/237/200/200',
      'https://picsum.photos/id/24/200/200',
      'https://picsum.photos/id/96/200/200',
      'https://picsum.photos/id/433/200/200',
      'https://picsum.photos/id/870/200/200',
    ];

    final int imageIndex = hash.abs() % logoImages.length;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          width: 50,
          height: 50,
          color: Colors.white,
          child: Image.network(
            logoImages[imageIndex],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  sender[0],
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: Text(
                  sender[0],
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String _getTruncatedDescription(String text) {
    if (text.length <= 100) {
      return text;
    }
    return '${text.substring(0, 100)}...';
  }

  Widget _buildCompactTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: Colors.blue.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class UploadFile {
  final File? file;
  final String name;
  final String type;

  UploadFile({
    required this.file,
    required this.name,
    required this.type,
  });
}

class AnnouncementDetailScreen extends StatelessWidget {
  final AnnouncementItem announcement;

  const AnnouncementDetailScreen({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    final int hash = announcement.sender.hashCode;
    final List<String> logoImages = [
      'https://picsum.photos/id/237/200/200',
      'https://picsum.photos/id/24/200/200',
      'https://picsum.photos/id/96/200/200',
      'https://picsum.photos/id/433/200/200',
      'https://picsum.photos/id/870/200/200',
    ];

    final int imageIndex = hash.abs() % logoImages.length;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        toolbarHeight: 0,
        title: null,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.blue.shade900,
                    Colors.blue.shade700,
                  ],
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        width: 50,
                        height: 50,
                        color: Colors.white,
                        child: Image.network(
                          logoImages[imageIndex],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                announcement.sender[0],
                                style: TextStyle(
                                  color: Colors.blue.shade900,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: Text(
                                announcement.sender[0],
                                style: TextStyle(
                                  color: Colors.blue.shade900,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          announcement.sender,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          announcement.date,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildHighContrastTag('Academics'),
                            const SizedBox(width: 6),
                            _buildHighContrastTag('BTech'),
                            const SizedBox(width: 6),
                            _buildHighContrastTag('CSE'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade100.withOpacity(0.5),
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      announcement.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      announcement.description,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade900,
                        height: 1.5,
                      ),
                    ),
                  ),
                  if (announcement.hasAttachment)
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.attach_file,
                              size: 20,
                              color: Colors.blue.shade900,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Attachment.pdf',
                                  style: TextStyle(
                                    color: Colors.blue.shade900,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '245 KB',
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Downloading...'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade900,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 2,
                            ),
                            child: const Text('Download'),
                          ),
                        ],
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

  Widget _buildHighContrastTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: Colors.blue.shade900,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class AnnouncementItem {
  final String sender;
  final String department;
  final String date;
  final String title;
  final String description;
  final bool hasAttachment;

  AnnouncementItem({
    required this.sender,
    required this.department,
    required this.date,
    required this.title,
    required this.description,
    this.hasAttachment = false,
  });
}

final List<AnnouncementItem> _dummyAnnouncements = [
  AnnouncementItem(
    sender: 'Dr. Sarah Johnson',
    department: 'CSE',
    date: '22 Jun 2023',
    title: 'Important - Final Examination Schedule',
    description:
        'The final examination for CS301 will be held on July 15, 2023 in Room 204. Please bring your student ID and necessary stationery. No electronic devices allowed except for approved calculators.',
    hasAttachment: true,
  ),
  AnnouncementItem(
    sender: 'Prof. Michael Chen',
    department: 'Engineering',
    date: '18 Jun 2023',
    title: 'Workshop on AI and Machine Learning',
    description:
        'We are pleased to announce a workshop on AI and Machine Learning taking place next week. All engineering students are encouraged to attend. This is a great opportunity to enhance your skills in this rapidly growing field.',
    hasAttachment: false,
  ),
  AnnouncementItem(
    sender: 'Admin Office',
    department: 'Admin',
    date: '15 Jun 2023',
    title: 'Holiday Notice - University Foundation Day',
    description:
        'This is to inform all students and faculty that the university will remain closed on June 30th to celebrate the University Foundation Day. All classes and administrative work will resume on July 1st.',
    hasAttachment: false,
  ),
  AnnouncementItem(
    sender: 'Library Services',
    department: 'Library',
    date: '10 Jun 2023',
    title: 'Extended Library Hours During Finals Week',
    description:
        'The university library will extend its operating hours from 7 AM to midnight during the finals week (July 10-21). Additional study spaces will be available on the second floor.',
    hasAttachment: true,
  ),
  AnnouncementItem(
    sender: 'Dr. Emily Rodriguez',
    department: 'Mathematics',
    date: '05 Jun 2023',
    title: 'Math Tutoring Sessions Available',
    description:
        'Free math tutoring sessions will be available for all students facing difficulties in Calculus I, II, and Linear Algebra. Sessions will be held every Tuesday and Thursday from 3-5 PM in Room 105.',
    hasAttachment: false,
  ),
];
