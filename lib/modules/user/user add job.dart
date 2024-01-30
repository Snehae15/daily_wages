import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TimeOfDayRange {
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  TimeOfDayRange({
    required this.startTime,
    required this.endTime,
  });
}

class AddJobPage extends StatefulWidget {
  const AddJobPage({Key? key}) : super(key: key);

  @override
  _AddJobPageState createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  DateTime? _workingDate;
  DateTime? _endingDate;
  TimeOfDayRange? _workingTime;

  final TextEditingController _jobNameController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _workingDaysController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final CollectionReference jobsCollection =
      FirebaseFirestore.instance.collection('add_job');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Job'),
        backgroundColor: const Color(0xFFF7F1E1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Job',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _jobNameController,
                decoration: const InputDecoration(
                  labelText: 'Job',
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Place',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _placeController,
                decoration: const InputDecoration(
                  labelText: 'Place',
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Working dates',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () => _selectWorkingDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  child: _workingDate != null
                      ? Text(
                          "${_workingDate!.toLocal()}".split(' ')[0],
                        )
                      : const Text('Select Working Date'),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Ending Date',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () => _selectEndingDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  child: _endingDate != null
                      ? Text(
                          "${_endingDate!.toLocal()}".split(' ')[0],
                        )
                      : const Text('Select Ending Date'),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'working Time',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () => _selectWorkingTime(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  child: _workingTime != null
                      ? Text(
                          '${_workingTime!.startTime.format(context)} to ${_workingTime!.endTime.format(context)}',
                        )
                      : const Text('Select Working Time'),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Working Days',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _workingDaysController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Amount',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Fetch userName before submitting the job
                  String? userName = await _fetchUserName();

                  if (userName != null) {
                    _submitJob(userName);
                  } else {
                    Fluttertoast.showToast(
                      msg: 'Failed to fetch user information.',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectWorkingDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _workingDate) {
      setState(() {
        _workingDate = pickedDate;
      });
    }
  }

  Future<void> _selectEndingDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _endingDate) {
      setState(() {
        _endingDate = pickedDate;
      });
    }
  }

  Future<void> _selectWorkingTime(BuildContext context) async {
    TimeOfDay? startTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (startTime != null) {
      TimeOfDay? endTime = await showTimePicker(
        context: context,
        initialTime: startTime,
      );

      if (endTime != null) {
        setState(() {
          _workingTime = TimeOfDayRange(startTime: startTime, endTime: endTime);
        });
      }
    }
  }

  Future<String?> _fetchUserName() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('users');

        QuerySnapshot querySnapshot = await usersCollection
            .where('userId', isEqualTo: currentUser.uid)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          var document = querySnapshot.docs.first;
          return document['userName'];
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> _submitJob(String userName) async {
    try {
      String workingTimeStr = _workingTime != null
          ? "${_workingTime!.startTime.format(context)} to ${_workingTime!.endTime.format(context)}"
          : "";

      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        DocumentReference jobDocument = await jobsCollection.add({
          'userId': currentUser.uid,
          'userName': userName,
          'jobName': _jobNameController.text,
          'place': _placeController.text,
          'workingDate': _workingDate,
          'endingDate': _endingDate,
          'workingTime': workingTimeStr,
          'workingDays': _workingDaysController.text,
          'amount': double.tryParse(_amountController.text) ?? 0.0,
        });

        await jobDocument.update({'jobId': jobDocument.id});

        Fluttertoast.showToast(
          msg: 'Job added successfully!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
          msg: 'User not authenticated. Please log in.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to add job. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
