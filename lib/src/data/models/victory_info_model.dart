// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class VictoryInfoModel extends Equatable {
  final String date;
  final int attempts;
  const VictoryInfoModel({
    required this.date,
    required this.attempts,
  });

  VictoryInfoModel copyWith({
    String? date,
    int? attempts,
  }) {
    return VictoryInfoModel(
      date: date ?? this.date,
      attempts: attempts ?? this.attempts,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date,
      'attempts': attempts,
    };
  }

  factory VictoryInfoModel.fromMap(Map<String, dynamic> map) {
    return VictoryInfoModel(
      date: map['date'] as String,
      attempts: map['attempts'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory VictoryInfoModel.fromJson(String source) =>
      VictoryInfoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'VictoryInfoModel(date: $date, attempts: $attempts)';

  @override
  bool operator ==(covariant VictoryInfoModel other) {
    if (identical(this, other)) return true;

    return other.date == date && other.attempts == attempts;
  }

  @override
  int get hashCode => date.hashCode ^ attempts.hashCode;

  @override
  List<Object> get props => [date, attempts];
}
