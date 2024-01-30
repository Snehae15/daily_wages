import 'package:flutter/material.dart';

class UsersendedApplication extends StatelessWidget {
  const UsersendedApplication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Submitted'),
        backgroundColor: const Color(0xFFF7F1E1),
      ),
      body: const Center(
        child: Text(
          'Your application has been submitted successfully!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
