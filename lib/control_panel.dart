import 'package:flutter/material.dart';
import 'direction.dart';
import 'control_button.dart';

//ControlPanel will hold 4 buttons Up, Right, Down, Left
//Each button requires an onPressed arg that triggers the ControlPanel's
//onTapped arg which will update direction variable in gamr.dart.
class ControlPanel extends StatelessWidget {
  final void Function(Direction direction) onTapped;
  const ControlPanel({Key? key, required this.onTapped}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 0.0,
        right: 0.0,
        bottom: 50.0,
        child: Row(children: [
          Expanded(
              child: Row(
            children: [
              Expanded(child: Container()),
              ControlButton(
                  onPressed: () {
                    onTapped(Direction.left);
                  },
                  icon: const Icon(Icons.arrow_left))
            ],
          )),
          Expanded(
            child: Column(
              children: [
                ControlButton(
                    onPressed: () {
                      onTapped(Direction.up);
                    },
                    icon: const Icon(Icons.arrow_drop_up)),
                const SizedBox(height: 70),
                ControlButton(
                    onPressed: () {
                      onTapped(Direction.down);
                    },
                    icon: const Icon(Icons.arrow_drop_down))
              ],
            ),
          ),
          Expanded(
              child: Row(
            children: [
              ControlButton(
                  onPressed: () {
                    onTapped(Direction.right);
                  },
                  icon: const Icon(Icons.arrow_right)),
              Expanded(child: Container()),
            ],
          ))
        ]));
  }
}
