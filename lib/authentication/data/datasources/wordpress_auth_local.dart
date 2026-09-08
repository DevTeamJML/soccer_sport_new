import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soccer_sport/authentication/domain/entities/wordpress_auth.dart';
import 'package:soccer_sport/authentication/domain/usecases/check_first_time_login.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:soccer_sport/footballMatch/data/model/football_match_model.dart';
import 'package:http/http.dart' as http;

abstract class WordpressAuthLocalDataSource {
  Future<WordpressAuth> getAuth();
  Future<bool> checkAuth();

  Future<bool> persistAuth(WordpressAuth auth);
  Future<bool> wordpressLogout();
  Future<List<bool?>> checkFirstTimeLogin();
  Future<bool> removeFirstTimeInstall();
  Future<bool> removeBetGuide();

  Future<bool> setFirstTimeInstall();
  Future<bool> setBetGuide();

  Future<bool?> checkMember();
}

const CACHED_AUTH = 'CACHED_AUTH4';
const FIRST_TIME_INSTALL = 'SSC_FIRST_TIME_INSTALL';
const BET_GUIDE = 'BET_GUIDE';

const SSC_MEMBER = 'SSC_MEMBER';

class WordpressAuthLocalDataSourceImpl implements WordpressAuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  WordpressAuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> checkAuth() async {
    final prefs = sharedPreferences.getString(CACHED_AUTH);
    if (prefs != null) {
      final auth = WordpressAuth.fromMap(jsonDecode(prefs));

      Constant.auth = auth;
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<WordpressAuth> getAuth() {
    final prefs = sharedPreferences.getString(CACHED_AUTH);
    return Future.value(WordpressAuth.fromMap(jsonDecode(prefs!)));
  }

  @override
  Future<bool> persistAuth(WordpressAuth auth) async {
    final success = await sharedPreferences.setString(
        CACHED_AUTH, jsonEncode(auth.toMap()));
    final member = await sharedPreferences.setString(SSC_MEMBER, SSC_MEMBER);
    return success;
  }

  @override
  Future<bool> wordpressLogout() async {
    final success = await sharedPreferences.remove(CACHED_AUTH);
    return success;
  }

  @override
  Future<List<bool?>> checkFirstTimeLogin() async {
    final success = sharedPreferences.getBool(FIRST_TIME_INSTALL);
    final betSuccess = sharedPreferences.getBool(BET_GUIDE);

    return [
      success != null ? success : null,
      betSuccess != null ? betSuccess : null
    ];
  }

  @override
  Future<bool> removeFirstTimeInstall() async {
    final success = await sharedPreferences.setBool(FIRST_TIME_INSTALL, false);
    // if()
    return success;
  }

  @override
  Future<bool> setFirstTimeInstall() async {
    final success = await sharedPreferences.setBool(FIRST_TIME_INSTALL, true);
    return success;
  }

  @override
  Future<bool?> checkMember() async {
    final success = sharedPreferences.getString(SSC_MEMBER);

    if (success != null) {
      return success == SSC_MEMBER;
    } else {
      return null;
    }
  }

  @override
  Future<bool> setBetGuide() async {
    final success = await sharedPreferences.setBool(BET_GUIDE, true);

    return success;
  }

  @override
  Future<bool> removeBetGuide() async {
    final success = await sharedPreferences.setBool(BET_GUIDE, false);

    return success;
  }
}
