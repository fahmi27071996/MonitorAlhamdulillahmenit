import 'dart:io';
import 'package:zoom_get_coordinate/src/models/employee_model.dart';
import 'package:path/path.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:zoom_get_coordinate/src/providers/employee_api_provider.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB("Employee");

    return _database;
  }

  Future<Database> get databaseHour async {
    // If database exists, return database
    if (_database != null) return _database;

    // If database don't exists, create one
    _database = await initDB("hourly");
    print("init namaDB : hourly");

    return _database;
  }

  // Create the database and the Employee table
  // initDB() async {
  //   Directory documentsDirectory = await getApplicationDocumentsDirectory();
  //   final path = join(documentsDirectory.path, 'employee_manager.db');

  //   return await openDatabase(path, version: 1, onOpen: (db) {},
  //       onCreate: (Database db, int version) async {
  //     await db.execute('CREATE TABLE Employee('
  //         'id INTEGER PRIMARY KEY,'
  //         'email TEXT,'
  //         'firstName TEXT,'
  //         'lastName TEXT,'
  //         'avatar TEXT'
  //         ')');
  //   });
  // }

  // init dg to get data from github

  initDB(String tabelData) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'employee_manager.db');

    //var dataz = new EmployeeApiProvider();
    //var dataz1 = dataz.getAllEmployees();

    //final path1 = join(documentsDirectory.path,EmployeeApiProvider.);

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE "$tabelData"('
          'time_stamp TEXT PRIMARY KEY,'
          'energy_total TEXT,'
          'energy_a TEXT,'
          'energy_b TEXT,'
          'energy_c TEXT'
          ')');
    });
  }

  // init dg to get data from github

  // Insert employee on database
  createEmployee(Employee newEmployee, String dbName) async {
    // await deleteAllEmployees();
    var db;
    if (dbName == "Employee") {
      db = await database;
    } else {
      db = await databaseHour;
    }
    var res;
    try {
      //  if (dbName == "Employee") {
      res = await db.insert('Employee', newEmployee.toJson());
      //  }
      //  else{
     // res = await db.insert('hourly', newEmployee.toJson());
      print("insert namaDB : hourly");

      //  }
      return res;
    } catch (e) {}
  }

  // Delete all employees
  Future<int> deleteAllEmployees() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Employee');
    //db.

    return res;
  }

  Future<List<Employee>> getAllEmployees(String query) async {
    final db = await database;
    // final res = await db.rawQuery('SELECT * FROM EMPLOYEE WHERE time_stamp = "20200411T080902.889+0700"'); // cari primary key yg sama
    final res =
        await db.rawQuery(query); //'SELECT * FROM EMPLOYEE'); //bettween
    List<Employee> list =
        res.isNotEmpty ? res.map((c) => Employee.fromJson(c)).toList() : [];

    return list;
  }

  Future<List> getLastData(String query) async {
    try {
      final db = await database;
      // final res = await db.rawQuery('SELECT * FROM EMPLOYEE WHERE time_stamp = "20200411T080902.889+0700"'); // cari primary key yg sama
      final res =
          await db.rawQuery(query); //'SELECT * FROM EMPLOYEE'); //bettween
      List<Employee> list =
          res.isNotEmpty ? res.map((c) => Employee.fromJson(c)).toList() : [];
      // print(Employee.);

      return res;
    } catch (e) {
      print("belum ada db");
      return [];
    }
  }
}
