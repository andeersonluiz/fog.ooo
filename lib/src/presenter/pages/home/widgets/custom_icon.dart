import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  final Function() onPressed;
  final IconData icon;
  final bool showCircle;
  const CustomIcon(
      {super.key,
      required this.onPressed,
      required this.icon,
      this.showCircle = true});

  @override
  Widget build(BuildContext context) {
    return showCircle
        ? ElevatedButton(
            child: Icon(
              icon,
              color: Colors.black,
            ),
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(20),
              backgroundColor: Colors.white, // <-- Button color
              foregroundColor: Colors.white, // <-- Splash color
            ))
        : GestureDetector(
            child: Icon(
              icon,
              color: Colors.black,
            ),
          );
  }
}
