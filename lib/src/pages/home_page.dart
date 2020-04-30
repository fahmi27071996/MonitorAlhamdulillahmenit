import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:google_fonts/google_fonts.dart';
import 'package:zoom_get_coordinate/src/providers/db_provider.dart';
import 'package:zoom_get_coordinate/src/providers/employee_api_provider.dart';
import 'package:flutter/material.dart';
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:zoom_get_coordinate/src/pages/getDate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
// import 'package:zoom_widget/zoom_widget.dart';
//date_start=20200428T000000&date_end=20200428T110121

String DataStop = "20200428T110000";
String DataStop1 = ""; //20200414T160000
var GeserStatus = false;
var DateLimit = false;

String dataQuery = //"";
    // "SELECT * FROM EMPLOYEE"; //'SELECT * FROM EMPLOYEE WHERE time_stamp BETWEEN "20200428T000000" AND "20200428T010000"';
    'SELECT * FROM EMPLOYEE WHERE time_stamp BETWEEN "20200429T000000" AND "20200430T000000"';

String mulai;
String akhir;

String Qmulai, Qakhir;

int counter = 1;

List<String> titles = [
  'Phasa A',
  'Phasa B',
  'Phasa C',
];

int data_tinggi = 60;
int data_lebar = 200;

var red = "#db0202";
var data2 = new List();
var panjang = 31;

// ==================== scALE========================//

var StartScale, EndScale, ChangeScale;
var StatusStartScale = false;

// ==================== scALE========================//

int AddManual = 0;
int AddManualLeft = 1;

int _downCounter = 0;
int _upCounter = 0;
double x = 0.0;
double y = 0.0;

var touch1 = 0, touch2 = 0;
var dataTouch = [0.0, 0.0];
var statusTouch1 = false, statusTouch2 = false;
var result = [0.0, 0.0];
int datat1l, datat2l;
int dataC = 0, cs = 0;
// int distance = 0;
List<int> dataTouchInt = [0, 0];

List<int> deltaTouch = [0, 0];

var mode = ["Stanby", "Drag 1", "Zoom"];
var selectMode = "Stanby";

var gKanan = false, gKiri = false;

//untuk timer

bool isStopped = false;

int durationTimeGraph = 1100;
var max_data = 0.0;

// untuk timer

bool stateData = false;

String label = "Tidak Ada data terdeteksi, silahkan update";
var iconStatus = Icons.warning;
var colorStatus = Colors.red;

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

// void ShowToast() {
//   Fluttertoast.showToast(
//       msg: "Minimum Data ..!!",
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.CENTER,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Colors.red,
//       textColor: Colors.white,
//       fontSize: 16.0);
// }

// _onDragUpdate(BuildContext context, DragUpdateDetails update) {
//   // print("update : " + update.globalPosition.toString());
//   RenderBox getBox = context.findRenderObject();
//   var local = getBox.globalToLocal(update.globalPosition);
//   print("update : " +
//       local.dx.toInt().toString() +
//       "|" +
//       local.dy.toInt().toString());
// }

// _onDragStart(BuildContext context, DragStartDetails start) {
//   //tambah();

//   //print(tampilTanggal());

//   print(newDate());

//   print("start :  " + start.globalPosition.toString());
//   RenderBox getBox = context.findRenderObject();
//   var local = getBox.globalToLocal(start.globalPosition);
//   // print(local.dx.toString() + "|" + local.dy.toString());
// }

// _onDragEnd(BuildContext context, DragEndDetails end) {
//   print(end.toString());
//   RenderBox getBox = context.findRenderObject();
// // var local = getBox.globalToLocal(end.globalPosition);
//   // print(local.dx.toString() + "|" + local.dy.toString());
// }

class _HomePageState extends State<HomePage> {
  var isLoading = false;
  int a = 0;
  int GestureLeft, GestureRight, ValueData, ValueStart;

  void tambah() {
    counter++;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Get Json'),
        centerTitle: true,
        actions: <Widget>[
          // Container(
          //   padding: EdgeInsets.only(right: 10.0),
          //   child: IconButton(
          //     icon: Icon(Icons.settings_input_antenna),
          //     onPressed: () async {
          //       await _loadFromApi();
          //     },
          //   ),
          // ),
          Center(
            //padding: EdgeInsets.all( 15.0),
            child: FlatButton(
              child: Text(
                "Update Data",
                textScaleFactor: 1.0,
                style: TextStyle(fontSize: 10.0, color: Colors.white),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  side: BorderSide(color: Colors.white)),
              onPressed: () async {
                // CircularProgressIndicator();
                label = "Proses Update Databse";
                iconStatus = Icons.update;
                colorStatus = Colors.lightGreen;
                await _loadFromApi();
                // stateData  =true;

                setState(() {
                  changeQuery1("data1", "data2");
                });
              },
            ),
          ),

          Padding(padding: EdgeInsets.all(6)),
        ],
      ),
      body: !stateData
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  // child: CircularProgressIndicator(),
                  child: IconButton(
                    icon: Icon(
                      iconStatus,
                      size: 90,
                      color: colorStatus,
                    ),
                    onPressed: () {
                      // ambil_data();
                    },
                    iconSize: 70,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(label),
                  // "Tidak ada Database Terdeteksi, silahkan klik update"),
                ),
                // Center(
                //   child: IconButton(
                //     icon: Icon(
                //       Icons.update,
                //       size: 90,
                //       color: Colors.green,
                //     ),
                //     onPressed: () async {
                //       // CircularProgressIndicator();
                //       label = "Proses Update Database";
                //       await _loadFromApi();
                //       // stateData  =true;

                //       setState(() {
                //         changeQuery1("data1", "data2");
                //       });
                //     },
                //     iconSize: 70,
                //   ),
                // ),
              ],
            )
          : Column(
              children: <Widget>[
                Expanded(
                    child: Center(
                  child: _buildEmployeeListView(),
                )),
                // Center(
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: <Widget>[
                //       Container(
                //         width: 70,
                //         padding: const EdgeInsets.all(10),
                //         margin: const EdgeInsets.only(right: 25),
                //         // color: Colors.grey[300],
                //         child: GestureDetector(
                //           child: Icon(Icons.add_box),
                //           onTap: () {
                //             setState(() {
                //               // AddManual=0;
                //               AddManualLeft++;

                //               changeQuery1("data1", "data2");
                //             });
                //           },
                //         ),
                //       ),
                //       Container(
                //         width: 70,
                //         padding: const EdgeInsets.all(10),
                //         margin: const EdgeInsets.only(right: 25),
                //         // color: Colors.grey[300],
                //         child: GestureDetector(
                //           child: Icon(Icons.indeterminate_check_box),
                //           onTap: () {
                //             setState(() {
                //               //  AddManual=0;
                //               AddManualLeft--;
                //               changeQuery1("data1", "data2");
                //             });
                //           },
                //         ),
                //       ),
                //       Container(
                //         width: 70,
                //         padding: const EdgeInsets.all(10),
                //         margin: const EdgeInsets.only(right: 25),
                //         // color: Colors.grey[300],
                //         child: GestureDetector(
                //           child: Icon(Icons.indeterminate_check_box),
                //           onTap: () {
                //             setState(() {
                //               // AddManualLeft = 0;
                //               AddManual--;
                //               changeQuery1("data1", "data2");
                //               // AddManual = 0;
                //             });
                //           },
                //         ),
                //       ),
                //       Container(
                //           width: 70,
                //           padding: const EdgeInsets.all(10),
                //           // margin: const EdgeInsets.only(right: 25),
                //           // color: Colors.grey[300],
                //           child: GestureDetector(
                //             child: Icon(Icons.add_box),
                //             onTap: () {
                //               setState(() {
                //                 //AddManualLeft = 0;
                //                 AddManual++;
                //                 changeQuery1("data1", "data2");
                //                 // AddManual = 0;
                //               });
                //             },
                //           )),
                //     ],
                //   ),
                // ),
                Center(
                  child: Text(
                    "Start : " +
                        Qmulai.toString() +
                        "\nEnd   : " +
                        Qakhir.toString(),
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Colors.red, fontSize: 18.0),
                  ),
                ),
                Stack(
                  children: <Widget>[
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   // crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: <Widget>[
                    //     Row(
                    //       //  mainAxisAlignment: MainAxisAlignment.center,
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: <Widget>[
                    //         Column(
                    //           mainAxisAlignment: MainAxisAlignment.start,
                    //           children: <Widget>[
                    //             Container(
                    //                 decoration: BoxDecoration(
                    //                   color: Colors.green,
                    //                   borderRadius: BorderRadius.circular(10),
                    //                 ),
                    //                 margin: const EdgeInsets.all(10),
                    //                 height: 35,
                    //                 width: 200,
                    //                 child: Column(
                    //                   mainAxisAlignment: MainAxisAlignment.center,
                    //                   children: <Widget>[
                    //                     Text(
                    //                       'Harvest',
                    //                       style: TextStyle(
                    //                           fontSize: 15, color: Colors.white),
                    //                       textAlign: TextAlign.center,
                    //                     ),
                    //                     Text(
                    //                       '40%',
                    //                       style: TextStyle(
                    //                           fontSize: 15, color: Colors.white),
                    //                       textAlign: TextAlign.center,
                    //                     ),
                    //                   ],
                    //                 )),
                    //             Container(
                    //                 decoration: BoxDecoration(
                    //                   color: Colors.blue,
                    //                   borderRadius: BorderRadius.circular(10),
                    //                 ),
                    //                 margin: const EdgeInsets.all(10),
                    //                 height: 35,
                    //                 width: 200,
                    //                 child: Column(
                    //                   mainAxisAlignment: MainAxisAlignment.center,
                    //                   children: <Widget>[
                    //                     Text(
                    //                       'Enjoy',
                    //                       style: TextStyle(
                    //                           fontSize: 15, color: Colors.white),
                    //                       textAlign: TextAlign.center,
                    //                     ),
                    //                     Text(
                    //                       '-10%',
                    //                       style: TextStyle(
                    //                           fontSize: 15, color: Colors.white),
                    //                       textAlign: TextAlign.center,
                    //                     ),
                    //                   ],
                    //                 )),
                    //             Container(
                    //               decoration: BoxDecoration(
                    //                 color: Colors.grey,
                    //                 borderRadius: BorderRadius.circular(10),
                    //               ),
                    //               margin: const EdgeInsets.all(10),
                    //               height: 35,
                    //               width: 200,
                    //               child: Column(
                    //                 mainAxisAlignment: MainAxisAlignment.center,
                    //                 children: <Widget>[
                    //                   Text(
                    //                     'PLN',
                    //                     style: TextStyle(
                    //                         fontSize: 15, color: Colors.white),
                    //                     textAlign: TextAlign.center,
                    //                   ),
                    //                   Text(
                    //                     '50%',
                    //                     style: TextStyle(
                    //                         fontSize: 15, color: Colors.white),
                    //                     textAlign: TextAlign.center,
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //         Container(
                    //           decoration: BoxDecoration(
                    //             color: Colors.red,
                    //             borderRadius: BorderRadius.circular(15),
                    //           ),
                    //           margin: const EdgeInsets.fromLTRB(10, 35, 10, 10),
                    //           height: 90,
                    //           width: 165,
                    //           child: Column(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             children: <Widget>[
                    //               Text(
                    //                 'Enjoy',
                    //                 style: TextStyle(fontSize: 15, color: Colors.white),
                    //                 textAlign: TextAlign.center,
                    //               ),
                    //               Text(
                    //                 '100%',
                    //                 style: TextStyle(fontSize: 15, color: Colors.white),
                    //                 textAlign: TextAlign.center,
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //     Container(
                    //       margin: const EdgeInsets.only(top: 50),
                    //       width: double.infinity,
                    //       height: 100,
                    //       color: Colors.green,
                    //       child: Text(
                    //         'Charts',
                    //         style: TextStyle(fontSize: 20, color: Colors.white),
                    //         textAlign: TextAlign.center,
                    //       ),
                    //     ),
                    //     Container(
                    //       margin: const EdgeInsets.only(top: 50),
                    //       width: double.infinity,
                    //       height: 100,
                    //       color: Colors.black45,
                    //       child: Text(
                    //         'Charts',
                    //         style: TextStyle(fontSize: 20, color: Colors.white),
                    //         textAlign: TextAlign.center,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(15),
                                child: IconButton(
                                    icon: Icon(Icons.keyboard_arrow_left),
                                    highlightColor: Colors.grey,
                                    onPressed: () {}),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    IconButton(
                                        icon: Icon(Icons.keyboard_arrow_up),
                                        highlightColor: Colors.grey,
                                        onPressed: () {
                                          setState(() {
                                            //AddManualLeft = 0;
                                            AddManualLeft++;
                                            if (AddManualLeft > 24)
                                              AddManualLeft = 24;
                                            print("mau : " +
                                                AddManualLeft.toString());
                                            changeQuery1("data1", "data2");
                                            // AddManual = 0;
                                          });
                                        }),
                                    Text(
                                      AddManualLeft.toString(),
                                      style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      textScaleFactor: 1,
                                    ),
                                    IconButton(
                                        icon: Icon(Icons.keyboard_arrow_down),
                                        highlightColor: Colors.grey,
                                        onPressed: () {
                                          setState(() {
                                            //AddManualLeft = 0;
                                            AddManualLeft--;
                                            if (AddManualLeft < 1)
                                              AddManualLeft = 1;
                                            changeQuery1("data1", "data2");
                                            // AddManual = 0;
                                          });
                                        }),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: <Widget>[
                                    IconButton(
                                        icon: Icon(Icons.keyboard_arrow_up),
                                        highlightColor: Colors.grey,
                                        onPressed: () {}),
                                    Text(
                                      'Hour',
                                      style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      textScaleFactor: 1,
                                    ),
                                    IconButton(
                                        icon: Icon(Icons.keyboard_arrow_down),
                                        highlightColor: Colors.red,
                                        onPressed: () {
                                          print("down");
                                          loadlast();
                                        }),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(15),
                                child: IconButton(
                                    icon: Icon(Icons.keyboard_arrow_right),
                                    highlightColor: Colors.grey,
                                    onPressed: () {}),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  changeQuery1(String data1, String data2) async {
    var dataq = await loadlast();
    DateTime tempDate;

    // try {
    if (dataq != null) {
      // dataq = await loadlast();
      tempDate = DateTime.parse(dataq.toString().split(".")[0].toString());

      //} catch (e) {
      // else {
      //   await _loadFromApi();
      //   dataq = await loadlast();
      //   tempDate = DateTime.parse(dataq.toString().split(".")[0].toString());
      stateData = true;
      // }
      // }
      //;.parse(DataStop.split('+')[0].toString()); //}

      var fiftyDaysFromNow = tempDate.add(new Duration(hours: -AddManualLeft));
      var format =
          DateFormat('yyyyMMddTkkmm').format(fiftyDaysFromNow).toString();

      DateTime dateTimeNow = DateTime.now();

      final differenceInDays = dateTimeNow.difference(tempDate).inHours;
      print("Selisih hour : " + differenceInDays.toString());
      print("awal : " + tempDate.toString());

      //DateTime tempDate1 = DateTime.parse(fiftyDaysFromNow);

      // var fiftyDaysFromNow1 = fiftyDaysFromNow
      //     .add(new Duration(hours: (1 + AddManual + AddManualLeft)));
      // var format1 =
      //     DateFormat('yyyyMMddTkkmmss').format(fiftyDaysFromNow1).toString();

      // untuk jam //

      // data2 = format1.replaceAll("T24", "T00");
      print("data1 aneh : " +
          format.toString() +
          " " +
          AddManualLeft.toString() +
          " " +
          tempDate.toString() +
          " " +
          fiftyDaysFromNow.toString());

      data1 = format.replaceAll("T24", "T00");
      format = DateFormat('yyyyMMddTkkmm').format(tempDate).toString();

      // data1 = data1.replaceAll("14T15", "14T16");

      // DateTime tempDateStart = DateTime.parse(data1);
      // var DisplayFormatStart =
      //     DateFormat('yyyy-MM-dd kk-mm-ss').format(tempDateStart).toString();

      // if (!DateLimit) {
      //   Qmulai = DisplayFormatStart;
      // }

      // DateTime tempDateFinish = DateTime.parse(data2);
      // DisplayFormatStart =
      //     DateFormat('yyyy-MM-dd kk-mm-ss').format(tempDateFinish).toString();

      // if (!DateLimit) {
      //   Qakhir = DisplayFormatStart;
      // }

      DateTime now = new DateTime.now();
      DateTime date =
          new DateTime(now.year, now.month, now.day, now.hour, now.minute);

      // var endDatex = new DateFormat('yyyyMMddTkkmmss').format(date).toString();

      // print("end : " + endDatex.toString());
      // data2 = endDatex;
      // endDatex = new DateFormat('yyyy-MM-dd kk-mm-ss').format(date).toString();
      // var mulainow = date.add(new Duration(hours: -a - AddManualLeft));
      // mulainow = new DateFormat('yyyy-MM-dd kk-mm-ss').format(mulainow).to;

      DateTime timeStart = DateTime.parse(data1.toString());
      var timeStartFormat =
          new DateFormat('yyyy-MM-dd kk-mm-ss').format(timeStart).toString();
      // Qakhir = endDatex;
      Qmulai = timeStartFormat.toString();

      print(data1);
      print(data2);

      // if (data2 == null) {
      //   data2 = format;
      // } else {
      data2 = dataq.toString().split(".")[0].toString();

      // }

      print("okxx : " + format.toString());

      // var dataq = await loadlast();
      // try {
      //  data2 = await loadlast().toString();

      // } catch (e) {
      //   data2 = data1;
      // }

      DateTime endDate =
          DateTime.parse(data2.toString().split(".")[0].toString());
      timeStartFormat =
          new DateFormat('yyyy-MM-dd kk-mm-ss').format(endDate).toString();
      Qakhir = timeStartFormat.toString();
      print("end : " + timeStartFormat.toString());

      setState(() {
        dataQuery =
            'SELECT * FROM EMPLOYEE WHERE time_stamp BETWEEN "$data1" AND "$data2"';
      });
      // } catch (e) {}

      // else
      // {
      //   data1 = "20200414T160000";
      //   print("no");
      // }
    }
  }

  loadlast() async {
    var getlast = await DBProvider.db
        .getLastData("SELECT * FROM EMPLOYEE ORDER BY time_stamp DESC LIMIT 1");
    if (getlast != null) {
      var dx = getlast.toList();
      //  var datax1 = jsonDecode(dx.toString());
      // // print(dx[0]['time_stamp']);
      // if(dx!=null){
      try {
        print("ok " + dx[0]['time_stamp'].toString());
        return dx[0]['time_stamp'].toString();
      } catch (e) {}
    }
  }

  //return [];
  //}
  // }

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    var apiProvider = EmployeeApiProvider();
    await apiProvider.getAllEmployees();

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      //changeQuery();

      isLoading = false;
    });
  }

  _deleteData() async {
    setState(() {
      isLoading = true;
    });

    await DBProvider.db.deleteAllEmployees();

    // wait for 1 second to simulate loading of data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });

    print('All employees deleted');
  }

  _buildEmployeeListView() {
    print("query data" + dataQuery.toString());
    return FutureBuilder(
      future: DBProvider.db.getAllEmployees(dataQuery),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("Loading data ...."),
              ),
            ],
          );
        } else {
          // print(snapshot.data[0].energy_enjoy.toString());
          List raw_data = new List();
          List phasaA = new List();
          List phasaB = new List();
          List phasaC = new List();

          print("panjang berapa ? " + snapshot.data.length.toString());

          for (int i = 0; i < snapshot.data.length; i++) {
            raw_data.add(snapshot.data[i].time_stamp.toString());
            phasaA.add(snapshot.data[i].energy_a.toString());
            phasaB.add(snapshot.data[i].energy_b.toString());
            phasaC.add(snapshot.data[i].energy_c.toString());
          }

          print("pasa : " + phasaA.length.toString());

          // List <int> datamax = phasaA.toList();

          // max_data = datamax.reduce((num1, num2) => num1 + num2);
          // DataStop = raw_data[0].toString().split("+")[0].toString();

          // try {
          //   // print('pertama : ' + raw_data[0].toString());
          // } catch (e) {}
          // try {
          //   //   print('terakhir : ' + raw_data[35].toString());
          // } catch (e) {
          //   if (snapshot.data.length > 1) {
          //     //  print('terakhir : ' +
          //     //    raw_data[snapshot.data.length - 1].toString());
          //   }
          // }

          // print("A" + phasaA.reduce((num1, num2) => num1 - num2));
          // print("B" + phasaB.reduce((num1, num2) => num1 - num2));
          // print("C" + phasaC.reduce((num1, num2) => num1 - num2));

          // print('Energy A : ' + snapshot.data.energy_c.toString());
          //  print('last Energy A : ' + phasaA.toString());

          // print('Energy A : ' + phasaA.toString());
          // print('Energy B : ' + phasaB.toString());
          // print('Energy C : ' + phasaC.toString());

          // print(object[0]);
          // var object1 = jsonEncode(phasaA);
          // var object2 = jsonEncode(phasaA);
          // var data_akhir = new List();
          // data_akhir.add(object);
          // data_akhir.add(object1);
          // data_akhir.add(object2);
          // print(object);
          //  data2 = phasaA;
          // panjang = data2.length;

          // var min_data = phasaA.reduce((num1, num2) => num1 - num2);
          var object = jsonDecode(phasaA.toString());
          var min_data = 10;
          var dx = object.reduce((curr, next) =>
              curr > next ? curr : next); //[0];//jsonDecode(phasaA).;
          // dx =  double.parse(phasaA.toList()[0]);
          // assert(dx is double);
          if (phasaA != null) {
            // max_data = dx[0].toString() as int;
            max_data = dx;

            // max_data = phasaA.toList().reduce((num1, num2) => num1 + num2);

          } else {
            max_data = 5628428;
          }

          // print(dx);
          //phasaA.reduce((num1, num2) => num1 + num2);

          return Container(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                color: Colors.black,
              ),

              //itemCount: snapshot.data.length, //31
              itemCount: titles.length,
              //itemCount: (present <= originalItems.length) ? items.length + 1 : items.length,
              itemBuilder: (BuildContext context, int index) {
                // int indexx = index + 1;
                // return (indexx == snapshot.data.length)
                // int indexx = 0;//index + 1;

                //  if (raw_data.length == 35) {
                //changeQuery1("data1", "data2");
                DateLimit = false;

                if (index == 0) {
                  data2 = phasaA;
                  // print("daat1");
                }
                if (index == 1) {
                  data2 = phasaB;
                  //  print("daat2");
                }

                if (index == 2) {
                  data2 = phasaC;
                  // print("daat3");
                }
                // } else {
                //   DateLimit = true;
                // }

                return (index == titles.length)
                    ? Container(
                        color: Colors.greenAccent,
                        child: FlatButton(
                          child: Text(
                            "Load More",
                            textScaleFactor: 1.0,
                            style: TextStyle(fontSize: 18.0),
                          ),
                          onPressed: () {},
                        ),
                      )
                    : Column(
                        children: <Widget>[
                          Center(
                            child: ListTile(
                              leading: Text(
                                "${titles[index]}",
                                textScaleFactor: 1.0,
                                style: TextStyle(fontSize: 18.0),
                              ),
                              // title: Text('grafik disini'
                              //     //"Data: ${snapshot.data[snapshot.data.length - indexx].energy_total} ${snapshot.data[snapshot.data.length - indexx].energy_a} "
                              //     ),
                              title: Container(
                                width: double.infinity,
                                height: data_tinggi.toDouble(),
                                // mainAxisSize: MainAxisSize.max,
                                // child: Column(
                                //   children: <Widget>[

                                child: Echarts(option: '''
              {
                animation:false,
                height:'$data_tinggi',
              
                grid: {
                        left: '0px',
                        right: '0px',
                        top:'0px'
                      },
               
                xAxis: {
                        type: 'category',

                       
                       
                        show: false,                         
                        },
                yAxis: {
                    type: 'value',
                    show: false,  
                    min:'$min_data',
                    max:'$max_data',
                   
                        },

                series: [{
                    
                    data: $data2,
                    type: 'bar',
                    itemStyle: {color: '$red'},
                    showBackground: true,
                    backgroundStyle: {
                        color: '#ffffff'
                    }
                    
                }]

              }
              
              '''),

                                //  ],

                                // ),,
                                // onTap: () {}, // Text(item,textAlign: TextAlign.left,style: TextStyle(fontSize: 15.0),
                              ),
                              // subtitle: Text(titles[index]
                              //     //'Time: ${snapshot.data[snapshot.data.length - indexx].time_stamp}'
                              //     ),
                            ),
                          ),
                        ],
                      );
              },
            ),
          );
        }
      },
    );
  }

  @override
  void initState() {
    // mulai program
    changeQuery1("data1", "data2");
    // Future.delayed(const Duration(seconds: 2));

    super.initState();
  }

  double x = 0.0;
  double y = 0.0;

  void _incrementDown(PointerEvent details) {
    // _updateLocation(details);
    setState(() {
      //startTimer();

      // startTimer();

      // AddManual++;
      // changeQuery1("data1", "data2");

      deltaTouch[0] = 0;
      deltaTouch[1] = 0;
      print("start");
      statusTouch1 = true;

      if (statusTouch1 == true && !statusTouch2) {
        dataTouch[0] = details.position.dx;
        // dataTouch[1] = details.position.dx;
        // if (dataTouch[0] > dataTouch[1]) {
        statusTouch2 = true;
        //}

        // if(dataTouch[0] == dataTouch[1])
        // {
        //   statusTouch2 = false;
        // }
      }

      if (statusTouch1 && statusTouch2) {
        dataTouch[1] = details.position.dx;

        if (dataTouch[0] > dataTouch[1]) {
          dataTouchInt[0] = dataTouch[1].toInt();
          dataTouchInt[1] = dataTouch[0].toInt();
        } else {
          dataTouchInt[0] = dataTouch[0].toInt();
          dataTouchInt[1] = dataTouch[1].toInt();
        }

        datat1l = dataTouchInt[0];
        result[0] = dataTouchInt[0].toDouble();
        datat2l = dataTouchInt[1];
        result[1] = dataTouchInt[1].toDouble();

        print("Touch 1 : " + dataTouchInt[0].toInt().toString());
        print("Touch 2 : " + dataTouchInt[1].toInt().toString());

        // if (dataTouch[0] == dataTouch[1]) {
        //   statusTouch2 = false;
        // }
        // selectMode = mode[0];

      }
    });
  }

  void _incrementUp(PointerEvent details) {
    //_updateLocation(details);
    setState(() {
      if (gKiri) {
        print("Kiri release");
        gKiri = false;
      }

      if (gKanan) {
        print("Kanan Release");
        gKanan = false;
      }

      dataTouch[0] = 0;
      dataTouch[1] = 0;
      deltaTouch[0] = 0;
      deltaTouch[1] = 0;
      dataTouchInt[0] = 0;
      dataTouchInt[1] = 0;
      datat1l = 0;
      datat2l = 0;
      result[0] = 0;
      result[1] = 0;
      statusTouch2 = false;
      statusTouch1 = false;
      selectMode = mode[0];
      dataC = 0;

      //isStopped = true;

      print("up : " + x.round().toString());
      print("timer stop");
    });
  }

  void _updateLocation(PointerEvent details) {
    setState(() {
      x = details.position.dx;
      if (statusTouch1 && statusTouch2) {
        var jarak1 = 0;
        var jarak2 = 0;
        jarak1 = (x - dataTouchInt[0]).abs().toInt();
        jarak2 = (x - dataTouchInt[1]).abs().toInt();

        // print("jarak 1 : " + jarak1.toString());
        // print("jarak 2 : " + jarak2.toString());

        if (jarak1 > jarak2 && dataTouchInt[0] < x) {
          result[1] = x;
          print("gerak kanan");
          gKanan = true;
        } else {
          if (jarak1 < jarak2) {
            result[0] = x;
            print("gerak kiri");
            gKiri = true;
          }
        }
        print("Xnow : " + x.toInt().toString());
        double datakalkulasi = (x / 8);
        double delayTime = (10 / datakalkulasi) * 1000;

        if (delayTime < 400) {
          delayTime = 400;
        }

        print("delayTime" + delayTime.round().toString());

        // print("result 1 : " + dataTouchInt[0].toInt().toString());
        // print("result 2 : " + result[1].toInt().toString());

        deltaTouch[0] = datat1l.toInt() - dataTouchInt[0].toInt();
        deltaTouch[1] = dataTouchInt[1].toInt() - datat2l.toInt();

        if ((result[0] < result[1])) {
          datat1l = result[0].toInt();
          datat2l = result[1].toInt();
        } else {
          datat2l = result[0].toInt();
          datat1l = result[1].toInt();
        }

        if (deltaTouch[0] != deltaTouch[1]) {
          selectMode = mode[2];
        }
        if (jarak1 == jarak2) {
          selectMode = mode[1];
        } else {
          dataC = 0;
        }

        // startTimer();
        print("duration : " + durationTimeGraph.toString());

        //nyalakan timer

        //  startTimer(delayTime.round());

        //nyalakan timer
      }

      if (selectMode == mode[1]) {
        dataC = x.round() - dataTouch[0].round();
      }
    });
  }

  Timer timer;
  void startTimer(int lama) {
    // ganti timer periodically
    isStopped = true;
    durationTimeGraph--;
    isStopped = false;

    // Start the periodic timer which prints something every 1 seconds
    timer = new Timer.periodic(new Duration(milliseconds: lama), (time) {
      if (isStopped) {
        timer.cancel();
      }

      print('counter detik');
      AddManual++;
      // changeQuery1("data1", "data2");
    });
  }
}
