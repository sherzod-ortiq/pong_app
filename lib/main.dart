import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pong app',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final ticker = Ticker((elapsed) => print('hello'));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pong app"),
      ),
      body: Stack(
        children: <Widget>[
          Ball(
            screenHeight: MediaQuery.of(context).size.height,
            screenWidth: MediaQuery.of(context).size.width,
            paddingBottom: MediaQuery.of(context).padding.bottom,
          ),
        ],
      ),
    );
  }
}

class Ball extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final double paddingBottom;

  Ball({
    @required this.screenWidth,
    @required this.screenHeight,
    @required this.paddingBottom,
  });

  @override
  _BallState createState() => _BallState();
}

class _BallState extends State<Ball> {
  double ballHeight = 50;
  double ballWidth = 50;
  double xAxis = 0;
  double yAxis = 0;
  double dX = 0;
  double dY = 0;

  void moveBall() {
    if (xAxis <= 0) dX = 4;
    if (xAxis >= widget.screenWidth - ballWidth) dX = -4;
    if (yAxis <= 0) dY = 4;
    if (yAxis >= widget.screenHeight - ballHeight - kToolbarHeight) dY = -4;

    setState(() {
      xAxis += dX;
      yAxis += dY;
    });
  }

  void initState() {
    super.initState();
    final ticker = Ticker((elapsed) => moveBall());
    ticker.start();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: xAxis,
      top: yAxis,
      child: Container(
        width: ballWidth,
        height: ballHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.red,
        ),
      ),
    );
  }
}
