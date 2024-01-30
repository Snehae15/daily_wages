import 'package:cloud_firestore/cloud_firestore.dart';
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
  late List<QueryDocumentSnapshot<Map<String, dynamic>>> _filteredUsers;
  late List<QueryDocumentSnapshot<Map<String, dynamic>>> _filteredJobs;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_tabChanged);
    _filteredUsers = [];
    _filteredJobs = [];
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
          const SizedBox(height: 50),
          const Text(
            "Admin Home",
            style: TextStyle(color: Colors.black, fontSize: 30),
          ),
          const SizedBox(height: 10),
          Container(
            child: Center(
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F1E1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TabBar(
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 113, 85, 14),
                      width: 2.0,
                    ),
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
                  labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                  tabs: const [
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("User"),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Jobs"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_showSearchBar)
            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 16, right: 16),
              child: Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F1E1),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(2),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.black),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        onChanged: (query) {
                          _filterJobs(query);
                        },
                        decoration: const InputDecoration(
                          hintText: 'Search Jobs...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // User Tab
                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance.collection('users').get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final users = _filteredUsers.isNotEmpty
                          ? _filteredUsers
                          : snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user =
                              users[index].data() as Map<String, dynamic>;
                          final userName =
                              user['userName'] ?? 'User Name Not Found';
                          final jobName = user['jobName'] ?? 'Job not found';
                          final userImage =
                              user['userImage'] ?? 'assets/person.png';

                          return GestureDetector(
                            onTap: () {
                              _navigateToUserProfile(user);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Card(
                                color: Colors.black.withOpacity(0.1),
                                child: Container(
                                  color: const Color(0xFFF7F1E1),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: AssetImage(userImage),
                                      radius: 30,
                                    ),
                                    title: Text(userName),
                                    subtitle: Text(jobName),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
                // Jobs Tab
                FutureBuilder<QuerySnapshot>(
                  future:
                      FirebaseFirestore.instance.collection('add_job').get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final jobs = _filteredJobs.isNotEmpty
                          ? _filteredJobs
                          : snapshot.data!.docs;

                      if (jobs.isEmpty) {
                        return const Center(child: Text('No jobs found.'));
                      }

                      return ListView.builder(
                        itemCount: jobs.length,
                        itemBuilder: (context, index) {
                          final job =
                              jobs[index].data() as Map<String, dynamic>;

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              color: const Color(0xFFF7F1E1),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: const CircleAvatar(
                                      backgroundImage:
                                          AssetImage('assets/person.png'),
                                      radius: 50,
                                    ),
                                    title: Text(
                                      job['jobName'] ?? 'Job Name Not Found',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(job['userName'] ??
                                                'UserName Not Found'),
                                            const SizedBox(width: 8),
                                            const Text('|'),
                                            const SizedBox(width: 8),
                                            Text(job['workingTime'] ??
                                                'Working Hr NotFound'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  ButtonBar(
                                    alignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          _showStatusDialog('Accepted', job);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: job['jobStatus'] ==
                                                  'Accepted'
                                              ? Colors.green
                                              : Colors.grey.withOpacity(0.5),
                                        ),
                                        child: Text(
                                          'Accept',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          _showStatusDialog('Rejected', job);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: job['jobStatus'] ==
                                                  'Rejected'
                                              ? Colors.red
                                              : Colors.grey.withOpacity(0.5),
                                        ),
                                        child: Text(
                                          'Reject',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'Admin Status: ${job['admin_status'] ?? 'Not Set'}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: job['admin_status'] == 'Accepted'
                                          ? Colors.green
                                          : job['admin_status'] == 'Rejected'
                                              ? Colors.red
                                              : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _filterJobs(String query) {
    setState(() {
      _filteredJobs = query.isEmpty
          ? []
          : _filteredJobs.where((job) {
              final jobName = job['jobName']?.toString().toLowerCase() ?? '';
              return jobName.contains(query.toLowerCase());
            }).toList();
    });
  }

  void _navigateToUserProfile(Map<String, dynamic> userData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfilePage(userData: userData),
      ),
    );
  }

  void _showStatusDialog(String status, Map<String, dynamic> jobData) async {
    print('Job Data: $jobData');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Job Status'),
          content: Text('Job $status'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);

                // Check if 'jobId' is available in jobData
                if (!jobData.containsKey('jobId') || jobData['jobId'] == null) {
                  print('Invalid documentId in jobData: ${jobData['jobId']}');
                  return;
                }

                var documentId = jobData['jobId'];
                print('DocumentId: $documentId');

                var documentRef = FirebaseFirestore.instance
                    .collection('add_job')
                    .doc(documentId);

                try {
                  var documentSnapshot = await documentRef.get();

                  if (documentSnapshot.exists) {
                    // Document exists, proceed with the update
                    await documentRef.update({
                      'jobStatus': status,
                      'admin_status': status,
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Job $status by ${jobData['userName']}'),
                      ),
                    );

                    setState(() {
                      jobData['jobStatus'] = status;
                      jobData['admin_status'] = status;
                    });
                  } else {
                    print('Document not found for jobId: $documentId');
                  }
                } catch (e) {
                  print('Error updating document: $e');
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
