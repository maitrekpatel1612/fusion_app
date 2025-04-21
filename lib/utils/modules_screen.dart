import 'package:flutter/material.dart';
import 'bottom_bar.dart';
import 'sidebar.dart';
import 'gesture_sidebar.dart';
import '../screens/Examination/examination_dashboard.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ModulesScreen extends StatefulWidget {
  const ModulesScreen({Key? key}) : super(key: key);

  @override
  _ModulesScreenState createState() => _ModulesScreenState();
}

class _ModulesScreenState extends State<ModulesScreen> with TickerProviderStateMixin {
  final Color moduleBlue = Colors.blue.shade700;
  late AnimationController _animationController;
  late ScrollController _scrollController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  // App-specific modules with icons
  final List<Module> _modules = [
    Module(id: '1', title: 'Examination', icon: Icons.school, size: ModuleSize.large),
    Module(id: '2', title: 'Patent', icon: Icons.brightness_7, size: ModuleSize.small),
    Module(id: '3', title: 'Placement', icon: Icons.work, size: ModuleSize.medium),
    Module(id: '4', title: 'Library', icon: Icons.local_library, size: ModuleSize.small),
    Module(id: '5', title: 'Hostel', icon: Icons.apartment, size: ModuleSize.medium),
    Module(id: '6', title: 'Academic Calendar', icon: Icons.calendar_today, size: ModuleSize.medium),
    Module(id: '7', title: 'Finance', icon: Icons.account_balance_wallet, size: ModuleSize.small),
    Module(id: '8', title: 'File Tracking', icon: Icons.file_copy, size: ModuleSize.large),
    Module(id: '9', title: 'Purchase', icon: Icons.shopping_cart, size: ModuleSize.small),
    Module(id: '10', title: 'Programme & Curriculum', icon: Icons.menu_book, size: ModuleSize.medium),
    Module(id: '11', title: 'Inventory', icon: Icons.inventory_2, size: ModuleSize.small),
    Module(id: '12', title: 'Event Management', icon: Icons.event_available, size: ModuleSize.large),
    Module(id: '13', title: 'Human Resources', icon: Icons.people_alt, size: ModuleSize.medium),
    Module(id: '14', title: 'Alumni Network', icon: Icons.group, size: ModuleSize.small),
    Module(id: '15', title: 'Research', icon: Icons.science, size: ModuleSize.medium),
  ];
  
  // Recently used modules - will be populated from SharedPreferences
  final List<Module> _recentModules = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Increased from 1000 to 1500 milliseconds
    );
    _scrollController = ScrollController();
    _animationController.forward();
    
    // Randomize the module sizes for a more dynamic layout
    List<ModuleSize> sizes = [ModuleSize.small, ModuleSize.medium, ModuleSize.large];
    for (int i = 0; i < _modules.length; i++) {
      _modules[i].size = sizes[i % 3];
    }
    
    // Load recent modules from shared preferences
    _loadRecentModules();
  }

  // Load recently used modules from SharedPreferences
  Future<void> _loadRecentModules() async {
    final prefs = await SharedPreferences.getInstance();
    final recentModuleIds = prefs.getStringList('recent_modules') ?? [];
    
    // Clear current list
    _recentModules.clear();
    
    // Add modules to recent list based on saved IDs
    for (String id in recentModuleIds) {
      final module = _modules.firstWhere(
        (module) => module.id == id,
        orElse: () => _modules[0], // Default to first module if not found
      );
      _recentModules.add(module);
    }
    
    // If no recent modules, initialize with first 4 modules
    if (_recentModules.isEmpty) {
      _recentModules.addAll(_modules.take(4));
    }
    
    // Limit to 4 recent modules
    if (_recentModules.length > 4) {
      _recentModules.removeRange(4, _recentModules.length);
    }
    
    // Update UI
    if (mounted) setState(() {});
  }
  
  // Update recently used modules when a module is accessed
  Future<void> _updateRecentModules(Module module) async {
    // Remove the module if it already exists in recent modules
    _recentModules.removeWhere((m) => m.id == module.id);
    
    // Add the module to the start of the list
    _recentModules.insert(0, module);
    
    // Keep only the most recent 4 modules
    if (_recentModules.length > 4) {
      _recentModules.removeRange(4, _recentModules.length);
    }
    
    // Save to shared preferences
    final prefs = await SharedPreferences.getInstance();
    final recentModuleIds = _recentModules.map((m) => m.id).toList();
    await prefs.setStringList('recent_modules', recentModuleIds);
    
    // Update UI
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[50],
      drawer: const Sidebar(),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Modules',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                moduleBlue.withOpacity(0.9),
                moduleBlue,
              ],
            ),
          ),
        ),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        // Update shape to use continuous rounded corners for a more circular appearance
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
      ),
      body: GestureSidebar(
        scaffoldKey: _scaffoldKey,
        child: Stack(
          children: [
            // Background designs
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: moduleBlue.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -120,
              right: -70,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: moduleBlue.withOpacity(0.07),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            
            // Main content
            NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                // You could add scroll animations here
                return false;
              },
              child: _buildModernModuleLayout(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomBar(currentIndex: 1),
    );
  }

  Widget _buildModernModuleLayout() {
    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(), // Adding elastic scroll physics
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(top: 120, left: 16, right: 16),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recent Modules section
                Text(
                  'Recently Used',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Horizontal list of recent modules
                SizedBox(
                  height: 110, // Fixed height for the horizontal list
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _recentModules.length,
                    itemBuilder: (context, index) {
                      // Create smaller, simplified versions of the module cards
                      final module = _recentModules[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            final delay = index * 0.05;
                            final animation = CurvedAnimation(
                              parent: _animationController,
                              curve: Interval(
                                delay.clamp(0.0, 0.4),
                                (delay + 0.3).clamp(0.0, 1.0),
                                curve: Curves.easeOut,
                              ),
                            );
                            return Transform.translate(
                              offset: Offset(50 * (1 - animation.value), 0),
                              child: Opacity(
                                opacity: animation.value,
                                child: child,
                              ),
                            );
                          },
                          child: _buildRecentModuleItem(module),
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // All Modules section
                Text(
                  'All Modules',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        
        SliverPadding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
          sliver: SliverToBoxAdapter(
            child: StaggeredModuleGrid(modules: _modules, animationController: _animationController),
          ),
        ),
      ],
    );
  }

  // Simplified module card for recent modules
  Widget _buildRecentModuleItem(Module module) {
    final moduleColor = moduleBlue;
    return InkWell(
      onTap: () {
        // Update recent modules when tapped
        _updateRecentModules(module);
        
        if (module.id == '1') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ExaminationDashboard(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening ${module.title} module'),
              duration: const Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 110,
        decoration: BoxDecoration(
          color: moduleColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: moduleColor.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: moduleColor.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                module.icon,
                color: moduleColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              module.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// Staggered grid layout for modules with different sizes
class StaggeredModuleGrid extends StatelessWidget {
  final List<Module> modules;
  final AnimationController animationController;

  const StaggeredModuleGrid({
    Key? key,
    required this.modules,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        int columnCount = maxWidth > 600 ? 4 : maxWidth > 400 ? 3 : 2;
        
        // Create rows of modules with mixed sizes
        List<Widget> rows = [];
        
        for (int i = 0; i < modules.length; i += columnCount) {
          List<Widget> rowChildren = [];
          
          for (int j = 0; j < columnCount; j++) {
            int index = i + j;
            if (index < modules.length) {
              // Animation delay based on position - increased for more pronounced staggering
              final delay = index * 0.07; // Increased from 0.05 to 0.07
              final animation = CurvedAnimation(
                parent: animationController,
                curve: Interval(
                  delay.clamp(0.0, 0.8), // Increased upper bound from 0.7 to 0.8
                  (delay + 0.5).clamp(0.0, 1.0), // Increased duration from 0.4 to 0.5
                  curve: Curves.easeOutQuart,
                ),
              );
              
              rowChildren.add(
                Expanded(
                  child: AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, 50 * (1 - animation.value)),
                        child: Opacity(
                          opacity: animation.value,
                          child: child,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: _buildModuleItem(modules[index], context),
                    ),
                  ),
                ),
              );
            } else {
              // Empty space to maintain grid
              rowChildren.add(Expanded(child: Container()));
            }
          }
          
          rows.add(Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rowChildren,
          ));
        }
        
        return Column(
          children: rows,
        );
      },
    );
  }

  Widget _buildModuleItem(Module module, BuildContext context) {
    // Use fixed size with increased height for longer cards
    return SizedBox(
      height: 160, // Increased height from 135 to 160
      child: ModernModuleCard(
        module: module,
        onModuleTapped: (module) {
          // Call _updateRecentModules from parent
          if (context.findAncestorStateOfType<_ModulesScreenState>() != null) {
            context.findAncestorStateOfType<_ModulesScreenState>()!._updateRecentModules(module);
          }
        },
      ),
    );
  }
}

// Modern card design that breaks away from squares
class ModernModuleCard extends StatefulWidget {
  final Module module;
  final Function(Module)? onModuleTapped;

  const ModernModuleCard({
    Key? key,
    required this.module,
    this.onModuleTapped,
  }) : super(key: key);

  @override
  State<ModernModuleCard> createState() => _ModernModuleCardState();
}

class _ModernModuleCardState extends State<ModernModuleCard> with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  bool isHovered = false;
  bool isLongPressed = false;
  
  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100), // Reduced from 200ms to 100ms for smoother animation
    );
  }
  
  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  // Use a consistent blue color for all modules
  Color _getModuleColor() {
    return Colors.blue.shade700;
  }

  @override
  Widget build(BuildContext context) {
    final Color moduleColor = _getModuleColor();
    
    return GestureDetector(
      onLongPressStart: (_) {
        setState(() {
          isLongPressed = true;
        });
        _hoverController.forward();
      },
      onLongPressEnd: (_) {
        setState(() {
          isLongPressed = false;
        });
        _hoverController.reverse();
      },
      onPanStart: (_) {
        if (!isHovered && !isLongPressed) {
          setState(() {
            isLongPressed = true;
          });
          _hoverController.forward();
        }
      },
      onPanEnd: (_) {
        if (isLongPressed) {
          setState(() {
            isLongPressed = false;
          });
          _hoverController.reverse();
        }
      },
      onPanCancel: () {
        if (isLongPressed) {
          setState(() {
            isLongPressed = false;
          });
          _hoverController.reverse();
        }
      },
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            isHovered = true;
          });
          _hoverController.forward();
        },
        onExit: (_) {
          setState(() {
            isHovered = false;
          });
          // Only reverse if not being long pressed
          if (!isLongPressed) {
            _hoverController.reverse();
          }
        },
        child: AnimatedBuilder(
          animation: _hoverController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + (_hoverController.value * 0.03),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: moduleColor.withOpacity(0.2 + (_hoverController.value * 0.1)),
                      blurRadius: 10 + (_hoverController.value * 10),
                      offset: Offset(0, 4 + (_hoverController.value * 2)),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      // Show animation first by forwarding the controller
                      _hoverController.forward();
                      
                      // Increased delay from 150ms to 300ms to better see the animation
                      Future.delayed(const Duration(milliseconds: 300), () {
                        // Reset the animation
                        _hoverController.reverse();
                        
                        // Update recent modules
                        if (widget.onModuleTapped != null) {
                          widget.onModuleTapped!(widget.module);
                        }
                        
                        // Navigate to appropriate screens based on the module
                        if (widget.module.id == '1') { // Examination module
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ExaminationDashboard(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Opening ${widget.module.title} module'),
                              duration: const Duration(seconds: 2),
                              backgroundColor: moduleColor,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.all(10),
                            ),
                          );
                        }
                      });
                    },
                    splashColor: Colors.white.withOpacity(0.3),
                    highlightColor: Colors.white.withOpacity(0.1),
                    // ... rest of the child widgets
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Main card body
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                moduleColor.withOpacity(0.9),
                                moduleColor,
                              ],
                            ),
                          ),
                        ),
                        
                        // Abstract wave pattern
                        Positioned.fill(
                          child: CustomPaint(
                            painter: FluidModulePainter(
                              color: Colors.white.withOpacity(0.07),
                              animationValue: _hoverController.value,
                            ),
                          ),
                        ),
                        
                        // Content container
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center, // Changed from start to center
                            mainAxisAlignment: MainAxisAlignment.center, // Added to center vertically
                            children: [
                              // Module icon with floating container effect - now centered
                              Transform.scale(
                                scale: 1.0 + (0.1 * _hoverController.value), // Icon scales up by 10%
                                child: Transform.translate(
                                  offset: Offset(
                                    0, 
                                    -5 * _hoverController.value
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          color: moduleColor.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      widget.module.icon,
                                      color: moduleColor,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                              
                              // Small gap between icon and text
                              const SizedBox(height: 12),
                              
                              // Module title with increased font size and better wrapping - now center aligned
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  widget.module.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16, // Increased from 14 to 16
                                    height: 1.2, // Slightly increased line height for better readability
                                    letterSpacing: 0.2,
                                  ),
                                  textAlign: TextAlign.center, // Center text horizontally
                                  maxLines: 4, // Increased from 3 to 4 to allow more wrapping
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true, // Explicitly enable text wrapping
                                ),
                              ),
                              
                              // Animated line that extends from left to right with no visible dot
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 250), // Increased from 100 to 250
                                    margin: const EdgeInsets.only(top: 8), // Increased from 5 to 8 for better visibility
                                    width: constraints.maxWidth * _hoverController.value, // Start from 0 and extend to full width
                                    height: 2,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(1),
                                    ),
                                  );
                                },
                              ),
                              
                              // We'll remove the spacer and use mainAxisAlignment instead
                              // to better center the content vertically
                            ],
                          ),
                        ),
                        
                        // Corner accent shape
                        Positioned(
                          top: -4,
                          right: -4,
                          child: Transform.rotate(
                            angle: math.pi / 4,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
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
      ),
    );
  }
}

// Fluid animated painter for the background pattern
class FluidModulePainter extends CustomPainter {
  final Color color;
  final double animationValue;
  
  FluidModulePainter({
    required this.color,
    required this.animationValue,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;
    
    // Create fluid, organic shapes that move slightly with animation
    Path path = Path();
    path.moveTo(0, size.height * (0.7 - 0.1 * animationValue));
    path.quadraticBezierTo(
      size.width * (0.2 + 0.05 * animationValue), 
      size.height * (0.9 - 0.05 * animationValue), 
      size.width * (0.5 + 0.05 * animationValue), 
      size.height * (0.75 + 0.05 * animationValue));
    path.quadraticBezierTo(
      size.width * (0.8 - 0.05 * animationValue), 
      size.height * (0.6 + 0.1 * animationValue), 
      size.width, 
      size.height * (0.8 - 0.05 * animationValue));
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
    
    // Second fluid shape
    paint.color = color.withOpacity(0.7);
    Path path2 = Path();
    path2.moveTo(0, size.height * (0.4 + 0.05 * animationValue));
    path2.quadraticBezierTo(
      size.width * (0.25 - 0.05 * animationValue), 
      size.height * (0.3 + 0.05 * animationValue), 
      size.width * (0.5 - 0.05 * animationValue), 
      size.height * (0.4 - 0.05 * animationValue));
    path2.quadraticBezierTo(
      size.width * (0.75 + 0.05 * animationValue), 
      size.height * (0.5 - 0.05 * animationValue), 
      size.width, 
      size.height * (0.3 + 0.05 * animationValue));
    path2.lineTo(size.width, size.height * 0.5);
    path2.lineTo(0, size.height * 0.5);
    path2.close();
    
    canvas.drawPath(path2, paint);
    
    // Dots pattern for added texture
    if (animationValue > 0.1) {
      paint.color = color.withOpacity(0.2 * animationValue);
      final dotSize = size.width * 0.02;
      final spacing = size.width * 0.08;
      for (double x = dotSize; x < size.width; x += spacing) {
        for (double y = dotSize; y < size.height * 0.7; y += spacing) {
          canvas.drawCircle(Offset(x, y), dotSize / 2, paint);
        }
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Size options for varied module sizes
enum ModuleSize {
  small,
  medium,
  large,
}

class Module {
  final String id;
  final String title;
  final IconData icon;
  ModuleSize size;

  Module({
    required this.id,
    required this.title,
    required this.icon,
    this.size = ModuleSize.medium,
  });
}