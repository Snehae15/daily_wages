import 'package:daily_wage/modules/admin/admin%20rating%20view.dart';
import 'package:daily_wage/modules/admin/admin_payment_view.dart';
import 'package:daily_wage/modules/admin/adminapplication.dart';
import 'package:daily_wage/modules/admin/adminhome.dart';
import 'package:flutter/material.dart';

class AdminBottomNavigation extends StatefulWidget {
  const AdminBottomNavigation({Key? key}) : super(key: key);

  @override
  State<AdminBottomNavigation> createState() => _AdminBottomNavigationState();
}

class _AdminBottomNavigationState extends State<AdminBottomNavigation> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const AdminHome(),
    const ApplicationPage(),
    RatingView(),
    const ViewPaymentPage(),
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
        unselectedItemColor: const Color.fromARGB(255, 237, 224, 190),
        selectedItemColor: Colors.green, // Set the selected item color
        unselectedLabelStyle:
            const TextStyle(color: Colors.black), // Set unselected text color
        selectedLabelStyle:
            const TextStyle(color: Colors.white), // Set selected text color
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: 'Application',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Rating',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Payment',
          ),
        ],
        backgroundColor: Colors.grey[200], // Set the background color
      ),
    );
  }
}
