// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class VictoryInfo extends Equatable {
  final String date;
  final int attempts;
  const VictoryInfo({
    required this.date,
    required this.attempts,
  });

  @override
  List<Object> get props => [date, attempts];
}
