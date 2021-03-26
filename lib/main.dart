import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SharedProps(),
        ),
        ChangeNotifierProvider(
          create: (context) => PlPaddleProps(),
        ),
      ],
      child: MaterialApp(
        title: 'Pong app',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final ticker = Ticker((elapsed) => print('hello'));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<SharedProps>(
          builder: (context, sharedProps, child) {
            return Text(
              "Scores Player: ${sharedProps.pSc} Bot: ${sharedProps.bSc}",
            );
          },
        ),
      ),
      body: Stack(
        alignment: Alignment.topLeft,
        children: <Widget>[
          BotPaddle(
            paddleWidth: 100,
          ),
          PlayerPaddle(
            screenWidth: MediaQuery.of(context).size.width,
            paddleWidth: 100,
          ),
          Ball(
            sharedProps: Provider.of<SharedProps>(context, listen: false),
            plPaddleProps: Provider.of<PlPaddleProps>(context, listen: false),
            screenHeight: MediaQuery.of(context).size.height,
            screenWidth: MediaQuery.of(context).size.width,
            paddingBottom: MediaQuery.of(context).padding.bottom,
            paddleWidth: 100,
          ),
        ],
      ),
    );
  }
}

class SharedProps extends ChangeNotifier {
  double botPaddleXAxis = 0;
  final reduceSpeedBy = 2;
  int botScore = 0;
  int playerScore = 0;

  double get botPaddleX {
    return botPaddleXAxis;
  }

  int get bSc {
    return botScore;
  }

  int get pSc {
    return playerScore;
  }

  void updateProperties(dX) {
    this.botPaddleXAxis += dX / reduceSpeedBy;
    notifyListeners();
  }

  void botUp() {
    botScore += 1;
  }

  void playerUp() {
    playerScore += 1;
  }
}

class PlPaddleProps extends ChangeNotifier {
  double xAxis = 0;

  double get plPaddleX {
    return xAxis;
  }

  void updateProperties(xAxis) {
    this.xAxis = xAxis;
    notifyListeners();
  }
}

class Ball extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final double paddingBottom;
  final double paddleWidth;
  final sharedProps;
  final plPaddleProps;

  Ball({
    @required this.screenWidth,
    @required this.screenHeight,
    @required this.paddingBottom,
    @required this.paddleWidth,
    @required this.sharedProps,
    @required this.plPaddleProps,
  });

  @override
  _BallState createState() => _BallState();
}

class _BallState extends State<Ball> {
  double xAxis = 0;
  double yAxis = 0;
  double ballHeight = 30;
  double ballWidth = 30;
  double dX = 0;
  double dY = 0;

  void initState() {
    super.initState();
    final ticker = Ticker((elapsed) => moveBall());
    ticker.start();
  }

  void moveBall() {
    if (xAxis <= 0) dX = 4;
    if (xAxis >= widget.screenWidth - ballWidth) dX = -4;
    if (yAxis <= 0) {
      if (xAxis >= widget.sharedProps.botPaddleX &&
          xAxis <= widget.sharedProps.botPaddleX + widget.paddleWidth) {
        widget.sharedProps.botUp();
      }
      dY = 4;
    }
    if (yAxis >=
        widget.screenHeight -
            ballHeight -
            kToolbarHeight -
            widget.paddingBottom) {
      if (xAxis >= widget.plPaddleProps.plPaddleX &&
          xAxis <= widget.plPaddleProps.plPaddleX + widget.paddleWidth) {
        widget.sharedProps.playerUp();
      }
      dY = -4;
    }

    widget.sharedProps.updateProperties(dX);
    setState(() {
      xAxis += dX;
      yAxis += dY;
    });
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
  final double reduceSpeedBy = 2;
  final double paddleWidth;

  BotPaddle({this.paddleWidth});

  @override
  Widget build(BuildContext context) {
    final sharedProps = Provider.of<SharedProps>(context, listen: true);
    return Positioned(
      top: 0,
      left: sharedProps.botPaddleXAxis,
      child: Draggable(
        axis: Axis.horizontal,
        child: Container(
          width: 100,
          height: 12,
          decoration: BoxDecoration(
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
  final double paddleWidth;

  PlayerPaddle({this.screenWidth, this.paddleWidth});

  @override
  _PlayerPaddleState createState() => _PlayerPaddleState();
}

class _PlayerPaddleState extends State<PlayerPaddle> {
  double bottom = 0;
  double left = 0;
  final double paddleWidth = 100;
  final double paddleHeight = 12;

  void onDrag(dX) {
    setState(() {
      left += dX;
    });
    Provider.of<PlPaddleProps>(context, listen: false).updateProperties(left);
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
        onDragUpdate: (updateDetails) {
          onDrag(updateDetails.delta.dx);
        },
      ),
    );
  }
}
