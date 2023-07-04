// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'package:fogooo/src/data/models/victory_info_model.dart';

class UserHistoryModel extends Equatable {
  final int victorys;
  final int streaks;
  final List<VictoryInfoModel> victoryList;
  const UserHistoryModel({
    required this.victorys,
    required this.streaks,
    required this.victoryList,
  });

  UserHistoryModel copyWith({
    int? victorys,
    int? streaks,
    List<VictoryInfoModel>? victoryList,
  }) {
    return UserHistoryModel(
      victorys: victorys ?? this.victorys,
      streaks: streaks ?? this.streaks,
      victoryList: victoryList ?? this.victoryList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'victorys': victorys,
      'streaks': streaks,
      'victoryList': victoryList.map((x) => x.toMap()).toList(),
    };
  }

  factory UserHistoryModel.fromMap(Map<String, dynamic> map) {
    return UserHistoryModel(
      victorys: map['victorys'] as int,
      streaks: map['streaks'] as int,
      victoryList: List<VictoryInfoModel>.from(
        (map['victoryList']).map<VictoryInfoModel>(
          (x) => VictoryInfoModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserHistoryModel.fromJson(String source) =>
      UserHistoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'UserHistoryModel(victorys: $victorys, streaks: $streaks, victoryList: $victoryList)';

  @override
  bool operator ==(covariant UserHistoryModel other) {
    if (identical(this, other)) return true;

    return other.victorys == victorys &&
        other.streaks == streaks &&
        listEquals(other.victoryList, victoryList);
  }

  @override
  int get hashCode =>
      victorys.hashCode ^ streaks.hashCode ^ victoryList.hashCode;

  @override
  List<Object> get props => [victorys, streaks, victoryList];
}
