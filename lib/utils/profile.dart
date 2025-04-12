import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../services/user_preferences_service.dart';
import 'bottom_bar.dart'; // Import the bottom bar
import 'sidebar.dart';
import 'gesture_sidebar.dart'; // Import the gesture sidebar

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Add scaffold key
  // User information (this would typically come from a state management solution or API)
  final Map<String, dynamic> _userData = {
    'name': 'Maitrek Patel',
    'email': 'maitrek.patel@example.com',
    'phone': '+91 9876543210',
    'position':
        'Faculty Member', // Default value, will be updated from preferences
    'department': 'Computer Science',
    'employeeId': 'FAC-2023-001',
    'dateJoined': 'August 15, 2018',
    'address': '123 University Campus, Academic Block B, Gujarat, India',
    'skills': [
      'Flutter Development',
      'Machine Learning',
      'Database Systems',
      'Algorithm Design'
    ],
    'education': [
      {
        'degree': 'Ph.D in Computer Science',
        'institution': 'Gujarat Technological University',
        'year': '2016'
      },
      {
        'degree': 'M.Tech in Information Technology',
        'institution': 'DAIICT',
        'year': '2012'
      },
      {
        'degree': 'B.Tech in Computer Engineering',
        'institution': 'Gujarat University',
        'year': '2010'
      }
    ],
    'publications': [
      {
        'title': 'Advancements in Mobile Application Development with Flutter',
        'journal': 'International Journal of Mobile Computing',
        'year': '2022'
      },
      {
        'title': 'Efficient Algorithms for Educational Data Mining',
        'journal': 'Journal of Educational Technology',
        'year': '2020'
      }
    ]
  };

  final Map<String, Color> _positionColors = {
    'Faculty Member': Colors.blue,
    'Dean': Colors.purple,
    'HOD': Colors.teal,
    'Student': const Color(0xFF0D47A1), // Dark blue color
    'Admin': Colors.deepPurple,
  };

  final Map<String, IconData> _positionIcons = {
    'Faculty Member': Icons.school,
    'Dean': Icons.architecture,
    'HOD': Icons.account_balance,
    'Student': Icons.person_outline,
    'Admin': Icons.admin_panel_settings,
  };

  // Position options dropdown
  bool _showPositionOptions = false;
  final List<String> _positions = [
    'Faculty Member',
    'Dean',
    'HOD',
    'Student',
    'Admin',
  ];

  bool _isEditMode = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _employeeIdController = TextEditingController();
  final TextEditingController _dateJoinedController = TextEditingController();

  // For adding new skills
  final TextEditingController _newSkillController = TextEditingController();

  // For editing education entries
  List<Map<String, TextEditingController>> _educationControllers = [];

  // For editing publication entries
  List<Map<String, TextEditingController>> _publicationControllers = [];

  String? _profileImagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserPosition();
    _initializeControllers();
  }

  Future<void> _loadUserPosition() async {
    // Load the saved position from preferences
    final savedPosition = await UserPreferencesService.getPosition();
    setState(() {
      _userData['position'] = savedPosition;
    });
  }

  void _initializeControllers() {
    // Basic info controllers
    _nameController.text = _userData['name'];
    _emailController.text = _userData['email'];
    _phoneController.text = _userData['phone'];
    _addressController.text = _userData['address'];
    _departmentController.text = _userData['department'];
    _employeeIdController.text = _userData['employeeId'];
    _dateJoinedController.text = _userData['dateJoined'];

    // Initialize education controllers
    _educationControllers = List.generate(
      _userData['education'].length,
      (index) => {
        'degree': TextEditingController(
            text: _userData['education'][index]['degree']),
        'institution': TextEditingController(
            text: _userData['education'][index]['institution']),
        'year':
            TextEditingController(text: _userData['education'][index]['year']),
      },
    );

    // Initialize publication controllers
    _publicationControllers = List.generate(
      _userData['publications'].length,
      (index) => {
        'title': TextEditingController(
            text: _userData['publications'][index]['title']),
        'journal': TextEditingController(
            text: _userData['publications'][index]['journal']),
        'year': TextEditingController(
            text: _userData['publications'][index]['year']),
      },
    );
  }

  @override
  void dispose() {
    // Dispose basic info controllers
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _departmentController.dispose();
    _employeeIdController.dispose();
    _dateJoinedController.dispose();
    _newSkillController.dispose();

    // Dispose education controllers
    for (var controllers in _educationControllers) {
      controllers.forEach((key, controller) {
        controller.dispose();
      });
    }

    // Dispose publication controllers
    for (var controllers in _publicationControllers) {
      controllers.forEach((key, controller) {
        controller.dispose();
      });
    }

    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _profileImagePath = image.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to pick image'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _toggleEditMode() {
    setState(() {
      if (_isEditMode) {
        // Save the changes
        _saveChanges();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
      _isEditMode = !_isEditMode;
    });
  }

  void _saveChanges() {
    // Save basic info
    _userData['name'] = _nameController.text;
    _userData['email'] = _emailController.text;
    _userData['phone'] = _phoneController.text;
    _userData['address'] = _addressController.text;
    _userData['department'] = _departmentController.text;
    _userData['employeeId'] = _employeeIdController.text;
    _userData['dateJoined'] = _dateJoinedController.text;

    // Save education info
    for (int i = 0; i < _educationControllers.length; i++) {
      _userData['education'][i]['degree'] =
          _educationControllers[i]['degree']!.text;
      _userData['education'][i]['institution'] =
          _educationControllers[i]['institution']!.text;
      _userData['education'][i]['year'] =
          _educationControllers[i]['year']!.text;
    }

    // Save publication info
    for (int i = 0; i < _publicationControllers.length; i++) {
      _userData['publications'][i]['title'] =
          _publicationControllers[i]['title']!.text;
      _userData['publications'][i]['journal'] =
          _publicationControllers[i]['journal']!.text;
      _userData['publications'][i]['year'] =
          _publicationControllers[i]['year']!.text;
    }
  }

  void _addSkill() {
    if (_newSkillController.text.trim().isNotEmpty) {
      setState(() {
        _userData['skills'].add(_newSkillController.text.trim());
        _newSkillController.clear();
      });
    }
  }

  void _removeSkill(int index) {
    setState(() {
      _userData['skills'].removeAt(index);
    });
  }

  void _addEducation() {
    setState(() {
      _userData['education'].add({
        'degree': 'New Degree',
        'institution': 'Institution Name',
        'year': DateTime.now().year.toString(),
      });

      _educationControllers.add({
        'degree': TextEditingController(text: 'New Degree'),
        'institution': TextEditingController(text: 'Institution Name'),
        'year': TextEditingController(text: DateTime.now().year.toString()),
      });
    });
  }

  void _removeEducation(int index) {
    setState(() {
      _userData['education'].removeAt(index);

      // Dispose controllers before removing them
      _educationControllers[index].forEach((key, controller) {
        controller.dispose();
      });
      _educationControllers.removeAt(index);
    });
  }

  void _addPublication() {
    setState(() {
      _userData['publications'].add({
        'title': 'New Publication',
        'journal': 'Journal Name',
        'year': DateTime.now().year.toString(),
      });

      _publicationControllers.add({
        'title': TextEditingController(text: 'New Publication'),
        'journal': TextEditingController(text: 'Journal Name'),
        'year': TextEditingController(text: DateTime.now().year.toString()),
      });
    });
  }

  void _removePublication(int index) {
    setState(() {
      _userData['publications'].removeAt(index);

      // Dispose controllers before removing them
      _publicationControllers[index].forEach((key, controller) {
        controller.dispose();
      });
      _publicationControllers.removeAt(index);
    });
  }

  String _getPositionDescription(String position) {
    switch (position) {
      case 'Faculty Member':
        return 'Teaching and research role';
      case 'Dean':
        return 'Academic leadership position';
      case 'HOD':
        return 'Department leadership role';
      case 'Student':
        return 'Enrolled in academic program';
      case 'Admin':
        return 'Administrative staff member';
      default:
        return '';
    }
  }

  void _changePosition(String position) async {
    setState(() {
      _userData['position'] = position;
      _showPositionOptions = false;
    });

    // Save the position to preferences for persistence across app
    await UserPreferencesService.savePosition(position);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Position changed to $position'),
        duration: const Duration(seconds: 2),
        backgroundColor: _positionColors[position],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor =
        _positionColors[_userData['position']] ?? Colors.blue;

    return GestureSidebar(
      scaffoldKey: _scaffoldKey,
      edgeWidthFactor: 1.0, // Allow swipe from anywhere on screen
      child: Scaffold(
        key: _scaffoldKey, // Use the scaffold key
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          elevation: 0,
          backgroundColor: primaryColor,
          iconTheme: const IconThemeData(color: Colors.white), // Set menu icon to white
        ),
        drawer: const Sidebar(), // Add Sidebar as a drawer
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile header with gradient
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Profile image
                    GestureDetector(
                      onTap: _isEditMode ? _pickImage : null,
                      child: Stack(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: _profileImagePath != null
                                  ? Image.file(
                                      File(_profileImagePath!),
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/profile.jpg',
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return CircleAvatar(
                                          backgroundColor: Colors.grey.shade200,
                                          child: Icon(
                                            _positionIcons[
                                                    _userData['position']] ??
                                                Icons.person,
                                            size: 60,
                                            color: primaryColor,
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ),
                          if (_isEditMode)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: primaryColor,
                                  size: 20,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Name field
                    _isEditMode
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: TextField(
                              controller: _nameController,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter your name',
                                hintStyle: TextStyle(
                                    color: Colors.white.withOpacity(0.7)),
                                border: InputBorder.none,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white.withOpacity(0.5)),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Text(
                            _userData['name'],
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                    const SizedBox(height: 10),
                    // Position badge with dropdown option
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showPositionOptions = !_showPositionOptions;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.5), width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _positionIcons[_userData['position']] ??
                                  Icons.person,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _userData['position'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              _showPositionOptions
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Position options dropdown
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 300),
                      crossFadeState: _showPositionOptions
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.swap_horiz,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'SWITCH POSITION',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    color: Colors.white,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ...List.generate(_positions.length, (index) {
                              final position = _positions[index];
                              final isSelected =
                                  position == _userData['position'];
                              return GestureDetector(
                                onTap: () {
                                  _changePosition(position);
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.white.withOpacity(0.3)
                                        : Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.2),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Colors.white.withOpacity(0.3)
                                              : Colors.white.withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          _positionIcons[position],
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            position,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            _getPositionDescription(position),
                                            style: TextStyle(
                                              fontSize: 11,
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      if (isSelected)
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.check,
                                            size: 12,
                                            color: primaryColor,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      secondChild: const SizedBox(height: 0),
                    ),

                    const SizedBox(height: 15),
                  ],
                ),
              ),

              // Contact Info Section
              _buildSectionHeader(
                primaryColor,
                'Contact Information',
                null,
                null,
              ),
              _buildContactInfoCard(primaryColor),

              // Professional Details Section
              _buildSectionHeader(
                primaryColor,
                'Professional Details',
                null,
                null,
              ),
              _buildProfessionalCard(primaryColor),

              // Education Section
              _buildSectionHeader(
                primaryColor,
                'Education',
                _isEditMode ? Icons.add : null,
                _isEditMode ? () => _addEducation() : null,
              ),
              ..._buildEducationCards(primaryColor),

              // Publications Section
              _buildSectionHeader(
                primaryColor,
                'Publications',
                _isEditMode ? Icons.add : null,
                _isEditMode ? () => _addPublication() : null,
              ),
              ..._buildPublicationCards(primaryColor),

              // Skills Section
              _buildSectionHeader(
                primaryColor,
                'Skills',
                null,
                null,
              ),
              _buildSkillsCard(primaryColor),

              const SizedBox(height: 30),
            ],
          ),
        ),
        // Add bottom bar with correct index
        bottomNavigationBar: const BottomBar(currentIndex: 3),
      ),
    );
  }

  Widget _buildSectionHeader(
    Color primaryColor,
    String title,
    IconData? actionIcon,
    VoidCallback? onActionPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
      child: Row(
        children: [
          Container(
            height: 25,
            width: 5,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const Spacer(),
          if (actionIcon != null)
            IconButton(
              icon: Icon(actionIcon, color: primaryColor),
              onPressed: onActionPressed,
              tooltip: actionIcon == Icons.add ? 'Add new entry' : null,
            ),
        ],
      ),
    );
  }

  Widget _buildContactInfoCard(Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              // Email field
              _buildContactField(
                icon: Icons.email,
                title: 'Email',
                controller: _emailController,
                value: _userData['email'],
                primaryColor: primaryColor,
              ),
              const SizedBox(height: 15),
              const Divider(),
              const SizedBox(height: 15),
              // Phone field
              _buildContactField(
                icon: Icons.phone,
                title: 'Phone',
                controller: _phoneController,
                value: _userData['phone'],
                primaryColor: primaryColor,
              ),
              const SizedBox(height: 15),
              const Divider(),
              const SizedBox(height: 15),
              // Address field
              _buildContactField(
                icon: Icons.location_on,
                title: 'Address',
                controller: _addressController,
                value: _userData['address'],
                primaryColor: primaryColor,
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactField({
    required IconData icon,
    required String title,
    required TextEditingController controller,
    required String value,
    required Color primaryColor,
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment:
          maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: primaryColor),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 5),
              _isEditMode
                  ? TextField(
                      controller: controller,
                      maxLines: maxLines,
                      decoration: InputDecoration(
                        hintText: 'Enter your $title',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfessionalCard(Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              _buildProfessionalField(
                icon: Icons.business,
                title: 'Department',
                controller: _departmentController,
                value: _userData['department'],
                primaryColor: primaryColor,
              ),
              const SizedBox(height: 15),
              const Divider(),
              const SizedBox(height: 15),
              _buildProfessionalField(
                icon: Icons.badge,
                title: 'Employee ID',
                controller: _employeeIdController,
                value: _userData['employeeId'],
                primaryColor: primaryColor,
              ),
              const SizedBox(height: 15),
              const Divider(),
              const SizedBox(height: 15),
              _buildProfessionalField(
                icon: Icons.calendar_today,
                title: 'Date Joined',
                controller: _dateJoinedController,
                value: _userData['dateJoined'],
                primaryColor: primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfessionalField({
    required IconData icon,
    required String title,
    required TextEditingController controller,
    required String value,
    required Color primaryColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: primaryColor),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 5),
              _isEditMode
                  ? TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: 'Enter $title',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildEducationCards(Color primaryColor) {
    List<Widget> cards = [];
    for (int i = 0; i < _userData['education'].length; i++) {
      cards.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Card(
            elevation: 5,
            shadowColor: Colors.black.withOpacity(0.2),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.school, color: primaryColor),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _isEditMode
                            ? TextField(
                                controller: _educationControllers[i]['degree'],
                                decoration: const InputDecoration(
                                  hintText: 'Enter degree',
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 8),
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Text(
                                _userData['education'][i]['degree'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      if (_isEditMode)
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red.shade400),
                          onPressed: () => _removeEducation(i),
                        ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _isEditMode
                            ? TextField(
                                controller: _educationControllers[i]
                                    ['institution'],
                                decoration: const InputDecoration(
                                  hintText: 'Enter institution',
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 8),
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              )
                            : Text(
                                _userData['education'][i]['institution'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              'Graduated: ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Expanded(
                              child: _isEditMode
                                  ? TextField(
                                      controller: _educationControllers[i]
                                          ['year'],
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        hintText: 'Enter year',
                                        isDense: true,
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 8),
                                        border: InputBorder.none,
                                      ),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade800,
                                      ),
                                    )
                                  : Text(
                                      _userData['education'][i]['year'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade800,
                                      ),
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
          ),
        ),
      );
    }
    return cards;
  }

  List<Widget> _buildPublicationCards(Color primaryColor) {
    List<Widget> cards = [];
    for (int i = 0; i < _userData['publications'].length; i++) {
      cards.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Card(
            elevation: 5,
            shadowColor: Colors.black.withOpacity(0.2),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.article, color: primaryColor),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _isEditMode
                            ? TextField(
                                controller: _publicationControllers[i]['title'],
                                decoration: const InputDecoration(
                                  hintText: 'Enter publication title',
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 8),
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Text(
                                _userData['publications'][i]['title'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      if (_isEditMode)
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red.shade400),
                          onPressed: () => _removePublication(i),
                        ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _isEditMode
                            ? TextField(
                                controller: _publicationControllers[i]
                                    ['journal'],
                                decoration: const InputDecoration(
                                  hintText: 'Enter journal name',
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 8),
                                  border: InputBorder.none,
                                ),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              )
                            : Text(
                                _userData['publications'][i]['journal'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              'Published: ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Expanded(
                              child: _isEditMode
                                  ? TextField(
                                      controller: _publicationControllers[i]
                                          ['year'],
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        hintText: 'Enter year',
                                        isDense: true,
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 8),
                                        border: InputBorder.none,
                                      ),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade800,
                                      ),
                                    )
                                  : Text(
                                      _userData['publications'][i]['year'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade800,
                                      ),
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
          ),
        ),
      );
    }
    return cards;
  }

  Widget _buildSkillsCard(Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isEditMode) ...[
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _newSkillController,
                        decoration: const InputDecoration(
                          hintText: 'Add a new skill',
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _addSkill,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                      child: const Text('Add'),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Divider(),
                const SizedBox(height: 10),
              ],
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(_userData['skills'].length, (index) {
                  return Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: primaryColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          _userData['skills'][index],
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (_isEditMode)
                        Positioned(
                          right: -5,
                          top: -5,
                          child: GestureDetector(
                            onTap: () => _removeSkill(index),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red.shade400,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 1),
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
