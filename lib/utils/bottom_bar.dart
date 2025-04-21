import 'package:flutter/material.dart';
import 'home.dart';
import 'profile.dart';
import 'search_screen.dart';
import 'modules_screen.dart';

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
      duration: const Duration(milliseconds: 600), // Reverted from 1200ms to original 600ms
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450), // Reverted from 900ms to original 450ms
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

    // Increased height calculation to accommodate larger elements (+5px)
    final barHeight = 70.0 + bottomPadding; // Increased from 65.0 to 70.0

    // Determine if we need to use compact mode for small screens
    final bool useCompactMode = screenWidth < 340;

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
              _buildNavItem(context,
                  index: 0,
                  icon: Icons.home,
                  label: "Home",
                  compact: useCompactMode),
              _buildNavItem(context,
                  index: 1,
                  icon: Icons.book,
                  label: "Modules",
                  compact: useCompactMode),
              _buildNavItem(context,
                  index: 2,
                  icon: Icons.search,
                  label: "Search",
                  compact: useCompactMode),
              _buildNavItem(context,
                  index: 3,
                  icon: Icons.person,
                  label: "Profile",
                  compact: useCompactMode),
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
    required bool compact,
  }) {
    final isSelected = index == widget.currentIndex;
    final availableWidth = MediaQuery.of(context).size.width / 4;
    final maxLabelWidth =
        availableWidth - 8; // Reduced padding for more text space

    return Expanded(
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => _handleNavigation(context, index),
        child: AnimatedBuilder(
          animation: Listenable.merge([_slideController, _fadeController]),
          builder: (context, _) {
            final isLeaving = index == _previousIndex &&
                _previousIndex != widget.currentIndex;
            final isEntering = index == widget.currentIndex &&
                _previousIndex != widget.currentIndex;

            // Smoother opacity transition with curved animation
            double opacity = 1.0;
            if (isLeaving) {
              opacity = 1.0 - (_slideController.value * 0.2);
            } else if (isEntering) {
              opacity = 0.8 + (_slideController.value * 0.2);
            }

            // Color transitions with smoother curve
            final Color iconColor = isSelected
                ? Color.lerp(
                    Colors.grey, 
                    Colors.blue.shade700, 
                    Curves.easeInOut.transform(_fadeController.value))!
                : Colors.grey;

            // Add size animation for icons
            final double iconSize = isSelected 
                ? 24 + (4 * Curves.easeInOut.transform(_fadeController.value))
                : 24;
                
            // Calculate scale for the label container - completely shrink to zero and grow to normal
            // Using Curves.easeInOut for smoother animation and more pronounced effect
            double labelScale;
            if (isLeaving) {
              // Complete shrink when leaving (shrink to zero)
              labelScale = 1.0 - Curves.easeInOut.transform(_slideController.value);
            } else if (isEntering) {
              // Complete grow when entering (from zero to full size)
              labelScale = Curves.easeOut.transform(_slideController.value);
            } else if (isSelected) {
              // Full size when selected
              labelScale = 1.0;
            } else {
              // Slightly smaller size for unselected items
              labelScale = 0.9;
            }

            return Opacity(
              opacity: opacity,
              child: SizedBox(
                height: 55, // Increased from 50 to 55
                width: availableWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: iconSize,
                      color: iconColor,
                    ),
                    SizedBox(height: compact ? 2 : 3), // Increased spacing
                    Transform.scale(
                      scale: labelScale,
                      alignment: Alignment.center,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: maxLabelWidth,
                          maxHeight: 20, // Added explicit height constraint
                        ),
                        child: isSelected
                            ? _buildSelectedLabel(label, compact)
                            : _buildUnselectedLabel(label, compact),
                      ),
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

  Widget _buildSelectedLabel(String label, bool compact) {
    // For very small screens, still show minimal text
    if (MediaQuery.of(context).size.width < 280) {
      // Show at least 3 characters instead of just a dot
      String shortText =
          label.substring(0, label.length > 3 ? 3 : label.length);
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.blue.shade700,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade200.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          shortText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10, // Increased font size
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    // Allow more characters for profile text
    int maxChars = compact ? 6 : 8;
    // Special case for "Profile" to ensure it fits
    if (label == "Profile") {
      maxChars = compact ? 7 : 9;
    }

    String displayText =
        label.length > maxChars ? label.substring(0, maxChars) : label;

    return AnimatedBuilder(
      animation: _slideController,
      builder: (context, child) {
        // Calculate width for the container animation
        final double horizontalPadding = 
            compact ? 4 : 6;
            
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: Colors.blue.shade700,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade200.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: child,
        );
      },
      child: Text(
        displayText,
        style: TextStyle(
          color: Colors.white,
          fontSize: compact ? 12 : 13, // Larger font for better readability
          fontWeight: FontWeight.w600,
          letterSpacing: -0.1, // Slightly tighter letter spacing
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Widget _buildUnselectedLabel(String label, bool compact) {
    // For very small screens, still show some text
    if (MediaQuery.of(context).size.width < 280) {
      // Show at least 2 characters
      String shortText =
          label.substring(0, label.length > 2 ? 2 : label.length);
      return Text(
        shortText,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 9, // Increased font size
          fontWeight: FontWeight.w400,
        ),
        textAlign: TextAlign.center,
      );
    }

    // Allow more characters for regular display
    int maxChars = compact ? 6 : 8;
    // Special case for "Profile" to ensure it fits
    if (label == "Profile") {
      maxChars = compact ? 7 : 9;
    }

    String displayText =
        label.length > maxChars ? label.substring(0, maxChars) : label;

    return Text(
      displayText,
      style: TextStyle(
        color: Colors.grey,
        fontSize: compact ? 11 : 12, // Larger font for better readability
        fontWeight: FontWeight.w500,
        letterSpacing: -0.1, // Slightly tighter letter spacing
      ),
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    // Don't navigate if already on the selected page
    if (index == widget.currentIndex) return;

    switch (index) {
      case 0:
        // If already at root (no previous routes), don't do anything
        if (Navigator.of(context).canPop() == false) return;

        // Navigate to HomeScreen directly without ExitConfirmationWrapper
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const HomeScreen(),
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
            pageBuilder: (_, __, ___) =>
                const SearchScreen(autoFocusSearch: false),
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
