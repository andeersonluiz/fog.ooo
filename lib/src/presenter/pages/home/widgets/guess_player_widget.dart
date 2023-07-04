import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_improved_scrolling/flutter_improved_scrolling.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:fogooo/src/core/utils/constants.dart';
import 'package:fogooo/src/core/utils/utils.dart';
import 'package:fogooo/src/domain/entities/player_entity.dart';
import 'package:fogooo/src/presenter/pages/home/widgets/card_item.dart';
import 'package:fogooo/src/presenter/pages/home/widgets/custom_icon.dart';
import 'package:fogooo/src/presenter/pages/pop_ups/feedback.dart';
import 'package:fogooo/src/presenter/pages/pop_ups/how_to_play.dart';
import 'package:fogooo/src/presenter/pages/pop_ups/statics.dart';
import 'package:fogooo/src/presenter/pages/pop_ups/win_game.dart';
import 'package:fogooo/src/presenter/state_management/bloc/player/player_event.dart';
import 'package:fogooo/src/presenter/state_management/bloc/user/user_bloc.dart';
import 'package:fogooo/src/presenter/state_management/bloc/user/user_event.dart';
import 'package:fogooo/src/presenter/state_management/valueNotifier/time_notifier.dart';

import '../../../dataTransferObject/feedback_DTO.dart';
import '../../../state_management/bloc/player/player_bloc.dart';

class GuessPlayerWidget extends StatefulWidget {
  const GuessPlayerWidget(
      {super.key,
      required this.players,
      required this.guessPlayers,
      required this.sortedPlayer,
      required this.isCompleted});

  final List<Player> guessPlayers;
  final bool isCompleted;
  final List<Player> players;
  final Player sortedPlayer;

  @override
  State<GuessPlayerWidget> createState() => _GuessPlayerWidgetState();
}

class _GuessPlayerWidgetState extends State<GuessPlayerWidget>
    with SingleTickerProviderStateMixin {
  late List<Animation<double>> listAnim = [];
  late Timer mytimer;
  late TimeNotifier timeNotifier;
  final ScrollController scrollController =
      ScrollController(initialScrollOffset: 0.0);
  late UserBloc userBloc;
  late AnimationController _controller;
  late FocusNode focusNode;
  late FeedbackDTO feedbackDTO;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    userBloc = context.read<UserBloc>();

    feedbackDTO = context.read<FeedbackDTO>();

    timeNotifier = context.read<TimeNotifier>();
    userBloc.add(const LoadUserHistoryEvent());
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
    mytimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      String timenow =
          Utils.formatDuration(Constants.endOfDay.difference(DateTime.now()));
      
      if (timenow == "00:00:00" || timenow=="") {
        html.window.location.reload();
      }
      timeNotifier.update(timenow);
    });
    focusNode = FocusNode();
    super.initState();
  }

  Iterable<E> mapIndexed<E, T>(
      Iterable<T> items, E Function(int index, T item) f) sync* {
    var index = 0;

    for (final item in items) {
      yield f(index, item);
      index = index + 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final PlayerBloc playerBloc = context.read<PlayerBloc>();
    final TextEditingController controller = TextEditingController();
    return ImprovedScrolling(
      enableMMBScrolling: true,
      enableKeyboardScrolling: true,
      enableCustomMouseWheelScrolling: true,
      scrollController: scrollController,
      child: RawScrollbar(
        thickness: 20,
        thumbColor: Colors.grey,
        controller: scrollController,
        radius: const Radius.circular(20),
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                              constraints: BoxConstraints(
                                  maxHeight: 80,
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.8),
                              child: Image.asset("assets/white_logo.png")),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(8.0),
                                child: CustomIcon(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return ValueListenableBuilder(
                                            valueListenable: timeNotifier.state,
                                            builder: (ctx, data, w) {
                                              return HowToPlayPopUp(
                                                timeRemaining: data,
                                              );
                                            },
                                          );
                                        });
                                  },
                                  icon: FontAwesomeIcons.question,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomIcon(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return BlocProvider<UserBloc>.value(
                                            value: userBloc,
                                            child: const StaticsPopUp(),
                                          );
                                        });
                                  },
                                  icon: Icons.bar_chart,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomIcon(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Provider<FeedbackDTO>.value(
                                            value: feedbackDTO,
                                            child: const FeedbackPopUp(),
                                          );
                                        });
                                  },
                                  icon: Icons.feedback,
                                ),
                              ),
                              /*CustomIcon(
                                  onPressed: () {}, icon: Icons.settings),*/
                            ],
                          ),
                        ),
                        widget.isCompleted
                            ? Container()
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                constraints: const BoxConstraints(
                                    maxWidth: 700, maxHeight: 50),
                                child: TypeAheadField(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    controller: controller,
                                    autocorrect: true,
                                    onTapOutside: (type) {
                                      focusNode.unfocus();
                                    },
                                    focusNode: focusNode,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      hintText: "Digite um jogador",
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(25.7),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(25.7),
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
                                      child: const Text(
                                          "Nenhum jogador encontrado.",
                                          textAlign: TextAlign.center),
                                    );
                                  },
                                  itemBuilder: (ctx, suggestion) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        leading: SizedBox(
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
                                    playerBloc.add(
                                        AddPlayerGuessEvent(player: player));
                                    _controller.forward(from: 0.0);

                                    Future.delayed(
                                        const Duration(
                                          seconds: 4,
                                        ), () {
                                      if (player.id == widget.sortedPlayer.id) {
                                        playerBloc
                                            .add(const FinishedPlayerEvent());

                                        userBloc.add(SaveUserHistoryEvent(
                                            attempts: playerBloc
                                                .state.guessList.length));
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return ValueListenableBuilder(
                                                valueListenable:
                                                    timeNotifier.state,
                                                builder: (ctx, data, w) {
                                                  return WinGamePopUp(
                                                    sortedPlayer:
                                                        widget.sortedPlayer,
                                                    guessList: playerBloc
                                                        .state.guessList,
                                                    timeReset:
                                                        timeNotifier.value,
                                                    orderNumber: playerBloc
                                                        .state.orderNumber,
                                                  );
                                                },
                                              );
                                            });
                                      }
                                    });
                                  },
                                ),
                              ),
                        playerBloc.state.finishedGame
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(11)),
                                  constraints: BoxConstraints(
                                      maxWidth: 700,
                                      maxHeight:
                                          MediaQuery.of(context).size.width >
                                                  700
                                              ? 255
                                              : 335),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        const Text(
                                          "Você acertou, parabéns!!",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 20),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "O jogador era: ${widget.sortedPlayer.name}",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ),
                                        Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16,
                                                      horizontal: 8.0),
                                              child: SizedBox(
                                                width: 300, // <-- Your width
                                                child: ElevatedButton(
                                                    onPressed: () async {
                                                      String result = Utils
                                                          .generateEmojiText(
                                                              widget
                                                                  .sortedPlayer,
                                                              playerBloc.state
                                                                  .guessList);
                                                      await Clipboard.setData(
                                                          ClipboardData(
                                                              text:
                                                                  "Ganhei no #fogooo #${playerBloc.state.orderNumber} em ${playerBloc.state.guessList.length} tentativas.\n\n${result}Jogue #fogooo em: ${Constants.myUrl}\n\n#Botafogo #fogooo #wordle #VamosBOTAFOGO #BFR"));
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Copiado com sucesso",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .CENTER,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor:
                                                              Colors.black,
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 16.0);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          const Color(
                                                              0xffF2388F),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50.0)),
                                                    ),
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons.copy,
                                                              color:
                                                                  Colors.white),
                                                          Spacer(),
                                                          AutoSizeText(
                                                            "Copiar conteúdo",
                                                            maxFontSize: 20,
                                                            minFontSize: 15,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          Spacer(),
                                                        ],
                                                      ),
                                                    )),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16,
                                                      horizontal: 8.0),
                                              child: SizedBox(
                                                width: 300,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ElevatedButton(
                                                      onPressed: () async {
                                                        String result = Utils
                                                            .generateEmojiText(
                                                                widget
                                                                    .sortedPlayer,
                                                                playerBloc.state
                                                                    .guessList);
                                                        Utils.launchMyUrl(
                                                            "http://twitter.com/share?text=Ganhei no %23fogooo %23${playerBloc.state.orderNumber} em ${playerBloc.state.guessList.length} tentativas.%0a%0a${result}Jogue %23fogooo em: ${Constants.myUrl}%0a%0a%23Botafogo %23fogooo %23wordle %23VamosBOTAFOGO %23BFR");
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.lightBlue,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50.0)),
                                                          side: const BorderSide(
                                                              color: Colors
                                                                  .lightBlue,
                                                              width: 2)),
                                                      child: const Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                                FontAwesome
                                                                    .twitter,
                                                                color: Colors
                                                                    .white),
                                                            Spacer(),
                                                            AutoSizeText(
                                                              "Compartilhar",
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            Spacer(),
                                                          ],
                                                        ),
                                                      )),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        const AutoSizeText(
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
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                data,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                            );
                                          },
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : widget.guessPlayers.length >= 5
                                ? Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Container(
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          border:
                                              Border.all(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(11)),
                                      constraints: const BoxConstraints(
                                          maxWidth: 700, maxHeight: 200),
                                      child: Column(
                                        children: [
                                          const AutoSizeText(
                                            "Dica",
                                            minFontSize: 20,
                                            maxFontSize: 30,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 30),
                                          ),
                                          const Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: AutoSizeText(
                                                playerBloc.state.finishedGame
                                                    ? widget.sortedPlayer.name
                                                    : Utils.hiddenName(
                                                        widget
                                                            .sortedPlayer.name,
                                                        widget.guessPlayers
                                                            .length),
                                                minFontSize: 20,
                                                maxFontSize: 40,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    height:
                                                        1.2, // the height between text, default is null
                                                    letterSpacing: 5.0),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          Utils.verifyIfDicasEnd()
                                              ? Container()
                                              : playerBloc.state.finishedGame
                                                  ? const Text(
                                                      "Você acertou, parabéns!!",
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 20),
                                                    )
                                                  : AutoSizeText(
                                                      "Mais ${((widget.guessPlayers.length ~/ 5) + 1) * 5 - widget.guessPlayers.length} tentativas para próxima dica",
                                                      maxFontSize: 20,
                                                      minFontSize: 10,
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Container(
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          border:
                                              Border.all(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(11)),
                                      constraints: const BoxConstraints(
                                          maxWidth: 650, maxHeight: 60),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: AutoSizeText(
                                              "Mais ${((widget.guessPlayers.length ~/ 5) + 1) * 5 - widget.guessPlayers.length} tentativas para dica",
                                              maxFontSize: 20,
                                              minFontSize: 10,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
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
                                                bottom: BorderSide(
                                                    width: 3,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            height: 90,
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
                                                bottom: BorderSide(
                                                    width: 3,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            height: 90,
                                            child: Text(
                                              "Nacionalidade",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          CardItem(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    width: 3,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            height: 90,
                                            child: Text(
                                              "Idade",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          CardItem(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    width: 3,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            height: 90,
                                            child: Text(
                                              "Posição",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          CardItem(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    width: 3,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            height: 90,
                                            child: Text(
                                              "Anos que jogou no Botafogo",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          CardItem(
                                            decoration: BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    width: 3,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            height: 90,
                                            child: Text(
                                              "Convocado pela seleção brasileira\n(profissional)",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                Column(
                                  children:
                                      widget.guessPlayers.reversed.map((p) {
                                    bool isLast =
                                        p.id == widget.guessPlayers.last.id;
                                    List<Widget> elements = [
                                      CardItem(
                                        color:
                                            widget.sortedPlayer.nationality ==
                                                    p.nationality
                                                ? Colors.green.shade700
                                                : Colors.red.shade700,
                                        child: SizedBox(
                                          height: 70,
                                          width: 70,
                                          child: Image.network(
                                            p.nationality.image,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      /* CardItem(
                                        color: widget.sortedPlayer.age == p.age
                                            ? Colors.green.shade700
                                            : Colors.red.shade700,
                                        child: Center(
                                          child: Container(
                                            child: Text(
                                              p.age == -1
                                                  ? "Falecido"
                                                  : p.age.toString(),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),*/

                                      Stack(
                                        children: [
                                          CardItem(
                                            decoration: BoxDecoration(
                                              color: widget.sortedPlayer.age ==
                                                      p.age
                                                  ? Colors.green.shade700
                                                  : Colors.red.shade700,
                                              borderRadius:
                                                  BorderRadius.circular(11.0),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2),
                                            ),
                                            child: Container(),
                                          ),
                                          Positioned.fill(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: CardItem(
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  image: widget.sortedPlayer
                                                              .age ==
                                                          p.age
                                                      ? null
                                                      : widget.sortedPlayer
                                                                  .age >
                                                              p.age
                                                          ? const DecorationImage(
                                                              image: AssetImage(
                                                                "assets/arrow_up.png",
                                                              ),
                                                              fit: BoxFit.fill,
                                                            )
                                                          : const DecorationImage(
                                                              image: AssetImage(
                                                                "assets/arrow_down.png",
                                                              ),
                                                              fit: BoxFit.fill,
                                                            ),
                                                ),
                                                child: Container(
                                                  color: Colors.transparent,
                                                  child: Text(
                                                    p.age == 500
                                                        ? "Falecido"
                                                        : p.age.toString(),
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      CardItem(
                                        color: widget.sortedPlayer.pos == p.pos
                                            ? Colors.green.shade700
                                            : Colors.red.shade700,
                                        child: Center(
                                          child: Text(
                                            p.pos,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      CardItem(
                                        color: listEquals(
                                                widget.sortedPlayer.yearsPlayed,
                                                p.yearsPlayed)
                                            ? Colors.green.shade700
                                            : widget.sortedPlayer.yearsPlayed
                                                    .any(p.yearsPlayed.contains)
                                                ? Colors.orange.shade700
                                                : Colors.red.shade700,
                                        child: Center(
                                          child: Text(
                                            Utils
                                                .convertYearsPlayedInvervalToString(
                                                    p.yearsPlayedInterval),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      CardItem(
                                        color: widget.sortedPlayer.playedTeam ==
                                                p.playedTeam
                                            ? Colors.green.shade700
                                            : Colors.red.shade700,
                                        child: Center(
                                          child: Text(
                                            p.playedTeam ? "Sim" : "Não",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ), /*
                                      Stack(
                                        children: [
                                          Positioned.fill(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: CardItem(
                                                decoration: BoxDecoration(
                                                  image: widget.sortedPlayer
                                                              .matches ==
                                                          p.matches
                                                      ? null
                                                      : widget.sortedPlayer
                                                                  .matches >
                                                              p.matches
                                                          ? DecorationImage(
                                                              colorFilter: ColorFilter.mode(
                                                                  Colors.grey
                                                                      .withOpacity(
                                                                          0.1),
                                                                  BlendMode
                                                                      .color),
                                                              image:
                                                                  const AssetImage(
                                                                "assets/arrow_up.png",
                                                              ),
                                                              fit: BoxFit.cover,
                                                            )
                                                          : DecorationImage(
                                                              colorFilter: ColorFilter.mode(
                                                                  Colors.grey
                                                                      .withOpacity(
                                                                          0.1),
                                                                  BlendMode
                                                                      .color),
                                                              image:
                                                                  const AssetImage(
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
                                              color:
                                                  widget.sortedPlayer.matches ==
                                                          p.matches
                                                      ? Colors.green.shade700
                                                      : Colors.red.shade700
                                                          .withOpacity(0.7),
                                              borderRadius:
                                                  BorderRadius.circular(11.0),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2),
                                            ),
                                            child: Text(
                                              p.matches.toString(),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),*/
                                    ];
                                    return Column(
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
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [])),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                  height: 100,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            11.0),
                                                    border: Border.all(
                                                        color: Colors.white,
                                                        width: 2),
                                                    color: Colors.white,
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            p.imageUrl),
                                                        fit: BoxFit.contain),
                                                  ),
                                                  child: Container()),
                                            ),
                                            isLast && playerBloc.addedPlayer
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children:
                                                        mapIndexed(elements,
                                                            (index, item) {
                                                      return AnimatedBuilder(
                                                          animation:
                                                              _controller,
                                                          builder:
                                                              (context, child) {
                                                            return AnimatedBuilder(
                                                              animation:
                                                                  listAnim[
                                                                      index],
                                                              child: widget,
                                                              builder: (context,
                                                                  widget) {
                                                                final value = min(
                                                                    listAnim[
                                                                            index]
                                                                        .value,
                                                                    pi / 2);
                                                                return Transform(
                                                                  transform: Matrix4
                                                                      .rotationY(
                                                                          value),
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
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
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      color: Colors.black87,
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          const Text(
                            "© 2023  |  Desenvolvido por Anderson Luiz  |  Todos os direitos reservados  |  Contato:",
                            style: TextStyle(color: Colors.white, height: 1.5),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: CustomIcon(
                              onPressed: () {
                                Utils.launchMyUrl(
                                    "mailto:devowlytech@gmail.com");
                              },
                              logo: Logos.gmail,
                              padding: 14,
                              sizeLogo: 24,
                            ),
                          ),
                          const Text(
                            "|  Siga-me: ",
                            style: TextStyle(color: Colors.white),
                          ),
                          CustomIcon(
                            onPressed: () {
                              Utils.launchMyUrl(
                                  "https://twitter.com/Luizinnh01");
                            },
                            logo: Logos.twitter,
                            padding: 14,
                            sizeLogo: 24,
                          ),
                          CustomIcon(
                            onPressed: () {
                              Utils.launchMyUrl(
                                  "https://play.google.com/store/apps/dev?id=7240282986682420125");
                            },
                            logo: Logos.google_play,
                            padding: 14,
                            sizeLogo: 24,
                          ),
                          CustomIcon(
                            onPressed: () {
                              Utils.launchMyUrl(
                                  "https://github.com/andeersonluiz");
                            },
                            logo: Logos.github,
                            padding: 14,
                            sizeLogo: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    _controller.dispose();
    focusNode.dispose();

    super.dispose();
  }
}
