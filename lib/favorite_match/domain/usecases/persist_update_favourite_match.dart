import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/favorite_match/domain/repository/favorite_match_repository.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/news/domain/entities/news.dart';
import 'package:soccer_sport/news/domain/repositories/news_repository.dart';
import 'package:soccer_sport/notification/domain/repository/notification_repository.dart';
import 'package:wordpress_api/wordpress_api.dart';

class PersistUpdateFavoriteMatch
    extends UseCase<bool, PersistUpdateFavoriteMatchParams> {
  final FavoriteMatchRepository repository;

  PersistUpdateFavoriteMatch(this.repository);

  Future<Either<Failure, bool>> call(
      PersistUpdateFavoriteMatchParams params) async {
    return await repository.persistUpdateFavoriteMatch(params.match);
  }
}

class PersistUpdateFavoriteMatchParams extends Equatable {
  final List<FootballMatch> match;
  PersistUpdateFavoriteMatchParams({
    required this.match,
  });

  @override
  List<Object> get props => [match];
}
