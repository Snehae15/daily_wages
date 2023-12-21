import 'package:cloud_firestore/cloud_firestore.dart';
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
                onPressed: () {
                  _submitJob();
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

  void _submitJob() async {
    try {
      // Convert TimeOfDayRange to String
      String workingTimeStr = _workingTime != null
          ? "${_workingTime!.startTime.format(context)} to ${_workingTime!.endTime.format(context)}"
          : "";

      await jobsCollection.add({
        'jobName': _jobNameController.text,
        'place': _placeController.text,
        'workingDate': _workingDate,
        'endingDate': _endingDate,
        'workingTime': workingTimeStr,
        'workingDays': _workingDaysController.text,
        'amount': double.tryParse(_amountController.text) ?? 0.0,
      });

      Fluttertoast.showToast(
        msg: 'Job added successfully!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
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

    // Navigate back to the previous screen
    Navigator.pop(context);
  }
}
