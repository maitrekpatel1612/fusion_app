import 'package:flutter/material.dart';

class ViewApplicationsPage extends StatelessWidget {
  const ViewApplicationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Applications'),
      ),
      body: const Center(
        child: Text(
          'Submitted applications will be shown here.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
