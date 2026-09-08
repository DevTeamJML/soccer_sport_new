import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/products/domain/entities/cart_product.dart';
import 'package:soccer_sport/products/domain/entities/coupon.dart';
import 'package:soccer_sport/products/domain/usecase/add_to_cart.dart';
import 'package:soccer_sport/products/domain/usecase/apply_coupon.dart';
import 'package:soccer_sport/products/domain/usecase/generate_coupon.dart';
import 'package:soccer_sport/products/domain/usecase/get_all_categories.dart';
import 'package:soccer_sport/products/domain/usecase/get_all_products.dart';
import 'package:soccer_sport/products/domain/usecase/get_cart_items.dart';
import 'package:soccer_sport/products/domain/usecase/get_product_variations.dart';
import 'package:soccer_sport/products/domain/usecase/get_products.dart';

import '../../../core/util/failure_message.dart';
import '../../domain/entities/cart.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecase/get_category_products.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetAllCategories getAllCategories;
  final GetProducts getProducts;
  final GetAllProducts getAllProducts;
  final AddToCart addToCart;
  final GetCartItems getCartItems;
  final GetCategoryProducts getCategoryProducts;
  final GetProductVariations getProductVariations;
  final GenerateCoupon generateCoupon;
  final ApplyCoupon applyCoupon;
  ProductBloc({
    required GetAllCategories getAllCategories,
    required GetProducts getProducts,
    required GetAllProducts getAllProducts,
    required GetCartItems getCartItems,
    required AddToCart addToCart,
    required GetCategoryProducts getCategoryProducts,
    required GetProductVariations getProductVariations,
    required GenerateCoupon generateCoupon,
    required ApplyCoupon applyCoupon,
  })  : getAllCategories = getAllCategories,
        getProducts = getProducts,
        getAllProducts = getAllProducts,
        addToCart = addToCart,
        getCartItems = getCartItems,
        getCategoryProducts = getCategoryProducts,
        getProductVariations = getProductVariations,
        applyCoupon = applyCoupon,
        generateCoupon = generateCoupon,
        super(ProductInitial());

  @override
  Stream<ProductState> mapEventToState(
    ProductEvent event,
  ) async* {
    if (event is GetAllCategoriesRequest) {
      yield LoadingAllCategories();
      final failureOrProduct = await getAllCategories(NoParams());
      yield failureOrProduct.fold(
          (failure) => ProductError(message: Failure2Message.map(failure)),
          (categories) => AllCategoriesLoaded(categories: categories));
    }

    if (event is GetProductsRequest) {
      yield LoadingProducts();
      final failureOrProduct = await getProducts(
          GetProductsParams(page: event.page, perPage: event.perPage));
      yield failureOrProduct.fold(
          (failure) => ProductError(message: Failure2Message.map(failure)),
          (products) => ProductsLoaded(products: products));
    }

    if (event is GetAllProductsRequest) {
      yield LoadingAllProducts();
      final failureOrProduct = await getAllProducts(NoParams());
      yield failureOrProduct.fold(
          (failure) => ProductError(message: Failure2Message.map(failure)),
          (products) => AllProductsLoaded(products: products));
    }

    if (event is GetCartItemsRequest) {
      yield LoadCartItems();
      final failureOrProduct =
          await getCartItems(GetCartItemsParams(userId: event.userId));
      yield failureOrProduct.fold(
          (failure) => ProductError(message: Failure2Message.map(failure)),
          (products) => CartItemsLoaded(products: products));
    }

    if (event is AddToCartRequest) {
      yield AddingToCart();
      final failureOrProduct =
          await addToCart(AddToCartParams(cart: event.cart));
      yield failureOrProduct.fold(
          (failure) => ProductError(message: Failure2Message.map(failure)),
          (products) => CartAdded(products: products));
    }

    if (event is GetCategoryProductsResquest) {
      yield LoadingCategoryProducts();
      final failureOrProduct =
          await getCategoryProducts(GetCategoryProductsParams(id: event.id));
      yield failureOrProduct.fold(
          (failure) => ProductError(message: Failure2Message.map(failure)),
          (products) => CategoryProductsLoaded(products: products));
    }
    if (event is GetProductVariationsReques) {
      yield LoadingProdutVariations();
      final failureOrProduct =
          await getProductVariations(GetProductVariationsParams(id: event.id));
      yield failureOrProduct.fold(
          (failure) => ProductError(message: Failure2Message.map(failure)),
          (products) => ProductVariationsLoaded(products: products));
    }

    if (event is ApplyCouponRequest) {
      yield ApplyingCoupon();
      final failureOrProduct =
          await applyCoupon(ApplyCouponParams(code: event.code));
      yield failureOrProduct.fold(
          (failure) => ProductError(message: Failure2Message.map(failure)),
          (products) => CouponApplied(coupon: products));
    }

    if (event is GenerateCouponRequest) {
      yield GeneratingCoupon();
      final failureOrProduct =
          await generateCoupon(GenerateCouponParams(coupon: event.coupon));
      yield failureOrProduct.fold(
          (failure) => ProductError(message: Failure2Message.map(failure)),
          (products) => CouponGenerated(coupon: products));
    }
  }
}
