import 'package:equatable/equatable.dart';

class Team extends Equatable {
  int id;
  String name;
  String logoUrl;
  bool? winner;
  Team(
      {required this.id,
      required this.name,
      required this.logoUrl,
      this.winner});

  @override
  List<Object?> get props => [
        id,
        name,
        logoUrl,
        winner,
      ];
}
