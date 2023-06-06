import 'package:either_dart/either.dart';
import 'package:fogooo/src/data/models/player_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHandler {
  late final SupabaseClient _supabaseClient;
  SupabaseHandler() {
    _supabaseClient = Supabase.instance.client;
  }

  Future<Either<List<PlayerModel>, StackTrace>> getAllPlayers() async {
    try {
      var data = await _supabaseClient.from("players").select();

      return Left(
          data.map<PlayerModel>((item) => PlayerModel.fromMap(item)).toList());
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      return Right(stacktrace);
    }
  }

  Future<Either<PlayerModel, StackTrace>> getSortedPlayer() async {
    try {
      var sortedId = await _supabaseClient
          .from("sortedIds")
          .select()
          .order('order')
          .limit(1);
      var data = await _supabaseClient
          .from("players")
          .select()
          .eq('id', sortedId.first['id'])
          .limit(1);
      return Left(PlayerModel.fromMap(data.first));
    } catch (e, stacktrace) {
      return Right(stacktrace);
    }
  }

  Future<Either<int, StackTrace>> getVersionNumber() async {
    try {
      var sortedId = await _supabaseClient.from("version").select().limit(1);
      return Left(sortedId[0]["version_number"]);
    } catch (e, stacktrace) {
      return Right(stacktrace);
    }
  }
}
