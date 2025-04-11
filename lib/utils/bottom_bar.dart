import 'package:flutter/material.dart';
import 'home.dart';
import 'profile.dart';
import 'search_screen.dart';
import 'modules_screen.dart';
import '../main.dart';

class BottomBar extends StatefulWidget {
  final int currentIndex;

  const BottomBar({
    Key? key,
    this.currentIndex = 0,
  }) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> with TickerProviderStateMixin {
  late int _previousIndex;
  
  // Animation controllers
  late AnimationController _slideController;
  late AnimationController _fadeController;
  
  @override
  void initState() {
    super.initState();
    _previousIndex = widget.currentIndex;
    
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    
    _fadeController.forward();
  }
  
  @override
  void didUpdateWidget(BottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _previousIndex = oldWidget.currentIndex;
      
      // Reset and run animations
      _slideController.forward(from: 0.0);
      _fadeController.forward(from: 0.0);
    }
  }
  
  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen metrics for responsive design
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final bottomPadding = mediaQuery.padding.bottom;
    
    // Fixed height calculation
    final barHeight = 65.0 + bottomPadding;
    
    return Container(
      height: barHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, -3),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildNavItem(context, index: 0, icon: Icons.home, label: "Home"),
              _buildNavItem(context, index: 1, icon: Icons.book, label: "Modules"),
              _buildNavItem(context, index: 2, icon: Icons.search, label: "Search"),
              _buildNavItem(context, index: 3, icon: Icons.person, label: "Profile"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = index == widget.currentIndex;
    
    return Expanded(
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => _handleNavigation(context, index),
        child: AnimatedBuilder(
          animation: Listenable.merge([_slideController, _fadeController]),
          builder: (context, _) {
            final isLeaving = index == _previousIndex && _previousIndex != widget.currentIndex;
            final isEntering = index == widget.currentIndex && _previousIndex != widget.currentIndex;
            
            // Only animate opacity, NOT position (to avoid jumping)
            double opacity = 1.0;
            
            if (isLeaving) {
              opacity = 1.0 - (_slideController.value * 0.2);
            } else if (isEntering) {
              opacity = 0.8 + (_slideController.value * 0.2);
            }
            
            // Color transitions
            final Color iconColor = isSelected 
              ? Color.lerp(Colors.grey, Colors.blue.shade700, _fadeController.value)!
              : Colors.grey;
            
            final Color textColor = isSelected
              ? Color.lerp(Colors.grey, Colors.blue.shade700, _fadeController.value)!
              : Colors.grey;
            
            return Opacity(
              opacity: opacity,
              child: SizedBox(
                height: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: isSelected ? 24 : 22,
                      color: iconColor,
                    ),
                    const SizedBox(height: 3),
                    AnimatedBuilder(
                      animation: _fadeController,
                      builder: (context, _) {
                        return AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: isSelected ? 11 : 10,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: textColor,
                            letterSpacing: isSelected ? 0.4 : 0,
                          ),
                          child: isSelected
                            ? Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue.shade400,
                                      Colors.blue.shade600,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.withOpacity(0.2 * _fadeController.value),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  label,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            : Text(label),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    // Don't navigate if already on the selected page
    if (index == widget.currentIndex) return;

    switch (index) {
      case 0:
        // If already at root (no previous routes), don't do anything
        if (Navigator.of(context).canPop() == false) return;

        // Navigate to HomeScreen with ExitConfirmationWrapper
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const ExitConfirmationWrapper(child: HomeScreen()),
            transitionDuration: Duration.zero,
          ),
          (route) => false, // Remove all previous routes
        );
        break;
      case 1:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const ModulesScreen(),
            transitionDuration: Duration.zero,
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const SearchScreen(autoFocusSearch: false),
            transitionDuration: Duration.zero,
          ),
        );
        break;
      case 3:
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const ProfileScreen(),
            transitionDuration: Duration.zero,
          ),
          (route) => route.isFirst,
        );
        break;
    }
  }
}
