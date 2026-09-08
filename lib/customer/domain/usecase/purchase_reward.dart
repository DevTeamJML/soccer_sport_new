import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/checkout/domain/entities/reference.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/customer/domain/repositories/customer_repository.dart';

import '../../../core/error/failure.dart';

class PurchaseReward extends UseCase<Reference, PurchaseRewardParams> {
  final CustomerRepository repository;

  PurchaseReward(this.repository);

  Future<Either<Failure, Reference>> call(PurchaseRewardParams params) async {
    return await repository.purchaseReward(params.price, params.productID);
  }
}

class PurchaseRewardParams extends Equatable {
  final int price;
  final int productID;
  PurchaseRewardParams({
    required this.price,
    required this.productID,
  });

  @override
  List<Object> get props => [price, productID];
}
