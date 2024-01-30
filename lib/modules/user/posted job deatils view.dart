import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_wage/modules/user/job%20application%20view%20.dart';
import 'package:flutter/material.dart';

class ViewPostedJobDetails extends StatelessWidget {
  const ViewPostedJobDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Posted Job Details'),
        backgroundColor: const Color(0xFFF7F1E1),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('add_job').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              return ListTile(
                title: Text(document['jobName'] ?? 'Unknown Job'),
                subtitle: Text(document['place'] ?? 'Unknown Place'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          JobApplicationPage(jobId: document.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
