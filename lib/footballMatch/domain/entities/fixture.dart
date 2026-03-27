import 'package:equatable/equatable.dart';
import 'package:soccer_sport/footballMatch/domain/entities/status.dart';

class Fixture extends Equatable {
  final int id;
  final String date;
  final String? referee;
  final String? timeZone;
  final Status status;
  final int? timeStamp;
  Fixture({
    required this.id,
    required this.date,
    required this.status,
    this.timeZone,
    this.timeStamp,
    this.referee,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.image, @required this.publishDate, this.tags});

  @override
  List<Object?> get props => [id, date, referee, timeZone, timeStamp, status];
}
