import 'package:daily_wage/modules/user/job%20application%20view%20.dart';
import 'package:flutter/material.dart';

class ViewpostedJobdetails extends StatefulWidget {
  const ViewpostedJobdetails({super.key});

  @override
  State<ViewpostedJobdetails> createState() => _ViewpostedJobdetailsState();
}

class _ViewpostedJobdetailsState extends State<ViewpostedJobdetails> {
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
      floatingActionButton: ElevatedButton(
        onPressed: () {
          _navigateToJobApplication(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
        ),
        child: const Text('View Job Application'),
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
      MaterialPageRoute(builder: (context) => const JobApplicationPage()),
    );
  }
}
