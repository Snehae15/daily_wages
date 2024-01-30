import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_wage/screens/spalsh.dart';
import 'package:flutter/material.dart';

class ViewPaymentPage extends StatelessWidget {
  const ViewPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Payments'),
        backgroundColor: const Color(0xFFF7F1E1),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Splash(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('payments').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<QueryDocumentSnapshot<Map<String, dynamic>>> payments =
                  snapshot.data?.docs ?? [];
              return ListView.builder(
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  var payment = payments[index];
                  return FutureBuilder(
                    future: fetchDetails(payment['userId'], payment['jobId']),
                    builder: (context, detailsSnapshot) {
                      if (detailsSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (detailsSnapshot.hasError) {
                        return Text('Error: ${detailsSnapshot.error}');
                      } else {
                        var details =
                            detailsSnapshot.data as Map<String, dynamic>;
                        return Card(
                          color: const Color(0xFFF7F1E1),
                          child: ListTile(
                            title: RichText(
                              text: TextSpan(
                                style:
                                    DefaultTextStyle.of(context).style.copyWith(
                                          color: Colors.black,
                                        ),
                                children: [
                                  TextSpan(
                                    text: details['userName'] ?? '',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: ' Paid',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  TextSpan(
                                    text: ' ',
                                  ),
                                  TextSpan(
                                    text:
                                        'Job Name: ${details['jobName'] ?? ''}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Payment: ${payment['amount']}',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  ' ${payment['date']}',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> fetchDetails(String userId, String jobId) async {
    Map<String, dynamic> details = {};

    // Fetch userName from users
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      details['userName'] = userSnapshot['userName'] ?? '';
    }

    // Fetch jobName from add_jobs
    DocumentSnapshot jobSnapshot =
        await FirebaseFirestore.instance.collection('add_job').doc(jobId).get();

    if (jobSnapshot.exists) {
      details['jobName'] = jobSnapshot['jobName'] ?? '';
    }

    return details;
  }
}
