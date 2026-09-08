import 'dart:convert';
import 'dart:io';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:soccer_sport/products/domain/entities/cart_item.dart';
import 'package:soccer_sport/products/domain/entities/coupon.dart';

import '../../domain/entities/cart.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';

abstract class ProductApiDataSource {
  Future<List<Category>> getAllCategories();
  Future<List<Product>> getCategoryProducts(int id);
  Future<List<Product>> getProducts(int? page, int? perPage);
  Future<List<Product>> getAllProducts();
  Future<List<CartItem>> getCartItems(int id);
  Future<List<CartItem>> addToCart(Cart cart);
  Future<List<CartItem>> getProductVariations(int id);
  Future<Coupon> applyCoupon(String code);
  Future<List<Coupon>> generateCoupon(List<Coupon> coupon);
}

class ProductApiDataSourceImpl implements ProductApiDataSource {
  final http.Client client;

  ProductApiDataSourceImpl({required this.client});

  @override
  Future<List<Category>> getAllCategories() async {
    List<Category> categories = [];
    final response = await client.get(
      WebUri(FootballApi.wcUrl +
          FootballApi.categoriesURL +
          "?consumer_key=${FootballApi.csKey}&consumer_secret=${FootballApi.csSecret}"),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      List<dynamic> body = jsonDecode(response.body) as List<dynamic>;
      categories = body.map((e) => Category.fromMap(e)).toList();
      return categories;
    } else if (response.statusCode == 403) {
      return [];
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<Product>> getProducts(int? page, int? perPage) async {
    List<Product> products = [];
    String url = FootballApi.wcUrl +
        FootballApi.productsURL +
        "?consumer_key=${FootballApi.csKey}&consumer_secret=${FootballApi.csSecret}&status=publish";
    if (perPage != null) {
      url + '&per_page=$perPage';
    }
    if (page != null) {
      url + '&page=$page';
    }

    final response = await client.get(
      WebUri(url),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      List<dynamic> body = jsonDecode(response.body) as List<dynamic>;
      products = body.map((e) => Product.fromMap(e)).toList();
      return products;
    } else if (response.statusCode == 403) {
      return [];
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<Product>> getAllProducts() async {
    List<Product> products = [];
    String url = FootballApi.wcUrl +
        FootballApi.productsURL +
        "?consumer_key=${FootballApi.csKey}&consumer_secret=${FootballApi.csSecret}&per_page=100&status=publish";
    final response = await client.get(
      WebUri(url),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      List<dynamic> body = jsonDecode(response.body) as List<dynamic>;
      products = body.map((e) => Product.fromMap(e)).toList();
      return products;
    } else if (response.statusCode == 403) {
      return [];
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<CartItem>> addToCart(Cart cart) async {
    String url = "https://soccersport.club/wp-json/wv/v1/add_to_cart";

    final response = await client.post(WebUri(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: json.encode(cart.toMap()));

    if (response.statusCode == 200) {
      Map<String, dynamic> body =
          jsonDecode(response.body) as Map<String, dynamic>;
      List<dynamic> dynamicList = body['data'] as List<dynamic>;
      // this mean that we are connected to the data base
      List<CartItem> cartItem =
          dynamicList.map((e) => CartItem.fromMap(e)).toList();
      return cartItem;
    } else if (response.statusCode == 403) {
      return [];
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<CartItem>> getCartItems(int id) async {
    String url = "https://soccersport.club/wp-json/wv/v1/cart_list?user_id=$id";
    final response = await client.get(WebUri(url), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });
    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      Map<String, dynamic> body =
          jsonDecode(response.body) as Map<String, dynamic>;
      List<dynamic> dynamicList = body['data'] as List<dynamic>;
      List<CartItem> cartItem =
          dynamicList.map((e) => CartItem.fromMap(e)).toList();

      return cartItem;
    } else if (response.statusCode == 403) {
      return [];
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<Product>> getCategoryProducts(int id) async {
    List<Product> product = [];
    final response = await client.get(
      WebUri(FootballApi.wcUrl +
          FootballApi.productsURL +
          "?category=${id}&consumer_key=${FootballApi.csKey}&consumer_secret=${FootballApi.csSecret}"),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      List<dynamic> body = jsonDecode(response.body) as List<dynamic>;
      product = body.map((e) => Product.fromMap(e)).toList();
      return product;
    } else if (response.statusCode == 403) {
      return [];
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<CartItem>> getProductVariations(int id) async {
    String url = FootballApi.wcUrl +
        FootballApi.productsURL +
        '/' +
        id.toString() +
        '/variations' +
        "?consumer_key=${FootballApi.csKey}&consumer_secret=${FootballApi.csSecret}&status=publish&per_page=50";

    final response = await client.get(
      WebUri(url),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base

      List<CartItem> cartItem = (jsonDecode(response.body) as List<dynamic>)
          .map((e) => CartItem.fromMap(e))
          .toList();
      return cartItem;
    } else if (response.statusCode == 403) {
      return [];
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Coupon> applyCoupon(String code) async {
    final response = await client.post(
        WebUri('https://soccersport.club/wp-json/wl/v1/apply_coupon'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: json.encode({'code': code}));

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base

      return Coupon.fromMap(jsonDecode(response.body));
    }
    {
      throw ServerException();
    }
  }

  @override
  Future<List<Coupon>> generateCoupon(List<Coupon> coupon) async {
    final response = await client.post(
        WebUri(
            "https://soccersport.club/wp-json/wc/v3/coupons/batch?consumer_key=${FootballApi.csKey}&consumer_secret=${FootballApi.csSecret}"),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: json.encode({
          "create": coupon.map((e) => e.toMap()).toList(),
          "update": [],
          "delete": []
        }));

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base

      return ((jsonDecode(response.body) as Map<String, dynamic>)["create"]
              as List<dynamic>)
          .map((e) => Coupon.fromMap(e as Map<String, dynamic>))
          .toList();
    }
    {
      throw ServerException();
    }
  }
}
