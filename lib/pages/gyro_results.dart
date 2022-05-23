import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vysion_app_sensorsplus/main_database/database.dart';
import 'package:vysion_app_sensorsplus/pages/homepage.dart';

class GyroResult extends StatefulWidget {
  const GyroResult({Key? key}) : super(key: key);

  @override
  _GyroResultState createState() => _GyroResultState();
}

class _GyroResultState extends State<GyroResult> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gyroscope Resluts"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                children: [
                  SizedBox(
                    width: w * 0.05,
                  ),
                  Text('x', style: headerStyle),
                  SizedBox(
                    width: w * 0.12,
                  ),
                  Text(
                    'y',
                    style: headerStyle,
                  ),
                  SizedBox(
                    width: w * 0.15,
                  ),
                  Text(
                    'z',
                    style: headerStyle,
                  ),
                  SizedBox(
                    width: w * 0.16,
                  ),
                  Text(
                    'Time Stamp',
                    style: headerStyle,
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              child: FutureBuilder<List<Data>>(
                future: MainDatabase.instance.getData(),
                builder: (context, AsyncSnapshot<List<Data>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text('Getting Data..'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, idx) {
                        if (snapshot.data![idx].x == null) {
                          return Container();
                        }
                        gyrorow.add({
                          "x": snapshot.data![idx].x,
                          "y": snapshot.data![idx].y,
                          "z": snapshot.data![idx].z,
                          "timestamp": snapshot.data![idx].time
                        });

                        return ResRow(
                          x: snapshot.data![idx].x.toString(),
                          y: snapshot.data![idx].y.toString(),
                          z: snapshot.data![idx].z.toString(),
                          time: snapshot.data![idx].time.toString(),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  String? directory = await createFolder("Vibration Data");
                  final path = "$directory/GyroscopeData${DateTime.now()}.csv";
                  List<dynamic> row = [];
                  row.add("x");
                  row.add("y");
                  row.add("z");
                  row.add("timestamp");
                  gyrorows.add(row);
                  for (int i = 0; i < gyrorow.length; i++) {
                    List<dynamic> row = [];
                    row.add(gyrorow[i]["x"]);
                    row.add(gyrorow[i]["y"]);
                    row.add(gyrorow[i]["z"]);
                    row.add(gyrorow[i]["timestamp"]
                        .toString()
                        .replaceAll('.', 'ms'));
                    gyrorows.add(row);
                  }
                  gyrocsv = const ListToCsvConverter().convert(gyrorows);

                  final File file = File(path);
                  await file.writeAsString(gyrocsv.toString());
                  row = [];
                  gyrorow = [];
                  gyrorows = [];
                  gyrocsv = '';
                },
                child: const Text('Download .csv file'))
          ],
        ),
      ),
    );
  }
}

class ResRow extends StatelessWidget {
  final String? x;
  final String? y;
  final String? z;
  final String? time;
  const ResRow({Key? key, this.x, this.y, this.z, this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            x.toString(),
          ),
          Text(
            y.toString(),
          ),
          Text(z.toString()),
          Text(time.toString()),
        ],
      ),
    );
  }
}

TextStyle headerStyle =
    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20);

Future<String> createFolder(String cow) async {
  final folderName = cow;
  final path = Directory("storage/emulated/0/$folderName");
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  if ((await path.exists())) {
    return path.path;
  } else {
    path.create();
    return path.path;
  }
}
