import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ApplicationPage extends StatelessWidget {
  const ApplicationPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Page'),
        backgroundColor: const Color(0xFFF7F1E1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('applied_jobs').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData ||
                (snapshot.data as QuerySnapshot).docs.isEmpty) {
              return const Text('No applied jobs available.');
            }

            var appliedJobs = (snapshot.data as QuerySnapshot).docs;

            return ListView.builder(
              itemCount: appliedJobs.length,
              itemBuilder: (context, index) {
                var jobData = appliedJobs[index].data() as Map<String, dynamic>;

                return Card(
                  color: const Color(0xFFF7F1E1),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${jobData['jobName']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text('Posted: ${jobData['userName']}'),
                        Text('Date: ${jobData['workingDate']}'),
                        const SizedBox(height: 16),
                        Text('Applied: ${jobData['appliedUserName']}'),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
