// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:fogooo/src/domain/entities/player_entity.dart';

class PlayerState extends Equatable {
  final List<Player> playersList;
  final Player? sortedPlayer;
  final List<Player> guessList;
  final bool finishedGame;
  final int orderNumber;

  const PlayerState(
      {required this.playersList,
      this.sortedPlayer,
      required this.guessList,
      required this.orderNumber,
      required this.finishedGame});

  @override
  List<Object> get props =>
      [playersList, sortedPlayer ?? "", guessList, finishedGame];
}

class PlayerEmptyState extends PlayerState {
  const PlayerEmptyState(
      {required super.playersList,
      required super.sortedPlayer,
      required super.guessList,
      required super.finishedGame,
      required super.orderNumber});
}

class PlayerLoadingState extends PlayerState {
  const PlayerLoadingState(
      {required super.playersList,
      required super.sortedPlayer,
      required super.guessList,
      required super.finishedGame,
      required super.orderNumber});
}

class PlayerFilledState extends PlayerState {
  const PlayerFilledState(
      {required super.playersList,
      required super.sortedPlayer,
      required super.guessList,
      required super.finishedGame,
      required super.orderNumber});
}

class PlayerFinishedState extends PlayerState {
  const PlayerFinishedState(
      {required super.playersList,
      required super.sortedPlayer,
      required super.guessList,
      required super.finishedGame,
      required super.orderNumber});
}
