import 'package:flutter/material.dart';

class UserviewJobapplication extends StatefulWidget {
  const UserviewJobapplication({super.key});

  @override
  State<UserviewJobapplication> createState() => _UserviewJobapplicationState();
}

class _UserviewJobapplicationState extends State<UserviewJobapplication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F1E1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Job type',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                const SizedBox(height: 20),
                buildInfoRow('Place', 'Corresponding Place'),
                buildInfoRow('Working Start date', 'Corresponding date'),
                buildInfoRow('Working end date', 'Corresponding date'),
                buildInfoRow('Working time', 'Corresponding time'),
                buildInfoRow('Working days', 'Corresponding days'),
                buildInfoRow('Payment', 'Corresponding Payment'),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Center(
        child: ElevatedButton(
          onPressed: () {
            _navigateToJobApplication(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            fixedSize: const Size(200, 50), // Set the size of the button
          ),
          child: const Text('Apply'),
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

  void _navigateToJobApplication(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UsersendedApplication()),
    );
  }
}

class UsersendedApplication extends StatefulWidget {
  const UsersendedApplication({Key? key}) : super(key: key);

  @override
  _UsersendedApplicationState createState() => _UsersendedApplicationState();
}

class _UsersendedApplicationState extends State<UsersendedApplication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F1E1),
        title: const Text('Your Applications'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                buildJobCard(
                  jobType: 'Job Type',
                  postedDate: 'Posted Date',
                  postedBy: 'User Name',
                  status: 'Available', // Change the status accordingly
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildJobCard({
    required String jobType,
    required String postedDate,
    required String postedBy,
    required String status,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          color: const Color(0xFFF7F1E1),
          elevation: 3.0,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  jobType,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(height: 12.0),
                Text('Posted Date: $postedDate'),
                Text('Posted By: $postedBy'),
                const SizedBox(height: 12.0),
                Container(
                  color: status == 'Available' ? Colors.green : Colors.red,
                  padding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 8.0,
                  ),
                  child: Text(
                    'Status: $status',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
