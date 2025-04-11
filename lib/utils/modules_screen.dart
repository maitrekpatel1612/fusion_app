import 'package:flutter/material.dart';
import 'bottom_bar.dart';
import 'sidebar.dart';
import 'gesture_sidebar.dart';
import '../screens/Examination/examination_dashboard.dart';

class ModulesScreen extends StatefulWidget {
  const ModulesScreen({Key? key}) : super(key: key);

  @override
  _ModulesScreenState createState() => _ModulesScreenState();
}

class _ModulesScreenState extends State<ModulesScreen> with TickerProviderStateMixin {
  final Color primaryBlue = const Color(0xFF1E88E5);
  late AnimationController _animationController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // App-specific modules with icons from the sidebar
  final List<Module> _modules = [
    Module(id: '1', title: 'Examination', icon: Icons.school),
    Module(id: '2', title: 'Patent', icon: Icons.brightness_7),
    Module(id: '3', title: 'Placement', icon: Icons.work),
    Module(id: '4', title: 'Library', icon: Icons.local_library),
    Module(id: '5', title: 'Hostel', icon: Icons.apartment),
    Module(id: '6', title: 'Academic Calendar', icon: Icons.calendar_today),
    Module(id: '7', title: 'Finance', icon: Icons.account_balance_wallet),
    Module(id: '8', title: 'File Tracking', icon: Icons.file_copy),
    Module(id: '9', title: 'Purchase', icon: Icons.shopping_cart),
    Module(id: '10', title: 'Programme & Curriculum', icon: Icons.menu_book),
    Module(id: '11', title: 'Inventory', icon: Icons.inventory_2),
    Module(id: '12', title: 'Event Management', icon: Icons.event_available),
    Module(id: '13', title: 'Human Resources', icon: Icons.people_alt),
    Module(id: '14', title: 'Alumni Network', icon: Icons.group),
    Module(id: '15', title: 'Research', icon: Icons.science),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: const Sidebar(),
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Modules',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: false, // Changed from true to false to make it left-aligned
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
      ),
      body: GestureSidebar(
        scaffoldKey: _scaffoldKey,
        child: _buildModuleGrid(),
      ),
      bottomNavigationBar: const BottomBar(currentIndex: 1),
    );
  }

  Widget _buildModuleGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine the number of columns based on the screen width
        int crossAxisCount = 3;
        
        // For very small screens (e.g., small phones in portrait)
        if (constraints.maxWidth < 360) {
          crossAxisCount = 2;
        } 
        // For very large screens or tablets
        else if (constraints.maxWidth > 600) {
          crossAxisCount = 4;
        }

        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return GridView.builder(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.0,
              ),
              itemCount: _modules.length,
              itemBuilder: (context, index) {
                final delay = index * 0.05;
                final animation = CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(
                    delay.clamp(0.0, 0.7),
                    (delay + 0.4).clamp(0.0, 1.0),
                    curve: Curves.easeOutQuad,
                  ),
                );
                
                return AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 0.5 + (0.5 * animation.value),
                      child: Opacity(
                        opacity: animation.value,
                        child: child,
                      ),
                    );
                  },
                  child: CompactModuleCard(
                    module: _modules[index],
                    color: primaryBlue,
                    onTap: () {
                      // Navigate to appropriate screens based on the module
                      if (_modules[index].id == '1') { // Examination module
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ExaminationDashboard(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Opening ${_modules[index].title} module'),
                            duration: const Duration(seconds: 2),
                            backgroundColor: primaryBlue,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.all(10),
                          ),
                        );
                      }
                    }
                  ),
                );
              },
            );
          },
        );
      }
    );
  }
}

class Module {
  final String id;
  final String title;
  final IconData icon;

  Module({
    required this.id,
    required this.title,
    required this.icon,
  });
}

class CompactModuleCard extends StatelessWidget {
  final Module module;
  final Color color;
  final VoidCallback onTap;

  const CompactModuleCard({
    Key? key, 
    required this.module,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.white.withOpacity(0.3),
        highlightColor: Colors.white.withOpacity(0.1),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color,
                color.withOpacity(0.8),
              ],
            ),
          ),
          child: Stack(
            children: [
              // Background icon
              Positioned(
                right: -15,
                bottom: -15, 
                child: Icon(
                  module.icon,
                  size: 60,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
              
              // Content - center aligned
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icon - centered
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 3,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          module.icon,
                          color: color,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Module title - centered and flexible
                      Flexible(
                        child: Text(
                          module.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Shine effect
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.15),
                        Colors.transparent,
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.3, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}