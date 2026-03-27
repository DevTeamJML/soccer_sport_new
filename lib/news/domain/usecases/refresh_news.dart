import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/news/domain/entities/news.dart';
import 'package:soccer_sport/news/domain/repositories/news_repository.dart';
import 'package:wordpress_api/wordpress_api.dart';

class RefreshNews extends UseCase<List<News>, NoParams> {
  final NewsRepository repository;

  RefreshNews(this.repository);

  Future<Either<Failure, List<News>>> call(NoParams params) async {
    return await repository.refreshNews();
  }
}
