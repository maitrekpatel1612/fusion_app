import 'package:flutter/material.dart';
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

class SearchScreen extends StatefulWidget {
  final bool autoFocusSearch;
  
  const SearchScreen({
    super.key, 
    this.autoFocusSearch = false
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ModuleItem> _searchResults = [];
  final List<ModuleItem> _allModules = [];
  final List<SubModuleItem> _allSubModules = [];
  bool _isSearchBarFocused = false;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initializeModules();
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchBarFocused = _searchFocusNode.hasFocus;
      });
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
        .where((module) => module.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    // Then search for submodule matches
    List<SubModuleItem> subModuleMatches = _allSubModules
        .where((subModule) => 
            subModule.name.toLowerCase().contains(query.toLowerCase()) ||
            subModule.description.toLowerCase().contains(query.toLowerCase())
        )
        .toList();

    // Create a set of parent module names from matching submodules
    Set<String> parentModuleNames = {};
    for (var subModule in subModuleMatches) {
      parentModuleNames.add(subModule.parentModule);
    }

    // Add parent modules that aren't already in moduleMatches
    for (var parentName in parentModuleNames) {
      bool alreadyIncluded = moduleMatches.any((module) => module.name == parentName);
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

  List<SubModuleItem> _getSubModulesForModule(String moduleName) {
    return _allSubModules
        .where((subModule) => subModule.parentModule == moduleName)
        .toList();
  }

  List<SubModuleItem> _getMatchingSubModules(String query, String moduleName) {
    return _allSubModules
        .where((subModule) => 
            subModule.parentModule == moduleName &&
            (subModule.name.toLowerCase().contains(query.toLowerCase()) ||
             subModule.description.toLowerCase().contains(query.toLowerCase()))
        )
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue.shade700,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  onChanged: _performSearch,
                  autofocus: widget.autoFocusSearch,
                  decoration: InputDecoration(
                    hintText: 'Search modules or features...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              _performSearch('');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _searchController.text.isEmpty
                ? _buildModulesList()
                : _searchResults.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.info_outline, size: 80, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No results found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final module = _searchResults[index];
                          return _buildSearchResultItem(context, module);
                        },
                      ),
          ),
        ],
      ),
      // Add bottom bar with correct index
      bottomNavigationBar: const BottomBar(currentIndex: 2),
    );
  }

  Widget _buildModulesList() {
    return ListView.builder(
      itemCount: _allModules.length,
      itemBuilder: (context, index) {
        final module = _allModules[index];
        return _buildModuleListItem(context, module);
      },
    );
  }

  Widget _buildModuleListItem(BuildContext context, ModuleItem module) {
    final subModules = _getSubModulesForModule(module.name);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: module.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(module.icon, color: module.color),
        ),
        title: Text(
          module.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          "${subModules.length} subsections available",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade600),
        onTap: () {
          if (subModules.isNotEmpty) {
            _showModuleDetails(context, module);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: module.route),
            );
          }
        },
      ),
    );
  }

  Widget _buildSearchResultItem(BuildContext context, ModuleItem module) {
    // Find matching subsections if any
    final String query = _searchController.text.toLowerCase();
    final List<SubModuleItem> matchingSubModules = _getMatchingSubModules(query, module.name);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: module.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(module.icon, color: module.color),
            ),
            title: Text(
              module.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: matchingSubModules.isNotEmpty
                ? Text(
                    "${matchingSubModules.length} matching features",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  )
                : null,
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: module.route),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: module.color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text('Open'),
            ),
          ),
          if (matchingSubModules.isNotEmpty) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Matching Features",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _showModuleDetails(context, module);
                    },
                    child: const Text("View All"),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: matchingSubModules.length > 3 ? 3 : matchingSubModules.length,
              itemBuilder: (context, index) {
                return _buildSubModuleItem(context, matchingSubModules[index]);
              },
            ),
            if (matchingSubModules.length > 3)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: OutlinedButton(
                  onPressed: () {
                    _showModuleDetails(context, module);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: module.color,
                    side: BorderSide(color: module.color),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("View all ${matchingSubModules.length} features"),
                ),
              ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildSubModuleItem(BuildContext context, SubModuleItem subModule) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: subModule.color.withOpacity(0.1),
        child: Icon(subModule.icon, color: subModule.color, size: 18),
      ),
      title: Text(
        subModule.name,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        subModule.description,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.open_in_new, color: subModule.color, size: 18),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: subModule.route),
          );
        },
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: subModule.route),
        );
      },
    );
  }

  void _showModuleDetails(BuildContext context, ModuleItem module) {
    final List<SubModuleItem> subModules = _getSubModulesForModule(module.name);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: module.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(module.icon, color: module.color, size: 30),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              module.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${subModules.length} features available",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
                if (subModules.isEmpty)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.info_outline, size: 80, color: Colors.grey.shade300),
                          const SizedBox(height: 16),
                          const Text(
                            'No features available',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: subModules.length,
                      itemBuilder: (context, index) {
                        return _buildSubModuleDetailItem(context, subModules[index]);
                      },
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: module.route),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: module.color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Open ${module.name}'),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSubModuleDetailItem(BuildContext context, SubModuleItem subModule) {
    final String query = _searchController.text.toLowerCase();
    final bool isMatching = subModule.name.toLowerCase().contains(query) || 
                           subModule.description.toLowerCase().contains(query);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isMatching ? subModule.color.withOpacity(0.05) : null,
        border: isMatching ? Border.all(color: subModule.color.withOpacity(0.3)) : null,
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
            if (isMatching) ...[
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