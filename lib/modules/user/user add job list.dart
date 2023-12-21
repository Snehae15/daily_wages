import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_wage/modules/user/View%20Posted%20Job%20Details.dart';
import 'package:daily_wage/modules/user/user%20add%20job.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserAddJob extends StatelessWidget {
  const UserAddJob({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs'),
        backgroundColor: const Color(0xFFF7F1E1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('add_job')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  final jobCards = snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return _buildJobCard(
                      context,
                      docId: doc.id,
                      jobName: data['jobName'],
                      place: data['place'],
                      workingDate: (data['workingDate'] as Timestamp).toDate(),
                      endingDate: (data['endingDate'] as Timestamp).toDate(),
                      workingTime: data['workingTime'],
                      workingDays: data['workingDays'],
                      amount: data['amount']?.toDouble() ?? 0.0,
                    );
                  }).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: jobCards,
                  );
                },
              ),
            ],
          ),
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

  void _navigateToViewPostedJobDetails(
    BuildContext context,
    String docId,
    String jobName,
    String place,
    DateTime workingDate,
    DateTime endingDate,
    String workingTime,
    String workingDays,
    double amount,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewPostedJobDetails(
          docId: docId,
          jobName: jobName,
          place: place,
          workingDate: workingDate,
          endingDate: endingDate,
          workingTime: workingTime,
          workingDays: workingDays,
          amount: amount,
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, String docId) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Job'),
          content: const Text('Are you sure you want to delete this job?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteJob(docId);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteJob(String docId) {
    FirebaseFirestore.instance.collection('add_job').doc(docId).delete();
  }

  Widget _buildJobCard(
    BuildContext context, {
    required String docId,
    required String jobName,
    required String place,
    required DateTime workingDate,
    required DateTime endingDate,
    required String workingTime,
    required String workingDays,
    required double amount,
  }) {
    return GestureDetector(
      onTap: () {
        _navigateToViewPostedJobDetails(
          context,
          docId,
          jobName,
          place,
          workingDate,
          endingDate,
          workingTime,
          workingDays,
          amount,
        );
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
                  Expanded(
                    child: Center(
                      child: Text(
                        jobName,
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _showDeleteConfirmationDialog(context, docId);
                    },
                    icon: const Icon(Icons.delete),
                    color: Colors.black,
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              const SizedBox(height: 10.0),
              Text('Job Date: ${DateFormat('dd-MM-yyyy').format(workingDate)}'),
              Text('Working Hour: $workingTime'),
              Text('Amount: $amount'),
            ],
          ),
        ),
      ),
    );
  }
}
