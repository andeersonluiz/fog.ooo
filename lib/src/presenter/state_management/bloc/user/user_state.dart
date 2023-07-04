// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:fogooo/src/domain/entities/user_history_entity.dart';

class UserState extends Equatable {
  final UserHistory? userHistory;
  final double meanAttempts;
  final int firstVictory;
  const UserState({
    this.userHistory,
    this.meanAttempts = 0,
    this.firstVictory = 0,
  });

  @override
  List<Object> get props => [userHistory ?? ""];
}

class EmptyUserHistory extends UserState {
  const EmptyUserHistory();
}

class LoadingUserHistory extends UserState {
  const LoadingUserHistory({required super.userHistory});
}

class FilledUserHistory extends UserState {
  const FilledUserHistory(
      {required super.userHistory,
      required super.meanAttempts,
      required super.firstVictory});
}
