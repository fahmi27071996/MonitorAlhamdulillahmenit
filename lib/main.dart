// listener
// Flutter code sample for Listener

// This example makes a [Container] react to being touched, showing a count of
// the number of pointer downs and ups.

import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:zoom_get_coordinate/View/charts.dart';
import 'package:zoom_get_coordinate/src/pages/home_page.dart';
// import 'View/charts.dart';

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

int data_tinggi = 100, min_data = 10;
var data3 = [10, 20, 30, 40, 50, 60];
var red = "#db0202";

void main() => runApp(MyApp1());

class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'OpenSans'),
      initialRoute: 'home',
      routes: {
        'home': (BuildContext context) => HomePage(),
      },
    );
  }
}

/// This Widget is the main application widget.
class MyApp extends StatelessWidget {
  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: Center(
          child: MyStatefulWidget(),
        ),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  // int _downCounter = 0;
  // int _upCounter = 0;
  double x = 0.0;
  double y = 0.0;

  void _incrementDown(PointerEvent details) {
    // _updateLocation(details);
    setState(() {
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

      print("up : " + x.round().toString());
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
      }

      if (selectMode == mode[1]) {
        dataC = x.round() - dataTouch[0].round();
      }
    });
  }

  void enter(PointerEvent details) {
    setState(() {
      // print("detailxx : " + details.position.dx.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          // Container(
          //   height: 100,
          //   width: double.infinity,
          drawrEcharts(10),
          // Container(
          //   width: double.infinity,
          //   height: data_tinggi.toDouble(),
          //                       // mainAxisSize: MainAxisSize.max,
          //                       // child: Column(
          //                       //   children: <Widget>[

          //     child: Echarts(option: '''
          //     {
          //       animation:false,
          //       height:'$data_tinggi',

          //       grid: {
          //               left: '0px',
          //               right: '0px',
          //               top:'0px'
          //             },

          //       xAxis: {
          //               type: 'category',

          //               show: false,
          //               },
          //       yAxis: {
          //           type: 'value',
          //           show: false,
          //           min:'$min_data',

          //               },

          //       series: [{

          //           data: [10,20,30,40,50],
          //           type: 'bar',
          //           itemStyle: {color: '$red'},
          //           showBackground: true,
          //           backgroundStyle: {
          //               color: '#ffffff'
          //           }

          //       }]

          //     }

          //     '''),

          //                       //  ],

          //                       // ),,
          //                       // onTap: () {}, // Text(item,textAlign: TextAlign.left,style: TextStyle(fontSize: 15.0),
          //                     ),
          //),

          Text("Mode : $selectMode\n\n"),
          Text("As : " +
              dataTouchInt[0].toString() +
              "   Bs : " +
              dataTouchInt[1].toString()),

          Text("\nCs : " + dataTouch[0].round().toString()),
          Text("\ndC : " + dataC.toString()),

          Text(
              "\nAn : " + datat1l.toString() + "   Bn : " + datat2l.toString()),

          Text("\n\ndA : " +
              deltaTouch[0].toString() +
              "  dB : " +
              deltaTouch[1].toString() +
              "\n"),
          // Text("Distance : " + distance.toString()),
          // Text(),

          ConstrainedBox(
            constraints: BoxConstraints.tight(Size(double.infinity, 100.0)),
            child: Listener(
              onPointerDown: _incrementDown,
              onPointerMove: _updateLocation,
              onPointerUp: _incrementUp,
              // onPointerEnter: enter,
              child: Container(
                color: Colors.lightBlueAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
