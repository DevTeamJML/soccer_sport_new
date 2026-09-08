import 'dart:convert';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:http/http.dart' as http;
import 'package:soccer_sport/league/data/model/league_details_model.dart';
import 'package:soccer_sport/league/data/model/league_model.dart';
import 'package:soccer_sport/league/domain/entities/league.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BannerLocalDataSource {
  Future<String> getUpdateDate();
  Future<bool> persistUpdateDate(String date);
}

const CACHED_DATE = 'CACHED_DAILY_DATE';

class BannerLocalDataSourceImpl implements BannerLocalDataSource {
  final SharedPreferences sharedPreferences;

  BannerLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<String> getUpdateDate() async {
    final dateString = sharedPreferences.getString(CACHED_DATE);

    if (dateString != null) {
      return Future.value(dateString);
    } else {
      return Future.value(''); // Return empty list when not found
    }
  }

  @override
  Future<bool> persistUpdateDate(String date) async {
    bool success = await sharedPreferences.setString(
      CACHED_DATE,
      date,
    );
    if (success) {
      return true;
    } else {
      throw CacheException();
    }
  }
}
