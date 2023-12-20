import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: const Color(0xFFF7F1E1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/person.png'),
                      radius: 50,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'User Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              buildInfoRow('View Name', 'Corresponding Name'),
              buildInfoRow('Phone Number', 'Corresponding Value'),
              buildInfoRow('Email', 'Corresponding Value'),
              buildInfoRow('City', 'Corresponding Value'),
              buildInfoRow('Address', 'Corresponding Value'),
              buildInfoRow('Gender', 'Corresponding Value'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          const SizedBox(width: 10),
          Text(value),
        ],
      ),
    );
  }
}
