import 'dart:collection';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:http/http.dart' as http;
import 'package:soccer_sport/favourite/domain/entities/league_team.dart';
import 'package:soccer_sport/footballMatch/data/model/team_model.dart';
import 'package:soccer_sport/league/data/model/league_details_model.dart';
import 'package:soccer_sport/league/data/model/league_model.dart';
import 'package:soccer_sport/league/domain/entities/league.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../footballMatch/data/model/football_match_model.dart';
import '../../../footballMatch/domain/entities/team.dart';

abstract class FavouriteTeamLocalDataSource {
  Future<Map<String, List<TeamModel>>> getFavouriteTeam();
  Future<bool> persistFavouriteTeam(Team team, String id);
  Future<bool> removeFavouriteTeam(Team team, String id);
  Future<bool> getAllFavouriteTeam();

  Future<bool> persistTeamList(Map<String, List<dynamic>> team);
  Future<Map<String, List<Team>>> getTeamList();
  Future<List<TeamModel>> getFavouriteTeamV2();
  Future<bool> persistFavouriteTeamV2(Team team);
  Future<bool> removeFavouriteTeamV2(Team team);
}

const CACHED_TEAM = 'CACHED_TEAM';
const CACHED_TEAM_LIST = 'CACHED_TEAM_LIST';
const CACHED_MATCHES = 'CACHED_MATCHES';
const CACHED_TEAM_V2 = "CACHED_TEAM_V2";

class FavouriteTeamLocalDataSourceImpl implements FavouriteTeamLocalDataSource {
  final SharedPreferences sharedPreferences;

  FavouriteTeamLocalDataSourceImpl({required this.sharedPreferences});
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  @override
  Future<bool> persistFavouriteTeam(Team list, String id) async {
    Map<String, List<TeamModel>> cachedTeam = await getFavouriteTeam();
    if (cachedTeam[id] != null && cachedTeam[id]!.isNotEmpty) {
      cachedTeam[id]!.add(list as TeamModel);
    } else {
      cachedTeam[id] = [(list as TeamModel)];
    }

    bool success = await sharedPreferences.setString(
      CACHED_TEAM,
      jsonEncode(cachedTeam),
    );
    if (success) {
      Constant.favouriteTeam = cachedTeam;
      _fcm.subscribeToTopic("team" + list.id.toString());
      return true;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<Map<String, List<TeamModel>>> getFavouriteTeam() {
    final teamString = sharedPreferences.getString(CACHED_TEAM);
    if (teamString != null && jsonDecode(teamString) != "") {
      Map<String, List<TeamModel>> favouriteTeam = {};
      Map<String, dynamic> mapFavouriteTeam = jsonDecode(teamString);
      mapFavouriteTeam.forEach((key, value) {
        favouriteTeam[key] =
            (value as List<dynamic>).map((e) => TeamModel.fromJson(e)).toList();
      });

      return Future.value(favouriteTeam);
    } else {
      return Future.value({}); // Return empty list when not found
    }
  }

  @override
  Future<bool> removeFavouriteTeam(Team team, String id) async {
    Map<String, List<TeamModel>> cachedTeam = await getFavouriteTeam();
    if (cachedTeam.isNotEmpty &&
        cachedTeam[id] != null &&
        cachedTeam[id]!.isNotEmpty) {
      cachedTeam[id]!.remove(team as TeamModel);
      if (cachedTeam[id]!.isEmpty) {
        cachedTeam.remove(id);
      }
      // print(cachedTeam.toString());
      // return true;
      bool success = await sharedPreferences.setString(
        CACHED_TEAM,
        jsonEncode(cachedTeam.isNotEmpty ? cachedTeam : ''),
      );
      if (success) {
        _fcm.unsubscribeFromTopic("team" + team.id.toString());

        return true;
      } else {
        throw CacheException();
      }
    } else {
      return false;
    }
  }

  @override
  Future<bool> persistTeamList(Map<String, List<dynamic>> team) async {
    bool success =
        await sharedPreferences.setString(CACHED_TEAM_LIST, jsonEncode(team));
    if (success) {
      return true;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<Map<String, List<Team>>> getTeamList() {
    final teamString = sharedPreferences.getString(CACHED_TEAM_LIST);

    if (teamString != null) {
      Map<String, List<Team>> teams = {};
      Map<String, dynamic> mapTeam =
          Map<String, dynamic>.from(jsonDecode(teamString) as LinkedHashMap);
      ;
      mapTeam.forEach((key, value) {
        teams[key] = (value as List<dynamic>)
            .map((e) => TeamModel.fromJson(
                Map<String, dynamic>.from(e as LinkedHashMap)['team']
                    as Map<String, dynamic>) as Team)
            .toList();
      });

      // Constant.staticLeagues = teams;

      return Future.value(teams);
    } else {
      return Future.value({}); // Return empty list when not found
    }
  }

  @override
  Future<bool> getAllFavouriteTeam() {
    final teamString = sharedPreferences.getString(CACHED_TEAM_LIST);
    final matchString = sharedPreferences.getStringList(CACHED_MATCHES);
    Map<String, List<Team>> teams = {};
    List<FootballMatchModel> matches = [];

    if (teamString != null) {
      Map<String, dynamic> mapTeam =
          Map<String, dynamic>.from(jsonDecode(teamString) as LinkedHashMap);
      ;
      mapTeam.forEach((key, value) {
        teams[key] = (value as List<dynamic>)
            .map((e) => TeamModel.fromJson(
                Map<String, dynamic>.from(e as LinkedHashMap)['team']
                    as Map<String, dynamic>) as Team)
            .toList();
      });

      // Constant.staticLeagues = teams;
    }
    if (matchString != null) {
      matches = matchString
          .map((e) => FootballMatchModel.fromJson(json.decode(e)))
          .toList();
    }

    Constant.favouriteTeam = teams;
    Constant.favoriteList = matches;

    return Future.value(true);
  }

  @override
  Future<List<TeamModel>> getFavouriteTeamV2() {
    final teamString = sharedPreferences.getString(CACHED_TEAM_V2);
    if (teamString != null && jsonDecode(teamString) != "") {
      List<TeamModel> favouriteTeam = [];
      List<dynamic> mapFavouriteTeam = jsonDecode(teamString);
      favouriteTeam =
          mapFavouriteTeam.map((e) => TeamModel.fromJson(e)).toList();

      return Future.value(favouriteTeam);
    } else {
      return Future.value([]); // Return empty list when not found
    }
  }

  @override
  Future<bool> persistFavouriteTeamV2(Team team) async {
    List<TeamModel> cachedTeam = await getFavouriteTeamV2();

    cachedTeam.add(team as TeamModel);
    // if (cachedTeam[id] != null && cachedTeam[id]!.isNotEmpty) {
    //   cachedTeam[id]!.add(list as TeamModel);
    // } else {
    //   cachedTeam[id] = [(list as TeamModel)];
    // }

    bool success = await sharedPreferences.setString(
      CACHED_TEAM_V2,
      jsonEncode(cachedTeam),
    );
    if (success) {
      Constant.favouriteTeamV2 = cachedTeam;
      _fcm.subscribeToTopic("team" + team.id.toString());
      return true;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<bool> removeFavouriteTeamV2(Team team) async {
    List<TeamModel> cachedTeam = await getFavouriteTeamV2();

    if (cachedTeam.isNotEmpty && cachedTeam.length > 0) {
      cachedTeam.remove(team as TeamModel);

      // print(cachedTeam.toString());
      // return true;
      bool success = await sharedPreferences.setString(
        CACHED_TEAM_V2,
        jsonEncode(cachedTeam),
      );
      if (success) {
        _fcm.unsubscribeFromTopic("team" + team.id.toString());

        return true;
      } else {
        throw CacheException();
      }
    } else {
      return false;
    }
  }
}
