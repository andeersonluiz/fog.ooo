import 'package:flutter/material.dart';
import 'package:fogooo/src/core/resources/data_state.dart';
import 'package:fogooo/src/data/datasource/local/local_preferences.dart';
import 'package:fogooo/src/data/datasource/remote/supabase_handler.dart';
import 'package:fogooo/src/data/mappers/history_mapper.dart';
import 'package:fogooo/src/data/mappers/player_mapper.dart';
import 'package:fogooo/src/data/repositories/player_repository_impl.dart';
import 'package:fogooo/src/domain/repositories/player_repository.dart';
import 'package:fogooo/src/domain/usecases/add_player_guesses_usecase.dart';
import 'package:fogooo/src/domain/usecases/get_order_number_usecase.dart';
import 'package:fogooo/src/domain/usecases/get_user_history_usecase.dart';
import 'package:fogooo/src/domain/usecases/send_feedback_usecase.dart';
import 'package:fogooo/src/domain/usecases/set_user_history_usecase.dart';
import 'package:fogooo/src/domain/usecases/talvez%20remover/get_all_players_usecase.dart';
import 'package:fogooo/src/domain/usecases/get_player_guesses_usecase.dart';
import 'package:fogooo/src/domain/usecases/talvez%20remover/get_sorted_player_usecase.dart';
import 'package:provider/provider.dart';

import 'domain/usecases/get_all_players_local_usecase.dart';
import 'domain/usecases/get_sorted_player_local_usecase.dart';
import 'presenter/reusable_widgets/error_widget.dart';

_loadData(PlayerRepository playerRepository,
    LocalPreferences localPreferences) async {
  try {
    await localPreferences.init();

    var versionNumberResult = await playerRepository.getVersionNumber();
    if (versionNumberResult is DataSucess) {
      int oldVersionNumber = localPreferences.getVersionNumber();
      int newVersionNumber = versionNumberResult.data!;
      if (oldVersionNumber != newVersionNumber) {
        var playersList = await playerRepository.getAllPlayers();
        if (playersList is DataSucess) {
          await playerRepository.saveAllPlayersLocal(playersList.data!);
          await localPreferences.saveVersionNumber(newVersionNumber);
        } else {
          return "error:x01";
        }
      }
    }
    var playerSorted = await playerRepository.getSortedPlayer();
    if (playerSorted is DataSucess) {
      var localSortedPlayer = playerRepository.getSortedPlayerLocal();
      if (localSortedPlayer == null ||
          playerSorted.data!.id != localSortedPlayer.id) {
        await playerRepository.saveSortedPlayerLocal(playerSorted.data!);
        await localPreferences.resetPlayerGuesses();
      }
    }
    if (playerRepository.getSortedPlayerLocal() == null ||
        playerRepository.getAllPlayersLocal().isEmpty) {
      return Future.error('Erro ao carregar dados, tente novamente mais tarde');
    }
    return [];
  } catch (e) {
    return Future.error('Erro ao carregar dados, tente novamente mais tarde');
  }
  //print(playerRepository.getAllPlayersLocal()[0]);
  //print(playerRepository.getSortedPlayerLocal());
  //print((await playerRepository.getVersionNumber()).data);
}

class Injector extends StatelessWidget {
  final Widget child;
  const Injector({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LocalPreferences>(
          create: (context) => LocalPreferences(),
        ),
        Provider<PlayerRepository>(
          create: (context) => PlayerRepositoryImpl(
              SupabaseHandler(),
              PlayerMapper(),
              HistoryMapper(),
              context.read<LocalPreferences>()),
        ),
        Provider<GetSortedPlayerUseCase>(
          create: (context) =>
              GetSortedPlayerUseCase(context.read<PlayerRepository>()),
        ),
        Provider<GetAllPlayersUseCase>(
          create: (context) =>
              GetAllPlayersUseCase(context.read<PlayerRepository>()),
        ),
        Provider<GetAllPlayerGuessesUseCase>(
          create: (context) =>
              GetAllPlayerGuessesUseCase(context.read<PlayerRepository>()),
        ),
        Provider<AddPlayerGuessesUseCase>(
          create: (context) =>
              AddPlayerGuessesUseCase(context.read<PlayerRepository>()),
        ),
        Provider<GetSortedPlayerLocalUseCase>(
          create: (context) =>
              GetSortedPlayerLocalUseCase(context.read<PlayerRepository>()),
        ),
        Provider<GetAllPlayerLocalUseCase>(
          create: (context) =>
              GetAllPlayerLocalUseCase(context.read<PlayerRepository>()),
        ),
        Provider<GetUserHistoryUseCase>(
          create: (context) =>
              GetUserHistoryUseCase(context.read<PlayerRepository>()),
        ),
        Provider<SetUserHistoryUseCase>(
          create: (context) =>
              SetUserHistoryUseCase(context.read<PlayerRepository>()),
        ),
        Provider<SendFeedbackUseCase>(
          create: (context) =>
              SendFeedbackUseCase(context.read<PlayerRepository>()),
        ),
        Provider<GetOrderNumberUseCase>(
          create: (context) =>
              GetOrderNumberUseCase(context.read<PlayerRepository>()),
        ),
      ],
      child: Builder(builder: (context) {
        return FutureBuilder(
          future: _loadData(context.read<PlayerRepository>(),
              context.read<LocalPreferences>()),
          builder: (ctx, snp) {
            if (snp.hasData) {
              return child;
            } else if (snp.hasError) {
              return const CustomErrorWidget(
                  msg: "Erro ao carregar dados, tente novamente mais tarde");
            } else {
              return Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            "assets/bg_bota.png",
                          ),
                          fit: BoxFit.cover)),
                  child: const Center(
                      child: CircularProgressIndicator(
                    color: Colors.white,
                  )));
            }
          },
        );
      }),
    );
  }
}
