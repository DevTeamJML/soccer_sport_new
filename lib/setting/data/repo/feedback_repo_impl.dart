import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/products/domain/entities/cart.dart';
import 'package:soccer_sport/products/domain/entities/cart_item.dart';
import 'package:soccer_sport/products/domain/entities/category.dart';
import 'package:soccer_sport/products/domain/entities/coupon.dart';
import 'package:soccer_sport/products/domain/entities/product.dart';
import 'package:soccer_sport/setting/domain/entity/feedback.dart';
import 'package:soccer_sport/setting/domain/repo/feedback_repo.dart';

import '../datasources/feedback_api.dart';

class FeedbackRepositoryImpl implements FeedbackRepository {
  final FeedbackApiDataSource apiDataSource;
  // final ProductLocalDataSource localDataSource;
  // final ArticleLocalDataSource localDataSource;

  FeedbackRepositoryImpl({
    required this.apiDataSource,
    // required this.localDataSource,
  });

  @override
  Future<Either<Failure, bool>> sendFeedback(FeedbackC feedback) async {
    try {
      final product = await apiDataSource.sendFeedback(feedback);

      return Right(product);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
