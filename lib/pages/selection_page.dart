import 'package:flutter/material.dart';
import 'package:vysion_app_sensorsplus/pages/gyro_results.dart';

import 'acc_results.dart';

class Selection extends StatefulWidget {
  const Selection({Key? key}) : super(key: key);

  @override
  State<Selection> createState() => _SelectionState();
}

class _SelectionState extends State<Selection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => GyroResult()));
                },
                child: Text('Gyroscope Data')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => AccResult()));
                },
                child: Text('Accelerometer Data')),
          ],
        ),
      ),
    );
  }
}
