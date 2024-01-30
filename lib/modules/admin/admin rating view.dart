import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RatingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rating View'),
        backgroundColor: const Color(0xFFF7F1E1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('reviews').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<QueryDocumentSnapshot<Map<String, dynamic>>> reviews =
                  snapshot.data?.docs ?? [];
              return ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  var review = reviews[index];
                  return FutureBuilder(
                    future: fetchDetails(review['userId'], review['jobId']),
                    builder: (context, detailsSnapshot) {
                      if (detailsSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (detailsSnapshot.hasError) {
                        return Text('Error: ${detailsSnapshot.error}');
                      } else {
                        var details =
                            detailsSnapshot.data as Map<String, dynamic>;
                        return ListTile(
                          tileColor: Color(0xFFF7F1E1),
                          title: Text(details['userName'] ?? 'N/A'),
                          subtitle: Text(details['jobName'] ?? 'N/A'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              5,
                              (starIndex) => Icon(
                                starIndex < (review['rating'] ?? 0)
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.yellow,
                              ),
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
      details['userName'] = userSnapshot['userName'] ?? 'N/A';
    }

    // Fetch jobName from add_jobs
    DocumentSnapshot jobSnapshot =
        await FirebaseFirestore.instance.collection('add_job').doc(jobId).get();

    if (jobSnapshot.exists) {
      details['jobName'] = jobSnapshot['jobName'] ?? 'N/A';
    }

    return details;
  }
}
