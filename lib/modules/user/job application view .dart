import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_wage/modules/user/user%20accepted.dart';
import 'package:daily_wage/modules/user/user%20payment%20page.dart';
import 'package:flutter/material.dart';

class JobApplicationPage extends StatelessWidget {
  final String jobId;

  const JobApplicationPage({Key? key, required this.jobId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Applications'),
        backgroundColor: const Color(0xFFF7F1E1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('applied_jobs')
              .where('jobId', isEqualTo: jobId)
              .where('user_status',
                  isNotEqualTo: 'Rejected') // Exclude 'Rejected' users
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            final appliedUsers = snapshot.data!.docs.map((doc) {
              final appliedJobId = doc.id;
              final data = doc.data() as Map<String, dynamic>;
              final userId = data['userId'] ?? 'Unknown User';
              final jobName = data['jobName'] ?? 'Unknown Job';
              final city = data['city'] ?? 'Unknown Location';

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (!userSnapshot.hasData) {
                    return Text('User not found');
                  }

                  final userData =
                      userSnapshot.data!.data() as Map<String, dynamic>;
                  final userName = userData['userName'] ?? 'Unknown User';
                  final city = userData['city'] ?? 'Unknown City';

                  // Print only when jobId matches
                  if (data['jobId'] == jobId) {
                    print(
                        'applied_jobs id: $appliedJobId, userId: $userId, jobId: $jobId, userName: $userName, city: $city');
                  }

                  return buildJobApplicationCard(
                    appliedJobId,
                    userId,
                    userName,
                    jobName,
                    city,
                    'assets/person.png',
                    context,
                    onTap: () async {
                      // Check user_status in applied_jobs collection
                      DocumentSnapshot appliedJobDoc = await FirebaseFirestore
                          .instance
                          .collection('applied_jobs')
                          .doc(appliedJobId)
                          .get();

                      String userStatus = appliedJobDoc['user_status'];

                      if (userStatus == null || userStatus == 'pending') {
                        // If no user_status or user_status is 'Pending', go to UserAccepted
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserAccepted(
                              appliedJobId: appliedJobId,
                              userId: userId,
                              jobId: jobId,
                              jobName: jobName,
                              city: city,
                              imagePath: 'assets/person.png',
                              location: '',
                            ),
                          ),
                        );
                      } else if (userStatus == 'Accepted') {
                        // If user_status is 'Accepted', go to UserPayment
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserPayment(
                              appliedJobId: appliedJobId,
                              userId: userId,
                              jobId: jobId,
                              jobName: jobName,
                              city: city,
                              imagePath: 'assets/person.png',
                              location: '',
                              name: '',
                              jobType: '',
                              userName: '',
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              );
            }).toList();

            return ListView(
              children: appliedUsers,
            );
          },
        ),
      ),
    );
  }

  Widget buildJobApplicationCard(
    String appliedJobId,
    String userId,
    String userName,
    String jobName,
    String location,
    String imagePath,
    BuildContext context, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: const Color(0xFFF7F1E1),
        elevation: 3.0,
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundImage: AssetImage(imagePath),
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(width: 12.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        jobName,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              const Text(
                'Locations',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 4.0),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.black),
                  const SizedBox(width: 4.0),
                  Text(location),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
