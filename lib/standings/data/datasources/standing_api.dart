import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:http/http.dart' as http;
import 'package:soccer_sport/league/data/model/league_details_model.dart';
import 'package:soccer_sport/league/data/model/league_model.dart';
import 'package:soccer_sport/league/domain/entities/league.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/standings/data/model/league_standings_model.dart';

abstract class StandingApiDataSource {
  // Future<List<LeagueDetailsModel>> getAllLeague();
  Future<LeagueStandingsModel?> getStandingByLeague(String id, int season);
  Future<List<LeagueStandingsModel>> getStandingByTeam(String id, int season);
}

class StandingApiDataSourceImpl implements StandingApiDataSource {
  final http.Client client;

  StandingApiDataSourceImpl({required this.client});

  @override
  Future<List<LeagueDetailsModel>> getAllLeague() async {
    DateTime date = DateTime.now();
    String formattedYear = date.year.toString();
    final response = await http.get(
        WebUri(FootballApi.leagueApi + '?season=2022'),
        headers: FootballApi.footballHeaders);
    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      var body = jsonDecode(response.body);

      List<dynamic> matchesList = body['response'];
      List<LeagueDetailsModel> matches = matchesList
          .map((dynamic item) => LeagueDetailsModel.fromJson(item))
          .toList();

      return matches;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<LeagueStandingsModel?> getStandingByLeague(
      String id, int season) async {
    DateTime date = DateTime.now();
    String formattedYear = date.year.toString();
    String seasonString = season.toString();
    final response = await client.get(
        WebUri(
            FootballApi.standingsApi + '?season=$seasonString&league=$id'),
        headers: FootballApi.footballHeaders);

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      var body = jsonDecode(response.body);

      List<dynamic> matchesList = body['response'];
      if (matchesList.length > 0) {
        LeagueStandingsModel matches =
            LeagueStandingsModel.fromJson(matchesList[0]['league']);
        return matches;
      } else {
        return null;
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<LeagueStandingsModel>> getStandingByTeam(
      String id, int season) async {
    DateTime date = DateTime.now();
    String seasonString = season.toString();
    List<LeagueStandingsModel> list = [];
    final response = await client.get(
        WebUri(FootballApi.standingsApi + '?season=$seasonString&team=$id'),
        headers: FootballApi.footballHeaders);

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      var body = jsonDecode(response.body);

      List<dynamic> matchesList = body['response'];
      if (matchesList.length > 0) {
        list = matchesList
            .map((e) => LeagueStandingsModel.fromJson(e['league']))
            .toList();

        return list;
      } else {
        return list;
      }
    } else {
      throw ServerException();
    }
  }
}
