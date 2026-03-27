import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/news/domain/entities/news.dart';
import 'package:soccer_sport/news/domain/entities/news_content.dart';
import 'package:soccer_sport/news/domain/repositories/news_repository.dart';
import 'package:wordpress_api/wordpress_api.dart';

class GetNewContent extends UseCase<NewsContent, GetNewContentParams> {
  final NewsRepository repository;

  GetNewContent(this.repository);

  Future<Either<Failure, NewsContent>> call(GetNewContentParams params) async {
    return await repository.getNewContent(params.id, params.userid);
  }
}

class GetNewContentParams extends Equatable {
  final String id;
  final int? userid;

  GetNewContentParams({
    required this.id,
    this.userid,
  });

  @override
  List<Object?> get props => [id, userid];
}
