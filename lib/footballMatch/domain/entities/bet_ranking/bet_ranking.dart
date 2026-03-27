import 'package:equatable/equatable.dart';

class BetRanking extends Equatable {
  int total_win;
  int total_coin;
  int last_bet;
  String name;
  BetRanking(
      {required this.total_win,
      required this.name,
      required this.last_bet,
      required this.total_coin});

  @override
  List<Object?> get props => [
        total_win,
        name,
        total_coin,
        last_bet,
      ];

  factory BetRanking.fromJson(Map<String, dynamic> json) {
    return BetRanking(
      total_coin: int.parse(json['total_coin']),
      total_win: int.parse(json['total_win']),
      name: json['user_login'] != null ? json['user_login'] : null,
      last_bet: json['last_bet'] != null ? json['last_bet'] : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_coin': total_coin,
      'total_win': total_win,
      'user_login': name,
      'last_bet': last_bet,
    };
  }
}
