import 'package:flutter/material.dart';

class SavedDraftsPage extends StatelessWidget {
  const SavedDraftsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Drafts'),
      ),
      body: const Center(
        child: Text(
          'No saved drafts available.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
