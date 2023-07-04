import 'package:bloc/bloc.dart';
import 'package:fogooo/src/core/utils/utils.dart';
import 'package:fogooo/src/domain/entities/player_entity.dart';
import 'package:fogooo/src/domain/usecases/add_player_guesses_usecase.dart';
import 'package:fogooo/src/domain/usecases/get_all_players_local_usecase.dart';
import 'package:fogooo/src/domain/usecases/get_order_number_usecase.dart';
import 'package:fogooo/src/domain/usecases/get_player_guesses_usecase.dart';
import 'package:fogooo/src/domain/usecases/get_sorted_player_local_usecase.dart';
import 'package:fogooo/src/presenter/state_management/bloc/player/player_event.dart';
import 'package:fogooo/src/presenter/state_management/bloc/player/player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final GetAllPlayerLocalUseCase getAllPlayerLocalUseCase;
  final GetSortedPlayerLocalUseCase getSortedPlayerLocalUseCase;
  final AddPlayerGuessesUseCase addPlayerGuessesUseCase;
  final GetAllPlayerGuessesUseCase getAllPlayerGuessesUseCase;
  final GetOrderNumberUseCase getOrderNumberUseCase;
  PlayerBloc(
      {required this.getAllPlayerLocalUseCase,
      required this.getSortedPlayerLocalUseCase,
      required this.addPlayerGuessesUseCase,
      required this.getAllPlayerGuessesUseCase,
      required this.getOrderNumberUseCase})
      : super(const PlayerEmptyState(
            playersList: [],
            sortedPlayer: null,
            guessList: [],
            finishedGame: false,
            orderNumber: -1)) {
    on<LoadDataEvent>(_loadData);
    on<AddPlayerGuessEvent>(_guessPlayer);
    on<FinishedPlayerEvent>(_finishGame);
  }
  final int _limiter = 15;
  bool addedPlayer = false;
  Future<void> _loadData(LoadDataEvent event, Emitter<PlayerState> emit) async {
    addedPlayer = false;
    emit(PlayerLoadingState(
        guessList: state.guessList,
        playersList: state.playersList,
        sortedPlayer: state.sortedPlayer,
        finishedGame: state.finishedGame,
        orderNumber: state.orderNumber));
    int orderNumber = await getOrderNumberUseCase();
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
          guessList: players,
          orderNumber: orderNumber,
          finishedGame: isCompleted));
    } else {
      emit(PlayerFilledState(
          playersList: allPlayers,
          sortedPlayer: sortedPlayer,
          guessList: players,
          orderNumber: orderNumber,
          finishedGame: isCompleted));
    }
  }

  Future<void> _guessPlayer(
      AddPlayerGuessEvent event, Emitter<PlayerState> emit) async {
    addedPlayer = true;
    var guessList = List<Player>.from(state.guessList);
    state.playersList.remove(event.player);

    guessList.add(event.player!);

    emit(
      PlayerFilledState(
          playersList: state.playersList,
          sortedPlayer: state.sortedPlayer,
          guessList: guessList,
          finishedGame: state.finishedGame,
          orderNumber: state.orderNumber),
    );

    await addPlayerGuessesUseCase(event.player!);
  }

  Future<void> _finishGame(
      FinishedPlayerEvent event, Emitter<PlayerState> emit) async {
    return emit(PlayerFinishedState(
        playersList: state.playersList,
        sortedPlayer: state.sortedPlayer,
        guessList: state.guessList,
        orderNumber: state.orderNumber,
        finishedGame: true));
  }

  List<Player> showSuggestions(String text) {
    if (text.isEmpty) {
      var list = state.playersList;
      list.sort((a, b) => a.matches.compareTo(b.matches));

      if (list.length < _limiter) {
        return list.sublist(0, list.length);
      }
      return list.sublist(0, _limiter);
    }
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
