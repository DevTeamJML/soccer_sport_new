import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/products/domain/entities/cart.dart';
import 'package:soccer_sport/products/domain/entities/cart_item.dart';
import 'package:soccer_sport/products/domain/entities/category.dart';
import 'package:soccer_sport/products/domain/entities/coupon.dart';
import 'package:soccer_sport/products/domain/entities/product.dart';

import '../../domain/repository/product_repository.dart';
import '../datasource/product_api.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductApiDataSource apiDataSource;
  // final ProductLocalDataSource localDataSource;
  // final ArticleLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.apiDataSource,
    // required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Category>>> getAllCategories() async {
    try {
      final product = await apiDataSource.getAllCategories();

      return Right(product);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProducts(
      int? page, int? perPage) async {
    try {
      final product = await apiDataSource.getProducts(page, perPage);

      return Right(product);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    try {
      final product = await apiDataSource.getAllProducts();

      return Right(product);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<CartItem>>> addToCart(Cart cart) async {
    try {
      final product = await apiDataSource.addToCart(cart);

      return Right(product);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<CartItem>>> getCartItems(int userId) async {
    try {
      final product = await apiDataSource.getCartItems(userId);

      return Right(product);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getCategoryProducts(int id) async {
    try {
      final product = await apiDataSource.getCategoryProducts(id);

      return Right(product);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<CartItem>>> getProductVariations(int id) async {
    try {
      final product = await apiDataSource.getProductVariations(id);

      return Right(product);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Coupon>> applyCoupon(String code) async {
    try {
      final product = await apiDataSource.applyCoupon(code);

      return Right(product);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Coupon>>> generateCoupon(
      List<Coupon> coupon) async {
    try {
      final product = await apiDataSource.generateCoupon(coupon);

      return Right(product);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
