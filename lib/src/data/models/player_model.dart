// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:fogooo/src/data/models/club_model.dart';
import 'package:fogooo/src/data/models/nationality_model.dart';

class PlayerModel extends Equatable {
  final int id;
  final String name;
  final String oficialName;
  final String infoUrl;
  final NationalityModel nationality;
  final String pos;
  final int age;
  final int matches;
  final bool playedTeam;
  final int goals;
  final List<ClubModel> clubHistory;
  final String imageUrl;
  final List<String> caseSearch;
  final List<String> yearsPlayedInterval;
  final List<int> yearsPlayed;
  const PlayerModel(
      {required this.id,
      required this.name,
      required this.oficialName,
      required this.infoUrl,
      required this.nationality,
      required this.pos,
      required this.age,
      required this.matches,
      required this.playedTeam,
      required this.goals,
      required this.clubHistory,
      required this.imageUrl,
      required this.caseSearch,
      required this.yearsPlayedInterval,
      required this.yearsPlayed});

  PlayerModel copyWith({
    int? id,
    String? name,
    String? oficialName,
    String? infoUrl,
    NationalityModel? nationality,
    String? pos,
    int? age,
    int? matches,
    bool? playedTeam,
    int? goals,
    List<ClubModel>? clubHistory,
    String? imageUrl,
    List<String>? caseSearch,
    List<String>? yearsPlayedInterval,
    List<int>? yearsPlayed,
  }) {
    return PlayerModel(
        id: id ?? this.id,
        name: name ?? this.name,
        oficialName: oficialName ?? this.oficialName,
        infoUrl: infoUrl ?? this.infoUrl,
        nationality: nationality ?? this.nationality,
        pos: pos ?? this.pos,
        age: age ?? this.age,
        matches: matches ?? this.matches,
        playedTeam: this.playedTeam,
        goals: goals ?? this.goals,
        clubHistory: clubHistory ?? this.clubHistory,
        imageUrl: imageUrl ?? this.imageUrl,
        caseSearch: caseSearch ?? this.caseSearch,
        yearsPlayedInterval: yearsPlayedInterval ?? this.yearsPlayedInterval,
        yearsPlayed: yearsPlayed ?? this.yearsPlayed);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'oficialName': oficialName,
      'infoUrl': infoUrl,
      'nationality': nationality.toMap(),
      'pos': pos,
      'age': age,
      'playedTeam': playedTeam,
      'matches': matches,
      'goals': goals,
      'clubHistory': clubHistory.map((x) => x.toMap()).toList(),
      'imageUrl': imageUrl,
      'caseSearch': caseSearch,
      'yearsPlayed': yearsPlayed,
      'yearsPlayedInterval': yearsPlayedInterval
    };
  }

  factory PlayerModel.fromMap(Map<String, dynamic> map) {
    int age = map['age'] as int;
    if (age == -1) {
      age = 500;
    }
    return PlayerModel(
        id: map['id'] as int,
        name: map['name'] as String,
        oficialName: map['oficialName'] as String,
        infoUrl: map['infoUrl'] as String,
        nationality: NationalityModel.fromMap(
            map['nationality'] as Map<String, dynamic>),
        pos: map['pos'] as String,
        age: age,
        playedTeam: map['playedTeam'] as bool,
        matches: map['matches'] as int,
        goals: map['goals'] as int,
        clubHistory: List<ClubModel>.from(
          map['clubHistory'].map<ClubModel>(
            (x) => ClubModel.fromMap(x as Map<String, dynamic>),
          ),
        ),
        imageUrl: map['imageUrl'] as String,
        caseSearch: List<String>.from(map['caseSearch']),
        yearsPlayedInterval: List<String>.from(map['yearsPlayedInterval']),
        yearsPlayed: List<int>.from(map['yearsPlayed']));
  }

  String toJson() => json.encode(toMap());

  factory PlayerModel.fromJson(String source) =>
      PlayerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

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
      playedTeam,
      goals,
      clubHistory,
      imageUrl,
      caseSearch,
      yearsPlayedInterval,
      yearsPlayed
    ];
  }
}
