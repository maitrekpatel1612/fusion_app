import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:ui'; // For ImageFilter

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final AnimationController _slideController;
  late final List<AnimationController> _cardControllers;
  late final List<Animation<double>> _cardAnimations;
  // Add rotating logo animation controller
  late final AnimationController _rotationController;
  final int _numCards = 3;

  @override
  void initState() {
    super.initState();

    // Fade-in animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();

    // Slide-in animation
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();

    // Rotation animation for floating elements - slightly slower to prevent cutoff issues
    _rotationController = AnimationController(
      duration: const Duration(seconds: 12), // Slightly slower to prevent cutoff issues
      vsync: this,
    )..repeat();

    // Card animations with optimized timing
    _cardControllers = List.generate(
      _numCards,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 100),
        vsync: this,
      ),
    );

    _cardAnimations = _cardControllers
        .map((controller) => CurvedAnimation(
              parent: controller,
              curve: Curves.easeOutBack,
            ))
        .toList();

    // Start card animations with delay
    Future.delayed(const Duration(milliseconds: 300), () {
      for (var i = 0; i < _numCards; i++) {
        Future.delayed(Duration(milliseconds: 150 * i), () {
          _cardControllers[i].forward();
        });
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _rotationController.dispose(); // Dispose rotation controller
    for (var controller in _cardControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade800,
              Colors.indigo.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Animated background patterns - fixed with improved implementation
              ...List.generate(15, (index) => _buildFloatingShape(index, screenSize)),
              
              // Main content
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),

                    // App logo and title
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, -0.5),
                        end: Offset.zero,
                      ).animate(_slideController),
                      child: FadeTransition(
                        opacity: _fadeController,
                        child: Column(
                          children: [
                            // Stack the FUSION text to overlap with the bottom of the image
                            Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                // Image from assets with subtle animation
                                AnimatedBuilder(
                                  animation: _rotationController,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: 1.0 + 0.05 * math.sin(_rotationController.value * 2 * math.pi),
                                      child: SizedBox(
                                        width: 360,
                                        height: 360,
                                        child: Image.asset(
                                          'assets/image.png',
                                          fit: BoxFit.contain,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Center(
                                              child: Text(
                                                "Fusion",
                                                style: TextStyle(
                                                  fontSize: 120,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                // Position the FUSION text to overlap the image
                                Positioned(
                                  bottom: -30, 
                                  child: AnimatedBuilder(
                                    animation: _rotationController,
                                    builder: (context, child) {
                                      return Transform.scale(
                                        scale: 1.0 + 0.08 * math.sin(_rotationController.value * math.pi * 2),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 32),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Colors.blue.shade800.withOpacity(0.9),
                                                Colors.indigo.shade600.withOpacity(0.85),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(25),
                                            border: Border.all(
                                              color: Colors.white.withOpacity(0.5),
                                              width: 2,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.3),
                                                blurRadius: 15,
                                                spreadRadius: 2,
                                                offset: const Offset(0, 5),
                                              ),
                                            ],
                                          ),
                                          child: ShaderMask(
                                            blendMode: BlendMode.srcIn,
                                            shaderCallback: (bounds) => LinearGradient(
                                              colors: [
                                                Colors.white,
                                                Colors.blue.shade100,
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ).createShader(bounds),
                                            child: const Text(
                                              "FUSION",
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 46,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 6,
                                                shadows: [
                                                  Shadow(
                                                    color: Colors.black38,
                                                    offset: Offset(2, 3),
                                                    blurRadius: 7,
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
                              ],
                            ),
                            const SizedBox(height: 40),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 40),
                              child: const Text(
                                "Integrated Institute Management System",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white70,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 50),

                    // Animated cards with enhanced animations
                    _buildAnimatedCard(
                      0,
                      "About Project",
                      const [
                        "• Comprehensive institute management system for IIITDMJ",
                        "• Streamlines academic processes and administrative tasks",
                        "• Provides unified platform for communication and collaboration",
                        "• Integrates multiple modules under one system",
                        "• Designed to enhance efficiency and productivity"
                      ],
                      Icons.lightbulb_outline,
                      Colors.blue.shade700,
                    ),

                    _buildAnimatedCard(
                      1,
                      "System Features",
                      const [
                        "• Modular architecture with 25+ integrated modules",
                        "• Role-based access control system",
                        "• Real-time data synchronization across departments",
                        "• Responsive design for all device types",
                        "• Secure authentication and data encryption",
                        "• Comprehensive dashboards with data visualization",
                        "• Centralized notification system"
                      ],
                      Icons.star_outline,
                      Colors.blue.shade700,
                    ),

                    _buildAnimatedCard(
                      2,
                      "Development Info",
                      const [
                        "• Developed by 3rd year B.Tech CSE students of IIITDMJ",
                        "• Part of Software Engineering course project",
                        "• Follows Agile development methodology",
                        "• Incorporates user-centered design principles",
                        "• Open-source project available on GitHub",
                        "• Under the guidance of Prof. Atul Gupta, CSE Department"
                      ],
                      Icons.people_outline,
                      Colors.blue.shade700,
                    ),

                    // Added spacing at the bottom
                    const SizedBox(height: 60),

                    // Footer with institute name
                    FadeTransition(
                      opacity: _fadeController,
                      child: const Column(
                        children: [
                          Text(
                            "PDPM Indian Institute of Information Technology,\nDesign and Manufacturing, Jabalpur",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Padding(
                            padding: EdgeInsets.only(bottom: 30),
                            child: Text(
                              "© 2025 IIITDMJ. All Rights Reserved.",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Back button - with improved animation
              Positioned(
                top: 16,
                left: 16,
                child: AnimatedBuilder(
                  animation: _fadeController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _fadeController.value,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Improved card design with fixed opacity issue
  Widget _buildAnimatedCard(int index, String title, List<String> bulletPoints,
      IconData icon, Color accentColor) {
    return AnimatedBuilder(
      animation: _cardAnimations[index],
      builder: (context, child) {
        // Ensure opacity is always between 0.0 and 1.0
        final animationValue = _cardAnimations[index].value.clamp(0.0, 1.0);
        
        return Transform.translate(
          offset: Offset(
            0,
            50 * (1 - animationValue),
          ),
          child: Opacity(
            opacity: animationValue, // Use clamped value for opacity
            child: child, // Use the child parameter for the rest of the widget
          ),
        );
      },
      // Move complex widget tree to child for better performance
      child: AnimatedBuilder(
        animation: _rotationController,
        builder: (context, child) {
          // Faster hover animation
          final offsetY = math.sin(_rotationController.value * 5 * math.pi) * 2.5; // Increased frequency
          
          return Transform.translate(
            offset: Offset(0, offsetY),
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 30,
                    spreadRadius: 0,
                    offset: const Offset(0, 10),
                  ),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card header with enhanced title styling and glass morphism
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          // Add glass morphism effect to header
                          color: accentColor.withOpacity(0.4),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              accentColor.withOpacity(0.7),
                              accentColor.withOpacity(0.4),
                            ],
                          ),
                          // Add subtle border for glass effect
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                        ),
                        // Add backdrop filter for glass effect
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Row(
                              children: [
                                // Animated icon with pulsing effect - fixed scaling to prevent cutoff
                                AnimatedBuilder(
                                  animation: _rotationController,
                                  builder: (context, child) {
                                    // Limit scale factor to prevent cutoff
                                    final scale = 1.0 + 0.08 * math.sin(_rotationController.value * math.pi * 4);
                                    
                                    return Container(
                                      // Fixed container size to prevent cutoff
                                      width: 56, 
                                      height: 56,
                                      alignment: Alignment.center,
                                      child: Transform.scale(
                                        scale: scale,
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.3),
                                            borderRadius: BorderRadius.circular(16),
                                            // Add frosted glass effect to icon container
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white.withOpacity(0.2),
                                                blurRadius: 20,
                                                spreadRadius: 0,
                                              ),
                                            ],
                                            // Add subtle border for glass effect
                                            border: Border.all(
                                              color: Colors.white.withOpacity(0.4),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Icon(
                                            icon,
                                            color: Colors.white,
                                            size: 26, // Slightly smaller to prevent overflow
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                ),
                                const SizedBox(width: 16),
                                
                                // Enhanced title with shimmer effect and glass morphism
                                Expanded(
                                  child: ShaderMask(
                                    blendMode: BlendMode.srcIn,
                                    shaderCallback: (bounds) => LinearGradient(
                                      colors: [
                                        Colors.white,
                                        Colors.white.withOpacity(0.8),
                                        Colors.white,
                                      ],
                                      stops: const [0.0, 0.5, 1.0],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      tileMode: TileMode.clamp,
                                    ).createShader(bounds),
                                    child: Text(
                                      title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black26,
                                            offset: Offset(1, 1),
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      // Card content with improved bullet points
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          // Replace solid white with translucent glass effect
                          color: Colors.white.withOpacity(0.15),
                          // Add subtle gradient for depth
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.25),
                              Colors.white.withOpacity(0.1),
                            ],
                          ),
                          // Add very subtle border for definition
                          border: Border(
                            top: BorderSide(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                        ),
                        // Add backdrop filter to this container for true glass effect
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: bulletPoints.map((point) {
                                final bulletIndex = bulletPoints.indexOf(point);
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Improved animated bullet point
                                      _buildAnimatedBullet(accentColor, bulletIndex, _rotationController),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          point.substring(2), // Remove the bullet point from string
                                          style: const TextStyle(
                                            fontSize: 16,
                                            height: 1.5,
                                            // Changed to white text with proper opacity for readability
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
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
    );
  }

  // Improved bullet point design with fixed scaling
  AnimatedBuilder _buildAnimatedBullet(Color accentColor, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final pulseValue = math.sin(animation.value * math.pi * 3 + index).abs() * 0.8; // Reduced intensity
        
        // Fixed container with proper size to prevent cutoff
        return Container(
          width: 18, // Wider containing area
          height: 18, // Taller containing area
          alignment: Alignment.center, // Center the bullet within container
          margin: const EdgeInsets.only(top: 4),
          child: Container(
            width: 10 + (pulseValue * 2), // Limited size variation
            height: 10 + (pulseValue * 2),
            decoration: BoxDecoration(
              // Use gradient for more visually appealing bullet
              gradient: RadialGradient(
                colors: [
                  Colors.white.withOpacity(0.9),
                  accentColor,
                ],
                stops: const [0.3, 1.0],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: accentColor.withOpacity(0.2 + 0.2 * pulseValue), // Reduced opacity variation
                  blurRadius: 4 + 2 * pulseValue, // Reduced blur variation
                  spreadRadius: pulseValue, // Reduced spread
                ),
              ],
            ),
            // Add subtle inner white border for more dimension
            child: Container(
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.8),
                  width: 1,
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  // Fixed floating shape implementation to prevent cutoffs
  Widget _buildFloatingShape(int index, Size screenSize) {
    final random = math.Random(index);
    
    final size = random.nextDouble() * 40 + 10;
    final initialX = random.nextDouble() * screenSize.width;
    final initialY = random.nextDouble() * screenSize.height;
    // Ensure opacity stays within legal bounds
    final baseOpacity = 0.05 + (random.nextDouble() * 0.1);
    
    return AnimatedBuilder(
      animation: _rotationController, // Use new controller for smoother animation
      builder: (context, child) {
        // Create faster movement pattern
        final t = _rotationController.value * 3 * math.pi; // Increased frequency
        final offset = index * 0.8;
        
        // Calculate position with controlled movement range
        final offsetX = math.sin(t + offset) * math.min(20, screenSize.width * 0.05); // Limit by percentage of screen
        final offsetY = math.cos(t + offset) * math.min(20, screenSize.height * 0.05); // Limit by percentage of screen
        
        // Calculate opacity that pulses but stays within 0.0-1.0 range
        final opacityFactor = (math.sin(t * 2 + index) + 1) / 2; // Range 0.0-1.0
        final opacity = (baseOpacity + 0.05 * opacityFactor).clamp(0.0, 1.0);
        
        return Positioned(
          left: (initialX + offsetX).clamp(0, screenSize.width - size),
          top: (initialY + offsetY).clamp(0, screenSize.height - size),
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(index % 2 == 0 ? size / 2 : size / 4),
              ),
            ),
          ),
        );
      },
    );
  }
}
