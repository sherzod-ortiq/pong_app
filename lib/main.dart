import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => BallProperties(0, 0, 0, 0),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text("Pong app"),
        ),
        body: Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
            BotPaddle(),
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
      ),
    );
  }
}

class BallProperties extends ChangeNotifier {
  double xAxis;
  double yAxis;
  double dX;
  double dY;

  BallProperties(this.xAxis, this.yAxis, this.dX, this.dY);

  void updateProperties(xAxis, yAxis, dX, dY) {
    this.xAxis = xAxis;
    this.yAxis = yAxis;
    this.dX = dX;
    this.dY = dY;
    notifyListeners();
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
  double xAxis = 0;
  double yAxis = 0;
  double ballHeight = 50;
  double ballWidth = 50;
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
    Provider.of<BallProperties>(context, listen: false)
        .updateProperties(xAxis, yAxis, dX, dY);
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

class BotPaddle extends StatelessWidget {
  final double paddleHeight = 30;
  final double paddleWidth = 100;
  @override
  Widget build(BuildContext context) {
    final ballProperties = Provider.of<BallProperties>(context, listen: true);
    return Positioned(
      top: 0,
      left: ballProperties.xAxis / 2,
      child: Draggable(
        axis: Axis.horizontal,
        child: Container(
          width: 100,
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.purple,
          ),
        ),
        feedback: Container(),
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
