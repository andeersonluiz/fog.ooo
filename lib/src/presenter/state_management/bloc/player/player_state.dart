// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:fogooo/src/domain/entities/player_entity.dart';
import 'dart:math';

class PlayerState extends Equatable {
  final List<Player> playersList;
  final Player? sortedPlayer;
  final List<Player> guessList;

  const PlayerState(
      {required this.playersList, this.sortedPlayer, required this.guessList});

/*
  PlayerState copyWith({
    List<Player>? playersList,
    Player? sortedPlayer,
    List<Player>? guessList,
  }) {
    return PlayerState(
      playersList: playersList ?? this.playersList,
      sortedPlayer: sortedPlayer ?? this.sortedPlayer,
      guessList: guessList ?? this.guessList,
    );
  }
*/
  @override
  List<Object> get props => [
        playersList,
        sortedPlayer ?? "",
        guessList,
      ];
}

class PlayerEmptyState extends PlayerState {
  const PlayerEmptyState(
      {required super.playersList,
      required super.sortedPlayer,
      required super.guessList});
}

class PlayerLoadingState extends PlayerState {
  const PlayerLoadingState(
      {required super.playersList,
      required super.sortedPlayer,
      required super.guessList});
}

class PlayerFilledState extends PlayerState {
  const PlayerFilledState(
      {required super.playersList,
      required super.sortedPlayer,
      required super.guessList});
}

class PlayerFinishedState extends PlayerState {
  const PlayerFinishedState(
      {required super.playersList,
      required super.sortedPlayer,
      required super.guessList});
}
