import 'dart:convert';
import 'dart:io';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:soccer_sport/products/domain/entities/cart_item.dart';
import 'package:soccer_sport/products/domain/entities/coupon.dart';
import 'package:soccer_sport/setting/domain/entity/feedback.dart';

abstract class FeedbackApiDataSource {
  Future<bool> sendFeedback(FeedbackC feedback);
}

class FeedbackApiDataSourceImpl implements FeedbackApiDataSource {
  final http.Client client;

  FeedbackApiDataSourceImpl({required this.client});

  @override
  Future<bool> sendFeedback(FeedbackC feedback) async {
    if (feedback.attachment != null) {
      Map<String, String> headers = {
        "authorization": "f17c98cc-b68d-4734-87d2-eb2e0ba3ab3c",
        HttpHeaders.contentTypeHeader: 'application/json',
      };

      final request = http.MultipartRequest(
          'POST', WebUri("https://soccersport.club/api/feedback"))
        ..fields['email'] = feedback.email
        ..fields['comments'] = feedback.comments
        ..headers.addAll(headers)
        ..files.add(await http.MultipartFile.fromPath(
            'attachment', feedback.attachment!.path));
      final response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        // this mean that we are connected to the data base

        return true;
      } else {
        return false;
      }
    } else {
      final response = await client.post(
        WebUri("https://soccersport.club/api/feedback"),
        headers: {
          "authorization": "f17c98cc-b68d-4734-87d2-eb2e0ba3ab3c",
          HttpHeaders.contentTypeHeader: 'application/json',
        },
        body: json.encode(feedback.toMap()),
      );

      if (response.statusCode == 200) {
        // this mean that we are connected to the data base

        return true;
      } else {
        return false;
      }
    }
  }
}
