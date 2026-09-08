part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}

// class GetAllCategoriesRequest extends ProductEvent {
//   final Customer customer;
//   GetAllCategoriesRequest({required this.customer});

//   @override
//   List<Object> get props => [customer];
// }

class GetAllCategoriesRequest extends ProductEvent {}

class GetProductsRequest extends ProductEvent {
  final int? page;
  final int? perPage;

  GetProductsRequest({required this.page, required this.perPage});

  @override
  List<Object?> get props => [page, perPage];
}

class AddToCartRequest extends ProductEvent {
  final Cart cart;

  AddToCartRequest({required this.cart});

  @override
  List<Object?> get props => [cart];
}

class GetCartItemsRequest extends ProductEvent {
  final int userId;

  GetCartItemsRequest({required this.userId});

  @override
  List<Object> get props => [userId];
}

class GetAllProductsRequest extends ProductEvent {}

class GetCategoryProductsResquest extends ProductEvent {
  final int id;

  GetCategoryProductsResquest({required this.id});

  @override
  List<Object> get props => [id];
}

class GetProductVariationsReques extends ProductEvent {
  final int id;

  GetProductVariationsReques({required this.id});

  @override
  List<Object> get props => [id];
}

class ApplyCouponRequest extends ProductEvent {
  final String code;

  ApplyCouponRequest({required this.code});

  @override
  List<Object> get props => [code];
}

class GenerateCouponRequest extends ProductEvent {
  final List<Coupon> coupon;

  GenerateCouponRequest({required this.coupon});

  @override
  List<Object> get props => [coupon];
}
