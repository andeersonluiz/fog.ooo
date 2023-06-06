// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class Club extends Equatable {
  final int id;
  final String image;
  final String country;
  final String clubName;
  const Club({
    required this.id,
    required this.image,
    required this.country,
    required this.clubName,
  });

  @override
  List<Object> get props => [id, image, country, clubName];
}
