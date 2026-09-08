import 'package:equatable/equatable.dart';

import '../../../../topscore/domain/entities/statistics_sub/team.dart';

class Last5Goals extends Equatable {
  int total;
  String average;

  Last5Goals({required this.total, required this.average});

  //Now we will create a factory method to copy the data from
  // the json file
  @override
  List<Object?> get props => [total, average];

  Map<String, dynamic> toMap() {
    return {
      'total': total,
      'average': average,
    };
  }

  factory Last5Goals.fromMap(Map<String, dynamic> map) {
    return Last5Goals(total: map['total'], average: map['average']);
  }
}
