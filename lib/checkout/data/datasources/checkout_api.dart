import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:soccer_sport/products/domain/entities/cart_product.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../domain/entities/order.dart';

abstract class OrderApiDataSource {
  Future<bool> createOrder(OrderDetails order);
  Future<List<OrderDetails>> getOrders(int userID);
  Future<bool> checkLimitCheckout(List<CartProduct> orders);
}

class OrderApiDataSourceImpl implements OrderApiDataSource {
  final http.Client client;

  OrderApiDataSourceImpl({required this.client});

  @override
  Future<bool> createOrder(OrderDetails order) async {
    var authToken = base64
        .encode(utf8.encode(FootballApi.csKey + ':' + FootballApi.csSecret));
    final response =
        await client.post(WebUri(FootballApi.wcUrl + FootballApi.orderURL),
            headers: {
              HttpHeaders.authorizationHeader: 'Basic $authToken',
              HttpHeaders.contentTypeHeader: 'application/json'
            },
            body: jsonEncode(order.toMap()));

    if (response.statusCode == 201) {
      // this mean that we are connected to the data base
      var body = jsonDecode(response.body);
      List<dynamic> lineItems = body['line_items'];
      List<dynamic> test = [];
      for (var element in lineItems) {
        if ((element['name'] as String).split(' ').first.toLowerCase() ==
            'play666:') {
          test.add(element);
        }
      }
      body['line_items'] = test;

      if (test.length > 0) {
        String url =
            'https://soccersport.club/wp-admin/API/send_confirmation_prize.php';

        final response2 = await http.post(WebUri(url),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              'Accept': 'application/json',
            },
            body: json.encode(body));

        if (response2.statusCode == 200) {
          // this mean that we are connected to the data base
          // int body = jsonDecode(response.body) as int;
        }
      }

      return true;
    } else if (response.statusCode == 403) {
      throw ServerException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<OrderDetails>> getOrders(int userID) async {
    var authToken = base64
        .encode(utf8.encode(FootballApi.csKey + ':' + FootballApi.csSecret));
    final response = await client.get(
      WebUri(FootballApi.wcUrl +
          FootballApi.orderURL +
          '?customer=${Constant.auth!.id}&consumer_key=${FootballApi.csKey}&consumer_secret=${FootballApi.csSecret}'),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body) as List<dynamic>;
      List<OrderDetails> orders =
          body.map((e) => OrderDetails.fromMap(e)).toList();
      return orders;
    } else if (response.statusCode == 403) {
      throw ServerException();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> checkLimitCheckout(List<CartProduct> orders) async {
    String url = "https://soccersport.club/wp-json/wl/v1/check_limit_checkout";

    final response = await client.post(WebUri(url),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: jsonEncode({
          "line_items": orders.map((e) => e.toMap()).toList(),
          "id": Constant.auth!.id
        }));
    if (response.statusCode == 200) {
      // List<dynamic> body = jsonDecode(response.body) as List<dynamic>;
      // List<OrderDetails> orders =
      //     body.map((e) => OrderDetails.fromMap(e)).toList();
      return jsonDecode(response.body);
    } else if (response.statusCode == 403) {
      throw ServerException();
    } else {
      throw ServerException();
    }
  }
}
