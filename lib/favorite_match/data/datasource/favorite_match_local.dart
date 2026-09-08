import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/constant/local_notification_service.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:http/http.dart' as http;
import 'package:soccer_sport/footballMatch/data/model/football_match_model.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/league/data/model/league_details_model.dart';
import 'package:soccer_sport/league/data/model/league_model.dart';
import 'package:soccer_sport/league/domain/entities/league.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class FavoriteMatchLocalDataSource {
  Future<List<FootballMatchModel>> getFavoriteMatches();
  Future<bool> persistFavoriteMatch(FootballMatch match);
  Future<bool> persistUpdateFavoriteMatch(List<FootballMatch> match);

  Future<bool> removeFavoriteMatch(FootballMatch match);
  Future<bool> removeAllFavoriteMatch();
}

const CACHED_MATCHES = 'CACHED_MATCHES';

class FavoriteMatchLocalDataSourceImpl implements FavoriteMatchLocalDataSource {
  final SharedPreferences sharedPreferences;

  FavoriteMatchLocalDataSourceImpl({required this.sharedPreferences});
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  @override
  Future<bool> persistFavoriteMatch(FootballMatch match) async {
    List<String> matchString = [];
    List<FootballMatchModel> cachedMatch = await getFavoriteMatches();
    cachedMatch.add(match as FootballMatchModel);
    matchString = cachedMatch.map((e) => jsonEncode(e.toJson())).toList();

    bool success = await sharedPreferences.setStringList(
      CACHED_MATCHES,
      matchString,
    );
    if (success) {
      Constant.favoriteList = cachedMatch;
      await LocalNotificationService.createReminderNotifications(
          date: DateTime.parse(match.fixture.date).toLocal(),
          id: match.fixture.id,
          title: (match.home.name + ' vs ' + match.away.name),
          body: 'The match will begin soon',
          payload: {
            'value': match.league!.id.toString(),
          });
      _fcm.subscribeToTopic("fixtures" + (match.fixture.id.toString()));

      // await LocalNotificationService.showScheduledNotification(
      //     id: match.fixture.id,
      //     title: (match.home.name + ' vs ' + match.away.name),
      //     body: 'The match will begin soon',
      //     payload: match.league!.id.toString(),
      //     date: DateTime.parse(match.fixture.date));

      return true;
    } else {
      throw CacheException();
    }
  }

  @override
  Future<List<FootballMatchModel>> getFavoriteMatches() {
    final matchString = sharedPreferences.getStringList(CACHED_MATCHES);

    if (matchString != null) {
      List<FootballMatchModel> matches = [];
      matches = matchString
          .map((e) => FootballMatchModel.fromJson(json.decode(e)))
          .toList();

      // Constant.staticLeagues = matches;

      return Future.value(matches);
    } else {
      return Future.value([]); // Return empty list when not found
    }
  }

  @override
  Future<bool> removeFavoriteMatch(FootballMatch match) async {
    final matchString = sharedPreferences.getStringList(CACHED_MATCHES);

    if (matchString != null) {
      List<FootballMatchModel> matches = [];
      matches = matchString
          .map((e) => FootballMatchModel.fromJson(json.decode(e)))
          .toList();
      matches.removeWhere((element) => element.fixture.id == match.fixture.id);

      final newList = matches.map((e) => jsonEncode(e)).toList();
      // Constant.staticLeagues = matches;
      bool success = await sharedPreferences.setStringList(
        CACHED_MATCHES,
        newList,
      );

      if (success) {
        await LocalNotificationService.cancelScheduleNotification(
          id: match.fixture.id,
        );
        _fcm.unsubscribeFromTopic("fixtures" + (match.fixture.id.toString()));

        // await LocalNotificationService.cancelNotification(
        //   id: match.fixture.id,
        // );
        Constant.favoriteList = matches;
        return true;
      } else {
        throw CacheException();
      }
    } else {
      return false;
    }
  }

  @override
  Future<bool> removeAllFavoriteMatch() async {
    final notificationBool = await sharedPreferences.remove(CACHED_MATCHES);

    return notificationBool;
  }

  @override
  Future<bool> persistUpdateFavoriteMatch(List<FootballMatch> match) async {
    List<String> matchString = [];
    matchString = match.map((e) {
      var match = FootballMatchModel.fromEntity(e);

      return jsonEncode(match.toJson());
    }).toList();

    bool success = await sharedPreferences.setStringList(
      CACHED_MATCHES,
      matchString,
    );
    if (success) {
      Constant.favoriteList = match;
      return true;
    } else {
      throw CacheException();
    }
  }
}
