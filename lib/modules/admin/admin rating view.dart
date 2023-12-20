import 'package:flutter/material.dart';

class RatingView extends StatelessWidget {
  final List<String> names = [
    'John Doe',
    'Jane Doe',
    'Alice',
    'Bob',
    'Charlie'
  ];
  final List<String> jobTypes = [
    'Developer',
    'Designer',
    'Manager',
    'Engineer',
    'Artist'
  ];
  final List<double> ratings = [4.5, 3.0, 5.0, 4.0, 4.8];

  RatingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rating View'),
        backgroundColor: const Color(0xFFF7F1E1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: names.length,
          itemBuilder: (context, index) {
            return Card(
              color: const Color.fromARGB(255, 237, 224, 190),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/person.png'),
                      radius: 30,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            names[index],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            jobTypes[index],
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (starIndex) => Icon(
                          starIndex < ratings[index]
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.yellow,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
