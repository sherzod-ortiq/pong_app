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
        alignment: Alignment.topLeft,
        children: <Widget>[
          BotPaddle(
              //screenWidth: MediaQuery.of(context).size.width,
              ),
          PlayerPaddle(
            screenWidth: MediaQuery.of(context).size.width,
          ),
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
    if (yAxis >=
        widget.screenHeight -
            ballHeight -
            kToolbarHeight -
            widget.paddingBottom) dY = -4;

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

class BotPaddle extends StatefulWidget {
  @override
  _BotPaddleState createState() => _BotPaddleState();
}

class _BotPaddleState extends State<BotPaddle> {
  final double paddleHeight = 30;
  final double paddleWidth = 100;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: Draggable(
        child: Container(
          width: 100,
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.purple,
          ),
        ),
        feedback: Container(
          width: 100,
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.purple,
          ),
        ),
      ),
    );
  }
}

class PlayerPaddle extends StatefulWidget {
  final double screenWidth;

  PlayerPaddle({this.screenWidth});

  @override
  _PlayerPaddleState createState() => _PlayerPaddleState();
}

class _PlayerPaddleState extends State<PlayerPaddle> {
  double bottom = 0;
  double left = 0;
  final double paddleWidth = 100;
  final double paddleHeight = 20;

  @override
  void initState() {
    super.initState();
    left = widget.screenWidth / 2 - paddleWidth / 2;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom,
      left: left,
      height: paddleHeight,
      child: Draggable(
        axis: Axis.horizontal,
        child: Container(
          width: paddleWidth,
          height: paddleHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.purple,
          ),
        ),
        feedback: Container(
          width: paddleWidth,
          height: paddleHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.purple,
          ),
        ),
        childWhenDragging: Container(),
      ),
    );
  }
}
