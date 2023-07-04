import 'package:fogooo/src/domain/entities/player_entity.dart';
import 'package:fogooo/src/domain/entities/user_history_entity.dart';
import 'package:tuple/tuple.dart';

import '../../core/resources/data_state.dart';

abstract class PlayerRepository {
  Future<DataState<List<Player>>> getAllPlayers();
  Future<DataState<Player>> getSortedPlayer();
  Future<List<Player>> getPlayerGuesses();
  Future<DataState<bool>> addPlayerGuesses(Player player);

  List<Player> getAllPlayersLocal();
  Player? getSortedPlayerLocal();

  UserHistory getUserHistory();
  Future<bool> setUserHistory(UserHistory userHistory);
  Future<bool> sendFeedback(Tuple4<String, String, String, String> data);
  Future<int> getOrderNumber();
  //nao tem usecase
  Future<DataState<int>> getVersionNumber();
  Future<bool> saveAllPlayersLocal(List<Player> playersList);
  Future<bool> saveSortedPlayerLocal(Player player);
}
