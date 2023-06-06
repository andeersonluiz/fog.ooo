import 'dart:convert';

import 'package:fogooo/src/data/models/player_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/entities/player_entity.dart';

class LocalPreferences {
  late final SharedPreferences _instance;
  init() async {
    _instance = await SharedPreferences.getInstance();
  }

  final String versionNumberKey = "versionNumberKey";
  final String playerListKey = "playerListKey";
  final String sortedPlayerKey = "sortedPlayerKey";
  final String playerGuessKey = "playerGuessKey";

  int getVersionNumber() {
    int? result = _instance.getInt(versionNumberKey);
    return result ?? -1;
  }

  Future<bool> saveVersionNumber(int versionNumber) async {
    bool result = await _instance.setInt(versionNumberKey, versionNumber);
    return result;
  }

  List<PlayerModel> getPlayerList() {
    try {
      String? result = _instance.getString(playerListKey);
      if (result != null) {
        return jsonDecode(result)
            .map<PlayerModel>((e) => PlayerModel.fromJson(e))
            .toList();
      }
      return [];
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      return [];
    }
  }

  Future<bool> savePlayerList(List<PlayerModel> listPlayer) async {
    try {
      bool result = await _instance.setString(playerListKey,
          jsonEncode(listPlayer.map((e) => e.toJson()).toList()));
      return result;
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      return false;
    }
  }

  PlayerModel? getSortedPlayer() {
    print("sorteando..");
    try {
      String? result = _instance.getString(sortedPlayerKey);
      print(result.toString());
      if (result != null) {
        return PlayerModel.fromJson(jsonDecode(result));
      }
      return null;
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      return null;
    }
  }

  Future<bool> saveSortedPlayer(PlayerModel player) async {
    bool result =
        await _instance.setString(sortedPlayerKey, jsonEncode(player.toJson()));
    return result;
  }

  Future<bool> addPlayerGuesses(PlayerModel player) async {
    var result = _instance.getString(playerGuessKey);
    if (result == null) {
      await _instance.setString(playerGuessKey, jsonEncode([player.toJson()]));
    } else {
      var listUpdated = jsonDecode(result)
          .map<PlayerModel>((item) => PlayerModel.fromJson(item))
          .toList();
      listUpdated.add(player);
      await _instance.setString(playerGuessKey,
          jsonEncode(listUpdated.map((e) => e.toJson()).toList()));
    }

    return true;
  }

  List<PlayerModel> getPlayersGuesses() {
    var result = _instance.getString(playerGuessKey);
    if (result == null) {
      return [];
    } else {
      return jsonDecode(result)
          .map<PlayerModel>((item) => PlayerModel.fromJson(item))
          .toList();
    }
  }

  Future<bool> resetPlayerGuesses() async {
    bool result = await _instance.remove(playerGuessKey);
    return result;
  }
}
