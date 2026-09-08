import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/customer/domain/entities/cny_detail.dart';
import 'package:soccer_sport/customer/domain/entities/customer.dart';
import 'package:soccer_sport/customer/domain/entities/customer_reward_detail.dart';
import 'package:soccer_sport/customer/domain/entities/verified_detail.dart';
import 'package:soccer_sport/customer/domain/usecase/add_daily_reward.dart';
import 'package:soccer_sport/customer/domain/usecase/get_user_reward_detail.dart';

import '../../../checkout/domain/entities/reference.dart';
import '../entities/shipping.dart';

abstract class CustomerRepository {
  Future<Either<Failure, Customer>> getCustomerDetails(int userID);
  Future<Either<Failure, int>> getUserBalance(int userID);

  // Future<Either<Failure, bool>> convertDiamonds(int diamonds);
  Future<Either<Failure, Customer>> editAddress(Shipping shipping);
  // Future<Either<Failure, bool>> changePassword(String password);
  // Future<Either<Failure, bool>> removeFirstLogin();
  Future<Either<Failure, int>> getDailyReward(
      CustomerRewardDetail customerRewardDetail);
  Future<Either<Failure, bool>> addDailyReward(String points);
  Future<Either<Failure, CustomerRewardDetail>> getUserRewardDetail(String id);
  Future<Either<Failure, CnyRewardDetail>> cnyGetDetail(String id);
  Future<Either<Failure, bool>> cnyAddReward(CnyRewardDetail detail);

  Future<Either<Failure, VerifiedDetail>> checkVerified(String id);
  Future<Either<Failure, bool>> sendVerificationEmail(String id);

  Future<Either<Failure, Reference>> purchaseReward(int price, int productID);

  Future<Either<Failure, CustomerRewardDetail>> updatePersonalize(
      String id, List<int> leagues);
}
