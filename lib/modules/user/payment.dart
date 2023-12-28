import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PaymentPage(),
    );
  }
}

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final List<String> paymentOptions = [
    'Vehicle Mechanic',
    'Font: 990 Payment Vehicle Mechanic',
    'Font: 990',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: ListView.builder(
        itemCount: paymentOptions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              paymentOptions[index],
              style: const TextStyle(fontSize: 20),
            ),
          );
        },
      ),
    );
  }
}
