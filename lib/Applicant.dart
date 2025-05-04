import 'package:flutter/material.dart';

class ApplicantDashboard extends StatelessWidget {
  const ApplicantDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Applicant Dashboard'),
        backgroundColor: Colors.blue[800],
      ),
      body: const Center(
        child: Text(
          'Welcome to the Applicant Dashboard',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
