import 'package:flutter/material.dart';

class PCCAdminDashboard extends StatelessWidget {
  const PCCAdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PCC Admin Dashboard'),
        backgroundColor: Colors.green[800],
      ),
      body: const Center(
        child: Text(
          'Welcome to the PCC Admin Dashboard',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
