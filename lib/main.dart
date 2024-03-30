import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, Key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: Finger(),
    );
  }
}

class AppColors {
  static const mandarinColor = Color(0xFFF57850);
  static const whiteColor = Color(0xFFFFFFFF);
  static const grayColor = Color(0xFFB85DD7);
}

class Finger extends StatefulWidget {
  const Finger({super.key, Key});

  @override
  State<Finger> createState() => _FingerState();
}

class _FingerState extends State<Finger> {
  String currentTime = '';
  List<String> recordedTimes = [];
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Attendance',
          style: TextStyle(color: AppColors.whiteColor),
        ),
        backgroundColor: AppColors.mandarinColor,
      ),
      body: GestureDetector(
        onLongPressStart: (_) {
          setState(() {
            isPressed = true;
          });
          Future.delayed(const Duration(seconds: 1), () {
            if (isPressed) {
              setState(() {
                currentTime = getCurrentTime();
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DetailsScreen(currentTime.toString(), recordedTimes),
                ),
              ).then((value) {
                setState(() {
                  isPressed = false;
                });
              });
              recordedTimes.add(currentTime);
            }
          });
        },
        onLongPressEnd: (_) {
          setState(() {
            isPressed = false;
          });
        },
        child: Container(
          color: AppColors.whiteColor,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Icon(
                Icons.fingerprint_sharp,
                color: isPressed
                    ? AppColors.grayColor
                    : AppColors.mandarinColor,
                size: 120,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String getCurrentTime() {
    DateTime now = DateTime.now();
    return DateFormat('hh:mm:ss, d-MMM, EEE ').format(now);
  }
}

class DetailsScreen extends StatelessWidget {
  final String time;
  final List<String> recordedTimes;

  const DetailsScreen(this.time, this.recordedTimes, {Key? key});

  @override
  Widget build(BuildContext context) {
    // Check if the new time is already present in the recordedTimes list
    bool isTimeExists = recordedTimes.contains(time);

    // If the time is not already recorded, insert it at the beginning of the list
    if (!isTimeExists) {
      recordedTimes.insert(0, time);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Details'),
        backgroundColor: AppColors.mandarinColor,
      ),
      body: ListView.builder(
        itemCount: recordedTimes.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
                backgroundColor: AppColors.mandarinColor,
                child: Text('${index + 1}', style: const TextStyle(color: AppColors.whiteColor),)),
            title: const Text('Attendance'),
            subtitle: Text(recordedTimes[index]),
          );
        },
      ),
    );
  }
}


