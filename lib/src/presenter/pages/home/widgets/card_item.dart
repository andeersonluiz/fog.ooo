import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  final EdgeInsets padding;
  final Color? color;
  final Widget child;
  final double height;
  final Decoration? decoration;
  const CardItem(
      {super.key,
      this.padding = const EdgeInsets.all(8.0),
      this.color,
      this.decoration,
      this.height = 100,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        decoration: decoration ??
            BoxDecoration(
              borderRadius: BorderRadius.circular(11.0),
              border: Border.all(color: Colors.white, width: 2),
              color: color,
            ),
        height: height,
        width: 100,
        child: Center(child: child),
      ),
    );
  }
}
