import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_wage/modules/user/edit%20user%20profile.dart';
import 'package:daily_wage/modules/user/userviewjob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({Key? key}) : super(key: key);

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  late User? user;
  String userName = '';
  String phoneNumber = '';
  String email = '';
  String city = '';
  String address = '';
  String gender = '';

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    user = _auth.currentUser;

    if (user != null) {
      await _loadUserData();
    } else {
      print('User not authenticated');
    }
  }

  Future<void> _loadUserData() async {
    try {
      print('User ID: ${user!.uid}');
      final DocumentSnapshot userSnapshot =
          await userCollection.doc(user!.uid).get();

      print('Document data: ${userSnapshot.data()}');

      if (userSnapshot.exists) {
        setState(() {
          userName = userSnapshot.get('userName') ?? 'N/A';
          phoneNumber = userSnapshot.get('phoneNumber') ?? 'N/A';
          email = userSnapshot.get('email') ?? 'N/A';
          city = userSnapshot.get('city') ?? 'N/A';
          address = userSnapshot.get('address') ?? 'N/A';
          gender = userSnapshot.get('gender') ?? 'N/A';
        });
      } else {
        print('Document does not exist');
      }

      print('User Name: $userName');
      print('Phone Number: $phoneNumber');
      print('Email: $email');
      print('City: $city');
      print('Address: $address');
      print('Gender: $gender');
    } catch (e, stackTrace) {
      print('Error loading user data: $e');
      print('Stack trace: $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: const Color(0xFFF7F1E1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/person.png'),
                      radius: 50,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _navigateToEditProfile,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Edit Profile'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              buildInfoTable(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _navigateToRequests,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                ),
                child: const Text('Check Requests'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfoTable() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(3),
      },
      children: [
        buildTableRow('User Name', userName),
        buildTableRow('Phone Number', phoneNumber),
        buildTableRow('Email', email),
        buildTableRow('City', city),
        buildTableRow('Address', address),
        buildTableRow('Gender', gender),
      ],
    );
  }

  TableRow buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value),
        ),
      ],
    );
  }

  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          userName: userName,
          phoneNumber: phoneNumber,
          email: email,
          city: city,
          address: address,
          gender: gender,
        ),
      ),
    );
  }

  void _navigateToRequests() {
    // Assuming you have userId, jobName, workingDate, and endingDate
    String userId = user?.uid ?? ''; // Replace with your actual logic
    String jobName = ''; // Replace with your actual logic
    String workingDate = ''; // Replace with your actual logic
    String endingDate = ''; // Replace with your actual logic

    // Retrieve userName based on userId (you may need to fetch it from Firestore)
    String userName = 'John Doe'; // Replace with your actual logic

    // Show status if workingDate <= endingDate
    DateTime currentDate = DateTime.now();
    String status =
        DateTime.parse(workingDate).isBefore(DateTime.parse(endingDate)) &&
                DateTime.parse(workingDate).isBefore(currentDate)
            ? 'Available'
            : 'Not Available';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UsersendedApplication(
          jobName: jobName,
          workingDate: DateTime.parse(workingDate),
          endingDate: DateTime.parse(endingDate),
          userId: '',
          appliedId: '',
        ),
      ),
    );
  }
}
