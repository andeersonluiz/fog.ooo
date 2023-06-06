import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final String msg;
  const CustomErrorWidget({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/bg_bota.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      msg,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 35, color: Colors.white),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.all(8.0),
                      constraints: BoxConstraints(maxHeight: 500),
                      child: Image.asset("assets/biriba_triste.jpeg")),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Biriba está triste",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
