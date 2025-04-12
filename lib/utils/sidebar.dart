import 'package:flutter/material.dart';
import '../services/user_preferences_service.dart';
import '../screens/Examination/examination_dashboard.dart';
import '../screens/Examination/submit_grades.dart';
import '../screens/Examination/update_grades.dart';
import '../screens/Examination/result.dart';
import 'home.dart'; // Import home screen
import 'help.dart'; // Import help screen
import 'profile.dart'; // Import profile screen

class Sidebar extends StatefulWidget {
  final Function(int)? onItemSelected;

  const Sidebar({super.key, this.onItemSelected});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> with TickerProviderStateMixin {
  bool _isExaminationExpanded = false;
  bool _isFileTrackingExpanded = false;
  bool _isPurchaseExpanded = false;
  bool _isProgrammeExpanded = false;
  bool _isPatentExpanded = false;
  bool _isInventoryExpanded = false;
  bool _isEventManagementExpanded = false;
  bool _isResearchExpanded = false;
  bool _isFinanceExpanded = false;
  bool _isPlacementExpanded = false;
  bool _isHumanResourcesExpanded = false;
  bool _isLibraryManagementExpanded = false;
  bool _isHostelManagementExpanded = false;
  bool _isAlumniNetworkExpanded = false;
  bool _showPositionOptions = false;
  String _currentPosition = 'Faculty Member';
  
  // Animation controllers for each module
  late Map<String, AnimationController> _animationControllers;
  
  final List<String> _positions = [
    'Faculty Member',
    'Dean',
    'HOD',
    'Student',
    'Admin',
  ];

  // Map position to icon and color
  final Map<String, IconData> _positionIcons = {
    'Faculty Member': Icons.school,
    'Dean': Icons.architecture,
    'HOD': Icons.account_balance,
    'Student': Icons.person_outline,
    'Admin': Icons.admin_panel_settings,
  };

  final Map<String, Color> _positionColors = {
    'Faculty Member': Colors.blue,
    'Dean': Colors.purple,
    'HOD': Colors.teal,
    'Student': const Color(0xFF0D47A1), // Dark blue color
    'Admin': Colors.deepPurple,
  };

  // Updated map for user images - using only local assets
  final Map<String, String> _userImages = {
    'Faculty Member': 'assets/profile.jpg',
    'Dean': 'assets/profile.jpg',
    'HOD': 'assets/profile.jpg',
    'Student': 'assets/profile.jpg',
    'Admin': 'assets/profile.jpg',
  };

  @override
  void initState() {
    super.initState();
    _loadSavedPosition();
    
    // Initialize animation controllers for each module
    _animationControllers = {
      'examination': AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
      'fileTracking': AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
      'purchase': AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
      'programme': AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
      'patent': AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
      'inventory': AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
      'eventManagement': AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
      'research': AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
      'finance': AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
      'placement': AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
      'humanResources': AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
      'libraryManagement': AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
      'hostelManagement': AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
      'alumniNetwork': AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    };
  }

  @override
  void dispose() {
    // Dispose all animation controllers
    for (var controller in _animationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadSavedPosition() async {
    try {
      final savedPosition = await UserPreferencesService.getPosition();
      setState(() {
        _currentPosition = savedPosition;
      });
    } catch (e) {
      // Handle any errors during loading (fallback to default position)
      print('Error loading position: $e');
    }
  }

  Future<void> _savePosition(String position) async {
    try {
      // Update local state
      setState(() {
        _currentPosition = position;
        _showPositionOptions = false;
      });

      // Save to preferences for persistence across app
      await UserPreferencesService.savePosition(position);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Position changed to $position'),
          duration: const Duration(seconds: 2),
          backgroundColor: _positionColors[position],
        ),
      );
    } catch (e) {
      print('Error saving position: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save position'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculating screen width to set drawer width proportionally
    final screenWidth = MediaQuery.of(context).size.width;
    // Making the drawer width 85% of screen width for a more noticeable increase
    final drawerWidth = screenWidth * 0.85;
    
    return SizedBox(
      width: drawerWidth,
      child: Drawer(
        child: Column(
          children: [
            // Profile header section with improved UI
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _positionColors[_currentPosition]!,
                    _positionColors[_currentPosition]!.withOpacity(0.7),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Updated profile image with better fallback handling
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: Builder(
                            builder: (context) {
                              try {
                                return Image.asset(
                                  _userImages[_currentPosition] ??
                                      'assets/profile.jpg',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    // Fallback to icon if image loading fails
                                    return CircleAvatar(
                                      backgroundColor: Colors.grey.shade200,
                                      child: Icon(
                                        _positionIcons[_currentPosition] ??
                                            Icons.person,
                                        size: 40,
                                        color: _positionColors[_currentPosition],
                                      ),
                                    );
                                  },
                                );
                              } catch (e) {
                                // Extra safety in case of any other errors
                                return CircleAvatar(
                                  backgroundColor: Colors.grey.shade200,
                                  child: Icon(
                                    _positionIcons[_currentPosition] ??
                                        Icons.person,
                                    size: 40,
                                    color: _positionColors[_currentPosition],
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Name and position on the right
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Maitrek Patel',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  blurRadius: 2,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Position with toggle - enhanced design
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showPositionOptions = !_showPositionOptions;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.white.withOpacity(0.5),
                                    width: 1),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _positionIcons[_currentPosition],
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _currentPosition,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _showPositionOptions
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ],
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

            // Add position options if expanded with enhanced design
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: _showPositionOptions
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Container(
                color: _positionColors[_currentPosition]!.withOpacity(0.05),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.swap_horiz,
                          size: 14,
                          color: _positionColors[_currentPosition],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'SWITCH POSITION',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: _positionColors[_currentPosition],
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(_positions.length, (index) {
                      final position = _positions[index];
                      final isSelected = position == _currentPosition;
                      return GestureDetector(
                        onTap: () {
                          _savePosition(position);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? _positionColors[position]
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            border: Border.all(
                              color: isSelected
                                  ? Colors.transparent
                                  : Colors.grey.shade200,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white.withOpacity(0.2)
                                      : _positionColors[position]!
                                          .withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _positionIcons[position],
                                  size: 20,
                                  color: isSelected
                                      ? Colors.white
                                      : _positionColors[position],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    position,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    _getPositionDescription(position),
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: isSelected
                                          ? Colors.white.withOpacity(0.8)
                                          : Colors.grey.shade600,
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
                                    color: _positionColors[position],
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

            // Divider between header and modules
            const Divider(height: 1),

            // Scrollable modules section
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Examination Module
                  _buildModuleWithToggle(
                    icon: Icons.school,
                    title: 'Examination',
                    isExpanded: _isExaminationExpanded,
                    onToggle: () {
                      setState(() {
                        _isExaminationExpanded = !_isExaminationExpanded;
                      });
                    },
                    onTap: () {
                      // Navigate to Examination Dashboard when clicking on the module directly
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ExaminationDashboard(),
                        ),
                      );
                    },
                  ),
                  _buildAnimatedSubsections([
                    if (_isExaminationExpanded) ...[
                      _buildSubNavItem(context,
                          icon: Icons.campaign, title: 'Announcement', index: 2),
                      _buildSubNavItem(context,
                          icon: Icons.grade, title: 'Submit Grades', index: 3),
                      _buildSubNavItem(context,
                          icon: Icons.check_circle,
                          title: 'Verify Grades',
                          index: 4),
                      _buildSubNavItem(context,
                          icon: Icons.calendar_today,
                          title: 'Generate Transcript',
                          index: 5),
                      _buildSubNavItem(context,
                          icon: Icons.verified_user,
                          title: 'Validate Grades',
                          index: 6),
                      _buildSubNavItem(context,
                          icon: Icons.update,
                          title: 'Update Grades',
                          index: 7),
                      _buildSubNavItem(context,
                          icon: Icons.assessment,
                          title: 'Result',
                          index: 8),
                    ],
                  ]),

                  // File Tracking Module
                  _buildModuleWithToggle(
                    icon: Icons.file_copy,
                    title: 'File Tracking',
                    isExpanded: _isFileTrackingExpanded,
                    onToggle: () {
                      setState(() {
                        _isFileTrackingExpanded = !_isFileTrackingExpanded;
                      });
                    },
                  ),
                  _buildAnimatedSubsections([
                    if (_isFileTrackingExpanded) ...[
                      _buildSubNavItem(context,
                          icon: Icons.create_new_folder,
                          title: 'Create File',
                          index: 13),
                      _buildSubNavItem(context,
                          icon: Icons.find_in_page, title: 'Track File', index: 14),
                      _buildSubNavItem(context,
                          icon: Icons.history, title: 'File History', index: 15),
                    ],
                  ]),

                  // Purchase Module
                  _buildModuleWithToggle(
                    icon: Icons.shopping_cart,
                    title: 'Purchase',
                    isExpanded: _isPurchaseExpanded,
                    onToggle: () {
                      setState(() {
                        _isPurchaseExpanded = !_isPurchaseExpanded;
                      });
                    },
                  ),
                  if (_isPurchaseExpanded) ...[
                    _buildSubNavItem(context,
                        icon: Icons.add_shopping_cart,
                        title: 'Create Order',
                        index: 16),
                    _buildSubNavItem(context,
                        icon: Icons.receipt_long,
                        title: 'Purchase Requests',
                        index: 17),
                    _buildSubNavItem(context,
                        icon: Icons.inventory,
                        title: 'Manage Vendors',
                        index: 18),
                  ],

                  // Programme and Curriculum Module
                  _buildModuleWithToggle(
                    icon: Icons.menu_book,
                    title: 'Programme&Curriculum',
                    isExpanded: _isProgrammeExpanded,
                    onToggle: () {
                      setState(() {
                        _isProgrammeExpanded = !_isProgrammeExpanded;
                      });
                    },
                  ),
                  if (_isProgrammeExpanded) ...[
                    _buildSubNavItem(context,
                        icon: Icons.auto_stories,
                        title: 'Course Management',
                        index: 19),
                    _buildSubNavItem(context,
                        icon: Icons.class_, title: 'Timetable', index: 20),
                    _buildSubNavItem(context,
                        icon: Icons.assignment, title: 'Syllabus', index: 21),
                  ],

                  // Patent Module
                  _buildModuleWithToggle(
                    icon: Icons.brightness_7,
                    title: 'Patent',
                    isExpanded: _isPatentExpanded,
                    onToggle: () {
                      setState(() {
                        _isPatentExpanded = !_isPatentExpanded;
                      });
                    },
                  ),
                  if (_isPatentExpanded) ...[
                    _buildSubNavItem(context,
                        icon: Icons.add_circle_outline,
                        title: 'File Patent',
                        index: 22),
                    _buildSubNavItem(context,
                        icon: Icons.category,
                        title: 'Patent Portfolio',
                        index: 23),
                    _buildSubNavItem(context,
                        icon: Icons.timeline, title: 'Patent Status', index: 24),
                  ],

                  // Inventory Module
                  _buildModuleWithToggle(
                    icon: Icons.inventory_2,
                    title: 'Inventory',
                    isExpanded: _isInventoryExpanded,
                    onToggle: () {
                      setState(() {
                        _isInventoryExpanded = !_isInventoryExpanded;
                      });
                    },
                  ),
                  if (_isInventoryExpanded) ...[
                    _buildSubNavItem(context,
                        icon: Icons.add_box, title: 'Add Items', index: 25),
                    _buildSubNavItem(context,
                        icon: Icons.list_alt, title: 'View Inventory', index: 26),
                    _buildSubNavItem(context,
                        icon: Icons.analytics,
                        title: 'Inventory Reports',
                        index: 27),
                  ],

                  // Event Management Module
                  _buildModuleWithToggle(
                    icon: Icons.event_available,
                    title: 'Event Management',
                    isExpanded: _isEventManagementExpanded,
                    onToggle: () {
                      setState(() {
                        _isEventManagementExpanded = !_isEventManagementExpanded;
                      });
                    },
                  ),
                  if (_isEventManagementExpanded) ...[
                    _buildSubNavItem(context,
                        icon: Icons.add_circle, title: 'Create Event', index: 28),
                    _buildSubNavItem(context,
                        icon: Icons.calendar_month,
                        title: 'Event Calendar',
                        index: 29),
                    _buildSubNavItem(context,
                        icon: Icons.people, title: 'Participants', index: 30),
                  ],

                  // Research Module
                  _buildModuleWithToggle(
                    icon: Icons.science,
                    title: 'Research',
                    isExpanded: _isResearchExpanded,
                    onToggle: () {
                      setState(() {
                        _isResearchExpanded = !_isResearchExpanded;
                      });
                    },
                  ),
                  if (_isResearchExpanded) ...[
                    _buildSubNavItem(context,
                        icon: Icons.article, title: 'Publications', index: 31),
                    _buildSubNavItem(context,
                        icon: Icons.attach_money,
                        title: 'Research Grants',
                        index: 32),
                    _buildSubNavItem(context,
                        icon: Icons.group_work,
                        title: 'Research Groups',
                        index: 33),
                  ],

                  // Finance Module
                  _buildModuleWithToggle(
                    icon: Icons.account_balance_wallet,
                    title: 'Finance',
                    isExpanded: _isFinanceExpanded,
                    onToggle: () {
                      setState(() {
                        _isFinanceExpanded = !_isFinanceExpanded;
                      });
                    },
                  ),
                  if (_isFinanceExpanded) ...[
                    _buildSubNavItem(context,
                        icon: Icons.payment, title: 'Fee Payment', index: 34),
                    _buildSubNavItem(context,
                        icon: Icons.account_balance,
                        title: 'Scholarships',
                        index: 35),
                    _buildSubNavItem(context,
                        icon: Icons.receipt, title: 'Expense Claims', index: 36),
                  ],

                  // Placement Module
                  _buildModuleWithToggle(
                    icon: Icons.work,
                    title: 'Placement',
                    isExpanded: _isPlacementExpanded,
                    onToggle: () {
                      setState(() {
                        _isPlacementExpanded = !_isPlacementExpanded;
                      });
                    },
                  ),
                  if (_isPlacementExpanded) ...[
                    _buildSubNavItem(context,
                        icon: Icons.business, title: 'Companies', index: 37),
                    _buildSubNavItem(context,
                        icon: Icons.badge, title: 'Job Postings', index: 38),
                    _buildSubNavItem(context,
                        icon: Icons.trending_up,
                        title: 'Placement Statistics',
                        index: 39),
                  ],

                  // Human Resources Module (New)
                  _buildModuleWithToggle(
                    icon: Icons.people_alt,
                    title: 'Human Resources',
                    isExpanded: _isHumanResourcesExpanded,
                    onToggle: () {
                      setState(() {
                        _isHumanResourcesExpanded = !_isHumanResourcesExpanded;
                      });
                    },
                  ),
                  if (_isHumanResourcesExpanded) ...[
                    _buildSubNavItem(context,
                        icon: Icons.person_add, title: 'Recruitment', index: 40),
                    _buildSubNavItem(context,
                        icon: Icons.event_available,
                        title: 'Leave Management',
                        index: 41),
                    _buildSubNavItem(context,
                        icon: Icons.assessment,
                        title: 'Performance Appraisal',
                        index: 42),
                    _buildSubNavItem(context,
                        icon: Icons.card_membership,
                        title: 'Training Programs',
                        index: 43),
                  ],

                  // Library Management Module (New)
                  _buildModuleWithToggle(
                    icon: Icons.local_library,
                    title: 'Library Management',
                    isExpanded: _isLibraryManagementExpanded,
                    onToggle: () {
                      setState(() {
                        _isLibraryManagementExpanded =
                            !_isLibraryManagementExpanded;
                      });
                    },
                  ),
                  if (_isLibraryManagementExpanded) ...[
                    _buildSubNavItem(context,
                        icon: Icons.search, title: 'Book Search', index: 44),
                    _buildSubNavItem(context,
                        icon: Icons.book, title: 'Issue/Return', index: 45),
                    _buildSubNavItem(context,
                        icon: Icons.history,
                        title: 'Borrowing History',
                        index: 46),
                    _buildSubNavItem(context,
                        icon: Icons.new_releases,
                        title: 'New Arrivals',
                        index: 47),
                  ],

                  // Hostel Management Module (New)
                  _buildModuleWithToggle(
                    icon: Icons.apartment,
                    title: 'Hostel Management',
                    isExpanded: _isHostelManagementExpanded,
                    onToggle: () {
                      setState(() {
                        _isHostelManagementExpanded =
                            !_isHostelManagementExpanded;
                      });
                    },
                  ),
                  if (_isHostelManagementExpanded) ...[
                    _buildSubNavItem(context,
                        icon: Icons.bed, title: 'Room Allocation', index: 48),
                    _buildSubNavItem(context,
                        icon: Icons.report_problem,
                        title: 'Complaint Management',
                        index: 49),
                    _buildSubNavItem(context,
                        icon: Icons.food_bank,
                        title: 'Mess Management',
                        index: 50),
                    _buildSubNavItem(context,
                        icon: Icons.payments, title: 'Fee Payment', index: 51),
                  ],

                  // Alumni Network Module (New)
                  _buildModuleWithToggle(
                    icon: Icons.group,
                    title: 'Alumni Network',
                    isExpanded: _isAlumniNetworkExpanded,
                    onToggle: () {
                      setState(() {
                        _isAlumniNetworkExpanded = !_isAlumniNetworkExpanded;
                      });
                    },
                  ),
                  if (_isAlumniNetworkExpanded) ...[
                    _buildSubNavItem(context,
                        icon: Icons.people_outline,
                        title: 'Alumni Directory',
                        index: 52),
                    _buildSubNavItem(context,
                        icon: Icons.event_note,
                        title: 'Alumni Events',
                        index: 53),
                    _buildSubNavItem(context,
                        icon: Icons.forum, title: 'Discussion Forums', index: 54),
                    _buildSubNavItem(context,
                        icon: Icons.volunteer_activism,
                        title: 'Mentorship Programs',
                        index: 55),
                  ],
                ],
              ),
            ),

            // Divider between modules and fixed bottom items
            const Divider(height: 1),

            // Horizontal layout for Home, Profile, Help, Settings and Logout icons
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Home icon - already works properly
                  IconButton(
                    icon: Icon(Icons.home, color: Colors.blue.shade800),
                    tooltip: 'Home',
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                  ),
                  // Profile icon - updated to navigate to Profile screen
                  IconButton(
                    icon: Icon(Icons.person, color: Colors.blue.shade800),
                    tooltip: 'Profile',
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigate to Profile screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(), // This requires importing the ProfileScreen
                        ),
                      );
                      // Fallback to using onItemSelected if ProfileScreen navigation fails
                      if (widget.onItemSelected != null) {
                        widget.onItemSelected!(6);
                      }
                    },
                  ),
                  // Help icon
                  IconButton(
                    icon: Icon(Icons.help, color: Colors.blue.shade800),
                    tooltip: 'Help',
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HelpScreen(),
                        ),
                      );
                    },
                  ),
                  // Settings icon
                  IconButton(
                    icon: Icon(Icons.settings, color: Colors.blue.shade800),
                    tooltip: 'Settings',
                    onPressed: () {
                      Navigator.pop(context);
                      if (widget.onItemSelected != null) {
                        widget.onItemSelected!(7);
                      }
                    },
                  ),
                  // Logout icon
                  IconButton(
                    icon: Icon(Icons.logout, color: Colors.red.shade700),
                    tooltip: 'Log out',
                    onPressed: () {
                      Navigator.pop(context);
                      if (widget.onItemSelected != null) {
                        widget.onItemSelected!(9);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

  // Helper method to get the animation controller for a specific module
  AnimationController _getControllerForModule(String moduleName) {
    switch(moduleName) {
      case 'Examination': return _animationControllers['examination']!;
      case 'File Tracking': return _animationControllers['fileTracking']!;
      case 'Purchase': return _animationControllers['purchase']!;
      case 'Programme&Curriculum': return _animationControllers['programme']!;
      case 'Patent': return _animationControllers['patent']!;
      case 'Inventory': return _animationControllers['inventory']!;
      case 'Event Management': return _animationControllers['eventManagement']!;
      case 'Research': return _animationControllers['research']!;
      case 'Finance': return _animationControllers['finance']!;
      case 'Placement': return _animationControllers['placement']!;
      case 'Human Resources': return _animationControllers['humanResources']!;
      case 'Library Management': return _animationControllers['libraryManagement']!;
      case 'Hostel Management': return _animationControllers['hostelManagement']!;
      case 'Alumni Network': return _animationControllers['alumniNetwork']!;
      default: return _animationControllers['examination']!;
    }
  }

  Widget _buildModuleWithToggle({
    required IconData icon,
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    VoidCallback? onTap,
  }) {
    final controller = _getControllerForModule(title);
    
    // Update animation controller based on expanded state
    if (isExpanded) {
      controller.forward();
    } else {
      controller.reverse();
    }
    
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1.0,
          ),
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue.shade800),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: RotationTransition(
          turns: Tween(begin: 0.0, end: 0.25).animate(
            CurvedAnimation(
              parent: controller,
              curve: Curves.easeInOut,
            ),
          ),
          child: IconButton(
            icon: Icon(
              Icons.expand_more,
              color: Colors.blue.shade800,
            ),
            onPressed: () {
              onToggle();
            },
          ),
        ),
        onTap: onTap ?? onToggle,
      ),
    );
  }


  Widget _buildSubNavItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required int index,
  }) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.only(left: 52.0, right: 8.0),
      leading: Icon(
        icon, 
        color: Colors.blue.shade700, 
        size: 18
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 13,
          color: Colors.black87, // Changed from blue to black to match module name
        ),
      ),
      onTap: () {
        // Close the drawer
        Navigator.pop(context);
        // Navigate to Submit Grades screen if index matches
        if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SubmitGradesScreen()),
          );
        } else if (index == 7) {
          // Navigate to Update Grades screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UpdateGradesScreen()),
          );
        } else if (index == 8) {
          // Navigate to Result screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ResultScreen()),
          );
        }
        // Notify parent about selection
        if (widget.onItemSelected != null) {
          widget.onItemSelected!(index);
        }
      },
    );
  }

  // Helper method to build animated subsections for a module
  Widget _buildAnimatedSubsections(List<Widget> children) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Column(
        children: children,
      ),
    );
  }
}
