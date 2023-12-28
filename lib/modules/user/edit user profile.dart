import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final String? userName;
  final String? phoneNumber;
  final String? email;
  final String? city;
  final String? address;
  final String? gender;

  const EditProfilePage({super.key, 
    this.userName,
    this.phoneNumber,
    this.email,
    this.city,
    this.address,
    this.gender,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late User loggedInUser;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _gender;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loggedInUser = FirebaseAuth.instance.currentUser!;
    print("User ID: ${loggedInUser.uid}");
    _userNameController.text = widget.userName ?? '';
    _phoneNumberController.text = widget.phoneNumber ?? '';
    _emailController.text = widget.email ?? '';
    _cityController.text = widget.city ?? '';
    _addressController.text = widget.address ?? '';
    _gender = widget.gender;
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(loggedInUser.uid)
          .get();

      print("Snapshot data: ${snapshot.data()}");
      if (snapshot.exists) {
        setState(() {
          _userNameController.text = snapshot.get('userName') ?? 'N/A';
          _phoneNumberController.text = snapshot.get('phoneNumber') ?? 'N/A';
          _emailController.text = snapshot.get('email') ?? 'N/A';
          _cityController.text = snapshot.get('city') ?? 'N/A';
          _addressController.text = snapshot.get('address') ?? 'N/A';
          _gender = snapshot.get('gender') ?? 'N/A';
        });
        print("Fetched Data: $_userNameController, $_emailController, ...");
      } else {
        print("Document does not exist");
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: const Color(0xFFF7F1E1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage('assets/person.png'),
                        radius: 50,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                buildTextFormField(
                    'View Name', _userNameController, 'Enter your name'),
                const Text(
                  'Phone number',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                buildTextFormField('Phone Number', _phoneNumberController,
                    'Enter your phone number'),
                const Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                buildTextFormField(
                    'Email', _emailController, 'Enter your email'),
                const Text(
                  'City',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                buildTextFormField('City', _cityController, 'Enter your city'),
                const Text(
                  'Address',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                buildTextFormField(
                    'Address', _addressController, 'Enter your address'),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Gender',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Male',
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                    ),
                    const Text('Male'),
                    Radio<String>(
                      value: 'Female',
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value;
                        });
                      },
                    ),
                    const Text('Female'),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _saveProfile();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Save Profile'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextFormField(
      String label, TextEditingController controller, String hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  void _saveProfile() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(loggedInUser.uid)
          .update({
        'userName': _userNameController.text,
        'phoneNumber': _phoneNumberController.text,
        'email': _emailController.text,
        'city': _cityController.text,
        'address': _addressController.text,
        'gender': _gender,
      });
      Navigator.pop(context);
    } catch (e) {
      print("Error saving profile: $e");
    }
  }
}
