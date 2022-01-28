import 'dart:async';
import 'package:flutter/material.dart';
import 'piece.dart';
import 'dart:math';
import 'direction.dart';
import 'control_panel.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int? upperBoundX, upperBoundY, lowerBoundX, lowerBoundY;
  double? screenWidth, screenHeight;
  //size of each snake piece
  int step = 30;
  //defualt length for snake
  int length = 5;
  //list of snake piece postions
  List<Offset> positions = [];
  //default starting direction
  Direction direction = Direction.right;
  Timer? timer;

  void changeSpeed() {
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
    timer = Timer.periodic(const Duration(milliseconds: 400), (timer) {
      setState(() {});
    });
  }

  Widget getControls() {
    return ControlPanel(
      onTapped: (Direction newDirection) {
        direction = newDirection;
      },
    );
  }

  void restart() {
    changeSpeed();
  }

  @override
  initState() {
    super.initState();
    restart();
  }

  //Helper fn to round number down to nearest ten. Ex. screenWidth of 408 => 400
  int getNearestTens(int num) {
    int output;
    output = (num ~/ step) * step;
    if (output == 0) {
      output += step;
    }
    return output;
  }

  //Offset takes 2 parameters, X and Y axis.
  Offset getRandomPosition() {
    Offset position;
    int posX = Random().nextInt(upperBoundX!) + lowerBoundX!;
    int posY = Random().nextInt(upperBoundY!) + lowerBoundY!;

    position = Offset(
        getNearestTens(posX).toDouble(), getNearestTens(posY).toDouble());
    return position;
  }

  void draw() {
    //if no pieces of snake then create random piece and add to positions
    if (positions.isEmpty) {
      positions.add(getRandomPosition());
    }
    //while the snake != the default length, duplicate position until full
    while (length > positions.length) {
      positions.add(positions[positions.length - 1]);
    }
    //move each snake piece forward
    for (var i = positions.length - 1; i > 0; i--) {
      positions[i] = positions[i - 1];
    }
    //move head of snake forward by getting next position from input.
    positions[0] = getNextPosition(positions[0]);
  }

  Offset getNextPosition(Offset position) {
    Offset nextPosition;

    switch (direction) {
      case Direction.right:
        {
          nextPosition = Offset(position.dx + step, position.dy);
        }
        break;
      case Direction.left:
        {
          nextPosition = Offset(position.dx - step, position.dy);
        }
        break;
      case Direction.up:
        {
          nextPosition = Offset(position.dx, position.dy - step);
        }
        break;
      case Direction.down:
        {
          nextPosition = Offset(position.dx, position.dy + step);
        }
    }
    return nextPosition;
  }

  //Positions is an Offset type, dx and dy are built in fns that returns doubles. converting to int to use as Piece's posX and posY
  List<Piece> getPieces() {
    final pieces = <Piece>[];
    draw();

    for (var i = 0; i < length; ++i) {
      pieces.add(Piece(
        posX: positions[i].dx.toInt(),
        posY: positions[i].dy.toInt(),
        size: step,
        color: Colors.red,
      ));
    }

    return pieces;
  }

  @override
  Widget build(BuildContext context) {
    //grabs height and width from wherever app is running.
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    //setting upper and lower bounds of 20pixels.
    lowerBoundY = step;
    lowerBoundX = step;

    //By adding (!) Operator just after the expression, you tell Dart that the value won’t be null, and that it’s safe to assign it to a non-nullable variable.
    upperBoundY = getNearestTens(screenHeight!.toInt() - step);
    upperBoundX = getNearestTens(screenWidth!.toInt() - step);

    return Scaffold(
        body: Container(
            color: Colors.amber,
            child: Stack(
              children: [Stack(children: getPieces()), getControls()],
            )));
  }
}
