import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'dart:async'; // Import for Timer
import '../screens/Examination/announcement_screen.dart';
import '../screens/Examination/submit_grades.dart';
import '../screens/Examination/verify_grades.dart';
import '../screens/Examination/update_grades.dart';
import '../screens/Examination/generate_transcript.dart';
import '../screens/Examination/result.dart';
import '../screens/Examination/validate_grades.dart';
import 'profile.dart';
import '../screens/Examination/examination_dashboard.dart';
import 'bottom_bar.dart'; // Import the bottom bar
import 'sidebar.dart'; // Import the sidebar
import 'gesture_sidebar.dart'; // Import the gesture sidebar

class SearchScreen extends StatefulWidget {
  final bool autoFocusSearch;

  const SearchScreen({super.key, this.autoFocusSearch = false});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<ModuleItem> _searchResults = [];
  final List<ModuleItem> _allModules = [];
  final List<SubModuleItem> _allSubModules = [];
  final FocusNode _searchFocusNode = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); // Add scaffold key
  
  // Enhanced animation controllers
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;
  
  // Animation tracking
  bool _isSearchFocused = false;
  bool _isAnimatingSearch = false;
  
  // Gradient decoration for cards
  late final Decoration _cardGradient = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.blue.shade600,
        Colors.blue.shade800,
      ],
    ),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.blue.shade700.withOpacity(0.3),
        blurRadius: 8,
        offset: const Offset(0, 3),
      ),
    ],
  );
  
  // Gradient decoration for modal header
  late final Decoration _modalHeaderGradient = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.blue.shade600,
        Colors.blue.shade800,
      ],
    ),
    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
    boxShadow: [
      BoxShadow(
        color: Colors.blue.shade700.withOpacity(0.2),
        blurRadius: 8,
        offset: const Offset(0, 3),
      ),
    ],
  );

  Timer? _debounce; // Timer for debounce

  @override
  void initState() {
    super.initState();
    _initializeModules();
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
        // Trigger animation effects when focus changes
        if (_isSearchFocused) {
          _animationController.forward();
          _isAnimatingSearch = true;
          Future.delayed(const Duration(milliseconds: 500), () { // Increased from 300 to 500
            if (mounted) {
              setState(() {
                _isAnimatingSearch = false;
              });
            }
          });
        }
      });
    });
    
    // Initialize animations with longer durations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800), // Increased from 500 to 800
    );
    
    // Create multiple animations with custom curves
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController, 
        curve: const Interval(0.1, 0.9, curve: Curves.easeOutQuint), // Added interval for longer effect
      ),
    );
    
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController, 
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic), // Added interval for longer effect
      ),
    );
    
    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.05), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.05, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeInOut), // Changed from 0.5 to 0.7
    ));
    
    // Auto-start animation when screen loads with a slight delay for visibility
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _animationController.forward(from: 0.0); // Reset to ensure full animation
      }
    });
  }

  void _initializeModules() {
    // Main modules
    _allModules.addAll([
      // Examination module
      ModuleItem(
        name: 'Examination',
        icon: Icons.school,
        color: Colors.blue.shade700,
        route: (context) => const ExaminationDashboard(),
      ),
      // File Tracking module
      ModuleItem(
        name: 'File Tracking',
        icon: Icons.file_copy,
        color: Colors.blue.shade700,
        route: (context) => const AnnouncementScreen(), // Placeholder
      ),
      // Purchase module
      ModuleItem(
        name: 'Purchase',
        icon: Icons.shopping_cart,
        color: Colors.blue.shade700,
        route: (context) => const AnnouncementScreen(), // Placeholder
      ),
      // Programme & Curriculum module
      ModuleItem(
        name: 'Programme & Curriculum',
        icon: Icons.menu_book,
        color: Colors.blue.shade700,
        route: (context) => const AnnouncementScreen(), // Placeholder
      ),
      // Patent module
      ModuleItem(
        name: 'Patent',
        icon: Icons.brightness_7,
        color: Colors.blue.shade700,
        route: (context) => const AnnouncementScreen(), // Placeholder
      ),
      // Inventory module
      ModuleItem(
        name: 'Inventory',
        icon: Icons.inventory_2,
        color: Colors.blue.shade700,
        route: (context) => const AnnouncementScreen(), // Placeholder
      ),
      // Event Management module
      ModuleItem(
        name: 'Event Management',
        icon: Icons.event_available,
        color: Colors.blue.shade700,
        route: (context) => const AnnouncementScreen(), // Placeholder
      ),
      // Research module
      ModuleItem(
        name: 'Research',
        icon: Icons.science,
        color: Colors.blue.shade700,
        route: (context) => const AnnouncementScreen(), // Placeholder
      ),
      // Finance module
      ModuleItem(
        name: 'Finance',
        icon: Icons.account_balance_wallet,
        color: Colors.blue.shade700,
        route: (context) => const AnnouncementScreen(), // Placeholder
      ),
      // Placement module
      ModuleItem(
        name: 'Placement',
        icon: Icons.work,
        color: Colors.blue.shade700,
        route: (context) => const AnnouncementScreen(), // Placeholder
      ),
      // Human Resources module
      ModuleItem(
        name: 'Human Resources',
        icon: Icons.people_alt,
        color: Colors.blue.shade700,
        route: (context) => const AnnouncementScreen(), // Placeholder
      ),
      // Library Management module
      ModuleItem(
        name: 'Library Management',
        icon: Icons.local_library,
        color: Colors.blue.shade700,
        route: (context) => const AnnouncementScreen(), // Placeholder
      ),
      // Hostel Management module
      ModuleItem(
        name: 'Hostel Management',
        icon: Icons.apartment,
        color: Colors.blue.shade700,
        route: (context) => const AnnouncementScreen(), // Placeholder
      ),
      // Alumni Network module
      ModuleItem(
        name: 'Alumni Network',
        icon: Icons.group,
        color: Colors.blue.shade700,
        route: (context) => const AnnouncementScreen(), // Placeholder
      ),
      // Profile
      ModuleItem(
        name: 'Profile',
        icon: Icons.person,
        color: Colors.blue.shade700,
        route: (context) => const ProfileScreen(),
      ),
    ]);

    // Sub modules
    _allSubModules.addAll([
      // Examination sub-modules
      SubModuleItem(
        name: 'Announcement',
        icon: Icons.campaign,
        color: Colors.blue.shade700,
        route: (context) => const AnnouncementScreen(),
        parentModule: 'Examination',
        description: 'View announcements and updates',
      ),
      SubModuleItem(
        name: 'Submit Grades',
        icon: Icons.grade,
        color: Colors.blue.shade700,
        route: (context) => const SubmitGradesScreen(),
        parentModule: 'Examination',
        description: 'Submit student grades and evaluations',
      ),
      SubModuleItem(
        name: 'Verify Grades',
        icon: Icons.check_circle,
        color: Colors.blue.shade700,
        route: (context) => const VerifyGradesScreen(),
        parentModule: 'Examination',
        description: 'Verify and approve submitted grades',
      ),
      SubModuleItem(
        name: 'Generate Transcript',
        icon: Icons.calendar_today,
        color: Colors.blue.shade700,
        route: (context) => const GenerateTranscriptScreen(),
        parentModule: 'Examination',
        description: 'Generate student transcripts and reports',
      ),
      SubModuleItem(
        name: 'Validate Grades',
        icon: Icons.verified_user,
        color: Colors.blue.shade700,
        route: (context) => const ValidateGradesScreen(),
        parentModule: 'Examination',
        description: 'Validate grades against academic policies',
      ),
      SubModuleItem(
        name: 'Update Grades',
        icon: Icons.update,
        color: Colors.blue.shade700,
        route: (context) => const UpdateGradesScreen(),
        parentModule: 'Examination',
        description: 'Update existing grades and evaluations',
      ),
      SubModuleItem(
        name: 'Result',
        icon: Icons.assessment,
        color: Colors.blue.shade700,
        route: (context) => const ResultScreen(),
        parentModule: 'Examination',
        description: 'View and analyze examination results',
      ),

      // File Tracking sub-modules
      SubModuleItem(
        name: 'Create File',
        icon: Icons.create_new_folder,
        color: Colors.blue.shade700,
        route: (context) => const AnnouncementScreen(), // Placeholder
        parentModule: 'File Tracking',
        description: 'Create new tracking files',
      ),
      SubModuleItem(
        name: 'Track File',
        icon: Icons.find_in_page,
        color: Colors.blue.shade700,
        route: (context) => const AnnouncementScreen(), // Placeholder
        parentModule: 'File Tracking',
        description: 'Track existing files in the system',
      ),
      SubModuleItem(
        name: 'File History',
        icon: Icons.history,
        color: Colors.blue.shade700,
        route: (context) => const AnnouncementScreen(), // Placeholder
        parentModule: 'File Tracking',
        description: 'View history of file movements',
      ),

      // Purchase sub-modules
      SubModuleItem(
        name: 'Create Order',
        icon: Icons.add_shopping_cart,
        color: Colors.blue.shade700,
        route: (context) => const AnnouncementScreen(), // Placeholder
        parentModule: 'Purchase',
        description: 'Create new purchase orders',
      ),
      SubModuleItem(
        name: 'Purchase Requests',
        icon: Icons.receipt_long,
        color: Colors.blue.shade700,
        route: (context) => const AnnouncementScreen(), // Placeholder
        parentModule: 'Purchase',
        description: 'View and manage purchase requests',
      ),
      SubModuleItem(
        name: 'Manage Vendors',
        icon: Icons.inventory,
        color: Colors.blue.shade700,
        route: (context) => const AnnouncementScreen(), // Placeholder
        parentModule: 'Purchase',
        description: 'Manage vendor information and contracts',
      ),

      // Add submodules for other main modules as needed
    ]);
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    // First search for exact module matches
    List<ModuleItem> moduleMatches = _allModules
        .where(
            (module) => module.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    // Then search for submodule matches (excluding descriptions)
    List<SubModuleItem> subModuleMatches = _allSubModules
        .where((subModule) =>
            subModule.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    // Create a set of parent module names from matching submodules
    Set<String> parentModuleNames = {};
    for (var subModule in subModuleMatches) {
      parentModuleNames.add(subModule.parentModule);
    }

    // Add parent modules that aren't already in moduleMatches
    for (var parentName in parentModuleNames) {
      bool alreadyIncluded =
          moduleMatches.any((module) => module.name == parentName);
      if (!alreadyIncluded) {
        var parentModule = _allModules.firstWhere(
          (module) => module.name == parentName,
          orElse: () => ModuleItem(
            name: parentName,
            icon: Icons.folder,
            color: Colors.blue.shade700,
            route: (context) => const AnnouncementScreen(),
          ),
        );
        moduleMatches.add(parentModule);
      }
    }

    setState(() {
      _searchResults = moduleMatches;
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _performSearch(query); // Perform search after debounce delay
    });
  }

  List<SubModuleItem> _getSubModulesForModule(String moduleName) {
    return _allSubModules
        .where((subModule) => subModule.parentModule == moduleName)
        .toList();
  }

  List<SubModuleItem> _getMatchingSubModules(String query, String moduleName) {
    return _allSubModules
        .where((subModule) =>
            subModule.parentModule == moduleName &&
            subModule.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _animationController.dispose();
    _debounce?.cancel(); // Cancel debounce timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureSidebar(
      scaffoldKey: _scaffoldKey,
      edgeWidthFactor: 1.0, // Allow swipe from anywhere on screen
      child: Scaffold(
        key: _scaffoldKey, // Use the scaffold key
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            'Search',
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              color: Colors.white,
              fontSize: 20,
              letterSpacing: 0.5,
            ),
          ),
          backgroundColor: Colors.blue.shade700.withOpacity(0.95),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: false, // Changed from true to false to align title to the left
          systemOverlayStyle: SystemUiOverlayStyle.light,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        drawer: const Sidebar(), // Add Sidebar as a drawer
        body: Stack(
          children: [
            // Clean white background
            Container(
              color: Colors.white,
            ),
            Column(
              children: [
                _buildSearchHeader(),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    switchInCurve: Curves.easeOutQuint,
                    switchOutCurve: Curves.easeInQuint,
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.05),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: _searchController.text.isEmpty
                      ? _buildModulesList()
                      : _searchResults.isEmpty
                        ? _buildNoResultsFound()
                        : _buildSearchResultsList(),
                  ),
                ),
              ],
            ),
          ],
        ),
        bottomNavigationBar: const BottomBar(currentIndex: 2),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500), // Increased from 300 to 500
      curve: Curves.easeOutQuint,
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(_isSearchFocused ? 20 : 30)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_isSearchFocused ? 0.2 : 0.1),
            blurRadius: _isSearchFocused ? 15 : 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500), // Increased from 300 to 500
            curve: Curves.easeOutQuint,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(_isSearchFocused ? 18 : 25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_isSearchFocused ? 0.12 : 0.08),
                  blurRadius: _isSearchFocused ? 15 : 10,
                  offset: const Offset(0, 5),
                  spreadRadius: _isSearchFocused ? 1 : 0,
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: _onSearchChanged, // Use debounce handler
              autofocus: widget.autoFocusSearch,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.left, // Explicitly set left alignment
              textAlignVertical: TextAlignVertical.center, // Center vertically
              decoration: InputDecoration(
                hintText: 'Search modules or features...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 16,
                ),
                prefixIcon: AnimatedContainer(
                  duration: const Duration(milliseconds: 500), // Increased from 300 to 500
                  padding: EdgeInsets.all(_isSearchFocused ? 0 : 2),
                  child: Icon(
                    Icons.search,
                    color: _isSearchFocused ? Colors.blue.shade700 : Colors.grey.shade400,
                    size: _isSearchFocused ? 24 : 22,
                  ),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                  ? Hero(
                      tag: 'clear_button',
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey, size: 16),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {
                              _searchController.clear();
                              _performSearch('');
                              HapticFeedback.lightImpact();
                            },
                          ),
                        ),
                      ),
                    )
                  : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(left: 0, top: 15, right: 20, bottom: 15), // Left padding removed, handled by prefixIcon
                alignLabelWithHint: true,
                isCollapsed: false,
                isDense: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoResultsFound() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Center(
            key: const ValueKey<String>('no_results'),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Elastic animation for empty state message - increased duration
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.8, end: 1.0),
                  duration: const Duration(milliseconds: 1200), // Increased from 800 to 1200
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.search_off_rounded,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'No results found',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Try searching with different keywords or browse the modules below',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    _searchController.clear();
                    _performSearch('');
                    HapticFeedback.mediumImpact();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Clear Search', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModulesList() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ListView.builder(
            key: const ValueKey<String>('modules_list'),
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            itemCount: _allModules.length + 1, // +1 for the header
            itemBuilder: (context, index) {
              if (index == 0) {
                // Enhanced header with total module count
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'All Modules',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          '${_allModules.length} Modules',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              
              final moduleIndex = index - 1; // Adjust for header
              final module = _allModules[moduleIndex];
              
              // Staggered entrance for items with longer delays
              return AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  // Safe interval calculations to prevent overflow - adjusted for longer animation
                  final double startInterval = 0.1 + (moduleIndex * 0.03 > 0.6 ? 0.6 : moduleIndex * 0.03); // Reduced from 0.05 to 0.03
                  final double endInterval = 0.7 + (moduleIndex * 0.03 > 0.3 ? 0.3 : moduleIndex * 0.03);  // Reduced from 0.05 to 0.03
                  
                  final itemAnimation = CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(
                      startInterval,
                      endInterval,
                      curve: Curves.easeOutQuint,
                    ),
                  );
                  
                  return FadeTransition(
                    opacity: itemAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(itemAnimation),
                      child: child!,
                    ),
                  );
                },
                child: _buildModuleListItem(context, module),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResultsList() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ListView.builder(
            key: const ValueKey<String>('search_results'),
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final module = _searchResults[index];
              
              // Staggered entrance for search results
              return AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  // Safe interval calculations to prevent overflow
                  final double startInterval = 0.1 + (index * 0.08 > 0.6 ? 0.6 : index * 0.08);
                  final double endInterval = 0.6 + (index * 0.08 > 0.4 ? 0.4 : index * 0.08);
                  
                  final itemAnimation = CurvedAnimation(
                    parent: _animationController,
                    curve: Interval(
                      startInterval,
                      endInterval,
                      curve: Curves.easeOutQuint,
                    ),
                  );
                  
                  return FadeTransition(
                    opacity: itemAnimation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.15),
                        end: Offset.zero,
                      ).animate(itemAnimation),
                      child: child,
                    ),
                  );
                },
                child: _buildSearchResultItem(context, module),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildModuleListItem(BuildContext context, ModuleItem module) {
    final subModules = _getSubModulesForModule(module.name);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: _cardGradient,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              if (subModules.isNotEmpty) {
                _showModuleDetails(context, module);
              } else {
                // Add page transition animation
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => 
                      module.route(context),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0.0, 0.05);
                      const end = Offset.zero;
                      const curve = Curves.easeOutQuint;
                      
                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      
                      return SlideTransition(
                        position: animation.drive(tween),
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 400),
                  ),
                );
              }
              HapticFeedback.lightImpact();
            },
            splashColor: Colors.white.withOpacity(0.1),
            highlightColor: Colors.white.withOpacity(0.05),
            splashFactory: InkRipple.splashFactory,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // White icon container for contrast against blue background
                  Hero(
                    tag: 'module_icon_${module.name}',
                    child: Container(
                      width: 50,
                      height: 50,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(module.icon, color: Colors.blue.shade700),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          module.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${subModules.length} features available",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // White arrow button for contrast
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    width: 36,
                    height: 36,
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResultItem(BuildContext context, ModuleItem module) {
    // Find matching subsections if any
    final String query = _searchController.text.toLowerCase();
    final List<SubModuleItem> matchingSubModules =
        _getMatchingSubModules(query, module.name);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: _cardGradient,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'search_result_${module.name}',
                    child: Container(
                      width: 56,
                      height: 56,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(module.icon, color: module.color, size: 28),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          module.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (matchingSubModules.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "${matchingSubModules.length} matching features",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: module.route),
                      );
                      HapticFeedback.mediumImpact();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue.shade700,
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: const Text(
                      'Open',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            if (matchingSubModules.isNotEmpty) ...[
              Container(
                height: 1,
                color: Colors.white.withOpacity(0.2),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Matching Features",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        _showModuleDetails(context, module);
                        HapticFeedback.lightImpact();
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.view_list, size: 16, color: Colors.white),
                      label: const Text(
                        "View All",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Reduced spacing between header and list items
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero, // Remove padding around ListView
                itemCount: matchingSubModules.length > 3 ? 3 : matchingSubModules.length,
                separatorBuilder: (context, index) => Container(
                  height: 1,
                  margin: const EdgeInsets.only(left: 66),
                  color: Colors.white.withOpacity(0.2),
                ),
                itemBuilder: (context, index) {
                  return _buildSubModuleItemForSearch(context, matchingSubModules[index], true);
                },
              ),
              if (matchingSubModules.length > 3)
                Padding(
                  // Reduced top padding here
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showModuleDetails(context, module);
                      // Add haptic feedback
                      HapticFeedback.lightImpact();
                    },
                    icon: const Icon(Icons.expand_more, color: Colors.white),
                    label: Text(
                      "View all ${matchingSubModules.length} features",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // Reduced vertical padding on button
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  // New method for search results with white text on blue background
  Widget _buildSubModuleItemForSearch(BuildContext context, SubModuleItem subModule, [bool isInSearchResult = false]) {
    final String query = _searchController.text.toLowerCase();
    final bool isMatching = query.isNotEmpty && 
        (subModule.name.toLowerCase().contains(query));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: subModule.route),
          );
          // Add haptic feedback
          HapticFeedback.lightImpact();
        },
        splashColor: Colors.white.withOpacity(0.1),
        highlightColor: Colors.white.withOpacity(0.05),
        child: Padding(
          // Reduced vertical padding
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: ListTile(
            // More compact padding
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            leading: Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                border: isMatching 
                    ? Border.all(color: Colors.white, width: 1.5)
                    : null,
              ),
              child: Icon(subModule.icon, 
                color: Colors.white, 
                size: 20
              ),
            ),
            title: Text(
              subModule.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                Text(
                  subModule.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                if (isMatching) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.search,
                          size: 12,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Matches search",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            trailing: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 16,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: subModule.route),
                  );
                  // Add haptic feedback
                  HapticFeedback.lightImpact();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showModuleDetails(BuildContext context, ModuleItem module) {
    final List<SubModuleItem> subModules = _getSubModulesForModule(module.name);
    final String query = _searchController.text.toLowerCase();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // Remove the problematic animation controller
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: DraggableScrollableSheet(
            initialChildSize: 0.7,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            expand: false,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    // Gradient header section
                    Container(
                      decoration: _modalHeaderGradient,
                      child: Column(
                        children: [
                          // Animated handle indicator
                          Container(
                            margin: const EdgeInsets.only(top: 12),
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                            child: Row(
                              children: [
                                Hero(
                                  tag: 'details_${module.name}',
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Icon(module.icon, color: module.color, size: 30),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        module.name,
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          "${subModules.length} features available",
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Material(
                                  color: Colors.transparent,
                                  child: IconButton(
                                    icon: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Content section with sub-modules
                    if (subModules.isEmpty)
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.info_outline,
                                  size: 80, 
                                  color: Colors.grey.shade400
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'No features available',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 40),
                                child: Text(
                                  'This module doesn\'t have any features yet',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.separated(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          itemCount: subModules.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            thickness: 1,
                            indent: 66,
                            endIndent: 16,
                            color: Colors.grey.shade200,
                          ),
                          itemBuilder: (context, index) {
                            final bool isMatching = query.isNotEmpty &&
                                (subModules[index].name.toLowerCase().contains(query));
                            
                            return _buildSubModuleDetailItem(
                              context, 
                              subModules[index],
                              isMatching,
                            );
                          },
                        ),
                      ),
                    
                    // Bottom button section
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SafeArea(
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: module.route),
                              );
                              // Add haptic feedback
                              HapticFeedback.mediumImpact();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: module.color,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              'Open ${module.name}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSubModuleDetailItem(
      BuildContext context, SubModuleItem subModule, bool isMatching) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(
          color: isMatching 
              ? subModule.color.withOpacity(0.3)
              : Colors.grey.shade200,
          width: isMatching ? 1.5 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: subModule.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(subModule.icon, color: subModule.color),
        ),
        title: Text(
          subModule.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isMatching ? subModule.color : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              subModule.description,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
            if (isMatching && _searchController.text.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: subModule.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "Matches your search",
                  style: TextStyle(
                    fontSize: 10,
                    color: subModule.color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: subModule.route),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: subModule.color,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            minimumSize: const Size(80, 36),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Open'),
        ),
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: subModule.route),
          );
        },
      ),
    );
  }
}

class ModuleItem {
  final String name;
  final IconData icon;
  final Color color;
  final WidgetBuilder route;

  ModuleItem({
    required this.name,
    required this.icon,
    required this.color,
    required this.route,
  });
}

class SubModuleItem {
  final String name;
  final IconData icon;
  final Color color;
  final WidgetBuilder route;
  final String parentModule;
  final String description;

  SubModuleItem({
    required this.name,
    required this.icon,
    required this.color,
    required this.route,
    required this.parentModule,
    required this.description,
  });
}
