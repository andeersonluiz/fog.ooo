import 'package:auto_size_text/auto_size_text.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fogooo/src/core/utils/attribution.dart';
import 'package:fogooo/src/core/utils/constants.dart';
import 'package:fogooo/src/core/utils/utils.dart';
import 'package:fogooo/src/domain/entities/player_entity.dart';
import 'package:icons_plus/icons_plus.dart';

class WinGamePopUp extends StatelessWidget {
  final Player sortedPlayer;
  final List<Player> guessList;
  final String timeReset;
  final int orderNumber;
  const WinGamePopUp(
      {super.key,
      required this.sortedPlayer,
      required this.guessList,
      required this.timeReset,
      required this.orderNumber});

  @override
  Widget build(BuildContext context) {
    final String path = "assets/gifs/${Utils.generateGif()}.gif";
    final ConfettiController controllerCenter =
        ConfettiController(duration: const Duration(seconds: 4));
    controllerCenter.play();
    return AlertDialog(
        backgroundColor: Colors.black,
        contentPadding: EdgeInsets.zero,
        content: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                border: Border.all(color: Colors.white, width: 2)),
            width: 400,
            height: 750,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 12.0),
                  child: Text(
                    "VOCÊ ACERTOU!!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      width: 200, height: 300, child: Image.asset(path)),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Arvo'),
                        text: Attribution.generateNameAttribution(path)
                            .split("@")[0]),
                    TextSpan(
                      style: const TextStyle(
                          color: Colors.blue, fontSize: 15, fontFamily: 'Arvo'),
                      text:
                          "@${Attribution.generateNameAttribution(path).split("@")[1]}",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          Utils.launchMyUrl(
                              Attribution.generateUrlAttribution(path));
                        },
                    )
                  ])),
                ),
                const Divider(
                  color: Colors.white,
                ),
                ConfettiWidget(
                  confettiController: controllerCenter,
                  maxBlastForce: 50,
                  emissionFrequency: 0.05,
                  blastDirectionality: BlastDirectionality
                      .explosive, // don't specify a direction, blast randomly
                  shouldLoop:
                      false, // start again as soon as the animation is finished
                  colors: const [
                    Colors.black,
                    Colors.white,
                  ], // manually specify the colors to be used

                  minimumSize: const Size(50, 50),
                  maximumSize: const Size(50, 50),
                  createParticlePath:
                      Utils.drawStar, // define a custom shape/path.
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    "Numero de tentativas: ${guessList.length}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                const Divider(
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "Próximo jogador em: ",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, bottom: 8.0),
                        child: Text(
                          timeReset,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        String result =
                            Utils.generateEmojiText(sortedPlayer, guessList);
                        Utils.launchMyUrl(
                            "http://twitter.com/share?text=Ganhei no %23fogooo %23$orderNumber em ${guessList.length} tentativas.%0a%0a${result}Jogue %23fogooo em: ${Constants.myUrl}%0a%0a%23Botafogo %23fogooo %23wordle %23VamosBOTAFOGO %23BFR");
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          side: const BorderSide(
                              color: Colors.lightBlue, width: 2)),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(FontAwesome.twitter, color: Colors.white),
                            Spacer(),
                            AutoSizeText(
                              "Compartilhar",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            Spacer(),
                          ],
                        ),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0)),
                            side:
                                const BorderSide(color: Colors.grey, width: 2)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Fechar",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
