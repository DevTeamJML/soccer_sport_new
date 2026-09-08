import 'package:soccer_sport/footballMatch/domain/entities/team.dart';
import 'package:soccer_sport/footballMatch/domain/entities/venue.dart';

class VenueModel extends Venue {
  VenueModel({
    required int id,
    required String name,
    required String city,
    bool? winner,
  }) : super(
          id: id,
          name: name,
          city: city,
        );

  factory VenueModel.fromJson(Map<String, dynamic> json) {
    return VenueModel(
      id: json['id'],
      name: json['name'],
      city: json['city'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
    };
  }
}
