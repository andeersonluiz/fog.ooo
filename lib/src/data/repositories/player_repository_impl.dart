import 'package:fogooo/src/core/resources/data_state.dart';
import 'package:fogooo/src/data/datasource/local/local_preferences.dart';
import 'package:fogooo/src/data/datasource/remote/supabase_handler.dart';
import 'package:fogooo/src/data/mappers/player_mapper.dart';
import 'package:fogooo/src/domain/entities/player_entity.dart';
import 'package:fogooo/src/domain/repositories/player_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tuple/tuple.dart';

class PlayerRepositoryImpl implements PlayerRepository {
  final SupabaseHandler _supabaseHandler;
  final PlayerMapper _playerMapper;
  final LocalPreferences _localPreferences;
  PlayerRepositoryImpl(
      this._supabaseHandler, this._playerMapper, this._localPreferences);

  @override
  Future<DataState<List<Player>>> getAllPlayers() async {
    var resultGetAllPlayers = await _supabaseHandler.getAllPlayers();
    if (resultGetAllPlayers.isLeft) {
      return DataSucess(resultGetAllPlayers.left
          .map((value) => _playerMapper.modelToEntity(value))
          .toList());
    } else {
      return DataFailed(
          Tuple2("Erro ao obter jogadores", resultGetAllPlayers.right));
    }
  }

  @override
  List<Player> getAllPlayersLocal() {
    var playersList = _localPreferences.getPlayerList();
    return playersList.map((m) => _playerMapper.modelToEntity(m)).toList();
  }

  @override
  Future<bool> saveAllPlayersLocal(List<Player> playersList) async {
    return await _localPreferences.savePlayerList(
        playersList.map((e) => _playerMapper.entityToModel(e)).toList());
  }

  @override
  Future<DataState<Player>> getSortedPlayer() async {
    var resultGetSortedPlayer = await _supabaseHandler.getSortedPlayer();

    if (resultGetSortedPlayer.isLeft) {
      return DataSucess(
          _playerMapper.modelToEntity(resultGetSortedPlayer.left));
    } else {
      return DataFailed(
          Tuple2("Erro ao obter jogadores", resultGetSortedPlayer.right));
    }
  }

  @override
  Player? getSortedPlayerLocal() {
    var playerSorted = _localPreferences.getSortedPlayer();
    if (playerSorted == null) {
      return null;
    }

    return _playerMapper.modelToEntity(playerSorted);
  }

  @override
  Future<bool> saveSortedPlayerLocal(Player player) async {
    return await _localPreferences
        .saveSortedPlayer(_playerMapper.entityToModel(player));
  }

  @override
  Future<DataState<int>> getVersionNumber() async {
    var resultGetVersionNumber = await _supabaseHandler.getVersionNumber();
    if (resultGetVersionNumber.isLeft) {
      return DataSucess(resultGetVersionNumber.left);
    } else {
      return DataFailed(Tuple2(
          "Erro ao obter numero de versão", resultGetVersionNumber.right));
    }
  }

  @override
  Future<DataState<bool>> addPlayerGuesses(Player player) async {
    var playerModel = _playerMapper.entityToModel(player);

    var result = await _localPreferences.addPlayerGuesses(playerModel);
    if (result) {
      return DataSucess(true);
    } else {
      return DataFailed(Tuple2(
          "Erro ao adicionar jogador, tente novamente mais tarde",
          StackTrace.empty));
    }
  }

  @override
  Future<List<Player>> getPlayerGuesses() async {
    var result = _localPreferences.getPlayersGuesses();
    return result.map((e) => _playerMapper.modelToEntity(e)).toList();
  }
}
