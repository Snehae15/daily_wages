import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const String userNotLoggedInMessage = 'User is not logged in.';
const String applicationSubmittedSuccessMessage =
    'Job application submitted successfully!';
const String applicationSubmitErrorMessage =
    'Failed to submit job application.';

class UserviewJobapplication extends StatefulWidget {
  const UserviewJobapplication({
    Key? key,
    required this.place,
    required this.jobName,
    required this.amount,
    required this.workingDate,
    required this.endingDate,
    required this.workingTime,
    required this.workingDays,
    required this.jobId,
  }) : super(key: key);

  final String place;
  final String jobName;
  final String amount;
  final String workingDate;
  final String endingDate;
  final String workingTime;
  final String workingDays;
  final String jobId;

  @override
  State<UserviewJobapplication> createState() => _UserviewJobapplicationState();
}

class _UserviewJobapplicationState extends State<UserviewJobapplication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F1E1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 10),
                Text(
                  widget.jobName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 20),
                buildInfoRow('Place', widget.place),
                buildInfoRow('Working Date', widget.workingDate),
                buildInfoRow('Ending Date', widget.endingDate),
                buildInfoRow('Working Time', widget.workingTime),
                buildInfoRow('Working Days', widget.workingDays),
                buildInfoRow('Amount', '\$${widget.amount}'),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 180.0),
          child: ElevatedButton(
            onPressed: () {
              _applyForJob();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              fixedSize: const Size(200, 50),
            ),
            child: const Text('Apply'),
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

  void _applyForJob() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String userId = user.uid;
        String userName = await _getUserName(userId);

        // Generate a unique ID for the application
        String appliedId =
            FirebaseFirestore.instance.collection('applied_jobs').doc().id;

        Map<String, dynamic> applicationData = {
          'appliedId': appliedId,
          'userId': userId,
          'jobId': widget.jobId,
          'place': widget.place,
          'jobName': widget.jobName,
          'amount': widget.amount,
          'workingDate': widget.workingDate,
          'endingDate': widget.endingDate,
          'workingTime': widget.workingTime,
          'workingDays': widget.workingDays,
          'status': 'applied',
          'user_status': 'pending',
          'userName': userName,
        };

        CollectionReference appliedJobsCollection =
            FirebaseFirestore.instance.collection('applied_jobs');

        await appliedJobsCollection.add(applicationData);

        print(applicationSubmittedSuccessMessage);
        _showSuccessDialog(userId);
      } else {
        print(userNotLoggedInMessage);
      }
    } catch (e) {
      print('$applicationSubmitErrorMessage Error: $e');
    }
  }

  void _showSuccessDialog(String userId) async {
    String userName = await _getUserName(userId);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Application Submitted'),
          content:
              const Text('Your application has been submitted successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UsersendedApplication(
                      jobName: widget.jobName,
                      workingDate: DateTime.parse(widget.workingDate),
                      endingDate: DateTime.parse(widget.endingDate),
                      userId: userId,
                      appliedId: widget.jobId,
                    ),
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<String> _getUserName(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        // Check if 'username' field exists in the user document
        if ((userSnapshot.data() as Map<String, dynamic>?)
                ?.containsKey('username') ??
            false) {
          return userSnapshot['username'];
        } else {
          throw Exception(
              'Error: The username field does not exist in the user document.');
        }
      } else {
        throw Exception('No user document found for userId: $userId');
      }
    } catch (e) {
      print('Failed to get username. Error: $e');
      return ''; // You might want to return a default value or throw the error
    }
  }
}

class UsersendedApplication extends StatefulWidget {
  const UsersendedApplication({
    Key? key,
    required this.jobName,
    required this.workingDate,
    required this.endingDate,
    required this.userId,
    required this.appliedId,
  }) : super(key: key);

  final String jobName;
  final DateTime workingDate;
  final DateTime endingDate;
  final String userId;
  final String appliedId;

  @override
  _UsersendedApplicationState createState() => _UsersendedApplicationState();
}

class _UsersendedApplicationState extends State<UsersendedApplication> {
  String username = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsername();
  }

  Future<void> fetchUsername() async {
    try {
      print('Fetching username for userId: ${widget.userId}');

      var usersQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('userId', isEqualTo: widget.userId)
          .get();

      if (usersQuery.docs.isNotEmpty) {
        var purchaseDocument = usersQuery.docs.first;

        if ((purchaseDocument.data()).containsKey('userName') ?? false) {
          setState(() {
            username = purchaseDocument['userName'];
          });
          print('Username found: $username');
        } else {
          throw Exception(
              'Error: The userName field does not exist in the purchases document.');
        }
      } else {
        throw Exception('No document found for userId: ${widget.userId}');
      }
    } catch (error) {
      print('Error fetching username: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F1E1),
        title: const Text('Your Applications'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                buildJobCard(
                  jobName: widget.jobName,
                  workingDate: widget.workingDate,
                  endingDate: widget.endingDate,
                  userName: isLoading ? 'Loading...' : username,
                  appliedId: widget.appliedId,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildJobCard({
    required String jobName,
    required DateTime workingDate,
    required DateTime endingDate,
    required String userName,
    required String appliedId,
  }) {
    DateTime currentDate = DateTime.now();
    String status =
        currentDate.isAfter(workingDate) && currentDate.isBefore(endingDate)
            ? 'Available'
            : 'Not Available';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          color: const Color(0xFFF7F1E1),
          elevation: 3.0,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  jobName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(height: 12.0),
                Text('Working Date: ${_formattedDate(workingDate)}'),
                Text('Ending Date: ${_formattedDate(endingDate)}'),
                Text('Submitted By: $userName'),
                const SizedBox(height: 12.0),
                // Text('Applied ID: $appliedId'),
                Container(
                  color: status == 'Available' ? Colors.green : Colors.red,
                  padding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 8.0,
                  ),
                  child: Text(
                    'Status: $status',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formattedDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }
}
