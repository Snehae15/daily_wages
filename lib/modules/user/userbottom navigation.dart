import 'package:daily_wage/modules/user/user%20add%20job%20list.dart';
import 'package:daily_wage/modules/user/userhome.dart';
import 'package:flutter/material.dart';

class UserBottomNavigation extends StatefulWidget {
  const UserBottomNavigation({super.key});

  @override
  _UserBottomNavigationState createState() => _UserBottomNavigationState();
}

class _UserBottomNavigationState extends State<UserBottomNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const UserHome(),
    const UserAddJob(),
    Container(
      color: Colors.blue,
      child: const Center(
        child: Text('Wishlist'),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Job List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Add jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: 'Applications',
          ),
        ],
        unselectedItemColor: Color.fromARGB(255, 164, 151, 116),
        selectedItemColor: Colors.green,
        selectedFontSize: 16.0, // Set the font size for the selected label
        unselectedFontSize: 14.0, // Set the font size for the unselected labels
        iconSize: 30.0, // Set the size of the icons
      ),
    );
  }
}
