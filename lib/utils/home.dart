import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'sidebar.dart';
import 'gesture_sidebar.dart';
import 'bottom_bar.dart';
import '../screens/Examination/examination_dashboard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();

  // Filter variables
  String? _selectedModule;
  String? _selectedDateFilter;
  bool _showFilters = false;

  // Date filter options
  final List<String> _dateFilterOptions = [
    'All',
    'Today',
    'Yesterday',
    'This Week',
    'This Month',
    'This Year',
  ];

  // Example announcement data across various modules
  final List<Map<String, dynamic>> _announcements = [
    {
      'title': 'End Semester Examination Schedule',
      'module': 'Examination',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'content':
          'The End Semester Examination for all courses will commence from 15th May, 2025. Detailed schedule has been uploaded on the examination portal. Students are requested to check their respective schedules.',
      'author': 'Examination Controller',
      'priority': 'High',
      'isUnread': true,
      'hasAttachment': true,
      'attachmentName': 'exam_schedule_2025.pdf',
    },
    {
      'title': 'Library Membership Renewal',
      'module': 'Library',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'content':
          'All students and faculty members are requested to renew their library membership for the academic year 2025-2026. The renewal process starts from 1st April and ends on 15th April.',
      'author': 'Chief Librarian',
      'priority': 'Medium',
      'isUnread': true,
      'hasAttachment': false,
      'attachmentName': '',
    },
    {
      'title': 'Hostel Maintenance Notice',
      'module': 'Hostel',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'content':
          'Maintenance work will be carried out in Hostel Blocks A and B from 10th April to 15th April. Students are requested to cooperate with the maintenance staff.',
      'author': 'Hostel Warden',
      'priority': 'Medium',
      'isUnread': false,
      'hasAttachment': true,
      'attachmentName': 'maintenance_schedule.docx',
    },
    {
      'title':
          'Campus Placement Drive for Tech Solutions Inc. and Multiple Other Partner Companies',
      'module': 'Placement',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'content':
          'A campus placement drive for final year students will be conducted by Tech Solutions Inc. on 20th April. Eligible students should register on the placement portal by 15th April.',
      'author': 'Placement Officer',
      'priority': 'High',
      'isUnread': true,
      'hasAttachment': true,
      'attachmentName': 'eligibility_criteria.pdf',
    },
    {
      'title': 'Research Grant Applications',
      'module': 'Research',
      'date': DateTime.now().subtract(const Duration(days: 7)),
      'content':
          'Applications are invited for research grants under the Institute Innovation Scheme. Last date for submission is 30th April. Detailed guidelines are available on the research portal.',
      'author': 'Research Dean',
      'priority': 'Medium',
      'isUnread': false,
      'hasAttachment': true,
      'attachmentName': 'grant_guidelines.pdf',
    },
    {
      'title': 'New Course Introduction',
      'module': 'Academic',
      'date': DateTime.now().subtract(const Duration(days: 10)),
      'content':
          'A new elective course on "Artificial Intelligence for Healthcare" will be offered from the next semester. Interested students can pre-register on the academic portal.',
      'author': 'Academic Dean',
      'priority': 'Low',
      'isUnread': false,
      'hasAttachment': false,
      'attachmentName': '',
    },
    {
      'title': 'Faculty Development Program',
      'module': 'HR',
      'date': DateTime.now().subtract(const Duration(days: 4)),
      'content':
          'A Faculty Development Program on "Effective Teaching Methodologies" will be conducted from 5th to 10th May. Faculty members are encouraged to participate.',
      'author': 'HR Manager',
      'priority': 'Medium',
      'isUnread': true,
      'hasAttachment': true,
      'attachmentName': 'schedule_and_registration.pdf',
    },
    {
      'title': 'Annual Cultural Fest',
      'module': 'Event',
      'date': DateTime.now().subtract(const Duration(days: 12)),
      'content':
          'The Annual Cultural Fest "Fusion 2023" will be held from 25th to 27th April. Student coordinators are requested to attend the planning meeting on 15th April.',
      'author': 'Cultural Secretary',
      'priority': 'High',
      'isUnread': false,
      'hasAttachment': true,
      'attachmentName': 'event_schedule.xlsx',
    },
    {
      'title': 'Budget Proposal Submission',
      'module': 'Finance',
      'date': DateTime.now().subtract(const Duration(days: 15)),
      'content':
          'All departments are requested to submit their budget proposals for the financial year 2025-2026 by 20th April. The template for submission is available on the finance portal.',
      'author': 'Finance Officer',
      'priority': 'Medium',
      'isUnread': false,
      'hasAttachment': true,
      'attachmentName': 'budget_template.xlsx',
    },
    {
      'title': 'Patent Filing Workshop',
      'module': 'Patent',
      'date': DateTime.now().subtract(const Duration(days: 8)),
      'content':
          'A workshop on "Patent Filing Process and Guidelines" will be conducted on 18th April. Faculty members and research scholars are encouraged to attend.',
      'author': 'Patent Cell Coordinator',
      'priority': 'Low',
      'isUnread': true,
      'hasAttachment': true,
      'attachmentName': 'workshop_details.pdf',
    },
  ];

  // Example system notifications data (replacing the previous notifications)
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'System Maintenance Scheduled',
      'type': 'system',
      'date': DateTime.now().subtract(const Duration(hours: 1)),
      'content':
          'The system will be unavailable for maintenance on Sunday, April 15, 2025 from 2:00 AM to 6:00 AM.',
      'priority': 'High',
      'isUnread': true,
    },
    {
      'title': 'Password Reset Required',
      'type': 'system',
      'date': DateTime.now().subtract(const Duration(hours: 5)),
      'content':
          'For security reasons, please reset your password within the next 7 days.',
      'priority': 'Medium',
      'isUnread': true,
    },
    {
      'title': 'New Version Available',
      'type': 'system',
      'date': DateTime.now().subtract(const Duration(hours: 12)),
      'content':
          'A new version of Fusion App (v2.3.0) is now available. Please update your application for the latest features and security improvements.',
      'priority': 'Low',
      'isUnread': false,
    },
    {
      'title': 'Account Login Alert',
      'type': 'system',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'content':
          'Your account was accessed from a new device. If this wasn\'t you, please contact the IT department immediately.',
      'priority': 'High',
      'isUnread': true,
    },
    {
      'title': 'Data Backup Complete',
      'type': 'system',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'content':
          'Your account data has been successfully backed up to secure cloud storage.',
      'priority': 'Low',
      'isUnread': false,
    },
    {
      'title': 'System Update Successful',
      'type': 'system',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'content':
          'The recent system update was successfully installed. All services are now running on the latest version.',
      'priority': 'Medium',
      'isUnread': true,
    },
    {
      'title': 'Account Verification',
      'type': 'system',
      'date': DateTime.now().subtract(const Duration(days: 4)),
      'content':
          'Your account has been successfully verified. You now have access to all features of the Fusion App.',
      'priority': 'Medium',
      'isUnread': false,
    },
    {
      'title': 'Privacy Policy Update',
      'type': 'system',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'content':
          'Our privacy policy has been updated. Please review the changes and acknowledge your acceptance.',
      'priority': 'High',
      'isUnread': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedDateFilter = 'All'; // Default date filter
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (!_isSearchVisible) {
        _searchController.clear();
      }
    });
  }

  // Get all unique modules for filter
  List<String> _getUniqueModules() {
    final Set<String> modules = {};

    for (final notification in _notifications) {
      modules.add(notification['module'] as String);
    }

    for (final announcement in _announcements) {
      modules.add(announcement['module'] as String);
    }

    final List<String> modulesList = modules.toList();
    modulesList.sort(); // Sort alphabetically
    return ['All'] + modulesList; // Add 'All' as the first option
  }

  List<Map<String, dynamic>> _getFilteredAnnouncements() {
    List<Map<String, dynamic>> filtered = _announcements;

    // Apply text search filter if search is active
    if (_searchController.text.isNotEmpty) {
      filtered = filtered
          .where((announcement) =>
              announcement['title']
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              announcement['content']
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              announcement['module']
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
          .toList();
    }

    // Apply module filter
    if (_selectedModule != null && _selectedModule != 'All') {
      filtered = filtered
          .where((announcement) => announcement['module'] == _selectedModule)
          .toList();
    }

    // Apply date filter
    if (_selectedDateFilter != null && _selectedDateFilter != 'All') {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      filtered = filtered.where((announcement) {
        final date = announcement['date'] as DateTime;

        switch (_selectedDateFilter) {
          case 'Today':
            final announcementDate = DateTime(date.year, date.month, date.day);
            return announcementDate.isAtSameMomentAs(today);
          case 'Yesterday':
            final yesterday = today.subtract(const Duration(days: 1));
            final announcementDate = DateTime(date.year, date.month, date.day);
            return announcementDate.isAtSameMomentAs(yesterday);
          case 'This Week':
            final startOfWeek =
                today.subtract(Duration(days: today.weekday - 1));
            return date.isAfter(startOfWeek.subtract(const Duration(days: 1)));
          case 'This Month':
            return date.month == today.month && date.year == today.year;
          case 'This Year':
            return date.year == today.year;
          default:
            return true;
        }
      }).toList();
    }

    return filtered;
  }

  List<Map<String, dynamic>> _getFilteredNotifications() {
    List<Map<String, dynamic>> filtered = _notifications;

    // Apply text search filter if search is active
    if (_searchController.text.isNotEmpty) {
      filtered = filtered
          .where((notification) =>
              notification['title']
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              notification['content']
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              notification['module']
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()))
          .toList();
    }

    // Apply module filter
    if (_selectedModule != null && _selectedModule != 'All') {
      filtered = filtered
          .where((notification) => notification['module'] == _selectedModule)
          .toList();
    }

    // Apply date filter
    if (_selectedDateFilter != null && _selectedDateFilter != 'All') {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      filtered = filtered.where((notification) {
        final date = notification['date'] as DateTime;

        switch (_selectedDateFilter) {
          case 'Today':
            final notificationDate = DateTime(date.year, date.month, date.day);
            return notificationDate.isAtSameMomentAs(today);
          case 'Yesterday':
            final yesterday = today.subtract(const Duration(days: 1));
            final notificationDate = DateTime(date.year, date.month, date.day);
            return notificationDate.isAtSameMomentAs(yesterday);
          case 'This Week':
            final startOfWeek =
                today.subtract(Duration(days: today.weekday - 1));
            return date.isAfter(startOfWeek.subtract(const Duration(days: 1)));
          case 'This Month':
            return date.month == today.month && date.year == today.year;
          case 'This Year':
            return date.year == today.year;
          default:
            return true;
        }
      }).toList();
    }

    return filtered;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today ${DateFormat('h:mm a').format(date)}';
    } else if (difference.inDays == 1) {
      return 'Yesterday ${DateFormat('h:mm a').format(date)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }

  // Show notification details in a bottom sheet
  void _showNotificationDetails(Map<String, dynamic> notification) {
    final isSystemNotification = notification['type'] == 'system';
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true, // Allow dismissing by tapping outside
      enableDrag: true, // Allow dragging to dismiss
      builder: (context) {
        return Stack(
          children: [
            // Transparent overlay for detecting taps outside
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                color: Colors.transparent,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
            // The actual bottom sheet content
            DraggableScrollableSheet(
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
                      
                      // Header with module/system badge
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isSystemNotification ? Colors.green.shade50 : Colors.indigo.shade50,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSystemNotification ? Colors.green.shade200 : Colors.indigo.shade200,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isSystemNotification
                                        ? Icons.system_update
                                        : _getModuleTypeIcon(notification['module'] ?? ''),
                                    size: 16,
                                    color: isSystemNotification ? Colors.green.shade700 : Colors.indigo.shade700,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    isSystemNotification ? 'System' : notification['module'] ?? '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: isSystemNotification ? Colors.green.shade700 : Colors.indigo.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Text(
                              _formatDate(notification['date']),
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
                          notification['title'],
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
                                notification['content'],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade800,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                      // Removed action buttons container with Close button
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Show announcement details in a bottom sheet
  void _showAnnouncementDetails(Map<String, dynamic> announcement) {
    final hasAttachment = announcement['hasAttachment'] as bool? ?? false;
    final attachmentName = announcement['attachmentName'] as String? ?? '';
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true, // Allow dismissing by tapping outside
      enableDrag: true,   // Allow dragging to dismiss
      builder: (context) {
        return Stack(
          children: [
            // Transparent overlay for detecting taps outside
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                color: Colors.transparent,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
            // The actual bottom sheet content
            DraggableScrollableSheet(
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
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.indigo.shade50,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.indigo.shade200),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _getModuleTypeIcon(announcement['module']),
                                    size: 16,
                                    color: Colors.indigo.shade700,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    announcement['module'],
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
                              _formatDate(announcement['date']),
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
                          announcement['title'],
                          style: const TextStyle(
                            fontSize: 18,
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
                                announcement['content'],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade800,
                                  height: 1.5,
                                ),
                              ),
                              
                              // Attachment section
                              if (hasAttachment) ...[
                                const SizedBox(height: 24),
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.blue.shade100),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        _getFileIcon(attachmentName),
                                        color: Colors.blue.shade700,
                                        size: 32,
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              attachmentName,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.blue.shade900,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              'Tap to download',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.blue.shade700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.download,
                                          color: Colors.blue.shade700,
                                        ),
                                        onPressed: () {
                                          // Download logic
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Downloading ${attachmentName}...'),
                                              duration: const Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              const SizedBox(height: 24), // Add bottom padding
                            ],
                          ),
                        ),
                      ),
                      // Removed bottom actions container with Close button
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureSidebar(
      scaffoldKey: _scaffoldKey,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: _isSearchVisible
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    setState(() {});
                  },
                )
              : const Text(
                  'Home',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
          backgroundColor: Colors.blue.shade700,
          elevation: 2,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
          ),
          actions: [
            IconButton(
              icon: Icon(_isSearchVisible ? Icons.close : Icons.search,
                  color: Colors.white),
              onPressed: _toggleSearch,
            ),
            IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.white),
              onPressed: () {
                setState(() {
                  _showFilters = !_showFilters;
                });
              },
            ),
            // Notification bell icon removed
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(_showFilters ? 100 : 48),
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: const [
                    Tab(text: 'Notifications'),
                    Tab(text: 'Announcements'),
                  ],
                ),
                if (_showFilters) _buildFilterOptions(),
              ],
            ),
          ),
        ),
        drawer: Sidebar(
          onItemSelected: (index) {
            if (index == 0) {
              // Already on Home screen
              Navigator.pop(context);
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ExaminationDashboard()),
              );
            }
          },
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildNotificationsTab(),
            _buildAnnouncementsTab(),
          ],
        ),
        bottomNavigationBar: const BottomBar(currentIndex: 0),
      ),
    );
  }

  Widget _buildFilterOptions() {
    return Container(
      color: Colors.blue.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter title row
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Icon(Icons.filter_alt_outlined, size: 18, color: Colors.blue.shade800),
                const SizedBox(width: 8),
                Text(
                  'Filters',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                // Reset filters button
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectedModule = 'All';
                      _selectedDateFilter = 'All';
                    });
                  },
                  borderRadius: BorderRadius.circular(5),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Icon(Icons.refresh, size: 14, color: Colors.red.shade600),
                        const SizedBox(width: 4),
                        Text(
                          'Reset All',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.red.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filter chips in horizontal scroll
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Module filter
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: FilterChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.category_outlined, size: 14, color: Colors.blue.shade700),
                        const SizedBox(width: 4),
                        Text(
                          _selectedModule ?? 'All Modules',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                        Icon(Icons.arrow_drop_down, size: 14, color: Colors.blue.shade700),
                      ],
                    ),
                    backgroundColor: Colors.white,
                    checkmarkColor: Colors.transparent,
                    showCheckmark: false,
                    selected: false,
                    selectedColor: Colors.white,
                    onSelected: (_) {
                      // Show module selection dialog
                      _showModuleFilterDialog();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.blue.shade300),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                ),

                // Date filter
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: FilterChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: Colors.blue.shade700),
                        const SizedBox(width: 4),
                        Text(
                          _selectedDateFilter ?? 'All Dates',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                        Icon(Icons.arrow_drop_down, size: 14, color: Colors.blue.shade700),
                      ],
                    ),
                    backgroundColor: Colors.white,
                    checkmarkColor: Colors.transparent,
                    showCheckmark: false,
                    selected: false,
                    selectedColor: Colors.white,
                    onSelected: (_) {
                      // Show date filter dialog
                      _showDateFilterDialog();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.blue.shade300),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Show module filter dialog
  void _showModuleFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.category_outlined, color: Colors.blue.shade700, size: 20),
            const SizedBox(width: 8),
            const Text('Select Module'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _getUniqueModules().length,
            itemBuilder: (context, index) {
              final module = _getUniqueModules()[index];
              return RadioListTile<String>(
                title: Text(module),
                value: module,
                groupValue: _selectedModule,
                onChanged: (String? value) {
                  setState(() {
                    _selectedModule = value;
                  });
                  Navigator.pop(context);
                },
                activeColor: Colors.blue.shade700,
                contentPadding: EdgeInsets.zero,
                dense: true,
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey.shade700)),
          ),
        ],
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  // Show date filter dialog
  void _showDateFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.blue.shade700, size: 20),
            const SizedBox(width: 8),
            const Text('Select Date Range'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _dateFilterOptions.length,
            itemBuilder: (context, index) {
              final dateOption = _dateFilterOptions[index];
              return RadioListTile<String>(
                title: Text(dateOption),
                value: dateOption,
                groupValue: _selectedDateFilter,
                onChanged: (String? value) {
                  setState(() {
                    _selectedDateFilter = value;
                  });
                  Navigator.pop(context);
                },
                activeColor: Colors.blue.shade700,
                contentPadding: EdgeInsets.zero,
                dense: true,
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey.shade700)),
          ),
        ],
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _buildNotificationsTab() {
    final filteredNotifications = _getFilteredNotifications();

    if (filteredNotifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No notifications found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredNotifications.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        final notification = filteredNotifications[index];
        final isUnread = notification['isUnread'] as bool;
        final isSystemNotification = notification['type'] == 'system';

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 10,
                offset: const Offset(0, 5),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                setState(() {
                  notification['isUnread'] = false;
                });

                // Show notification details in bottom sheet banner
                _showNotificationDetails(notification);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with module tag and time
                    Container(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                      child: Row(
                        children: [
                          // System or Module tag pill
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: isSystemNotification
                                  ? Colors.green.shade50
                                  : Colors.indigo.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: isSystemNotification
                                      ? Colors.green.shade100
                                      : Colors.indigo.shade100,
                                  width: 0.5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isSystemNotification
                                      ? Icons.check_circle_outline
                                      : _getModuleTypeIcon(
                                          notification['module']),
                                  size: 12,
                                  color: isSystemNotification
                                      ? Colors.green.shade700
                                      : Colors.indigo.shade700,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isSystemNotification
                                      ? 'System'
                                      : notification['module'],
                                  style: TextStyle(
                                    color: isSystemNotification
                                        ? Colors.green.shade700
                                        : Colors.indigo.shade700,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          // Time indicator
                          Text(
                            _formatDate(notification['date']),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          if (isUnread)
                            Container(
                              margin: const EdgeInsets.only(left: 6),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: isSystemNotification
                                    ? Colors.green.shade600
                                    : Colors.blue.shade600,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Content section
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title with one line and ellipsis
                          Text(
                            notification['title'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                              fontSize: 16,
                              color: Colors.grey.shade900,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          
                          // Content with two lines and ellipsis for all notifications
                          Text(
                            notification['content'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                          
                          // "View more" indicator
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'View more',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 10,
                                  color: Colors.blue.shade700,
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
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnnouncementsTab() {
    final filteredAnnouncements = _getFilteredAnnouncements();
    
    if (filteredAnnouncements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.campaign_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No announcements found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredAnnouncements.length,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        final announcement = filteredAnnouncements[index];
        final isUnread = announcement['isUnread'] as bool;
        final hasAttachment = announcement['hasAttachment'] as bool? ?? false;
        final title = announcement['title'] as String;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 10,
                offset: const Offset(0, 5),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                // Mark as read
                setState(() {
                  announcement['isUnread'] = false;
                });
                
                // Show announcement details in bottom sheet
                _showAnnouncementDetails(announcement);
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Module and time row
                    Row(
                      children: [
                        // Module tag pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.indigo.shade100, width: 0.5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getModuleTypeIcon(announcement['module']),
                                size: 12,
                                color: Colors.indigo.shade700,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                announcement['module'],
                                style: TextStyle(
                                  color: Colors.indigo.shade700,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Attachment indicator
                        if (hasAttachment)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(
                              Icons.attach_file,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        
                        const Spacer(),
                        // Time indicator
                        Text(
                          _formatDate(announcement['date']),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        if (isUnread)
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade600,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Title with one line and ellipsis
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                        fontSize: 15,
                        color: Colors.grey.shade900,
                        height: 1.3,
                      ),
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // Preview of content with ellipsis
                    Text(
                      announcement['content'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                    
                    // "View more" indicator
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'View more',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 10,
                            color: Colors.blue.shade700,
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
    );
  }

  // Helper method to get appropriate icon for file attachments
  IconData _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();

    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  IconData _getModuleTypeIcon(String module) {
    switch (module) {
      case 'Examination':
        return Icons.school;
      case 'Library':
        return Icons.local_library;
      case 'Hostel':
        return Icons.apartment;
      case 'Placement':
        return Icons.work;
      case 'Research':
        return Icons.science;
      case 'Academic':
        return Icons.book;
      case 'HR':
        return Icons.people;
      case 'Event':
        return Icons.event;
      case 'Finance':
        return Icons.account_balance;
      case 'Patent':
        return Icons.brightness_7;
      case 'File Tracking':
        return Icons.file_copy;
      default:
        return Icons.notifications;
    }
  }
}
