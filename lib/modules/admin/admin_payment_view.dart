import 'package:daily_wage/screens/spalsh.dart';
import 'package:flutter/material.dart';

class ViewPaymentPage extends StatelessWidget {
  const ViewPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Payments'),
        backgroundColor: const Color(0xFFF7F1E1),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Splash(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Today',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              Card(
                color: const Color(0xFFF7F1E1),
                child: ListTile(
                  title: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: const [
                        TextSpan(
                          text: 'Username sent ',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: '₹200',
                          style: TextStyle(color: Colors.red),
                        ),
                        TextSpan(
                          text: ' to Employee Name (Type)',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  subtitle: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payment: ₹200',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '12:30 PM, 15 Dec 2023',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
