import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:soccer_sport/customer/data/datasources/customer_api.dart';
import 'package:soccer_sport/customer/domain/entities/cny_detail.dart';
import 'package:soccer_sport/customer/domain/entities/customer.dart';
import 'package:soccer_sport/customer/domain/entities/customer_reward_detail.dart';
import 'package:soccer_sport/customer/domain/entities/shipping.dart';
import 'package:soccer_sport/customer/domain/entities/verified_detail.dart';
import 'package:soccer_sport/customer/domain/repositories/customer_repository.dart';

import '../../../checkout/domain/entities/reference.dart';
import '../../../core/error/failure.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerApiDataSource apiDataSource;
  // final ProductLocalDataSource localDataSource;
  // final ArticleLocalDataSource localDataSource;

  CustomerRepositoryImpl({
    required this.apiDataSource,
    // required this.localDataSource,
  });

  @override
  Future<Either<Failure, Customer>> getCustomerDetails(int userID) async {
    try {
      final product = await apiDataSource.getCustomerDetails(userID);

      return Right(product);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Reference>> purchaseReward(
      int price, int productID) async {
    try {
      final product = await apiDataSource.purchaseReward(price, productID);

      return Right(product);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  // @override
  // Future<Either<Failure, bool>> convertDiamonds(int diamonds) async {
  //   try {
  //     final product = await apiDataSource.convertDiamonds(diamonds);

  //     return Right(product);
  //   } on ServerException {
  //     return Left(ServerFailure());
  //   }
  // }

  @override
  Future<Either<Failure, Customer>> editAddress(Shipping shipping) async {
    try {
      final product = await apiDataSource.editAddress(shipping);

      return Right(product);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>> getUserBalance(int userID) async {
    try {
      final product = await apiDataSource.getUserBalance(userID);

      return Right(product);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>> getDailyReward(
      CustomerRewardDetail customerRewardDetail) async {
    try {
      final product = await apiDataSource.getDailyReward(customerRewardDetail);

      return Right(product);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> addDailyReward(String points) async {
    try {
      final product = await apiDataSource.addDailyReward(points);

      return Right(product);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, CustomerRewardDetail>> getUserRewardDetail(
      String id) async {
    try {
      final product = await apiDataSource.getUserRewardDetail(id);

      return Right(product);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, VerifiedDetail>> checkVerified(String id) async {
    try {
      final product = await apiDataSource.checkVerified(id);

      return Right(product);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> sendVerificationEmail(String id) async {
    try {
      final product = await apiDataSource.sendVerificationEmail(id);

      return Right(product);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> cnyAddReward(CnyRewardDetail points) async {
    try {
      final product = await apiDataSource.cnyAddReward(points);

      return Right(product);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, CnyRewardDetail>> cnyGetDetail(String id) async {
    try {
      final product = await apiDataSource.cnyGetDetail(id);

      return Right(product);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, CustomerRewardDetail>> updatePersonalize(
      String id, List<int> leagues) async {
    try {
      final product = await apiDataSource.updatePersonalize(id, leagues);

      return Right(product);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
  // @override
  // Future<Either<Failure, bool>> changePassword(String password) async {
  //   try {
  //     final product = await apiDataSource.changePassword(password);

  //     return Right(product);
  //   } on ServerException {
  //     return Left(ServerFailure());
  //   }
  // }

  // @override
  // Future<Either<Failure, bool>> removeFirstLogin() async {
  //   try {
  //     final product = await apiDataSource.removeFirstLogin();

  //     return Right(product);
  //   } on ServerException {
  //     return Left(ServerFailure());
  //   }
  // }
}
