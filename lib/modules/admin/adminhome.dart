import 'package:daily_wage/modules/admin/admin_userprofile_view.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showSearchBar = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_tabChanged);
  }

  void _tabChanged() {
    setState(() {
      _showSearchBar = _tabController.index == 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          const Text("Admin Home",
              style: TextStyle(color: Colors.black, fontSize: 30)),
          const SizedBox(
            height: 10,
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF7F1E1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 137, 100, 7),
                    width: 5.0,
                  ),
                  insets: EdgeInsets.symmetric(horizontal: 40),
                ),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                unselectedLabelStyle: const TextStyle(
                  color: Colors.black,
                ),
                controller: _tabController,
                isScrollable: true,
                tabs: const [
                  Tab(
                    child: Text("User"),
                  ),
                  Tab(
                    child: Text("Jobs"),
                  ),
                ],
              ),
            ),
          ),
          if (_showSearchBar)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Container(
                  width: 350,
                  color: const Color(0xFFF7F1E1),
                  padding: const EdgeInsets.all(2),
                  child: const Row(
                    children: [
                      Icon(Icons.search, color: Colors.black),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search Jobs...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Expanded(
            child: Container(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // User Tab
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _navigateToUserProfile();
                          },
                          child: Card(
                            color: Colors.black.withOpacity(0.1),
                            child: Container(
                              color: const Color(0xFFF7F1E1),
                              child: const ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/person.png'),
                                  radius: 50,
                                ),
                                title: Text('User Name'),
                                subtitle: Text('Job Type'),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Jobs Tab
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Card(
                          color: const Color(0xFFF7F1E1),
                          child: Column(
                            children: [
                              Container(
                                color: const Color(0xFFF7F1E1),
                                child: const ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/person.png'),
                                    radius: 50,
                                  ),
                                  title: Text(
                                    'Job Title',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Name'),
                                          SizedBox(width: 8),
                                          Text('|'),
                                          SizedBox(width: 8),
                                          Text('Working Hr'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      _showStatusDialog('Accepted');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    child: const Text('Accept',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _showStatusDialog('Rejected');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: const Text('Reject',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToUserProfile() {
    // Add code to navigate to the user profile page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserProfilePage()),
    );
  }

  void _showStatusDialog(String status) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Status'),
            content: Text('Job $status'),
            actions: [
              TextButton(
                onPressed: () {
                  if (mounted) {
                    Navigator.pop(context);
                  }
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
