// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class ClubModel extends Equatable {
  final int id;
  final String image;
  final String country;
  final String clubName;
  const ClubModel({
    required this.id,
    required this.image,
    required this.country,
    required this.clubName,
  });

  ClubModel copyWith({
    int? id,
    String? image,
    String? country,
    String? clubName,
  }) {
    return ClubModel(
      id: id ?? this.id,
      image: image ?? this.image,
      country: country ?? this.country,
      clubName: clubName ?? this.clubName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'image': image,
      'country': country,
      'clubName': clubName,
    };
  }

  factory ClubModel.fromMap(Map<String, dynamic> map) {
    return ClubModel(
      id: map['id'] as int,
      image: map['image'] as String,
      country: map['country'] as String,
      clubName: map['clubName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClubModel.fromJson(String source) =>
      ClubModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, image, country, clubName];
}
