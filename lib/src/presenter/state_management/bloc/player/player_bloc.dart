import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:fogooo/src/core/utils/utils.dart';
import 'package:fogooo/src/domain/entities/player_entity.dart';
import 'package:fogooo/src/domain/usecases/add_player_guesses_usecase.dart';
import 'package:fogooo/src/domain/usecases/get_all_players_local_usecase.dart';
import 'package:fogooo/src/domain/usecases/talvez%20remover/get_all_players_usecase.dart';
import 'package:fogooo/src/domain/usecases/get_player_guesses_usecase.dart';
import 'package:fogooo/src/domain/usecases/get_sorted_player_local_usecase.dart';
import 'package:fogooo/src/presenter/state_management/bloc/player/player_event.dart';
import 'package:fogooo/src/presenter/state_management/bloc/player/player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final GetAllPlayerLocalUseCase getAllPlayerLocalUseCase;
  final GetSortedPlayerLocalUseCase getSortedPlayerLocalUseCase;
  final AddPlayerGuessesUseCase addPlayerGuessesUseCase;
  final GetAllPlayerGuessesUseCase getAllPlayerGuessesUseCase;

  PlayerBloc(
      {required this.getAllPlayerLocalUseCase,
      required this.getSortedPlayerLocalUseCase,
      required this.addPlayerGuessesUseCase,
      required this.getAllPlayerGuessesUseCase})
      : super(const PlayerEmptyState(
            playersList: [], sortedPlayer: null, guessList: [])) {
    print("creiei");
    on<LoadDataEvent>(_loadData);
    on<AddPlayerGuessEvent>(_guessPlayer);
  }
  bool addedPlayer = false;
  Future<void> _loadData(LoadDataEvent event, Emitter<PlayerState> emit) async {
    addedPlayer = false;
    emit(PlayerLoadingState(
        guessList: state.guessList,
        playersList: state.playersList,
        sortedPlayer: state.sortedPlayer));
    List<Player> players = await getAllPlayerGuessesUseCase();
    List<Player> allPlayers = getAllPlayerLocalUseCase();
    Player sortedPlayer = getSortedPlayerLocalUseCase()!;
    bool isCompleted = false;
    for (Player player in players) {
      if (allPlayers.contains(player)) {
        allPlayers.remove(player);
      }
      if (sortedPlayer.id == player.id) {
        isCompleted = true;
      }
    }
    if (isCompleted) {
      emit(PlayerFinishedState(
          playersList: allPlayers,
          sortedPlayer: sortedPlayer,
          guessList: players));
    } else {
      emit(PlayerFilledState(
          playersList: allPlayers,
          sortedPlayer: sortedPlayer,
          guessList: players));
    }
  }

  Future<void> _guessPlayer(
      AddPlayerGuessEvent event, Emitter<PlayerState> emit) async {
    addedPlayer = true;
    print("_guessPlayer(event, emit)1 ${state.guessList.length} ");
    var guessList = List<Player>.from(state.guessList);
    state.playersList.remove(event.player);

    guessList.add(event.player!);
    if (event.player!.id == state.sortedPlayer!.id) {
      emit(PlayerFinishedState(
          playersList: state.playersList,
          sortedPlayer: state.sortedPlayer,
          guessList: guessList));
    } else {
      emit(
        PlayerFilledState(
            playersList: state.playersList,
            sortedPlayer: state.sortedPlayer,
            guessList: guessList),
      );
    }
    print("_guessPlayer(event, emit)1 ${state.guessList.length} ");

    await addPlayerGuessesUseCase(event.player!);
  }

  List<Player> showSuggestions(String text) {
    //await Future.delayed(Duration(seconds: 5));
    String textUpdated = Utils.removeDiacritics(text.toLowerCase());
    var list = state.playersList
        .where((element) => element.caseSearch.contains(textUpdated))
        .toList();

    var others = state.playersList
        .where((element) =>
            !list.contains(element) &&
            (element.oficialName.split(" ").any((element) =>
                    Utils.removeDiacritics(element.toLowerCase().trim())
                        .startsWith(textUpdated)) ||
                element.name.split(" ").any((element) =>
                    Utils.removeDiacritics(element.toLowerCase().trim())
                        .startsWith(textUpdated))))
        .toList();
    return [...list, ...others];
  }
}
