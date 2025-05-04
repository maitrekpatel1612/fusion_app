import 'package:flutter/material.dart';

class DirectorDashboard extends StatelessWidget {
  const DirectorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Director Dashboard'),
        backgroundColor: Colors.deepPurple[800],
      ),
      body: const Center(
        child: Text(
          'Welcome to the Director Dashboard',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
