import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class UserAccepted extends StatefulWidget {
  final String appliedJobId;
  final String userId;
  final String jobId;
  final String jobName;
  final String city;
  final String imagePath;
  final String location;

  const UserAccepted({
    Key? key,
    required this.appliedJobId,
    required this.userId,
    required this.jobId,
    required this.jobName,
    required this.city,
    required this.imagePath,
    required this.location,
  }) : super(key: key);

  @override
  _UserAcceptedState createState() => _UserAcceptedState();
}

class _UserAcceptedState extends State<UserAccepted> {
  String userStatus = ''; // Holds the user status

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Accepted'),
        backgroundColor: const Color(0xFFF7F1E1),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .get(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
            return const Center(child: Text('User not found'));
          }

          final userData = userSnapshot.data!.data() as Map<String, dynamic>;

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(widget.imagePath),
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userData['userName'] ?? 'Unknown User',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.jobName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Rating stars
                  RatingBar.builder(
                    initialRating: 3.5,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 20.0,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      // Handle rating updates if needed
                    },
                  ),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildInfoRow('Place', userData['city'] ?? 'N/A'),
                      buildInfoRow(
                        'Phone Number',
                        userData['phoneNumber'] ?? 'N/A',
                      ),
                      buildInfoRow('Email', userData['email'] ?? 'N/A'),
                      // buildInfoRow('Job List', userData['jobList'] ?? 'N/A'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Fetching jobs based on userId
                  FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('add_jobs')
                        .where('userId', isEqualTo: widget.userId)
                        .get(),
                    builder: (context, jobsSnapshot) {
                      if (jobsSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return const SizedBox();
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Handle Accept button click
                          updateJobStatus('Accepted');
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('Accept'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle Reject button click
                          updateJobStatus('Rejected');
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Reject'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Display user_status in UI
                  Text('User Status: $userStatus'),
                ],
              ),
            ),
          );
        },
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

  void updateJobStatus(String status) {
    // Update user_status in Firestore
    FirebaseFirestore.instance
        .collection('applied_jobs')
        .doc(widget.appliedJobId)
        .update({'user_status': status});

    // Update the UI
    setState(() {
      userStatus = status;
    });
  }
}
