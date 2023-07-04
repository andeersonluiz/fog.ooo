import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fogooo/src/core/utils/constants.dart';
import 'package:fogooo/src/core/utils/utils.dart';
import 'package:fogooo/src/domain/entities/victory_info_entity.dart';
import 'package:fogooo/src/presenter/state_management/bloc/user/user_bloc.dart';
import 'package:fogooo/src/presenter/state_management/bloc/user/user_state.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StaticsPopUp extends StatelessWidget {
  const StaticsPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        backgroundColor: Colors.black,
        content: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
          if (state is FilledUserHistory) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.0),
                  border: Border.all(color: Colors.white)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
                      child: Text(
                        "ESTATÍSTICAS",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 35),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Divider(
                        color: Colors.white24,
                      ),
                    ),
                    Wrap(
                      alignment: WrapAlignment.spaceAround,
                      spacing: MediaQuery.of(context).size.width > 1000
                          ? 80
                          : MediaQuery.of(context).size.width > 725
                              ? 40
                              : 20,
                      children: [
                        Column(
                          children: [
                            const Text(
                              "Jogos ganhos",
                              style: TextStyle(color: Colors.white),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                userBloc.state.userHistory!.victorys.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 30),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              "Média de tentativas por jogo",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                userBloc.state.meanAttempts.toStringAsFixed(1),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 30),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              "De primeira",
                              style: TextStyle(color: Colors.white),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                userBloc.state.firstVictory.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 30),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              "Sequencia de vitórias",
                              style: TextStyle(color: Colors.white),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                userBloc.state.userHistory!.streaks.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 30),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    //Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          width: 500,
                          height: 500,
                          child: SfCartesianChart(
                              palette: const [Colors.white],
                              primaryXAxis: CategoryAxis(
                                labelRotation: -30,
                                majorGridLines: const MajorGridLines(
                                    color: Colors.transparent),
                              ),
                              primaryYAxis: NumericAxis(
                                title: AxisTitle(text: 'numero de tentativas'),
                                majorGridLines:
                                    const MajorGridLines(color: Colors.white70),
                              ),
                              enableAxisAnimation: true,
                              series: <LineSeries<VictoryInfo, String>>[
                                LineSeries<VictoryInfo, String>(
                                    // Bind data source
                                    dataSource:
                                        userBloc.state.userHistory!.victoryList,
                                    xValueMapper: (VictoryInfo v, _) => v.date,
                                    yValueMapper: (VictoryInfo v, _) =>
                                        v.attempts)
                              ])),
                    ),
                    //Spacer(),
                    Wrap(
                      alignment: WrapAlignment.spaceAround,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            width: 270, // <-- Your width
                            height: 50,
                            child: ElevatedButton(
                                onPressed: () async {
                                  Utils.launchMyUrl(
                                      "http://twitter.com/share?text=Minhas estatísticas em %23fogooo:%0a✌️ Vitórias: ${userBloc.state.userHistory!.victorys}.%0a🤓 Média de adivinhações: ${userBloc.state.meanAttempts.toStringAsFixed(1)}.%0a🥇 De primeira: ${userBloc.state.firstVictory}.%0a🔥 Sequência de vitórias: ${userBloc.state.userHistory!.streaks}.%0a%0aJogue %23fogooo em: ${Constants.myUrl}%0a%0a%23Botafogo %23fogooo %23wordle %23VamosBOTAFOGO %23BFR");
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.lightBlue),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Icon(FontAwesome.twitter,
                                          color: Colors.white),
                                      Spacer(),
                                      AutoSizeText(
                                        "Compartilhar no twitter",
                                        maxFontSize: 20,
                                        minFontSize: 15,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            width: 270, // <-- Your width
                            height: 50,
                            child: ElevatedButton(
                                onPressed: () async {
                                  Share.share(
                                    "Minhas estatísticas em fogooo:\n✌️ Vitórias: ${userBloc.state.userHistory!.victorys}.\n🤓 Média de adivinhações: ${userBloc.state.meanAttempts.toStringAsFixed(1)}.\n🥇 De primeira: ${userBloc.state.firstVictory}.\n🔥 Sequência de vitórias: ${userBloc.state.userHistory!.streaks}\n\nJogue #fogooo em: https://${Constants.myUrl}\n\n#Botafogo #fogooo #wordle #VamosBOTAFOGO #BFR",
                                    subject: "Minhas estatísticas em #fogooo",
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.share, color: Colors.black),
                                      Spacer(),
                                      AutoSizeText(
                                        "Compartilhar",
                                        maxFontSize: 20,
                                        minFontSize: 15,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SizedBox(
                            width: 270, // <-- Your width
                            height: 50,
                            child: ElevatedButton(
                                onPressed: () async {
                                  await Clipboard.setData(ClipboardData(
                                      text:
                                          "Minhas estatísticas em fogooo:\n✌️ Vitórias: ${userBloc.state.userHistory!.victorys}.\n🤓 Média de adivinhações: ${userBloc.state.meanAttempts.toStringAsFixed(1)}.\n🥇 De primeira: ${userBloc.state.firstVictory}.\n🔥 Sequência de vitórias: ${userBloc.state.userHistory!.streaks}.\n\nJogue #fogooo em: https://${Constants.myUrl}\n\n#Botafogo #fogooo #wordle #VamosBOTAFOGO #BFR"));
                                  Fluttertoast.showToast(
                                      msg: "Copiado com sucesso",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffF2388F)),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.copy, color: Colors.white),
                                      Spacer(),
                                      AutoSizeText(
                                        "Copiar conteúdo",
                                        maxFontSize: 20,
                                        minFontSize: 15,
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                    // Spacer(),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }));
  }
}
