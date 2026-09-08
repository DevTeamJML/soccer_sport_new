import 'package:equatable/equatable.dart';

import '../../../../topscore/domain/entities/statistics_sub/team.dart';

class LeagueStat extends Equatable {
  String? form;

  LeagueStat({
    this.form,
  });

  //Now we will create a factory method to copy the data from
  // the json file
  @override
  List<Object?> get props => [
        form,
      ];

  Map<String, dynamic> toMap() {
    return {
      'form': form,
    };
  }

  factory LeagueStat.fromMap(Map<String, dynamic> map) {
    var value = 0;

    return LeagueStat(
      form: map['form'] != null ? map['form'] : null,
    );
  }
}
