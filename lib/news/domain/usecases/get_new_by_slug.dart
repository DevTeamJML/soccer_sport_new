import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/news/domain/entities/news.dart';
import 'package:soccer_sport/news/domain/entities/news_content.dart';
import 'package:soccer_sport/news/domain/repositories/news_repository.dart';
import 'package:wordpress_api/wordpress_api.dart';

class GetNewsBySlug extends UseCase<News, GetNewsBySlugParams> {
  final NewsRepository repository;

  GetNewsBySlug(this.repository);

  Future<Either<Failure, News>> call(GetNewsBySlugParams params) async {
    return await repository.getNewsBySlug(params.slug);
  }
}

class GetNewsBySlugParams extends Equatable {
  final String slug;

  GetNewsBySlugParams({
    required this.slug,
  });

  @override
  List<Object?> get props => [id, slug];
}
