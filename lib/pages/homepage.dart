import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vysion_app_sensorsplus/main_database/database.dart';
import 'dart:async';
import 'package:vysion_app_sensorsplus/pages/selection_page.dart';

bool isStopped = true;

List<dynamic> gyrorow = [];
List<dynamic> accrow = [];
List<List<dynamic>> gyrorows = [];
List<List<dynamic>> accrows = [];
String? gyrocsv;

class SqliteApp extends StatefulWidget {
  const SqliteApp({Key? key}) : super(key: key);

  @override
  _SqliteAppState createState() => _SqliteAppState();
}

class _SqliteAppState extends State<SqliteApp> {
  Timer? timer, acctimer;
  double? x, y, z, accx, accy, accz;
  String? datetime, accdatetime;
  Timer? subtimer, accsubtimer;

  @override
  Widget build(BuildContext context) {
    StreamSubscription? subgyro;
    StreamSubscription? subacc;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text(
                isStopped ? 'START' : 'STOP',
              ),
              onPressed: () {
                setState(() {
                  isStopped = !isStopped;
                });
                if (!isStopped) {
                  timer = Timer.periodic(const Duration(milliseconds: 200),
                      (timer) async {
                    subtimer = timer;
                    await MainDatabase.instance
                        .addgyro(Data(x: x, y: y, z: z, time: datetime));
                  });
                  subgyro = gyroscopeEvents.listen((event) async {
                    x = double.parse(event.x.toStringAsFixed(4));
                    y = double.parse(event.y.toStringAsFixed(4));
                    z = double.parse(event.z.toStringAsFixed(4));
                    datetime = DateTime.now().toString();
                  });
                  acctimer = Timer.periodic(const Duration(milliseconds: 200),
                      (timer) async {
                    accsubtimer = timer;
                    await MainDatabase.instance.addacc(
                        Data(x: accx, y: accy, z: accz, time: accdatetime));
                  });
                  subgyro = gyroscopeEvents.listen((event) async {
                    accx = double.parse(event.x.toStringAsFixed(4));
                    accy = double.parse(event.y.toStringAsFixed(4));
                    accz = double.parse(event.z.toStringAsFixed(4));
                    accdatetime = DateTime.now().toString();
                  });
                } else {
                  subgyro?.cancel();
                  subacc?.cancel();
                  timer?.cancel();
                  subtimer?.cancel();
                  acctimer?.cancel();
                  accsubtimer?.cancel();
                }
              },
            ),
            ElevatedButton(
              child: const Text(
                'GET',
              ),
              onPressed: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Selection()));
              },
            ),
            ElevatedButton(
              child: const Text(
                'DELETE',
              ),
              onPressed: () async {
                gyrorow.clear();
                gyrorows.clear();
                accrow.clear();
                accrows.clear();
                gyrocsv = '';
                MainDatabase.instance.deleteall();
              },
            ),
          ],
        ),
      ),
    );
  }
}
