import 'package:equatable/equatable.dart';

class Time extends Equatable {
  int elapsed;
  int? extra;
  Time({required this.elapsed, this.extra});

  @override
  List<Object?> get props => [
        elapsed,
        extra,
      ];

  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(
      elapsed: json['elapsed'],
      extra: json['extra'] != null ? json['extra'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'elapsed': elapsed,
      'extra': extra,
    };
  }
}
