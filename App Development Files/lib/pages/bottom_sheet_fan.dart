import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FanBottomScreen extends StatefulWidget {
  const FanBottomScreen({super.key});

  @override
  State<FanBottomScreen> createState() => _FanBottomScreenState();
}

class _FanBottomScreenState extends State<FanBottomScreen> {
  final dbR = FirebaseDatabase.instance.ref();
  int timerValue = 0; // Initial timer value in seconds
  bool timerRunning = false;
  bool isSwitchOn = false; // Add this variable

  void toggleBulb() {
    setState(() {
      isSwitchOn = !isSwitchOn;
      int valueToSet = isSwitchOn ? 1 : 0;
      dbR.child('Pins/17/').set({'17': valueToSet});
    });
  }

  void setTimer(int value) {
    setState(() {
      timerValue = value;
    });
  }

  void startCountdown() {
    setState(() {
      timerRunning = true;
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timerValue > 0) {
          timerValue--;
        } else {
          isSwitchOn = !isSwitchOn;
          int valueToSet = isSwitchOn ? 1 : 0;
          dbR.child('Pins/17/').set({'17': valueToSet});

          timer.cancel();
          timerRunning = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Start The Timer :',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                onPressed: timerRunning ? null : startCountdown,
                child: Text('Start'),
              ),
            ],
          ),
          Slider(
            value: timerValue.toDouble(),
            min: 0,
            max: 60,
            onChanged: (value) {
              setTimer(value.toInt());
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                '$timerValue Seconds',
                style: TextStyle(fontSize: 20.0),
              ),
              Switch(
                value: isSwitchOn,
                onChanged: (value) {
                  toggleBulb(); // Toggle the switch state and update the database
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
