import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MainDatabase {
  static final MainDatabase instance = MainDatabase._init();
  static Database? _database;

  MainDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('maindb.db');
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, filepath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final fieldtype = 'REAL';
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    await db.execute(
        '''CREATE TABLE data ( id $idType, x $fieldtype, y $fieldtype, z $fieldtype, time TEXT )''');
    await db.execute(
        '''CREATE TABLE accdata ( id $idType, x $fieldtype, y $fieldtype, z $fieldtype, time TEXT )''');
  }

  Future<int?> addgyro(Data d) async {
    Database db = await instance.database;
    print("added gyro");
    return await db.insert('data', d.toMap());
  }

  Future<int?> addacc(Data d) async {
    Database db = await instance.database;
    print("added acc");
    return await db.insert('accdata', d.toMap());
  }

  Future<List<Data>> getData() async {
    Database db = await instance.database;
    var d = await db.query('data', orderBy: 'id');
    List<Data> DataList =
        d.isNotEmpty ? d.map((c) => Data.fromMap(c)).toList() : [];
    return DataList;
  }

  Future<List<Data>> getaccData() async {
    Database db = await instance.database;
    var d = await db.query('accdata', orderBy: 'id');
    List<Data> DataList =
        d.isNotEmpty ? d.map((c) => Data.fromMap(c)).toList() : [];
    return DataList;
  }

  Future<dynamic> alterTable() async {
    var dbClient = await instance.database;
    var count =
        await dbClient.execute("ALTER TABLE data ADD COLUMN time TEXT;");
    print(await dbClient.query('data'));
    print("altered");
    return count;
  }

  Future<dynamic> addtable() async {
    Database db = await instance.database;
    var count = await db.execute(
        '''CREATE TABLE accdata(id INTEGER PRIMARY KEY AUTOINCREMENT, x REAL, y REAL, z REAL, time TEXT );''');
    print('created new table');
    return count;
  }

  Future deleteall() async {
    Database db = await instance.database;
    await db.rawDelete('DELETE FROM data;');
    await db.rawDelete('DELETE FROM accdata;');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

class Data {
  final int? id;
  final double? x;
  final double? y;
  final double? z;
  final String? time;

  Data({this.id, this.x, this.y, this.z, this.time});

  factory Data.fromMap(Map<String, dynamic> json) => Data(
      id: json['id'],
      x: json['x'],
      y: json['y'],
      z: json['z'],
      time: json['time']);
  Map<String, dynamic> toMap() {
    return {'id': id, 'x': x, 'y': y, 'z': z, 'time': time};
  }
}

//
// Future<int> remove(int id) async {
//   Database db = await instance.database;
//   return await db.delete('groceries', where: 'id = ?', whereArgs: [id]);
// }
//
// Future<int> update(Grocery grocery) async {
//   Database db = await instance.database;
//   return await db.update('groceries', grocery.toMap(),
//       where: "id = ?", whereArgs: [grocery.id]);
// }
// }

//
// class Grocery {
//   final int? id;
//   final String name;
//
//   Grocery({this.id, required this.name});
//
//   factory Grocery.fromMap(Map<String, dynamic> json) => new Grocery(
//         id: json['id'],
//         name: json['name'],
//       );
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//     };
//   }
// }
//
// class DatabaseHelper {
//   DatabaseHelper._privateConstructor();
//   static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
//
//   static Database? _database;
//   Future<Database> get database async => _database ??= await _initDatabase();
//
//   Future<Database> _initDatabase() async {
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, 'groceries.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: _onCreate,
//     );
//   }
//
//   Future _onCreate(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE groceries(
//           id INTEGER PRIMARY KEY,
//           name TEXT
//       )
//       ''');
//   }
//
//   Future<List<Grocery>> getGroceries() async {
//     Database db = await instance.database;
//     var groceries = await db.query('groceries', orderBy: 'name');
//     List<Grocery> groceryList = groceries.isNotEmpty
//         ? groceries.map((c) => Grocery.fromMap(c)).toList()
//         : [];
//     return groceryList;
//   }
//
//   Future<int> add(Grocery grocery) async {
//     Database db = await instance.database;
//     return await db.insert('groceries', grocery.toMap());
//   }
//
//   Future<int> remove(int id) async {
//     Database db = await instance.database;
//     return await db.delete('groceries', where: 'id = ?', whereArgs: [id]);
//   }
//
//   Future<int> update(Grocery grocery) async {
//     Database db = await instance.database;
//     return await db.update('groceries', grocery.toMap(),
//         where: "id = ?", whereArgs: [grocery.id]);
//   }
// }
