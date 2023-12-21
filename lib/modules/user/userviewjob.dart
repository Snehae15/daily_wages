import 'package:flutter/material.dart';

class UserviewJobapplication extends StatefulWidget {
  const UserviewJobapplication({
    Key? key,
    required this.place,
    required this.jobName,
    required this.amount,
    required this.workingDate,
    required this.endingDate,
    required this.workingTime,
    required this.workingDays,
  }) : super(key: key);

  final String place;
  final String jobName;
  final String amount;
  final String workingDate;
  final String endingDate;
  final String workingTime;
  final String workingDays;

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
                Text(
                  widget.jobName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 20),
                buildInfoRow('Place', widget.place),
                buildInfoRow('Working Date', widget.workingDate),
                buildInfoRow('Ending Date', widget.endingDate),
                buildInfoRow('Working Time', widget.workingTime),
                buildInfoRow('Working Days', widget.workingDays),
                buildInfoRow('Amount', '\$${widget.amount}'),
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
            fixedSize: const Size(200, 50),
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
                  status: 'Available',
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
