import 'package:equatable/equatable.dart';

class Team extends Equatable {
  String name;
  String logoUrl;
  bool? winner;
  Team({required this.name, required this.logoUrl, this.winner});

  @override
  List<Object?> get props => [
        name,
        logoUrl,
        winner,
      ];

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
        name: json['name'],
        logoUrl: json['logo'],
        winner: json['winner'] == null ? null : json['winner']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'logo': logoUrl,
      'winner': winner,
    };
  }
}
