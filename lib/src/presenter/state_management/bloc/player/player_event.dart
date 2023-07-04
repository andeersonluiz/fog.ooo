// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:fogooo/src/domain/entities/player_entity.dart';

class PlayerEvent extends Equatable {
  final Player? player;
  const PlayerEvent({
    this.player,
  });
  @override
  List<Object> get props => [player ?? ""];
}

class AddPlayerGuessEvent extends PlayerEvent {
  const AddPlayerGuessEvent({required super.player});
}

class LoadDataEvent extends PlayerEvent {
  const LoadDataEvent();
}

class FinishedPlayerEvent extends PlayerEvent {
  const FinishedPlayerEvent();
}
