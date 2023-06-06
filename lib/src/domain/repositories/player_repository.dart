import 'package:fogooo/src/domain/entities/player_entity.dart';

import '../../core/resources/data_state.dart';

abstract class PlayerRepository {
  Future<DataState<List<Player>>> getAllPlayers();
  Future<DataState<Player>> getSortedPlayer();
  Future<List<Player>> getPlayerGuesses();
  Future<DataState<bool>> addPlayerGuesses(Player player);

  List<Player> getAllPlayersLocal();
  Player? getSortedPlayerLocal();

  //nao tem usecase
  Future<DataState<int>> getVersionNumber();
  Future<bool> saveAllPlayersLocal(List<Player> playersList);
  Future<bool> saveSortedPlayerLocal(Player player);
}
