import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async'; // Added import for Timer class
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
    with TickerProviderStateMixin {  // Changed from SingleTickerProviderStateMixin to TickerProviderStateMixin
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  final List<String> _searchHistory = []; // Search history list
  final int _maxSearchHistory = 10; // Changed from 5 to 10 entries
  bool _isSearchFocused = false;
  bool _showSearchHistory = false; // Added missing declaration
  String _searchQuery = ''; // Store the search query for highlighting
  bool _isSearching = false; // Flag to track active searching state
  bool _showFilters = false; // Flag to track if filters are shown
  
  // Animation controllers
  late AnimationController _searchAnimationController;
  late Animation<double> _searchAnimation;

  // Focus node for better control over the search field focus
  final FocusNode _searchFocusNode = FocusNode();

  // Filter variables
  String? _selectedModule;
  String? _selectedDateFilter;
  String? _selectedReadFilter; // Added read filter state

  // Date filter options
  final List<String> _dateFilterOptions = [
    'All',
    'Today',
    'Yesterday',
    'This Week',
    'This Month',
    'This Year',
  ];

  // Read status filter options
  final List<String> _readFilterOptions = [
    'All',
    'Read',
    'Unread',
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
    _selectedReadFilter = 'All'; // Default read filter

    _searchController.addListener(_onSearchChanged);
    
    // Initialize search animation controller
    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _searchAnimation = CurvedAnimation(
      parent: _searchAnimationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    _searchAnimationController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (!_isSearchVisible) {
        _searchController.clear();
        _searchFocusNode.unfocus();
        _searchAnimationController.reverse();
      } else {
        _searchFocusNode.requestFocus();
        _searchQuery = '';
        _searchAnimationController.forward();
      }
    });
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  // Add search to history - improved implementation for 5 most recent searches
  void _addToSearchHistory(String query) {
    if (query.isEmpty) return;

    setState(() {
      // Remove the query if it already exists (to move it to the top)
      _searchHistory.remove(query);

      // Add to the beginning of the list
      _searchHistory.insert(0, query);

      // Limit history to exactly 5 items
      if (_searchHistory.length > _maxSearchHistory) {
        _searchHistory.removeLast();
      }
    });
  }

  // Helper method to highlight search terms in text
  Widget _highlightSearchText(String text,
      {int maxLines = 1, bool isBold = false, double fontSize = 14.0, bool isRead = false}) {
    // Text color is grey if card is read, otherwise dark grey/black
    final Color textColor = isRead ? Colors.grey.shade600 : Colors.grey.shade900;
    
    if (_searchQuery.isEmpty) {
      return Text(
        text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontSize: fontSize,
          color: textColor,
          height: 1.3,
        ),
      );
    }

    // Create regex pattern from search query with case insensitivity
    final pattern = RegExp(_searchQuery, caseSensitive: false);

    // Find all matches
    final matches = pattern.allMatches(text);

    if (matches.isEmpty) {
      return Text(
        text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontSize: fontSize,
          color: textColor,
          height: 1.3,
        ),
      );
    }

    // Create TextSpans with highlighted parts
    final List<TextSpan> children = [];
    int lastMatchEnd = 0;

    for (final match in matches) {
      // Add text before match
      if (match.start > lastMatchEnd) {
        children.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: fontSize,
            color: textColor,
          ),
        ));
      }

      // Add highlighted match
      children.add(TextSpan(
        text: text.substring(match.start, match.end),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
          color: Colors.blue.shade800,
          backgroundColor: Colors.blue.shade50,
        ),
      ));

      lastMatchEnd = match.end;
    }

    // Add remaining text after last match
    if (lastMatchEnd < text.length) {
      children.add(TextSpan(
        text: text.substring(lastMatchEnd),
        style: TextStyle(
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontSize: fontSize,
          color: textColor,
        ),
      ));
    }

    return RichText(
      text: TextSpan(children: children),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }

  // Get all unique modules for filter
  List<String> _getUniqueModules() {
    final Set<String> modules = {};

    for (final notification in _notifications) {
      final module = notification['module'] as String?;
      if (module != null) {
        modules.add(module);
      }
    }

    for (final announcement in _announcements) {
      final module = announcement['module'] as String?;
      if (module != null) {
        modules.add(module);
      }
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
              (announcement['title'] != null &&
                  (announcement['title'] as String)
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase())) ||
              (announcement['content'] != null &&
                  (announcement['content'] as String)
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase())) ||
              (announcement['module'] != null &&
                  (announcement['module'] as String)
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase())))
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
        final date = announcement['date'] as DateTime?;

        if (date == null) return false;

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

    // Apply read/unread filter
    if (_selectedReadFilter != null && _selectedReadFilter != 'All') {
      filtered = filtered.where((announcement) {
        final isUnread = announcement['isUnread'] as bool? ?? false;

        switch (_selectedReadFilter) {
          case 'Read':
            return !isUnread;
          case 'Unread':
            return isUnread;
          default:
            return true;
        }
      }).toList();
    }

    // Sort by date in descending order
    filtered.sort((a, b) {
      final dateA = a['date'] as DateTime;
      final dateB = b['date'] as DateTime;
      return dateB.compareTo(dateA);
    });

    return filtered;
  }

  List<Map<String, dynamic>> _getFilteredNotifications() {
    List<Map<String, dynamic>> filtered = _notifications;

    // Apply text search filter if search is active
    if (_searchController.text.isNotEmpty) {
      filtered = filtered
          .where((notification) =>
              (notification['title'] != null &&
                  (notification['title'] as String)
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase())) ||
              (notification['content'] != null &&
                  (notification['content'] as String)
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase())) ||
              (notification['module'] != null &&
                  (notification['module'] as String)
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase())))
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
        final date = notification['date'] as DateTime?;

        if (date == null) return false;

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

    // Apply read/unread filter
    if (_selectedReadFilter != null && _selectedReadFilter != 'All') {
      filtered = filtered.where((notification) {
        final isUnread = notification['isUnread'] as bool? ?? false;

        switch (_selectedReadFilter) {
          case 'Read':
            return !isUnread;
          case 'Unread':
            return isUnread;
          default:
            return true;
        }
      }).toList();
    }

    // Sort by date in descending order
    filtered.sort((a, b) {
      final dateA = a['date'] as DateTime;
      final dateB = b['date'] as DateTime;
      return dateB.compareTo(dateA);
    });

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
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 400),
      ),
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
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isSystemNotification
                                    ? Colors.blue.shade50
                                    : Colors.indigo.shade50,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSystemNotification
                                      ? Colors.blue.shade200
                                      : Colors.indigo.shade200,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isSystemNotification
                                        ? Icons.system_update
                                        : _getModuleTypeIcon(
                                            notification['module'] ?? ''),
                                    size: 16,
                                    color: isSystemNotification
                                        ? Colors.blue.shade700
                                        : Colors.indigo.shade700,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    isSystemNotification
                                        ? 'System'
                                        : notification['module'] ?? '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: isSystemNotification
                                          ? Colors.blue.shade700
                                          : Colors.indigo.shade700,
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

                      // Title with hero animation for smooth transition
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                        child: Hero(
                          tag: 'notification_${notification['title']}',
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              notification['title'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                            ),
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
      isDismissible: true,
      enableDrag: true,
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 400),
      ),
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
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
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
                                border:
                                    Border.all(color: Colors.indigo.shade200),
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

                      // Title with hero animation
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                        child: Hero(
                          tag: 'announcement_${announcement['title']}',
                          child: Material(
                            color: Colors.transparent,
                            child: Text(
                              announcement['title'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                            ),
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

                              // Attachment section with subtle animation
                              if (hasAttachment) ...[
                                const SizedBox(height: 24),
                                TweenAnimationBuilder(
                                  duration: const Duration(milliseconds: 500),
                                  tween: Tween<double>(begin: 0.0, end: 1.0),
                                  builder: (context, double value, child) {
                                    return Opacity(
                                      opacity: value,
                                      child: Transform(
                                        transform: Matrix4.translationValues(0, 20 * (1 - value), 0),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade50,
                                      borderRadius: BorderRadius.circular(12),
                                      border:
                                          Border.all(color: Colors.blue.shade100),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                            // Download logic with animation feedback
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Row(
                                                  children: [
                                                    const SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 16),
                                                    Text('Downloading $attachmentName...'),
                                                  ],
                                                ),
                                                duration: const Duration(seconds: 2),
                                                behavior: SnackBarBehavior.floating,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 24), // Add bottom padding
                            ],
                          ),
                        ),
                      ),
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

  void _showFilterOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 400),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, setModalState) {
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Icon(Icons.filter_list, color: Colors.blue.shade800),
                        const SizedBox(width: 10),
                        const Text(
                          'Filters',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () {
                            setModalState(() {
                              _selectedModule = 'All';
                              _selectedDateFilter = 'All';
                              _selectedReadFilter = 'All';
                            });
                          },
                          icon: Icon(Icons.refresh,
                              size: 18, color: Colors.red.shade600),
                          label: Text(
                            'Reset Filters',
                            style: TextStyle(
                              color: Colors.red.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),

                    // Status Filter
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.mark_email_read,
                            size: 18,
                            color: Colors.grey.shade800,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Status',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: _readFilterOptions.map((readOption) {
                        return ChoiceChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                readOption == 'Read'
                                    ? Icons.visibility
                                    : readOption == 'Unread'
                                        ? Icons.visibility_off
                                        : Icons.remove_red_eye,
                                size: 16,
                                color: _selectedReadFilter == readOption
                                    ? Colors.blue.shade800
                                    : Colors.grey.shade700,
                              ),
                              const SizedBox(width: 6),
                              Text(readOption),
                            ],
                          ),
                          selected: _selectedReadFilter == readOption,
                          selectedColor: Colors.blue.shade100,
                          backgroundColor: Colors.grey.shade100,
                          labelStyle: TextStyle(
                            fontWeight: _selectedReadFilter == readOption
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: _selectedReadFilter == readOption
                                ? Colors.blue.shade800
                                : Colors.grey.shade800,
                          ),
                          onSelected: (selected) {
                            setModalState(() {
                              _selectedReadFilter =
                                  selected ? readOption : 'All';
                            });
                          },
                        );
                      }).toList(),
                    ),

                    // Module Filter
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.category_outlined,
                            size: 18,
                            color: Colors.grey.shade800,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Module',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: _getUniqueModules().map((module) {
                        return ChoiceChip(
                          label: Text(module),
                          selected: _selectedModule == module,
                          selectedColor: Colors.blue.shade100,
                          backgroundColor: Colors.grey.shade100,
                          labelStyle: TextStyle(
                            fontWeight: _selectedModule == module
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: _selectedModule == module
                                ? Colors.blue.shade800
                                : Colors.grey.shade800,
                          ),
                          onSelected: (selected) {
                            setModalState(() {
                              _selectedModule = selected ? module : 'All';
                            });
                          },
                        );
                      }).toList(),
                    ),

                    // Date Filter
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.date_range,
                            size: 18,
                            color: Colors.grey.shade800,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Date',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: _dateFilterOptions.map((dateOption) {
                        return ChoiceChip(
                          label: Text(dateOption),
                          selected: _selectedDateFilter == dateOption,
                          selectedColor: Colors.blue.shade100,
                          backgroundColor: Colors.grey.shade100,
                          labelStyle: TextStyle(
                            fontWeight: _selectedDateFilter == dateOption
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: _selectedDateFilter == dateOption
                                ? Colors.blue.shade800
                                : Colors.grey.shade800,
                          ),
                          onSelected: (selected) {
                            setModalState(() {
                              _selectedDateFilter =
                                  selected ? dateOption : 'All';
                            });
                          },
                        );
                      }).toList(),
                    ),

                    // Apply Button with animation
                    const SizedBox(height: 24.0),
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 300),
                      tween: Tween<double>(begin: 0.95, end: 1.0),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: SizedBox(
                            width: double.infinity,
                            height: 50.0,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  // Set _showFilters to true when filters are applied
                                  _showFilters = (_selectedModule != 'All' ||
                                      _selectedDateFilter != 'All' ||
                                      _selectedReadFilter != 'All');
                                });
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade700,
                                foregroundColor: Colors.white,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Apply Filters',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if any filters are active
    final bool hasActiveFilters =
        (_selectedModule != null && _selectedModule != 'All') ||
            (_selectedDateFilter != null && _selectedDateFilter != 'All') ||
            (_selectedReadFilter != null && _selectedReadFilter != 'All');

    return GestureSidebar(
      scaffoldKey: _scaffoldKey,
      child: Scaffold(
        key: _scaffoldKey,
        // Darkened background color for better contrast with white cards
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          title: _isSearchVisible
              ? SizeTransition(
                  sizeFactor: _searchAnimation,
                  axis: Axis.horizontal,
                  axisAlignment: -1,
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.7)),
                        prefixIcon: const Icon(Icons.search, color: Colors.white),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.close,
                                    color: Colors.white, size: 20),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                      ),
                      style: const TextStyle(color: Colors.white),
                      onChanged: (value) {
                        _onSearchChanged();
                      },
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          // Add search to history
                          _addToSearchHistory(value);
                          // Close keyboard and clear focus
                          _searchFocusNode.unfocus();
                        }
                      },
                      onTap: () {
                        // Show search history when search field is tapped
                        setState(() {
                          _isSearchFocused = true;
                        });
                      },
                    ),
                  ),
                )
              : AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: const Text(
                    'Home',
                    key: ValueKey('title'),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
          backgroundColor: Colors.blue.shade700,
          elevation: 2,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              if (_scaffoldKey.currentState != null) {
                _scaffoldKey.currentState!.openDrawer();
              }
            },
          ),
          actions: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: IconButton(
                key: ValueKey<bool>(_isSearchVisible),
                icon: Icon(_isSearchVisible ? Icons.close : Icons.search,
                    color: Colors.white),
                onPressed: _toggleSearch,
              ),
            ),
            // Filter icon with visual indicator when filters are active
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  onPressed: _showFilterOverlay,
                ),
                if (hasActiveFilters)
                  Positioned(
                    right: 10,
                    top: 10,
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 300),
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.scale(
                            scale: value,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.blue.shade700, width: 1.5),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(text: 'Notifications'),
              Tab(text: 'Announcements'),
            ],
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
        body: Column(
          children: [
            // Display the horizontal search history banner when there is search history
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _isSearchVisible && _searchHistory.isNotEmpty
                ? _buildRecentSearchesBanner()
                : const SizedBox.shrink(),
            ),
            
            // Main tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildNotificationsTab(),
                  _buildAnnouncementsTab(),
                ],
              ),
            ),
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
          // Filter title row with improved layout
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Icon(Icons.filter_list, size: 18, color: Colors.blue.shade800),
                const SizedBox(width: 8),
                Text(
                  'Active Filters',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                // Reset filters button with improved appearance
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
                        Icon(Icons.refresh,
                            size: 14, color: Colors.red.shade600),
                        const SizedBox(width: 4),
                        Text(
                          'Reset',
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

          // Filter chips in horizontal scroll with improved spacing
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Module filter with improved appearance
                if (_selectedModule != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: FilterChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.category_outlined,
                              size: 14, color: Colors.blue.shade700),
                          const SizedBox(width: 4),
                          Text(
                            _selectedModule == 'All'
                                ? 'All Modules'
                                : _selectedModule!,
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          Icon(Icons.arrow_drop_down,
                              size: 14, color: Colors.blue.shade700),
                        ],
                      ),
                      backgroundColor: Colors.white,
                      checkmarkColor: Colors.transparent,
                      showCheckmark: false,
                      selected: _selectedModule != 'All',
                      selectedColor: Colors.blue.shade50,
                      onSelected: (_) {
                        // Show module selection dialog
                        _showModuleFilterDialog();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.blue.shade300),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                    ),
                  ),

                // Date filter with improved appearance
                if (_selectedDateFilter != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: FilterChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calendar_today,
                              size: 14, color: Colors.blue.shade700),
                          const SizedBox(width: 4),
                          Text(
                            _selectedDateFilter == 'All'
                                ? 'All Dates'
                                : _selectedDateFilter!,
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          Icon(Icons.arrow_drop_down,
                              size: 14, color: Colors.blue.shade700),
                        ],
                      ),
                      backgroundColor: Colors.white,
                      checkmarkColor: Colors.transparent,
                      showCheckmark: false,
                      selected: _selectedDateFilter != 'All',
                      selectedColor: Colors.blue.shade50,
                      onSelected: (_) {
                        // Show date filter dialog
                        _showDateFilterDialog();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Colors.blue.shade300),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
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
            Icon(Icons.category_outlined,
                color: Colors.blue.shade700, size: 20),
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
            child:
                Text('Cancel', style: TextStyle(color: Colors.grey.shade700)),
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
            child:
                Text('Cancel', style: TextStyle(color: Colors.grey.shade700)),
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
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              tween: Tween<double>(begin: 0.5, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Icon(
                    Icons.notifications_off,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              tween: Tween<double>(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Text(
                    'No notifications found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredNotifications.length,
      padding: const EdgeInsets.all(16.0),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final notification = filteredNotifications[index];
        final isUnread = notification['isUnread'] as bool;
        final isSystemNotification = notification['type'] == 'system';

        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 50)),
          tween: Tween<double>(begin: 0.0, end: 1.0),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 50 * (1 - value)),
                child: child,
              ),
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: isUnread ? Colors.white : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: isUnread 
                    ? Colors.blue.withOpacity(0.15) // Reduced opacity for subtler shadow
                    : Colors.grey.shade300.withOpacity(0.3), // Reduced opacity
                  blurRadius: isUnread ? 6 : 4, // Reduced blur radius
                  offset: isUnread ? const Offset(0, 2) : const Offset(0, 1), // Smaller offset
                  spreadRadius: 0, // Removed spread radius for subtler effect
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
                  _showNotificationDetails(notification);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with module tag and time
                      Row(
                        children: [
                          // System or Module tag pill with blue color
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: isUnread ? Colors.blue.shade50 : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: isUnread ? Colors.blue.shade100 : Colors.grey.shade300,
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
                                  color: isUnread ? Colors.blue.shade700 : Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isSystemNotification
                                      ? 'System'
                                      : notification['module'],
                                  style: TextStyle(
                                    color: isUnread ? Colors.blue.shade700 : Colors.grey.shade600,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Spacer(),
                          // Time indicator with black text when unread
                          Text(
                            _formatDate(notification['date']),
                            style: TextStyle(
                              color: isUnread ? Colors.grey.shade900 : Colors.grey.shade600, // Changed to darker color for unread
                              fontSize: 12,
                            ),
                          ),
                          if (isUnread)
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
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

                      // Title with one line and ellipsis - using hero for animation
                      Hero(
                        tag: 'notification_${notification['title']}',
                        child: Material(
                          color: Colors.transparent,
                          child: _highlightSearchText(
                            notification['title'],
                            maxLines: 1,
                            isBold: true,
                            fontSize: 16,
                            isRead: !isUnread,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Content text
                      RichText(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: notification['content'],
                              style: TextStyle(
                                fontSize: 14,
                                color: isUnread ? Colors.grey.shade900 : Colors.grey.shade700,
                                height: 1.3,
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
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              tween: Tween<double>(begin: 0.5, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Icon(
                    Icons.campaign_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              tween: Tween<double>(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Text(
                    'No announcements found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredAnnouncements.length,
      padding: const EdgeInsets.all(16.0),
      physics: const BouncingScrollPhysics(), // Keep elastic scroll physics
      itemBuilder: (context, index) {
        final announcement = filteredAnnouncements[index];
        final isUnread = announcement['isUnread'] as bool;
        final hasAttachment = announcement['hasAttachment'] as bool? ?? false;
        final title = announcement['title'] as String;

        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * 50)),
          tween: Tween<double>(begin: 0.0, end: 1.0),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 50 * (1 - value)),
                child: child,
              ),
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: isUnread ? Colors.white : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: isUnread 
                    ? Colors.blue.withOpacity(0.15) // Reduced opacity for subtler shadow
                    : Colors.grey.shade300.withOpacity(0.3), // Reduced opacity
                  blurRadius: isUnread ? 6 : 4, // Reduced blur radius
                  offset: isUnread ? const Offset(0, 2) : const Offset(0, 1), // Smaller offset
                  spreadRadius: 0, // Removed spread radius for subtler effect
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  // Mark as read with animation
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
                          // Module tag pill with blue colors to match notification style
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: isUnread ? Colors.blue.shade50 : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: isUnread ? Colors.blue.shade100 : Colors.grey.shade300,
                                  width: 0.5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getModuleTypeIcon(announcement['module']),
                                  size: 12,
                                  color: isUnread ? Colors.blue.shade700 : Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  announcement['module'],
                                  style: TextStyle(
                                    color: isUnread ? Colors.blue.shade700 : Colors.grey.shade600,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Attachment indicator with subtle animation
                          if (hasAttachment)
                            TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 300),
                              tween: Tween<double>(begin: 0.0, end: 1.0),
                              builder: (context, value, child) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Opacity(
                                    opacity: value,
                                    child: Icon(
                                      Icons.attach_file,
                                      size: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                );
                              },
                            ),

                          const Spacer(),
                          // Time indicator with black text when unread
                          Text(
                            _formatDate(announcement['date']),
                            style: TextStyle(
                              color: isUnread ? Colors.grey.shade900 : Colors.grey.shade600, // Changed to darker color for unread
                              fontSize: 12,
                            ),
                          ),
                          if (isUnread)
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
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

                      // Title with one line and ellipsis using hero for animation
                      Hero(
                        tag: 'announcement_${announcement['title']}',
                        child: Material(
                          color: Colors.transparent,
                          child: _highlightSearchText(
                            title,
                            maxLines: 1,
                            isBold: true,
                            fontSize: 15,
                            isRead: !isUnread,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Content text
                      RichText(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: announcement['content'],
                              style: TextStyle(
                                fontSize: 13,
                                color: isUnread ? Colors.grey.shade900 : Colors.grey.shade700,
                                height: 1.3,
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

  // Add search history display widget
  Widget _buildSearchHistoryList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Icon(Icons.history, size: 16, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  'Recent Searches',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade900,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                if (_searchHistory.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _searchHistory.clear();
                      });
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Clear All',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red.shade600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          _searchHistory.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      'No recent searches',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:
                      _searchHistory.length > 5 ? 5 : _searchHistory.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      dense: true,
                      horizontalTitleGap: 0,
                      leading: Icon(
                        Icons.search,
                        size: 18,
                        color: Colors.grey.shade600,
                      ),
                      title: Text(
                        _searchHistory[index],
                        style: const TextStyle(fontSize: 14),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.north_west,
                          size: 16,
                          color: Colors.blue.shade700,
                        ),
                        onPressed: () {
                          setState(() {
                            _searchController.text = _searchHistory[index];
                            _searchQuery = _searchHistory[index];
                            _isSearching = true;
                            _searchFocusNode.unfocus();
                          });
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      onTap: () {
                        setState(() {
                          _searchController.text = _searchHistory[index];
                          _searchQuery = _searchHistory[index];
                          _isSearching = true;
                        });
                      },
                    );
                  },
                ),
        ],
      ),
    );
  }

  // Create a more visually appealing search history panel
  Widget _buildSearchHistoryPanel() {
    return Material(
      elevation: 4,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.4,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with Clear All button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 12, 8),
              child: Row(
                children: [
                  Icon(Icons.history, size: 18, color: Colors.blue.shade700),
                  const SizedBox(width: 8),
                  Text(
                    'Recent Searches',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  const Spacer(),
                  if (_searchHistory.isNotEmpty)
                    TextButton.icon(
                      icon: Icon(Icons.delete_outline,
                          size: 16, color: Colors.red.shade600),
                      label: Text(
                        'Clear All',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.red.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        setState(() {
                          _searchHistory.clear();
                        });
                      },
                    ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Search history list or empty state
            _searchHistory.isEmpty
                ? Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 36,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No recent searches',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: _searchHistory.length,
                      itemBuilder: (context, index) {
                        final searchTerm = _searchHistory[index];
                        return ListTile(
                          dense: true,
                          leading: Icon(
                            Icons.search,
                            size: 18,
                            color: Colors.grey.shade700,
                          ),
                          title: Text(
                            searchTerm,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          trailing: Icon(
                            Icons.north_west,
                            size: 16,
                            color: Colors.blue.shade700,
                          ),
                          onTap: () {
                            setState(() {
                              _searchController.text = searchTerm;
                              _searchQuery = searchTerm;
                              _isSearchFocused = false;
                              _showSearchHistory = false;
                              _searchFocusNode.unfocus();
                            });
                          },
                          hoverColor: Colors.blue.shade50,
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  // Custom widget to show recent searches in a horizontal banner with animation
  Widget _buildRecentSearchesBanner() {
    if (_searchHistory.isEmpty) {
      return Container(); // Return empty container if no search history
    }
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Search history chips
            for (int i = 0; i < _searchHistory.length; i++)
              TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 200 + (i * 50)),
                tween: Tween<double>(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform(
                      transform: Matrix4.translationValues(20 * (1 - value), 0, 0),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ActionChip(
                          label: Text(
                            _searchHistory[i],
                            style: TextStyle(
                              color: Colors.blue.shade800,
                              fontSize: 13,
                            ),
                          ),
                          backgroundColor: Colors.blue.shade50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: Colors.blue.shade200,
                              width: 0.5,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                          visualDensity: VisualDensity.compact,
                          onPressed: () {
                            setState(() {
                              _searchController.text = _searchHistory[i];
                              _searchQuery = _searchHistory[i];
                              _searchFocusNode.unfocus();
                            });
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              
            // Clear all button at the end with dustbin icon and "Clear recent" text
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 600),
              tween: Tween<double>(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform(
                    transform: Matrix4.translationValues(20 * (1 - value), 0, 0),
                    child: ActionChip(
                      avatar: Icon(
                        Icons.delete,
                        size: 16,
                        color: Colors.red.shade600,
                      ),
                      label: Text(
                        'Clear recent',
                        style: TextStyle(
                          color: Colors.red.shade600,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      backgroundColor: Colors.red.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: Colors.red.shade200,
                          width: 0.5,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      onPressed: () {
                        setState(() {
                          _searchHistory.clear();
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
