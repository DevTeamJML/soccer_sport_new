import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/news/domain/entities/news.dart';
import 'package:soccer_sport/news/domain/repositories/news_repository.dart';
import 'package:wordpress_api/wordpress_api.dart';

class LoadNews extends UseCase<List<News>, LoadNewsParams> {
  final NewsRepository repository;

  LoadNews(this.repository);

  Future<Either<Failure, List<News>>> call(LoadNewsParams params) async {
    return await repository.loadNews(params.page);
  }
}

class LoadNewsParams extends Equatable {
  final String page;
  LoadNewsParams({
    required this.page,
  });

  @override
  List<Object> get props => [page];
}
