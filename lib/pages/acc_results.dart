import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vysion_app_sensorsplus/main_database/database.dart';
import 'gyro_results.dart';
import 'homepage.dart';

class AccResult extends StatefulWidget {
  const AccResult({Key? key}) : super(key: key);

  @override
  _AccResultState createState() => _AccResultState();
}

class _AccResultState extends State<AccResult> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Accelerometer Resluts"),
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
                future: MainDatabase.instance.getaccData(),
                builder: (context, AsyncSnapshot<List<Data>> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text('Getting Data..'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, idx) {
                        if (snapshot.data![idx].x == null) {
                          return Container();
                        }
                        accrow.add({
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

                  final path =
                      "$directory/AccelerometerData${DateTime.now()}.csv";
                  List<dynamic> row = [];
                  row.add("x");
                  row.add("y");
                  row.add("z");
                  row.add("timestamp");
                  accrows.add(row);
                  for (int i = 0; i < accrow.length; i++) {
                    List<dynamic> row = [];
                    row.add(accrow[i]["x"]);
                    row.add(accrow[i]["y"]);
                    row.add(accrow[i]["z"]);
                    row.add(accrow[i]["timestamp"]
                        .toString()
                        .replaceAll('.', 'ms'));
                    accrows.add(row);
                  }
                  String acccsv = const ListToCsvConverter().convert(accrows);
                  print(path);
                  final File file = File(path);
                  await file.writeAsString(acccsv);
                  row = [];
                  accrow = [];
                  accrows = [];
                  acccsv = '';
                },
                child: Text('Download .csv file'))
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
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Text(
                x.toString(),
              ),
            ),
            Container(
              child: Text(
                y.toString(),
              ),
            ),
            Container(child: Text(z.toString())),
            Container(child: Text(time.toString())),
          ],
        ),
      ),
    );
  }
}

TextStyle headerStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
