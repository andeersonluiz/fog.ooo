// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:fogooo/src/domain/entities/victory_info_entity.dart';

class UserHistory extends Equatable {
  final int victorys;
  final int streaks;
  final List<VictoryInfo> victoryList;
  const UserHistory({
    required this.victorys,
    required this.streaks,
    required this.victoryList,
  });

  @override
  List<Object> get props => [victorys, streaks, victoryList];
}
