import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:http/http.dart' as http;
import 'package:soccer_sport/league/data/model/league_details_model.dart';
import 'package:soccer_sport/league/data/model/league_model.dart';
import 'package:soccer_sport/league/domain/entities/league.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/news/domain/entities/news.dart';
import 'package:soccer_sport/standings/data/model/league_standings_model.dart';
import 'package:wordpress_api/wordpress_api.dart';

abstract class NotificationLocalDataSource {
  // Future<List<LeagueDetailsModel>> getAllLeague();
  Future<bool?> getNotification();
  Future<bool> removeNotification();

  Future<bool> persistNotification(bool notification);
}

const CACHED_NOTIFICATION = 'CACHED_NOTIFICATION';

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  final SharedPreferences sharedPreferences;

  NotificationLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool?> getNotification() async {
    final notificationBool = sharedPreferences.getBool(CACHED_NOTIFICATION);

    if (notificationBool != null) {
      return Future.value(notificationBool);
    } else {
      return null; // Return empty list when not found
    }
  }

  @override
  Future<bool> persistNotification(bool notification) async {
    final notificationBool =
        await sharedPreferences.setBool(CACHED_NOTIFICATION, notification);
    if (notificationBool) {
      return notification;
    } else {
      return !notification;
    }
  }

  @override
  Future<bool> removeNotification() async {
    final notificationBool =
        await sharedPreferences.remove(CACHED_NOTIFICATION);

    return notificationBool;
  }
}
