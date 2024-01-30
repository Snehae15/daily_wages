import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_wage/modules/user/payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class UserPayment extends StatefulWidget {
  final String userId;
  final String jobId;
  final String name;
  final String jobName;
  final String imagePath;
  final String city;
  final String userName;

  const UserPayment({
    Key? key,
    required this.userId,
    required this.userName,
    required this.jobId,
    required this.name,
    required this.jobName,
    required this.city,
    required this.imagePath,
    required String appliedJobId,
    required String location,
    required String jobType,
  }) : super(key: key);

  @override
  _UserPaymentState createState() => _UserPaymentState();
}

class _UserPaymentState extends State<UserPayment> {
  double rating = 3.5; // Initial rating

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Accepted'),
        backgroundColor: const Color(0xFFF7F1E1),
      ),
      body: Center(
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
                widget.name, // Use name from widget
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.jobName, // Use jobName from widget
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RatingBar.builder(
                    initialRating: rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 20.0,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (newRating) {
                      // Update the rating when changed
                      setState(() {
                        rating = newRating;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Fetch user details based on userId
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.userId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                    return const Text('User not found');
                  }

                  final userData =
                      userSnapshot.data!.data() as Map<String, dynamic>;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildInfoRow('Place', widget.city),
                      buildInfoRow(
                          'Phone Number', userData['phoneNumber'] ?? 'N/A'),
                      buildInfoRow('Email', userData['email'] ?? 'N/A'),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Navigate to PaymentPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentPage(
                            appliedJobId: '',
                            userId: widget.userId,
                            jobId: widget.jobId,
                            jobName: widget.jobName,
                            city: widget.city,
                            imagePath: widget.imagePath,
                            location: '',
                            name: widget.name,
                            jobType: '',
                            userName: widget.userName,
                            amount: '',
                          ),
                        ),
                      );

                      // Add the rating to the review collection
                      await FirebaseFirestore.instance
                          .collection('reviews')
                          .add({
                        'userId': widget.userId,
                        'rating': rating,
                        'jobId': widget.jobId,
                        // Add other relevant data
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Payment'),
                  ),
                  IconButton(icon: const Icon(Icons.chat), onPressed: () {}),
                ],
              ),
            ],
          ),
        ),
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
