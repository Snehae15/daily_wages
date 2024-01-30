import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_wage/screens/spalsh.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserjobListview extends StatefulWidget {
  const UserjobListview({Key? key}) : super(key: key);

  @override
  State<UserjobListview> createState() => _UserjobListviewState();
}

class _UserjobListviewState extends State<UserjobListview> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserID = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F1E1),
        actions: [
          const SizedBox(width: 16.0),
          GestureDetector(
            onTap: () {
              // Navigate to LandingPage
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => Splash(),
                ),
                (route) => false,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.logout, color: Colors.black),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
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
                      controller: _searchController,
                      onChanged: (value) {
                        // Trigger a rebuild when the text in the search field changes
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: 'Search by job name',
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
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUserID)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (userSnapshot.hasError) {
                  return Text('Error: ${userSnapshot.error}');
                } else if (!userSnapshot.hasData) {
                  return const Text('User not found.');
                } else {
                  final userData =
                      userSnapshot.data!.data() as Map<String, dynamic>;
                  final userCity = userData['city'] as String? ?? 'N/A';

                  return FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('payments')
                        .where('userId', isEqualTo: currentUserID)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return const Text('No payments available.');
                      } else {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final paymentData = snapshot.data!.docs[index]
                                  .data() as Map<String, dynamic>;
                              final jobId = paymentData['jobId'] as String;
                              final amount =
                                  paymentData['amount']?.toString() ?? 'N/A';

                              return FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection('add_job')
                                    .doc(jobId)
                                    .get(),
                                builder: (context, jobSnapshot) {
                                  if (jobSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (jobSnapshot.hasError) {
                                    return Text('Error: ${jobSnapshot.error}');
                                  } else if (!jobSnapshot.hasData) {
                                    return const Text('Job not found.');
                                  } else {
                                    final jobData = jobSnapshot.data!.data()
                                        as Map<String, dynamic>;
                                    final jobName =
                                        jobData['jobName'] as String? ?? 'N/A';

                                    return GestureDetector(
                                      onTap: () {
                                        // Handle job item tap
                                      },
                                      child: Card(
                                        color: const Color(0xFFF7F1E1),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                jobName,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0,
                                                ),
                                              ),
                                              const SizedBox(height: 8.0),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                          Icons.location_on,
                                                          color: Colors.black),
                                                      const SizedBox(
                                                          width: 8.0),
                                                      Text(
                                                          userCity), // Display user city
                                                    ],
                                                  ),
                                                  const SizedBox(width: 16.0),
                                                  Text(
                                                    '\$$amount',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        );
                      }
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
