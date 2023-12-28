import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  final Map<String, dynamic> userData;

  const UserProfilePage({
    required this.userData,
    Key? key,
  }) : super(key: key);

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
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/person.png'),
                      radius: 50,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userData['userName'] ?? 'User Name',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              buildInfoRow('Phone Number', userData['phoneNumber'] ?? 'N/A'),
              buildInfoRow('Email', userData['email'] ?? 'N/A'),
              buildInfoRow('City', userData['city'] ?? 'N/A'),
              buildInfoRow('Address', userData['address'] ?? 'N/A'),
              buildInfoRow('Gender', userData['gender'] ?? 'N/A'),
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
