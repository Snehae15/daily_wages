import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_wage/modules/user/userprofileview.dart';
import 'package:daily_wage/modules/user/userviewjob.dart';
import 'package:flutter/material.dart';

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F1E1),
        title: const Text('User Home'),
        actions: [
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
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('add_job').get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Text('No jobs available.');
                } else {
                  // Filter jobs based on the search text
                  final filteredJobs = snapshot.data!.docs.where((document) {
                    final jobName = (document.data()
                        as Map<String, dynamic>)['jobName'] as String?;
                    return jobName != null &&
                        jobName
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase());
                  }).toList();

                  // Display the filtered jobs using ListView.builder
                  return Expanded(
                    child: ListView.builder(
                      itemCount: filteredJobs.length,
                      itemBuilder: (context, index) {
                        final jobData =
                            filteredJobs[index].data() as Map<String, dynamic>;
                        final jobName = jobData['jobName'] as String? ?? 'N/A';
                        final place = jobData['place'] as String? ?? 'N/A';
                        final amount = jobData['amount']?.toString() ?? 'N/A';
                        final workingDateTimestamp =
                            jobData['workingDate'] as Timestamp?;
                        final endingDateTimestamp =
                            jobData['endingDate'] as Timestamp?;
                        final workingTime =
                            jobData['workingTime'] as String? ?? 'N/A';
                        final workingDays =
                            jobData['workingDays'] as String? ?? 'N/A';

// Convert Timestamp to String
                        final workingDateString =
                            workingDateTimestamp?.toDate().toString() ?? 'N/A';
                        final endingDateString =
                            endingDateTimestamp?.toDate().toString() ?? 'N/A';

                        return GestureDetector(
                          onTap: () {
                            // Navigate to UserviewJobapplication page with job details
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserviewJobapplication(
                                  jobName: jobName,
                                  place: place,
                                  amount: amount,
                                  workingDate: workingDateString,
                                  endingDate: endingDateString,
                                  workingTime: workingTime,
                                  workingDays: workingDays,
                                ),
                              ),
                            );
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
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on,
                                              color: Colors.black),
                                          const SizedBox(width: 8.0),
                                          Text(place),
                                        ],
                                      ),
                                      const SizedBox(width: 16.0),
                                      Text(
                                        '\$$amount',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
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
                      },
                    ),
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
