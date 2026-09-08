import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/products/domain/entities/coupon.dart';
import 'package:soccer_sport/products/domain/usecase/apply_coupon.dart';
import 'package:soccer_sport/setting/domain/entity/feedback.dart';

abstract class FeedbackRepository {
  Future<Either<Failure, bool>> sendFeedback(FeedbackC feedback);
}
