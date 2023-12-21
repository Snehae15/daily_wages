import 'package:daily_wage/modules/user/job%20application%20view%20.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewPostedJobDetails extends StatelessWidget {
  final String docId;
  final String jobName;
  final String place;
  final DateTime workingDate;
  final DateTime endingDate;
  final String workingTime;
  final String workingDays;
  final double amount;

  const ViewPostedJobDetails({
    Key? key,
    required this.docId,
    required this.jobName,
    required this.place,
    required this.workingDate,
    required this.endingDate,
    required this.workingTime,
    required this.workingDays,
    required this.amount,
  }) : super(key: key);

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              textAlign: TextAlign.left,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Details'),
        backgroundColor: const Color(0xFFF7F1E1),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  '$jobName',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              _buildDataRow('Place:', place),
              _buildDataRow(
                'Working start Date:',
                DateFormat('dd-MM-yyyy').format(workingDate),
              ),
              _buildDataRow(
                'Working end Date:',
                DateFormat('dd-MM-yyyy').format(endingDate),
              ),
              _buildDataRow('Working Time:', workingTime),
              _buildDataRow('Working Days:', workingDays),
              _buildDataRow('Payment:', '$amount'),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _navigateToJobApplication(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                  ),
                  child: const Text('View Job Applications'),
                ),
              ),
            ],
          ),
        ),
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
