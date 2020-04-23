import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:zoom_widget/zoom_widget.dart';

void main() => runApp(MyApp());

var x, y, zoom1;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  Timer _timer;
int _start = 100;

void startTimer() {
  const oneSec = const Duration(seconds: 1);
  _timer = new Timer.periodic(
    oneSec,
    (Timer timer) => setState(
      () {
        if (_start < 1) {
          timer.cancel();
        } else {
          _start = _start - 1;
          print("timer : " + _start.toString());
        }
      },
    ),
  );
}

  @override
  Widget build(BuildContext context) {

    startTimer();
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    var detectorKey;
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: GestureDetector(

          onTap: (){
            print("object");

          },


          onScaleStart: (details) {
            // final Offset localOffset = box.getDistanceToBaseline(details.localFocalPoint.dx.toDouble().to)

            print("Start : " + details.localFocalPoint.dx.toInt().toString());

            // print(details.localFocalPoint.distanceSquared);
            // print(details.focalPoint.distance.toInt());
          },
          onTapDown: (details) {
            // print("ini : " + details.globalPosition.toString());
            final RenderBox box = context.findRenderObject();
            final Offset localOffset =
                box.globalToLocal(details.globalPosition);
            setState(() {
               print("ini : " + localOffset.dx.toString());
            });
          },
          child: new Container(
            child: Center(
              child: Text(
                "Touchpad",
                textScaleFactor: 1.0,
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
            height: 100,
            width: double.infinity,
            color: Colors.grey,
          ),
        ),
      ),

//       Zoom(
//     width: 1800,
//     height: 1800,
//     canvasColor: Colors.grey,
//     backgroundColor: Colors.grey,
//     colorScrollBars: Colors.purple,
//     opacityScrollBars: 0,
//     scrollWeight: 10.0,
//     centerOnScale: true,
//     //enableScroll: true,
//     //doubleTapZoom: true,
//     zoomSensibility: 2.3,
//     initZoom: 0.2,
//     onPositionUpdate: (position){
//         setState(() {

//             x=PointerData().physicalX.toInt();
//             y=position.dy;
//         });
//     },
//     onScaleUpdate: (scale,zoom){
//         setState(() {
//             zoom1=zoom;
//         });
//     },
//     child: Center(
//         child: Text("data x : " + x.toString() + "zoom : " + zoom1.toString(),style: TextStyle(fontSize: 70),),
//         //child: Text("x:${x.toStringAsFixed(2)} y:${y.toStringAsFixed(2)} zoom:${_zoom.toStringAsFixed(2)}",style: TextStyle(color: Colors.deepPurple,fontSize: 50),),
//     ),
// ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
