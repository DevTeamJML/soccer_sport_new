import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/favorite_match/domain/repository/favorite_match_repository.dart';
import 'package:soccer_sport/news/domain/entities/news.dart';
import 'package:soccer_sport/news/domain/repositories/news_repository.dart';
import 'package:soccer_sport/notification/domain/repository/notification_repository.dart';
import 'package:wordpress_api/wordpress_api.dart';

class RemoveAllFavoriteMatch extends UseCase<bool, NoParams> {
  final FavoriteMatchRepository repository;

  RemoveAllFavoriteMatch(this.repository);

  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.removeAllFavoriteMatch();
  }
}
