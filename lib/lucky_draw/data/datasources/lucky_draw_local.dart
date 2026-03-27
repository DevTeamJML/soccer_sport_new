import 'dart:convert';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:http/http.dart' as http;
import 'package:soccer_sport/league/data/model/league_details_model.dart';
import 'package:soccer_sport/league/data/model/league_model.dart';
import 'package:soccer_sport/league/domain/entities/league.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LuckyDrawLocalSource {
  Future<Map<String, dynamic>> getCoupons();
  Future<bool> updateCoupons(Map<String, dynamic> coupons);
}

const CACHED_COUPON = 'CACHED_COUPON';

class LuckyDrawLocalSourceImpl implements LuckyDrawLocalSource {
  final SharedPreferences sharedPreferences;

  LuckyDrawLocalSourceImpl({required this.sharedPreferences});

  @override
  Future<Map<String, dynamic>> getCoupons() {
    final couponString = sharedPreferences.getString(CACHED_COUPON);

    Map<String, dynamic>? coupons =
        couponString != null ? json.decode(couponString) : null;

    if (coupons != null) {
      return Future.value(coupons);
    } else {
      return Future.value({}); // Return empty list when not found
    }
  }

  @override
  Future<bool> updateCoupons(Map<String, dynamic> coupons) async {
    bool success =
        await sharedPreferences.setString(CACHED_COUPON, jsonEncode(coupons));
    // await sharedPreferences.remove(CACHED_COUPON);

    if (success) {
      return true;
    } else {
      return false;
    }
  }
}
