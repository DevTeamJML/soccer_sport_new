import 'package:soccer_sport/footballMatch/domain/entities/team.dart';

class TeamModel extends Team {
  TeamModel({
    required int id,
    required String name,
    required String logoUrl,
    bool? winner,
  }) : super(
          id: id,
          name: name,
          logoUrl: logoUrl,
          winner: winner,
        );

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
        id: json['id'],
        name: json['name'],
        logoUrl: json['logo'],
        winner: json['winner'] == null ? false : json['winner']);
  }

  TeamModel.fromEntity(Team teamModel)
      : super(
          id: teamModel.id,
          name: teamModel.name,
          logoUrl: teamModel.logoUrl,
          winner: teamModel.winner,
        );
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logoUrl,
      'winner': winner,
    };
  }
}
