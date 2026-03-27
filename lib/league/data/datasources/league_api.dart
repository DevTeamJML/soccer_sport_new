import 'dart:convert';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:http/http.dart' as http;
import 'package:soccer_sport/league/data/model/league_details_model.dart';
import 'package:soccer_sport/league/data/model/league_model.dart';
import 'package:soccer_sport/league/domain/entities/league.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';

abstract class LeagueApiDataSource {
  Future<List<LeagueDetailsModel>> getAllLeague();
  Future<List<LeagueDetailsModel>> getCurrentLeague();
  Future<List<LeagueDetailsModel>> getTeamSeason(String id);

  Future<League> getLeagueByName(String name);
}

class LeagueApiDataSourceImpl implements LeagueApiDataSource {
  // final http.Client client;

  // LeagueApiDataSourceImpl({required this.client});

  @override
  Future<List<LeagueDetailsModel>> getAllLeague() async {
    final response = await http.get(WebUri(FootballApi.leagueApi),
        headers: FootballApi.footballHeaders);
    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      var body = jsonDecode(response.body);

      List<dynamic> matchesList = body['response'];
      List<LeagueDetailsModel> matches = matchesList
          .map((dynamic item) => LeagueDetailsModel.fromJson(item))
          .toList();
      Constant.staticLeagues = matches;
      List<LeagueDetails> leagues =
          List<LeagueDetails>.from(Constant.staticLeagues);
      List<LeagueDetails> importantList = leagues
          .where((element) =>
              element.league.id == 39 ||
              element.league.id == 78 ||
              element.league.id == 61 ||
              element.league.id == 140 ||
              element.league.id == 1)
          .toList();
      print(importantList.length);
      Constant.staticLeagues.removeWhere((element) =>
          element.league.id == 39 ||
          element.league.id == 78 ||
          element.league.id == 61 ||
          element.league.id == 140 ||
          element.league.id == 1);
      importantList.forEach((element) {
        Constant.staticLeagues.insert(0, element);
      });
      // final response2 = await http.get(
      //     WebUri(FootballApi.leagueApi + '?current=true'),
      //     headers: FootballApi.footballHeaders);
      // if (response2.statusCode == 200) {
      //   // this mean that we are connected to the data base
      //   var body2 = jsonDecode(response2.body);
      //   List<dynamic> currentMatchesList = body2['response'];
      //   List<LeagueDetailsModel> currentMatches = currentMatchesList
      //       .map((dynamic item) => LeagueDetailsModel.fromJson(item))
      //       .toList();

      //   Constant.staticLeagues = matches;
      //   Constant.staticCurrentLeagues = currentMatches;

      //   List<LeagueDetails> leagues =
      //       List<LeagueDetails>.from(Constant.staticLeagues);
      //   List<LeagueDetails> importantList = leagues
      //       .where((element) =>
      //           element.league.id == 39 ||
      //           element.league.id == 78 ||
      //           element.league.id == 61 ||
      //           element.league.id == 140)
      //       .toList();
      //   print(importantList.length);
      //   Constant.staticLeagues.removeWhere((element) =>
      //       element.league.id == 39 ||
      //       element.league.id == 78 ||
      //       element.league.id == 61 ||
      //       element.league.id == 140);
      //   importantList.forEach((element) {
      //     Constant.staticLeagues.insert(0, element);
      //   });
      // } else {
      //   throw ServerException();
      // }
      return matches;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<LeagueDetailsModel>> getCurrentLeague() async {
    final response = await http.get(
        WebUri(FootballApi.leagueApi + '?current=true'),
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
  Future<League> getLeagueByName(String name) async {
    // DateTime date = DateTime.now();
    // String formattedYear = date.year.toString();
    // final response = await http.get(
    //     WebUri(FootballApi.standingsApi + '?season=$formattedYear & l'),
    //     headers: FootballApi.footballHeaders);
    //
    // if (response.statusCode == 200) {
    //   // this mean that we are connected to the data base
    //   var body = jsonDecode(response.body);
    //   print("Api service: ${body}"); // to debug

    //   List<dynamic> matchesList = body['response'];
    //   List<LeagueModel> matches = matchesList
    //       .map((dynamic item) => LeagueModel.fromJson(item))
    //       .toList();

    //   return matches;
    // } else {
    throw ServerException();
    // }
  }

  @override
  Future<List<LeagueDetailsModel>> getTeamSeason(id) async {
    final response = await http.get(
        WebUri(FootballApi.leagueApi + '?team=$id'),
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
}
