import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:zoom_get_coordinate/src/models/employee_model.dart';
import 'package:zoom_get_coordinate/src/providers/db_provider.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

// int a = 0;

var path = ["5minutes", "hourly"];

class EmployeeApiProvider {
  Future<List<Employee>> getAllEmployees() async {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second);

    var endDate = new DateFormat('yyyyMMddTkkmmss').format(date).toString();
    var startDateget = date.add(new Duration(hours: -10));

    var startDate =
        new DateFormat('yyyyMMddTkkmmss').format(startDateget).toString();

    startDate = startDate.replaceAll("24", "00");

    // for (var i = 0; i < path.length; i++) {
    var url = "http://192.168.2.8:8001/api/chint/" +
        path[1].toString() +
        "?date_start=" +
        startDate +
        "&date_end=" +
        endDate;
    url = "http://192.168.2.8:8001/api/chint/" + path[1].toString();

    // url = "https://raw.githubusercontent.com/fahmi27071996/sudnaya_chint/master/5minute.json";
    var token = '87zPVKPw.h3Up7yBVHenVx184JvHOf5qpOYM7yhyf';

    // HttpClient client = new HttpClient();

    // HttpClientRequest request = await client.getUrl(Uri.parse(url));

    // request.headers.set('content-type', 'application/json');

    // request.headers.set('x-api-key', '$token');

    // HttpClientResponse response = await request.close();

    // var reply = await response.transform(utf8.decoder).join();

    var responseData = await http.get(
      url,
      headers: {"x-api-key": "$token"},
    );

    //  Response response = await Dio().get(url);

    // if(responseData.statusCode ==200)
    // {}
    print("URl : " + url.toString());

    var data = json.decode(responseData.body);
    // a=0;

    var panjangData = data[0]['data'][0];
    // print("pjg : " + panjangData.length.toString());
    print("Data Masuk : " + panjangData.toString());

    return (data[0]['data'] as List).map((employee) {
      // print("aaaa"+a.toString());
      //a++;
      // DBProvider.db.createEmployee(Employee.fromJson(employee), "Employee");
      DBProvider.db.createEmployee(Employee.fromJson(employee), "hourly");
    }).toList();
    // }
  }
}
