// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class NationalityModel extends Equatable {
  final int id;
  final String country;
  final String image;
  const NationalityModel({
    required this.id,
    required this.country,
    required this.image,
  });

  NationalityModel copyWith({
    int? id,
    String? country,
    String? image,
  }) {
    return NationalityModel(
      id: id ?? this.id,
      country: country ?? this.country,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'country': country,
      'image': image,
    };
  }

  factory NationalityModel.fromMap(Map<String, dynamic> map) {
    return NationalityModel(
      id: map['id'] as int,
      country: map['country'] as String,
      image: map['image'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory NationalityModel.fromJson(String source) =>
      NationalityModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, country, image];
}
