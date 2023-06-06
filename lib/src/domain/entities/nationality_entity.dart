import 'package:equatable/equatable.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Nationality extends Equatable {
  final int id;
  final String country;
  final String image;
  const Nationality({
    required this.id,
    required this.country,
    required this.image,
  });

  @override
  List<Object> get props => [id, country, image];
}
