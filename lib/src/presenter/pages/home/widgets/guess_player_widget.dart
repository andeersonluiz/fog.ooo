import 'dart:async';
import 'dart:math';
import 'dart:html' as html;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fogooo/src/core/utils/constants.dart';
import 'package:fogooo/src/core/utils/utils.dart';
import 'package:fogooo/src/domain/entities/player_entity.dart';
import 'package:fogooo/src/presenter/pages/home/widgets/card_item.dart';
import 'package:fogooo/src/presenter/pages/home/widgets/custom_icon.dart';
import 'package:fogooo/src/presenter/state_management/bloc/player/player_event.dart';
import 'package:fogooo/src/presenter/state_management/valueNotifier/time_notifier.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../../../state_management/bloc/player/player_bloc.dart';

class GuessPlayerWidget extends StatefulWidget {
  final List<Player> players;
  final List<Player> guessPlayers;
  final Player sortedPlayer;
  final bool isCompleted;

  const GuessPlayerWidget(
      {super.key,
      required this.players,
      required this.guessPlayers,
      required this.sortedPlayer,
      required this.isCompleted});

  @override
  State<GuessPlayerWidget> createState() => _GuessPlayerWidgetState();
}

class _GuessPlayerWidgetState extends State<GuessPlayerWidget>
    with SingleTickerProviderStateMixin {
  late List<Animation<double>> listAnim = [];

  late AnimationController _controller;
  late Timer mytimer;
  late TimeNotifier timeNotifier;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    timeNotifier = context.read<TimeNotifier>();

    double offset = 0.0;
    for (int i = 0; i < 6; i++) {
      listAnim.add(Tween<double>(begin: pi, end: 0.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(offset, offset + 1 / 5, curve: Curves.easeInBack),
        ),
      ));
      offset += 1 / 5;
    }
    mytimer = Timer.periodic(Duration(seconds: 1), (timer) {
      String timenow =
          Utils.formatDuration(Constants.endOfDay.difference(DateTime.now()));
      if (timenow == "00:00:00") {
        html.window.location.reload();
      }
      timeNotifier.update(timenow);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PlayerBloc playerBloc = context.read<PlayerBloc>();
    final TextEditingController controller = TextEditingController();
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
                constraints: BoxConstraints(
                    maxHeight: 80,
                    maxWidth: MediaQuery.of(context).size.width * 0.8),
                child: Image.asset("assets/white_logo.png")),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIcon(
                  onPressed: () {},
                  icon: Icons.question_mark,
                ),
                CustomIcon(onPressed: () {}, icon: Icons.grade),
                CustomIcon(
                  onPressed: () {},
                  icon: Icons.feedback,
                ),
                CustomIcon(onPressed: () {}, icon: Icons.settings),
              ],
            ),
          ),
          widget.isCompleted
              ? Container()
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  constraints:
                      const BoxConstraints(maxWidth: 700, maxHeight: 50),
                  child: TypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: controller,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Digite um jogador",
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                      ),
                    ),
                    suggestionsCallback: (pattern) {
                      //print("c $pattern");
                      //print(pattern);
                      return playerBloc.showSuggestions(pattern);
                    },
                    loadingBuilder: (ctx) {
                      return const IntrinsicHeight(
                          child: Center(
                        child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: CircularProgressIndicator()),
                      ));
                    },
                    noItemsFoundBuilder: (ctx) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8.0),
                        child: const Text("Nenhum jogador encontrado.",
                            textAlign: TextAlign.center),
                      );
                    },
                    itemBuilder: (ctx, suggestion) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Container(
                            height: 200,
                            width: 30,
                            child: Image.network(
                              suggestion.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(suggestion.name),
                          subtitle: Text(suggestion.oficialName),
                        ),
                      );
                    },
                    onSuggestionSelected: (player) {
                      controller.clear();
                      playerBloc.add(AddPlayerGuessEvent(player: player));
                      _controller.forward(from: 0.0);
                    },
                  ),
                ),
          widget.guessPlayers.contains(widget.sortedPlayer)
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(11)),
                    constraints:
                        const BoxConstraints(maxWidth: 700, maxHeight: 200),
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Text(
                            "Você acertou, parabéns!!",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.green, fontSize: 20),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "O jogador era: ${widget.sortedPlayer.name}",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                          Spacer(),
                          AutoSizeText(
                            "Tempo para o próximo jogador",
                            textAlign: TextAlign.center,
                            maxFontSize: 25,
                            minFontSize: 15,
                            style: TextStyle(color: Colors.white),
                          ),
                          ValueListenableBuilder(
                            valueListenable: timeNotifier.state,
                            builder: (ctx, data, w) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  data,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              );
                            },
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                )
              : widget.guessPlayers.length >= 5
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(11)),
                        constraints:
                            const BoxConstraints(maxWidth: 700, maxHeight: 200),
                        child: Column(
                          children: [
                            AutoSizeText(
                              "Dica",
                              minFontSize: 20,
                              maxFontSize: 30,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 30),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: AutoSizeText(
                                  widget.guessPlayers
                                          .contains(widget.sortedPlayer)
                                      ? widget.sortedPlayer.name
                                      : Utils.hiddenName(
                                          widget.sortedPlayer.name,
                                          widget.guessPlayers.length),
                                  minFontSize: 20,
                                  maxFontSize: 40,
                                  style: TextStyle(
                                      color: Colors.white,
                                      height:
                                          1.2, // the height between text, default is null
                                      letterSpacing: 5.0),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Spacer(),
                            (widget.guessPlayers.length ~/ 5) + 1 >=
                                    widget.sortedPlayer.name.length
                                ? Container()
                                : widget.guessPlayers
                                        .contains(widget.sortedPlayer)
                                    ? Text(
                                        "Você acertou, parabéns!!",
                                        style: TextStyle(
                                            color: Colors.green, fontSize: 20),
                                      )
                                    : AutoSizeText(
                                        "Mais ${((widget.guessPlayers.length ~/ 5) + 1) * 5 - widget.guessPlayers.length} tentativas para próxima dica",
                                        maxFontSize: 20,
                                        minFontSize: 10,
                                        style: TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(11)),
                        constraints:
                            const BoxConstraints(maxWidth: 700, maxHeight: 60),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AutoSizeText(
                              "Mais ${((widget.guessPlayers.length ~/ 5) + 1) * 5 - widget.guessPlayers.length} tentativas para dica",
                              maxFontSize: 20,
                              minFontSize: 10,
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  widget.guessPlayers.isEmpty
                      ? Container()
                      : const Row(
                          children: [
                            CardItem(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(width: 3, color: Colors.white),
                                ),
                              ),
                              height: 70,
                              child: Text(
                                "Jogador",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            CardItem(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(width: 3, color: Colors.white),
                                ),
                              ),
                              height: 70,
                              child: Text(
                                "Nacionalidade",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            CardItem(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(width: 3, color: Colors.white),
                                ),
                              ),
                              height: 70,
                              child: Text(
                                "Idade",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            CardItem(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(width: 3, color: Colors.white),
                                ),
                              ),
                              height: 70,
                              child: Text(
                                "Posição",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            CardItem(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(width: 3, color: Colors.white),
                                ),
                              ),
                              height: 70,
                              child: Text(
                                "Anos que jogou no Botafogo",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            CardItem(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(width: 3, color: Colors.white),
                                ),
                              ),
                              height: 70,
                              child: Text(
                                "Partidas disputadas",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                  Column(
                    children: widget.guessPlayers.reversed.map((p) {
                      bool isLast = p.id == widget.guessPlayers.last.id;
                      List<Widget> elements = [
                        CardItem(
                          color:
                              widget.sortedPlayer.nationality == p.nationality
                                  ? Colors.green.shade700
                                  : Colors.red.shade700,
                          child: Container(
                            height: 70,
                            width: 70,
                            child: Image.network(
                              p.nationality.image,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        CardItem(
                          color: widget.sortedPlayer.age == p.age
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                          child: Center(
                            child: Container(
                              child: Text(
                                p.age == -1 ? "Falecido" : p.age.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        CardItem(
                          color: widget.sortedPlayer.pos == p.pos
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                          child: Center(
                            child: Container(
                              child: Text(
                                p.pos,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        CardItem(
                          color: listEquals(widget.sortedPlayer.yearsPlayed,
                                  p.yearsPlayed)
                              ? Colors.green.shade700
                              : widget.sortedPlayer.yearsPlayed
                                      .any(p.yearsPlayed.contains)
                                  ? Colors.orange.shade700
                                  : Colors.red.shade700,
                          child: Center(
                            child: Container(
                              child: Text(
                                Utils.convertYearsPlayedInvervalToString(
                                    p.yearsPlayedInterval),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Stack(
                          children: [
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CardItem(
                                  decoration: BoxDecoration(
                                    image: widget.sortedPlayer.matches ==
                                            p.matches
                                        ? null
                                        : widget.sortedPlayer.matches >
                                                p.matches
                                            ? DecorationImage(
                                                colorFilter: ColorFilter.mode(
                                                    Colors.grey
                                                        .withOpacity(0.1),
                                                    BlendMode.color),
                                                image: const AssetImage(
                                                  "assets/arrow_up.png",
                                                ),
                                                fit: BoxFit.cover,
                                              )
                                            : DecorationImage(
                                                colorFilter: ColorFilter.mode(
                                                    Colors.grey
                                                        .withOpacity(0.1),
                                                    BlendMode.color),
                                                image: const AssetImage(
                                                  "assets/arrow_down.png",
                                                ),
                                                fit: BoxFit.cover,
                                              ),
                                  ),
                                  child: Container(),
                                ),
                              ),
                            ),
                            CardItem(
                              decoration: BoxDecoration(
                                color: widget.sortedPlayer.matches == p.matches
                                    ? Colors.green.shade700
                                    : Colors.red.shade700.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(11.0),
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: Text(
                                p.matches.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ];
                      return Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 16.0,
                                  bottom: 8.0,
                                  left: 8.0,
                                  right: 8.0),
                              child: Text(
                                p.name,
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [])),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(11.0),
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                        color: Colors.white,
                                        image: DecorationImage(
                                            image: NetworkImage(p.imageUrl),
                                            fit: BoxFit.contain),
                                      ),
                                      child: Container()),
                                ),
                                isLast && playerBloc.addedPlayer
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children:
                                            mapIndexed(elements, (index, item) {
                                          return AnimatedBuilder(
                                              animation: _controller,
                                              builder: (context, child) {
                                                return AnimatedBuilder(
                                                  animation: listAnim[index],
                                                  child: widget,
                                                  builder: (context, widget) {
                                                    final value = min(
                                                        listAnim[index].value,
                                                        pi / 2);
                                                    return Transform(
                                                      transform:
                                                          Matrix4.rotationY(
                                                              value),
                                                      alignment:
                                                          Alignment.center,
                                                      child: item,
                                                    );
                                                  },
                                                );
                                              });
                                        }).toList())
                                    : Row(children: elements),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Iterable<E> mapIndexed<E, T>(
      Iterable<T> items, E Function(int index, T item) f) sync* {
    var index = 0;

    for (final item in items) {
      yield f(index, item);
      index = index + 1;
    }
  }
}
