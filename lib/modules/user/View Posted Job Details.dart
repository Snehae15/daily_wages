import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_wage/modules/user/job%20application%20view%20.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class ViewPostedJobDetails extends StatelessWidget {
  final String jobId;
  final String jobName;
  final String place;
  final DateTime workingDate;
  final DateTime endingDate;
  final String workingTime;
  final String workingDays;
  final double amount;

  const ViewPostedJobDetails({
    Key? key,
    required this.jobId,
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
                  jobName,
                  style: const TextStyle(
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
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
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
      MaterialPageRoute(
        builder: (context) => JobApplicationPage(
          jobId: jobId,
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserData(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            print('Error fetching user data: ${snapshot.error}');
            return const Text('Error fetching user data');
          }

          final userData = snapshot.data;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage(imagePath),
                  backgroundColor: Colors.grey,
                ),
                const SizedBox(height: 16.0),
                Text(
                  userData?['userName'] ?? '',
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
                    buildInfoRow('Place', userData?['place'] ?? 'Malappuram'),
                    buildInfoRow(
                      'Phone Number',
                      userData?['phoneNumber'] ?? '874584512',
                    ),
                    buildInfoRow(
                      'Email',
                      userData?['email'] ?? 'snehae15@gmail.com',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        updateStatus(context, 'Accepted');
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Accept'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        updateStatus(context, 'Rejected');
                      },
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

  Future<Map<String, dynamic>> fetchUserData(String userId) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc.data() as Map<String, dynamic>? ?? {};
  }

  Future<void> updateStatus(BuildContext context, String status) async {
    await FirebaseFirestore.instance
        .collection('applied_jobs')
        .doc(userId)
        .set({'status': status}, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Status Updated: $status'),
      ),
    );
  }
}
