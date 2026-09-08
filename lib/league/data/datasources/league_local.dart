import 'dart:convert';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:http/http.dart' as http;
import 'package:soccer_sport/league/data/model/league_details_model.dart';
import 'package:soccer_sport/league/data/model/league_model.dart';
import 'package:soccer_sport/league/domain/entities/league.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class LeagueLocalDataSource {
  Future<List<LeagueDetailsModel>> getLocalLeagues();
  Future<bool> checkLocalLeagues(List<LeagueDetailsModel> list);
  Future<bool> persistLocalLeagues(List<LeagueDetailsModel> list);
  Future<List<LeagueDetailsModel>> getLocalCurrentLeagues();
  Future<bool> persistLocalCurrentLeagues(List<LeagueDetailsModel> list);
  Future<String> getUpdateDate();
  Future<bool> persistUpdateDate(String date);
}

const CACHED_LEAGUES = 'CACHED_LEAGUES';
const CACHED_CURRENT_LEAGUES = 'CACHED_CURRENT_LEAGUES';

const CACHED_DATE = 'CACHED_DATE';

class LeagueLocalDataSourceImpl implements LeagueLocalDataSource {
  final SharedPreferences sharedPreferences;

  LeagueLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> checkLocalLeagues(List<LeagueDetailsModel> list) async {
    List<LeagueDetailsModel> cachedLeagues = await getLocalLeagues();

    bool founded = Constant.deepEq(list, cachedLeagues);
    return Future.value(founded);
  }

  @override
  Future<List<LeagueDetailsModel>> getLocalLeagues() {
    final leaguesString = sharedPreferences.getStringList(CACHED_LEAGUES);

    if (leaguesString != null) {
      List<LeagueDetailsModel> leagues = [];
      leaguesString.forEach((leagueString) {
        leagues.add(LeagueDetailsModel.fromJson(json.decode(leagueString)));
      });
      Constant.staticLeagues = leagues;
      // final leaguesString2 =
      //     sharedPreferences.getStringList(CACHED_CURRENT_LEAGUES);

      // if (leaguesString2 != null) {
      //   List<LeagueDetailsModel> leagues2 = [];
      //   leaguesString2.forEach((leagueString2) {
      //     leagues2.add(LeagueDetailsModel.fromJson(json.decode(leagueString2)));
      //   });

      //   Constant.staticCurrentLeagues = leagues2;
      //   Constant.staticLeagues = leagues;
      //   return Future.value(leagues);
      // } else {
      //   return Future.value([]); // Return empty list when not found

      // }
      return Future.value(leagues);
    } else {
      return Future.value([]); // Return empty list when not found
    }
  }

  @override
  Future<bool> persistLocalLeagues(List<LeagueDetailsModel> list) async {
    List<String> leaguesString = [];
    bool founded = await checkLocalLeagues(list);
    if (founded) {
      return false;
    } else {
      leaguesString = list.map((e) => jsonEncode(e)).toList();

      bool success = await sharedPreferences.setStringList(
        CACHED_LEAGUES,
        leaguesString,
      );
      if (success) {
        return true;
      } else {
        throw CacheException();
      }
    }
  }

  @override
  Future<String> getUpdateDate() async {
    final dateString = sharedPreferences.getString(CACHED_DATE);

    if (dateString != null) {
      print('got or not');

      return Future.value(dateString);
    } else {
      print('gdont hv');

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
      print('persit or not');

      return true;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<List<LeagueDetailsModel>> getLocalCurrentLeagues() {
    final leaguesString =
        sharedPreferences.getStringList(CACHED_CURRENT_LEAGUES);

    if (leaguesString != null) {
      List<LeagueDetailsModel> leagues = [];
      leaguesString.forEach((leagueString) {
        leagues.add(LeagueDetailsModel.fromJson(json.decode(leagueString)));
      });

      return Future.value(leagues);
    } else {
      return Future.value([]); // Return empty list when not found
    }
  }

  @override
  Future<bool> persistLocalCurrentLeagues(List<LeagueDetailsModel> list) async {
    List<String> leaguesString = [];
    bool founded = await checkLocalLeagues(list);
    if (founded) {
      return false;
    } else {
      leaguesString = list.map((e) => jsonEncode(e)).toList();

      bool success = await sharedPreferences.setStringList(
        CACHED_CURRENT_LEAGUES,
        leaguesString,
      );
      if (success) {
        return true;
      } else {
        throw CacheException();
      }
    }
  }
}
