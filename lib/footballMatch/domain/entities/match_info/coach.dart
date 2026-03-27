import 'package:equatable/equatable.dart';

import '../../../../topscore/domain/entities/statistics_sub/team.dart';

class Coach extends Equatable {
  int id;
  String name;
  String? imgUrl;

  Coach({required this.name, required this.id, this.imgUrl});

  //Now we will create a factory method to copy the data from
  // the json file
  @override
  List<Object?> get props => [name, id, imgUrl];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'photo': imgUrl,
    };
  }

  factory Coach.fromMap(Map<String, dynamic> map) {
    var value = 0;

    return Coach(
      name: map['name'] ?? '',
      id: map['id'] != null ? map['id'] : 0,
      imgUrl: map['photo'] != null ? map['photo'] : null,
    );
  }
}
