import 'package:flutter/material.dart';
import 'piece.dart';
import 'dart:math';
import 'dart:developer';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int? upperBoundX, upperBoundY, lowerBoundX, lowerBoundY;
  double? screenWidth, screenHeight;
  int step = 20;
  List<Offset> positions = [];

  //Helper fn to round number down to nearest ten. Ex. screenWidth of 408 => 400
  int getNearestTens(int num) {
    int output;
    output = (num ~/ step) * step;
    if (output == 0) {
      output += step;
    }
    return output;
  }

  Offset getRandomPosition() {
    Offset position;
    int posX = Random().nextInt(upperBoundX!) + lowerBoundX!;
    int posY = Random().nextInt(upperBoundY!) + lowerBoundY!;

    position = Offset(
        getNearestTens(posX).toDouble(), getNearestTens(posY).toDouble());
    return position;
  }

  void draw() {
    if (positions.isEmpty) {
      positions.add(getRandomPosition());
    }
  }

  List<Piece> getPieces() {
    final pieces = <Piece>[];
    draw();

    pieces.add(Piece(
      posX: positions[0].dx.toInt(),
      posY: positions[0].dy.toInt(),
      size: step,
      color: Colors.red,
    ));
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
              children: [
                Stack(children: getPieces()),
              ],
            )));
  }
}
