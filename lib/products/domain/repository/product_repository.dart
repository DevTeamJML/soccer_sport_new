import 'package:dartz/dartz.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/products/domain/entities/coupon.dart';
import 'package:soccer_sport/products/domain/usecase/apply_coupon.dart';

import '../entities/cart.dart';
import '../entities/cart_item.dart';
import '../entities/category.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Category>>> getAllCategories();
  Future<Either<Failure, List<Product>>> getProducts(int? page, int? perPage);
  Future<Either<Failure, List<Product>>> getCategoryProducts(int id);

  Future<Either<Failure, List<Product>>> getAllProducts();
  Future<Either<Failure, List<CartItem>>> getCartItems(int userId);
  Future<Either<Failure, List<CartItem>>> getProductVariations(int id);

  Future<Either<Failure, List<CartItem>>> addToCart(Cart cart);
  Future<Either<Failure, Coupon>> applyCoupon(String code);
  Future<Either<Failure, List<Coupon>>> generateCoupon(List<Coupon> coupon);
}
