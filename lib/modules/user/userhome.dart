import 'package:daily_wage/modules/user/userprofileview.dart';
import 'package:daily_wage/modules/user/userviewjob.dart';
import 'package:flutter/material.dart'; // Import the UserProfileView

class UserHome extends StatelessWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F1E1),
        title: const Text('User Home'),
        actions: [
          // Circular avatar in the AppBar
          GestureDetector(
            onTap: () {
              // Navigate to UserProfileView
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserProfileView(),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/person.png'),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    // Do something when the area outside the TextField is tapped
                  },
                  child: Container(
                    color: const Color(0xFFF7F1E1),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        fillColor: const Color(0xFFF7F1E1),
                        filled: true,
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                // Navigate to UserviewJobapplication page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserviewJobapplication(),
                  ),
                );
              },
              child: const ListTile(
                tileColor: Color(0xFFF7F1E1),
                contentPadding: EdgeInsets.all(16.0),
                title: Text(
                  'Job Name',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.black),
                        SizedBox(width: 8.0),
                        Text('Location'),
                      ],
                    ),
                    SizedBox(width: 16.0),
                    Text(
                      '\$100/hr',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
