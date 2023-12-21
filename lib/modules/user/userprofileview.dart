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
  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('users');

  late User? user;
  String _userName = '';
  String _phoneNumber = '';
  String _email = '';
  String _city = '';
  String _address = '';
  String _gender = '';

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
      // Handle the case where the user is not authenticated
      print('User not authenticated');
    }
  }

  Future<void> _loadUserData() async {
    try {
      print('User ID: ${user!.uid}');
      final DocumentReference userDocumentRef = _userCollection.doc(user!.uid);
      print('Document Path: ${userDocumentRef.path}');
      final DocumentSnapshot userSnapshot = await userDocumentRef.get();

      // Check if the widget is still mounted before updating the state
      if (mounted) {
        if (userSnapshot.exists) {
          setState(() {
            _userName = userSnapshot['userName'];
            _phoneNumber = userSnapshot['phoneNumber'] ?? 'N/A';
            _email = userSnapshot['email'] ?? 'N/A';
            _city = userSnapshot['city'] ?? 'N/A';
            _address = userSnapshot['address'] ?? 'N/A';
            _gender = userSnapshot['gender'] ?? 'N/A';
          });
        } else {
          print('Document does not exist');
        }

        print('User Name: $_userName');
        print('Phone Number: $_phoneNumber');
        print('Email: $_email');
        print('City: $_city');
        print('Address: $_address');
        print('Gender: $_gender');
      }
    } catch (e) {
      print('Error loading user data: $e');
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
                      _userName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _navigateToEditProfile();
                      },
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
              buildInfoRow('User Name', _userName),
              buildInfoRow('Phone Number', _phoneNumber),
              buildInfoRow('Email', _email),
              buildInfoRow('City', _city),
              buildInfoRow('Address', _address),
              buildInfoRow('Gender', _gender),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _navigateToRequests();
                },
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

  void _navigateToEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          userName: _userName,
          phoneNumber: _phoneNumber,
          email: _email,
          city: _city,
          address: _address,
          gender: _gender,
        ),
      ),
    );
  }

  void _navigateToRequests() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UsersendedApplication()),
    );
  }
}
