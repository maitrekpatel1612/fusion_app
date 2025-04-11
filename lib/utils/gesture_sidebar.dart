import 'package:flutter/material.dart';

class GestureSidebar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Widget child;
  final double sensitivity;

  const GestureSidebar({
    Key? key,
    required this.scaffoldKey,
    required this.child,
    this.sensitivity = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Only open drawer with sufficient horizontal movement and when starting near the edge
        if (details.delta.dx > sensitivity && 
            details.globalPosition.dx < MediaQuery.of(context).size.width * 0.15) {
          scaffoldKey.currentState?.openDrawer();
        }
      },
      behavior: HitTestBehavior.translucent, // Makes gesture detection more reliable
      child: child,
    );
  }
}