import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class JobApplicationPage extends StatelessWidget {
  final String jobId; // Add jobId parameter

  const JobApplicationPage({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Application'),
        backgroundColor: const Color(0xFFF7F1E1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('applied_jobs')
              .where('jobId', isEqualTo: jobId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            final appliedUsers = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;

              // Check for null values before using them
              final userName = data['userName'] ?? 'Unknown User';
              final jobName = data['jobName'] ?? 'Unknown Job';
              final location = data['location'] ?? 'Unknown Location';

              return buildJobApplicationCard(
                userName,
                jobName,
                location,
                'assets/person.png',
                context,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserAccepted(
                        userId: userName,
                        jobName: jobName,
                        location: location,
                        imagePath: 'assets/person.png',
                      ),
                    ),
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
                'Location',
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

class UserAccepted extends StatelessWidget {
  final String userId;
  final String jobName;
  final String location;
  final String imagePath;

  const UserAccepted({
    Key? key,
    required this.userId,
    required this.jobName,
    required this.location,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Accepted'),
        backgroundColor: const Color(0xFFF7F1E1),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print('Error fetching user data: ${snapshot.error}');
            return const Center(child: Text('Error fetching user data'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User not found'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(imagePath),
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
                    jobName,
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
                      buildInfoRow('Place', userData['place'] ?? 'N/A'),
                      buildInfoRow('Age', userData['age'] ?? 'N/A'),
                      buildInfoRow(
                          'Phone Number', userData['phoneNumber'] ?? 'N/A'),
                      buildInfoRow('Email', userData['email'] ?? 'N/A'),
                      buildInfoRow('Job List', userData['jobList'] ?? 'N/A'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('Accept'),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Reject'),
                      ),
                    ],
                  ),
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
}
