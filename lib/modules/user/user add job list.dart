import 'package:daily_wage/modules/user/posted%20job%20deatils%20view.dart';
import 'package:daily_wage/modules/user/user%20add%20job.dart';
import 'package:flutter/material.dart';

class UserAddJob extends StatelessWidget {
  const UserAddJob({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Job'),
        backgroundColor: const Color(0xFFF7F1E1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Add your form fields or any content related to adding a job

            // Example card with job details
            _buildJobCard(
              context,
              jobType: 'Example Job Type',
              jobDate: '2023-01-01', // Replace with the actual date format
              workingHour: '12:00 PM', // Replace with the actual time format
              amount: '100',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddJob(context);
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _navigateToAddJob(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddJobPage()),
    );
  }

  void _navigateToViewPostedJobDetails(BuildContext context, String jobType,
      String jobDate, String workingHour, String amount) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ViewpostedJobdetails(),
      ),
    );
  }

  Widget _buildJobCard(
    BuildContext context, {
    required String jobType,
    required String jobDate,
    required String workingHour,
    required String amount,
  }) {
    return GestureDetector(
      onTap: () {
        _navigateToViewPostedJobDetails(
            context, jobType, jobDate, workingHour, amount);
      },
      child: Card(
        color: const Color(0xFFF7F1E1),
        elevation: 3.0,
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Job Type',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Implement delete logic
                    },
                    icon: const Icon(Icons.delete),
                    color: Colors.black, // Change icon color to black
                  ),
                ],
              ),
              const SizedBox(height: 10.0),

              // Spacing
              const SizedBox(height: 10.0),

              // Job details
              Text('Job Date: $jobDate'),
              Text('Working Hour: $workingHour'),
              Text('Amount: $amount'),
            ],
          ),
        ),
      ),
    );
  }
}
