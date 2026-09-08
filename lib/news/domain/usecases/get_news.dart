import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/news/domain/entities/news.dart';
import 'package:soccer_sport/news/domain/repositories/news_repository.dart';
import 'package:wordpress_api/wordpress_api.dart';

class GetNews extends UseCase<List<News>, GetNewsParams> {
  final NewsRepository repository;

  GetNews(this.repository);

  Future<Either<Failure, List<News>>> call(GetNewsParams params) async {
    return await repository.getNews(params.page);
  }
}

class GetNewsParams extends Equatable {
  final String page;
  GetNewsParams({
    required this.page,
  });

  @override
  List<Object> get props => [page];
}
