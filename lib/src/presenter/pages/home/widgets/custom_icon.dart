import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class CustomIcon extends StatelessWidget {
  final Function() onPressed;
  final IconData? icon;
  final bool showCircle;
  final double padding;
  final Color iconColor;
  final String? logo;
  final double sizeLogo;
  const CustomIcon(
      {super.key,
      required this.onPressed,
      this.icon,
      this.iconColor = Colors.black,
      this.padding = 20,
      this.logo,
      this.sizeLogo = 35,
      this.showCircle = true});

  @override
  Widget build(BuildContext context) {
    return showCircle
        ? Container(
            margin: EdgeInsets.only(bottom: 6),
            child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: logo == null
                      ? EdgeInsets.only(
                          top: padding,
                          left: padding,
                          right: padding,
                          bottom: padding + 1)
                      : EdgeInsets.all(padding),

                  backgroundColor: Colors.white, // <-- Button color
                  foregroundColor: Colors.white, // <-- Splash color
                ),
                child: logo != null
                    ? Logo(
                        logo,
                        size: sizeLogo,
                      )
                    : Icon(
                        icon,
                        color: iconColor,
                      )),
          )
        : GestureDetector(
            child: logo != null
                ? Logo(
                    logo,
                    size: sizeLogo,
                  )
                : Icon(
                    icon,
                    color: iconColor,
                  ),
          );
  }
}
