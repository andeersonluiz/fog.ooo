import 'package:bloc/bloc.dart';
import 'package:fogooo/src/domain/entities/user_history_entity.dart';
import 'package:fogooo/src/domain/entities/victory_info_entity.dart';
import 'package:fogooo/src/domain/usecases/get_user_history_usecase.dart';
import 'package:fogooo/src/presenter/state_management/bloc/user/user_event.dart';
import 'package:fogooo/src/presenter/state_management/bloc/user/user_state.dart';
import 'package:intl/intl.dart';

import '../../../../domain/usecases/set_user_history_usecase.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserHistoryUseCase getUserHistoryUseCase;
  final SetUserHistoryUseCase setUserHistoryUseCase;

  UserBloc(
      {required this.getUserHistoryUseCase,
      required this.setUserHistoryUseCase})
      : super(const EmptyUserHistory()) {
    on<LoadUserHistoryEvent>(_loadUserHistory);
    on<SaveUserHistoryEvent>(_setUserHistory);
  }
  double maxX = 0;

  void _loadUserHistory(LoadUserHistoryEvent event, Emitter<UserState> emit) {
    var result = getUserHistoryUseCase();
    //emit(FilledUserHistory(userHistory: result));

    //DateFormat df = DateFormat('dd/MM/yy');
    /*result = UserHistory(streaks: 4, victorys: 18, victoryList: [
      VictoryInfo(date: '25/05/23', attempts: 10),
      VictoryInfo(date: '26/05/23', attempts: 15),
      VictoryInfo(date: '27/05/23', attempts: 5),
      VictoryInfo(date: '28/05/23', attempts: 20),
      VictoryInfo(date: '30/05/23', attempts: 1),
      VictoryInfo(date: '31/05/23', attempts: 3),
      VictoryInfo(date: '1/06/23', attempts: 28),
      VictoryInfo(date: '2/06/23', attempts: 10),
      VictoryInfo(date: '3/06/23', attempts: 28),
      VictoryInfo(date: '4/06/23', attempts: 10),
      VictoryInfo(date: '5/06/23', attempts: 28),
      VictoryInfo(date: '6/06/23', attempts: 10),
      VictoryInfo(date: '7/06/23', attempts: 28),
      VictoryInfo(date: '8/06/23', attempts: 10),
      VictoryInfo(date: '9/06/23', attempts: 28),
      VictoryInfo(date: '10/06/23', attempts: 10),
      VictoryInfo(date: '11/06/23', attempts: 28),
      VictoryInfo(date: '12/06/23', attempts: 10)
    ]);*/
    int firstVictory = 0;
    double average = 0;
    if (result.victoryList.isNotEmpty) {
      firstVictory = result.victoryList
          .where((element) => element.attempts == 1)
          .toList()
          .length;
      average = result.victoryList
              .map((e) => e.attempts)
              .toList()
              .reduce((a, b) => a + b) /
          result.victoryList.length;
    }

    emit(FilledUserHistory(
        userHistory: result,
        meanAttempts: average,
        firstVictory: firstVictory));
  }

  Future<void> _setUserHistory(
      SaveUserHistoryEvent event, Emitter<UserState> emit) async {
    emit(LoadingUserHistory(userHistory: state.userHistory));

    UserHistory tempUserHistory = state.userHistory!;

    int victorys = tempUserHistory.victorys + 1;
    int streaks = tempUserHistory.streaks;
    List<VictoryInfo> victoryList = tempUserHistory.victoryList;
    if (victoryList.isEmpty) {
      streaks = 1;
    } else {
      var oldVictory =
          DateFormat('dd/MM/yyyy').parse(tempUserHistory.victoryList.last.date);
      var actualData = DateTime.now();
      if (actualData.difference(oldVictory).inDays == 1) {
        streaks += 1;
      } else {
        streaks = 1;
      }
    }
    String dateNow = DateFormat('dd/MM/yyyy').format(DateTime.now());
    var index = victoryList.indexWhere((element) => element.date == dateNow);
    if (index != -1) {
      return emit(FilledUserHistory(
          userHistory: state.userHistory,
          firstVictory: victoryList
              .where((element) => element.attempts == 1)
              .toList()
              .length,
          meanAttempts: victoryList
                  .map((e) => e.attempts)
                  .toList()
                  .reduce((a, b) => a + b) /
              victoryList.length));
    }
    victoryList.add(VictoryInfo(date: dateNow, attempts: event.attempts));
    UserHistory updatedUserHistory = UserHistory(
        streaks: streaks, victorys: victorys, victoryList: victoryList);
    bool value = await setUserHistoryUseCase(updatedUserHistory);

    int firstVictory = 0;
    double average = 0;
    firstVictory =
        victoryList.where((element) => element.attempts == 1).toList().length;
    average =
        victoryList.map((e) => e.attempts).toList().reduce((a, b) => a + b) /
            victoryList.length;

    if (value) {
      return emit(FilledUserHistory(
          userHistory: updatedUserHistory,
          firstVictory: firstVictory,
          meanAttempts: average));
    }
  }
}
