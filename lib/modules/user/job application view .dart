import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class JobApplicationPage extends StatelessWidget {
  const JobApplicationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Application'),
        backgroundColor: const Color(0xFFF7F1E1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            buildJobApplicationCard(
              'Name 1',
              'Job type1',
              'Location 1',
              'assets/person.png',
              context,
            ),
            const SizedBox(height: 16.0),
            buildJobApplicationCard(
              'Name 2',
              'Job Type 2',
              'Location 2',
              'assets/person.png',
              context,
            ),
            const SizedBox(height: 16.0),
            buildJobApplicationCard(
              'Name 3',
              'Job type 3',
              'Location 3',
              'assets/person.png',
              context,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildJobApplicationCard(
    String name,
    String jobType,
    String location,
    String imagePath,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserAccepted(
              name: name,
              jobType: jobType,
              location: location,
              imagePath: imagePath,
            ),
          ),
        );
      },
      child: Card(
        color: const Color(0xFFF7F1E1),
        elevation: 3.0,
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundImage: AssetImage(imagePath),
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(width: 12.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        jobType,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              const Text(
                'Location',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
              const SizedBox(height: 4.0),
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.black),
                  const SizedBox(width: 4.0),
                  Text(location),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserAccepted extends StatelessWidget {
  final String name;
  final String jobType;
  final String location;
  final String imagePath;

  const UserAccepted({
    super.key,
    required this.name,
    required this.jobType,
    required this.location,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Accepted'),
        backgroundColor: const Color(0xFFF7F1E1),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(imagePath),
                backgroundColor: Colors.grey,
              ),
              const SizedBox(height: 10),
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                jobType,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 10),
              // Rating stars
              RatingBar.builder(
                initialRating: 3.5,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 20.0,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  // Handle rating updates if needed
                },
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildInfoRow('Place', 'Corresponding Place'),
                  buildInfoRow('Age', 'Corresponding Age'),
                  buildInfoRow('Phone Number', 'Corresponding Phone Number'),
                  buildInfoRow('Email', 'Corresponding Email'),
                  buildInfoRow('Job List', 'Corresponding Job List'),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Add logic for accepting the application
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Accept'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Add logic for rejecting the application
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Reject'),
                  ),
                ],
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
}
