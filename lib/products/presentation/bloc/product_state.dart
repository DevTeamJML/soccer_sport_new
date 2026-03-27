part of 'product_bloc.dart';

@immutable
abstract class ProductState {}

class ProductInitial extends ProductState {}

class LoadingAllCategories extends ProductState {}

class AllCategoriesLoaded extends ProductState {
  final List<Category> categories;
  AllCategoriesLoaded({required this.categories});

  @override
  List<Object> get props => [categories];
}

class ProductError extends ProductState {
  final String message;

  ProductError({required this.message});

  @override
  List<Object> get props => [message];
}

class LoadingProducts extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<Product> products;
  ProductsLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class LoadingAllProducts extends ProductState {}

class AllProductsLoaded extends ProductState {
  final List<Product> products;
  AllProductsLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class AddingToCart extends ProductState {}

class CartAdded extends ProductState {
  final List<CartItem> products;
  CartAdded({required this.products});

  @override
  List<Object> get props => [products];
}

class LoadCartItems extends ProductState {}

class CartItemsLoaded extends ProductState {
  final List<CartItem> products;
  CartItemsLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class LoadingCategoryProducts extends ProductState {}

class CategoryProductsLoaded extends ProductState {
  final List<Product> products;
  CategoryProductsLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class LoadingProdutVariations extends ProductState {}

class ProductVariationsLoaded extends ProductState {
  final List<CartItem> products;
  ProductVariationsLoaded({required this.products});

  @override
  List<Object> get props => [products];
}

class ApplyingCoupon extends ProductState {}

class CouponApplied extends ProductState {
  final Coupon coupon;
  CouponApplied({required this.coupon});

  @override
  List<Object> get props => [coupon];
}

class GeneratingCoupon extends ProductState {}

class CouponGenerated extends ProductState {
  final List<Coupon> coupon;
  CouponGenerated({required this.coupon});

  @override
  List<Object> get props => [coupon];
}
