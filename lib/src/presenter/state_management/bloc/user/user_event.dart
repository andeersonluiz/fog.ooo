// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class UserEvent extends Equatable {
  final int attempts;
  const UserEvent({
    required this.attempts,
  });

  @override
  List<Object> get props => [attempts];
}

class LoadUserHistoryEvent extends UserEvent {
  const LoadUserHistoryEvent() : super(attempts: 0);
}

class SaveUserHistoryEvent extends UserEvent {
  const SaveUserHistoryEvent({required super.attempts});
}
