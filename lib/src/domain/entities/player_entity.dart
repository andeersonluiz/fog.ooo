import 'package:equatable/equatable.dart';
import 'package:fogooo/src/domain/entities/club_entity.dart';
import 'package:fogooo/src/domain/entities/nationality_entity.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Player extends Equatable {
  final int id;
  final String name;
  final String oficialName;
  final String infoUrl;
  final Nationality nationality;
  final String pos;
  final int age;
  final int matches;
  final int goals;
  final List<Club> clubHistory;
  final String imageUrl;
  final List<String> caseSearch;
  final List<String> yearsPlayedInterval;
  final List<int> yearsPlayed;
  const Player(
      {required this.id,
      required this.name,
      required this.oficialName,
      required this.infoUrl,
      required this.nationality,
      required this.pos,
      required this.age,
      required this.matches,
      required this.goals,
      required this.clubHistory,
      required this.imageUrl,
      required this.caseSearch,
      required this.yearsPlayedInterval,
      required this.yearsPlayed});

  @override
  List<Object> get props {
    return [
      id,
      name,
      oficialName,
      infoUrl,
      nationality,
      pos,
      age,
      matches,
      goals,
      clubHistory,
      imageUrl,
      caseSearch,
      yearsPlayedInterval,
      yearsPlayed
    ];
  }
}
