import 'package:equatable/equatable.dart';

class Venue extends Equatable {
  int id;
  String name;
  String city;
  Venue({
    required this.id,
    required this.name,
    required this.city,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        city,
      ];
}
