import 'dart:convert';

import 'package:equatable/equatable.dart';

class Prize extends Equatable {
  final String name;
  final int index;
  final String img;
  final String? stack;

  Prize({
    required this.name,
    required this.index,
    required this.img,
    this.stack,
  });

  // Article({@required this.id, @required this.title, @required this.description, this.Order, @required this.publishid, this.tags});

  @override
  List<Object?> get props => [name, index, img];
}
