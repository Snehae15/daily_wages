import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentPage extends StatefulWidget {
  final String appliedJobId;
  final String userId;
  final String jobId;
  final String jobName;
  final String city;
  final String imagePath;
  final String location;
  final String name;
  final String jobType;
  final String userName;
  late String amount;

  PaymentPage({
    Key? key,
    required this.appliedJobId,
    required this.userId,
    required this.jobId,
    required this.jobName,
    required this.city,
    required this.imagePath,
    required this.location,
    required this.name,
    required this.jobType,
    required this.userName,
    required String amount,
  }) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late String userName;
  late String jobName;
  late String amount;

  @override
  void initState() {
    super.initState();
    userName = '';
    jobName = '';
    amount = '';
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();

    if (userSnapshot.exists) {
      setState(() {
        userName = userSnapshot['userName'] ?? '';
      });
    }

    DocumentSnapshot jobSnapshot = await FirebaseFirestore.instance
        .collection('add_job')
        .doc(widget.jobId)
        .get();

    if (jobSnapshot.exists) {
      setState(() {
        jobName = jobSnapshot['jobName'] ?? '';
        amount = (jobSnapshot['amount'] ?? 0).toString();
      });
    }
  }

  final List<String> paymentOptions = ['jobName'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: ListView.builder(
        itemCount: paymentOptions.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 3.0,
            margin: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    paymentOptions[index],
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text('Username:'),
                          const SizedBox(width: 8.0),
                          Text(userName),
                        ],
                      ),
                      Row(
                        children: [
                          const Text('Amount:'),
                          const SizedBox(width: 8.0),
                          Text(amount),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Last Date:'),
                      const SizedBox(width: 8.0),
                      Text(formatDate(DateTime.now())),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      addPaymentRecord();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Payment Successful'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      onPrimary: Colors.white,
                    ),
                    child: const Text('Pay'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> addPaymentRecord() async {
    DateTime currentDate = DateTime.now();
    await FirebaseFirestore.instance.collection('payments').add({
      'userId': widget.userId,
      'jobId': widget.jobId,
      'amount': double.parse(amount),
      'date': formatDate(currentDate),
    });
  }

  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
