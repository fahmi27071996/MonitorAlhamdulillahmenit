// listener
// Flutter code sample for Listener

// This example makes a [Container] react to being touched, showing a count of
// the number of pointer downs and ups.

import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';

var touch1 = 0, touch2 = 0;
var dataTouch = [0.0, 0.0];
var statusTouch1 = false, statusTouch2 = false;
var result = [0.0, 0.0];
int data1, data2;
// int distance = 0;
List<int> dataTouchInt = [0, 0];

List<int> deltaTouch = [0, 0];

void main() => runApp(MyApp());

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
  int _downCounter = 0;
  int _upCounter = 0;
  double x = 0.0;
  double y = 0.0;

  void _incrementDown(PointerEvent details) {
    _updateLocation(details);
    setState(() {
      _downCounter++;
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

      if (statusTouch2 && statusTouch2) {
        dataTouch[1] = details.position.dx;

        if (dataTouch[0] > dataTouch[1]) {
          dataTouchInt[0] = dataTouch[1].toInt();
          dataTouchInt[1] = dataTouch[0].toInt();
        } else {
          dataTouchInt[0] = dataTouch[0].toInt();
          dataTouchInt[1] = dataTouch[1].toInt();
        }

        // if (dataTouch[0] == dataTouch[1]) {
        //   statusTouch2 = false;
        // }
      }
    });
  }

  void _incrementUp(PointerEvent details) {
    _updateLocation(details);
    setState(() {
      statusTouch2 = false;
      statusTouch1 = false;
      _upCounter++;
      print("up");
    });
  }

  void _updateLocation(PointerEvent details) {
    setState(() {
      x = details.position.dx;
      // y = details.position.dy;
      // int data = x.toInt();
      // print("x : " + data.toString());
      if (statusTouch1 && statusTouch2) {
        var jarak1 = 0;
        var jarak2 = 0;
        jarak1 = (x - dataTouch[0]).abs().toInt();
        jarak2 = (x - dataTouch[1]).abs().toInt();

        if (jarak1 > jarak2) {
          result[1] = x;
        }
        if (jarak1 < jarak2) {
          result[0] = x;
        }

      //  print("Touch 1 : " + result[0].toInt().toString());
       // print("Touch 2 : " + result[1].toInt().toString());
        data1 = result[0].toInt();
        data2 = result[1].toInt();

        deltaTouch[0] = dataTouch[0].toInt() - data1;
        deltaTouch[1] = dataTouch[1].toInt() - data2;

        // distance = (data1 - data2).abs();
        // }
      }
    });
  }

  void enter(PointerEvent details) {
    setState(() {
      print("detailxx : " + details.position.dx.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text("As : " +
              dataTouchInt[0].toString() +
              "   Bs : " +
              dataTouchInt[1].toString()),
          Text("An : " + data1.toString() + "   Bn : " + data2.toString()),

          Text("dA : " + deltaTouch[0].toString()),
          Text("dB : " + deltaTouch[1].toString()),
          // Text("Distance : " + distance.toString()),
          // Text(),

          ConstrainedBox(
            constraints: BoxConstraints.tight(Size(300.0, 200.0)),
            child: Listener(
              onPointerDown: _incrementDown,
              onPointerMove: _updateLocation,
              onPointerUp: _incrementUp,
              // onPointerEnter: enter,
              child: Container(
                color: Colors.lightBlueAccent,
                // child: Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: <Widget>[
                //     Text(
                //         'You have pressed or released in this area this many times:'),
                //     Text(
                //       '$_downCounter presses\n$_upCounter releases',
                //       style: Theme.of(context).textTheme.display1,
                //     ),
                //     Text(
                //       'The cursor is here: (${x.toStringAsFixed(2)}, ${y.toStringAsFixed(2)})',
                //     ),
                //   ],
                // ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
