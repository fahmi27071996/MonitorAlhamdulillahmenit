import 'dart:async';
import 'dart:convert';
import 'dart:ffi';



import 'package:zoom_get_coordinate/src/providers/db_provider.dart';
import 'package:zoom_get_coordinate/src/providers/employee_api_provider.dart';
import 'package:flutter/material.dart';
import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:zoom_get_coordinate/src/pages/getDate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:zoom_get_coordinate/sizeConfig.dart';
// import 'package:zoom_widget/zoom_widget.dart';

String DataStop = "20200428T110000";
String DataStop1 = ""; //20200414T160000
var GeserStatus = false;
var DateLimit = false;

String dataQuery = "";
//  'SELECT * FROM EMPLOYEE WHERE time_stamp BETWEEN "20200414T164647" AND "20200414T180459"';

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
int AddManualLeft = 0;

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

int durationTimeGraph = 1000;


// untuk timer

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
    SizeConfig().init(context);
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
                await _loadFromApi();
              },
            ),
          ),

          Padding(padding: EdgeInsets.all(6)),
        ],
      ),
      body:isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                 Row(
                  //  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                            height: SizeConfig.blockSizeVertical*5,
                            width: SizeConfig.blockSizeHorizontal*45,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Harvest',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  '40%',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )),
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.only(left: 10, right: 10),
                             height: SizeConfig.blockSizeVertical*5,
                            width: SizeConfig.blockSizeHorizontal*45,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Store',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  '-10%',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.only(left: 10, right: 10,top: 5),
                            height: SizeConfig.blockSizeVertical*5,
                            width: SizeConfig.blockSizeHorizontal*45,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'PLN',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                '50%',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.fromLTRB(10, 35, 10, 10),
                      height: SizeConfig.blockSizeVertical*10,
                      width: SizeConfig.blockSizeHorizontal*45,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Enjoy',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            '100%',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      // ),
                    ),
                    ),
                  ],
                ),
                Expanded(
                    child: Center(
                  child: _buildEmployeeListView(),
                )),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 70,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(right: 25),
                        // color: Colors.grey[300],
                        child: GestureDetector(
                          child: Icon(Icons.add_box),
                          onTap: () {
                            setState(() {
                              // AddManual=0;
                              AddManualLeft++;

                              changeQuery1("data1", "data2");
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 70,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(right: 25),
                        // color: Colors.grey[300],
                        child: GestureDetector(
                          child: Icon(Icons.indeterminate_check_box),
                          onTap: () {
                            setState(() {
                              //  AddManual=0;
                              AddManualLeft--;
                              changeQuery1("data1", "data2");
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 70,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(right: 25),
                        // color: Colors.grey[300],
                        child: GestureDetector(
                          child: Icon(Icons.indeterminate_check_box),
                          onTap: () {
                            setState(() {
                              // AddManualLeft = 0;
                              AddManual--;
                              changeQuery1("data1", "data2");
                              // AddManual = 0;
                            });
                          },
                        ),
                      ),
                      Container(
                          width: 70,
                          padding: const EdgeInsets.all(10),
                          // margin: const EdgeInsets.only(right: 25),
                          // color: Colors.grey[300],
                          child: GestureDetector(
                            child: Icon(Icons.add_box),
                            onTap: () {
                              setState(() {
                                //AddManualLeft = 0;
                                AddManual++;
                                changeQuery1("data1", "data2");
                                // AddManual = 0;
                              });
                            },
                          )),
                    ],
                  ),
                ),
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
                Center(
              
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(15),
                      child:IconButton(
                        icon: Icon(Icons.keyboard_arrow_left), 
                        highlightColor: Colors.grey,
                        onPressed: (){}),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Column(children: <Widget>[
                        IconButton(
                        icon: Icon(Icons.keyboard_arrow_up), 
                        highlightColor: Colors.grey,
                        onPressed: (){}),
                         Text('1',style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 20,),),textScaleFactor: 1,),
                         IconButton(
                        icon: Icon(Icons.keyboard_arrow_down), 
                        highlightColor: Colors.grey,
                        onPressed: (){}),
                        ],), 
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Column(children: <Widget>[
                        IconButton(
                        icon: Icon(Icons.keyboard_arrow_up), 
                        highlightColor: Colors.grey,
                        onPressed: (){}),
                         Text('Days',style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 20,),),textScaleFactor: 1,),
                         IconButton(
                        icon: Icon(Icons.keyboard_arrow_down), 
                        highlightColor: Colors.grey,
                        onPressed: (){}),
                        ],), 
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                      child:IconButton(
                        icon: Icon(Icons.keyboard_arrow_right), 
                        highlightColor: Colors.grey,
                        onPressed: (){}),
                      ),
                  ],
                  ),
                  
                  
                ],
              ),
            ),
              ],
            ),

      //       bottomNavigationBar: BottomNavigationBar(
      //    currentIndex: 0, // this will be set when a new tab is tapped
      //    items: [
      //      BottomNavigationBarItem(
      //        icon: new Icon(Icons.home),
      //        title: new Text('Home'),
      //      ),
      //      BottomNavigationBarItem(
      //        icon: new Icon(Icons.mail),
      //        title: new Text('Messages'),
      //      ),
      //      BottomNavigationBarItem(
      //        icon: Icon(Icons.person),
      //        title: Text('Profile')
      //      )
      //    ],
      //  ),
    );
  }

  changeQuery() {
    setState(() {
      // sleep(const Duration(milliseconds: 10));
      dataQuery =
          'SELECT * FROM EMPLOYEE WHERE time_stamp BETWEEN "20200414T155754" AND "20200414T171455"';
    });
  }

  changeQuery1(String data1, String data2) {
    //var today = new DateTime.now();
//20200414T160000
    DateTime tempDate;
    // if(!DateLimit){
    tempDate = DateTime.parse(DataStop.split('+')[0].toString()); //}

    // else{
    //      tempDate = DateTime.parse("20200414T160000");
    // }
    //if(a < 0 )a=0;
    // untuk menit //

    // var fiftyDaysFromNow = tempDate.add(new Duration(minutes: -a));
    // var format =
    //     DateFormat('yyyyMMddTkkmmss').format(fiftyDaysFromNow).toString();

    // //DateTime tempDate1 = DateTime.parse(fiftyDaysFromNow);

    // var fiftyDaysFromNow1 = fiftyDaysFromNow.add(new Duration(minutes: 35));
    // var format1 =
    //     DateFormat('yyyyMMddTkkmmss').format(fiftyDaysFromNow1).toString();

    // untuk menit //

    // untuk jam //

    var fiftyDaysFromNow =
        tempDate.add(new Duration(hours: -a - AddManualLeft));
    var format =
        DateFormat('yyyyMMddTkkmmss').format(fiftyDaysFromNow).toString();

    //DateTime tempDate1 = DateTime.parse(fiftyDaysFromNow);

    var plus;

    var fiftyDaysFromNow1 = fiftyDaysFromNow
        .add(new Duration(hours: (35 + AddManual + AddManualLeft)));
    var format1 =
        DateFormat('yyyyMMddTkkmmss').format(fiftyDaysFromNow1).toString();

    // untuk jam //

    data2 = format1.replaceAll("T24", "T00");

    data1 = format.replaceAll("T24", "T00");

    data1 = data1.replaceAll("14T15", "14T16");

    DateTime tempDateStart = DateTime.parse(data1);
    var DisplayFormatStart =
        DateFormat('yyyy-MM-dd kk-mm-ss').format(tempDateStart).toString();

    if (!DateLimit) {
      Qmulai = DisplayFormatStart;
    }

    DateTime tempDateFinish = DateTime.parse(data2);
    DisplayFormatStart =
        DateFormat('yyyy-MM-dd kk-mm-ss').format(tempDateFinish).toString();

    if (!DateLimit) {
      Qakhir = DisplayFormatStart;
    }

    // if(DateLimit)
    // {data1 = "20200414T160000";

    // }
    print("start " + data1.toString());
    print("stop " + data2.toString());

    DateTime data_limit = DateTime.parse("20200414T160000");

    // try {
    // if (tempDateStart.isAfter(data_limit)) {
    //   DataStop1 = data1.toString();
    //   print("yes");
    // } else if (tempDateStart.isBefore(data_limit)) {
    //   data1 = "20200414T160000";
    //   data2 = "20200416T040000";
    // }

    // else {
    //   DataStop1 = "20200414T160000";
    //   data1 = "20200414T160000";
    // }

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

  // _queryy (){
  //   var dataQ = DBProvider.db.getAllEmployees(dataQuery);
  //   dataQ.whenComplete();

  // }
//SELECT * FROM tablename ORDER BY column DESC LIMIT 1;
//SELECT * FROM SAMPLE_TABLE ORDER BY ROWID ASC LIMIT 1
  // Future<List> getCustomers() async {
  //   var result = await DBProvider.db.getAllEmployees(
  //       'SELECT * FROM EMPLOYEE WHERE time_stamp BETWEEN "20200414T155754" AND "20200416T171455"');
  //   //'SELECT * FROM EMPLOYEE ORDER BY time_stamp');

  //   //print(result.toList()[0].toString());
  //   return result.toList();
  // }

  // Future<List> getCustomers1() async {
  //   var result = await DBProvider.db.getAllEmployees(
  //       'SELECT * FROM EMPLOYEE WHERE time_stamp LIKE "20200414T160000+0700"');

  //   // var res =await  db.query("Client", where: "id = ?", whereArgs: [id]);
  //   //'SELECT * FROM EMPLOYEE ORDER BY time_stamp');

  //   print(result);
  //   return result.toList();
  // }

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
    return FutureBuilder(
      future: DBProvider.db.getAllEmployees(dataQuery),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          // print(snapshot.data[0].energy_enjoy.toString());
          List raw_data = new List();
          List phasaA = new List();
          List phasaB = new List();
          List phasaC = new List();

          for (int i = 0; i < snapshot.data.length; i++) {
            raw_data.add(snapshot.data[i].time_stamp.toString());
            phasaA.add(snapshot.data[i].energy_a.toString());
            phasaB.add(snapshot.data[i].energy_b.toString());
            phasaC.add(snapshot.data[i].energy_c.toString());
          }
          // DataStop = raw_data[0].toString().split("+")[0].toString();

          try {
            print('pertama : ' + raw_data[0].toString());
            // DataStop = raw_data[0].toString().split("+")[0].toString();
          } catch (e) {}
          try {
            print('terakhir : ' + raw_data[35].toString());
            // DataStop1 = raw_data[35].toString();
          } catch (e) {
            if (snapshot.data.length > 1) {
              print('terakhir : ' +
                  raw_data[snapshot.data.length - 1].toString());
              //  DataStop1 = raw_data[snapshot.data.length - 1].toString();
              // Qakhir = raw_data[snapshot.data.length - 1].toString();
            }
          }

          // print("A" + phasaA.reduce((num1, num2) => num1 - num2));
          // print("B" + phasaB.reduce((num1, num2) => num1 - num2));
          // print("C" + phasaC.reduce((num1, num2) => num1 - num2));

          // print('Energy A : ' + snapshot.data.energy_c.toString());
          //  print('last Energy A : ' + phasaA.toString());

          // print('Energy A : ' + phasaA.toString());
          // print('Energy B : ' + phasaB.toString());
          // print('Energy C : ' + phasaC.toString());

          // var object = jsonEncode(phasaA);
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
          var min_data = 10;
         
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
                      mainAxisAlignment: MainAxisAlignment.end,
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
                    max:24848600,
                   
                        },

                series: [{
                    animation: true,
                    animationDuration: 1000,
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
   // startTimer();

    super.initState();
  }

  double x = 0.0;
  double y = 0.0;

  void _incrementDown(PointerEvent details) {
    // _updateLocation(details);
    setState(() {

      //startTimer();
      isStopped = true;
      durationTimeGraph-=100;
      isStopped = false;
      startTimer();

      print("duration : " + durationTimeGraph.toString());
     

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
        print("result 1 : " + dataTouchInt[0].toInt().toString());
        print("result 2 : " + result[1].toInt().toString());

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

        //nyalakan timer

        //  startTimer();



        //nyalakan timer
      }

      if (selectMode == mode[1]) {
        dataC = x.round() - dataTouch[0].round();
      }
    });
  }

  Timer timer;
  void startTimer() {
    // Start the periodic timer which prints something every 1 seconds
    timer = new Timer.periodic(new Duration(milliseconds: durationTimeGraph), (time) {

      if (isStopped) {
      timer.cancel();
    }

      print('counter detik');
      AddManual++;
      changeQuery1("data1", "data2");

    });
  }
}
