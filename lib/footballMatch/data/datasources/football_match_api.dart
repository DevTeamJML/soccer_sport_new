import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:soccer_sport/footballMatch/data/model/football_match_model.dart';
import 'package:http/http.dart' as http;
import 'package:soccer_sport/footballMatch/domain/entities/bet_entities/bet.dart';
import 'package:soccer_sport/footballMatch/domain/entities/bet_ranking/bet_ranking.dart';
import 'package:soccer_sport/footballMatch/domain/entities/event.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/match_injuries.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/match_lineups.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/match_stats_info.dart';
import 'package:soccer_sport/footballMatch/domain/entities/match_info/predict.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_match_injuries.dart';

import '../../domain/entities/team_info/player_stats_info.dart';
import '../../domain/entities/team_info/player_stats_info_v2.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';

abstract class FootballMatchApiDataSource {
  Future<List<FootballMatchModel>> getAllMatch();
  Future<List<FootballMatchModel>> getAllIncomingMatch();

  Future<List<FootballMatchModel>> getFixturesByLeague(
      String id, String season);
  Future<List<FootballMatchModel>> getFixtureBetweenDates(List<String> ids);
  Future<List<FootballMatchModel>> getIncomingFixturesByLeague(
      String id, String season);

  Future<List<FootballMatchModel>> getFixtureByRound(
      String round, String id, String season);
  Future<List<String>> getFixtureRounds(String id, String season);
  Future<String> getFixturesCurrentRound(String id, String season);
  Future<FootballMatchModel?> checkFixtureOnLive(
      FootballMatchModel ongoingMatch);
  Future<List<FootballMatchModel>?> getIncomingLiveMatch();
  Future<List<FootballMatchModel>> getAllMatchByLeague(
      String id, String season);
  Future<List<List<Bet>>> getBetLog(String id);
  Future<List<List<Bet>>> updateBet(String id, List<Bet> bet, List<Bet> betLog);
  Future<List<List<Bet>>> updateFinishedBet(
      String id, List<Bet> bet, List<Bet> betLog);

  Future<bool> betWonUpdate(String id, int value, List<String> data);
  Future<List<BetRanking>> getBetRanking();
  Future<List<MatchStatsInfo>> getMatchStatsInfo(String id);
  Future<List<MatchLineups>> getMatchLineups(String id);
  Future<List<MatchInjuries>> getMatchInjuries(String id);
  Future<List<Event>> getMatchEvent(String id);
  Future<Predict> getMatchPredict(String id);
  Future<List<FootballMatchModel>> getFixturesByTeam(String id, String season);
  Future<List<PlayerStatsInfoV2>> getPlayerStatsInfo(String id, String season);
}

class FootballMatchApiDataSourceImpl implements FootballMatchApiDataSource {
  // final http.Client client;

  // FootballMatchApiDataSourceImpl({required this.client});

  @override
  Future<List<FootballMatchModel>> getAllMatch() async {
    DateTime date = DateTime.now();
    String formattedDate = Constant.formattedDate(date);
    int test = 811500;
    final response = await http.get(
        WebUri(FootballApi.fixtureApi +
            '?live=188-7573-15550&timezone=Asia/Singapore'),
        headers: FootballApi.footballHeaders);

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      var body = jsonDecode(response.body);

      List<dynamic> matchesList = body['response'];
      List<FootballMatchModel> matches = matchesList
          .map((dynamic item) => FootballMatchModel.fromJson(item))
          .toList();

      // const allowedLeagues = [39, 135, 78, 140, 1];

      const allowedLeagues = [
        39, // Premier League
        78, // Bundesliga
        135, // Serie A
        140, // La Liga
        61, // Ligue 1
        2, // UEFA Champions League
        3, // UEFA Europa League
        848, // UEFA Europa Conference League
        5, // UEFA Nations League
        1, //
        850
      ];

      matches = matches.where((m) {
        return allowedLeagues.contains(m.league?.id);
      }).toList();

      return matches;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<FootballMatchModel>> getFixturesByLeague(
      String id, String season) async {
    DateTime date = DateTime.now();
    String formattedDate = Constant.formattedDate(date);

    var lastMonth = DateTime(date.year, date.month - 1, date.day);
    var nextMonth = DateTime(date.year, date.month + 1, date.day);

    // String formattedLastTwoMonth = Constant.formattedDate(lastTwoMonth);
    String formmattedLastMonth = Constant.formattedDate(lastMonth);
    String formattedNextMonth = Constant.formattedDate(nextMonth);
    int leageId = 370;
    int seaason = 2021;
    final response = await http.get(
        WebUri(FootballApi.fixtureApi +
            '?league=$id&next=50&timezone=Asia/Singapore'),
        // WebUri(FootballApi.fixtureApi + '?live=all&timezone=Asia/Singapore'),
        // WebUri(FootballApi.fixtureApi +
        //     '?league=$leageId&season=$seaason&from=$formattedLastTwoMonth&to=$formattedDate&timezone=Asia/Singapore'),
        headers: FootballApi.footballHeaders);

    final response2 = await http.get(
        WebUri(FootballApi.fixtureApi +
            '?league=$id&last=50&timezone=Asia/Singapore'),
        // WebUri(FootballApi.fixtureApi + '?live=all&timezone=Asia/Singapore'),
        // WebUri(FootballApi.fixtureApi +
        //     '?league=$leageId&season=$seaason&from=$formattedLastTwoMonth&to=$formattedDate&timezone=Asia/Singapore'),
        headers: FootballApi.footballHeaders);

    var body1;

    var body2;

    if (response.statusCode == 200 && response2.statusCode == 200) {
      // this mean that we are connected to the data base
      body1 = jsonDecode(response.body);
      List<dynamic> matchesList1 = body1['response'];
      List<FootballMatchModel> matches1 = matchesList1
          .map((dynamic item) => FootballMatchModel.fromJson(item))
          .toList();

      body2 = jsonDecode(response2.body);
      List<dynamic> matchesList2 = body2['response'];
      List<FootballMatchModel> matches2 = matchesList2
          .map((dynamic item) => FootballMatchModel.fromJson(item))
          .toList();

      return [...matches1, ...matches2];
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<FootballMatchModel>> getIncomingFixturesByLeague(
      String id, String season) async {
    DateTime date = DateTime.now();
    String formattedDate = Constant.formattedDate(date);

    var nextTwoMonth = DateTime(date.year, date.month + 2, date.day);
    String formattedNextTwoMonth = Constant.formattedDate(nextTwoMonth);

    final response = await http.get(
        WebUri(FootballApi.fixtureApi + '?league=$id&next=99'),

        // WebUri(FootballApi.fixtureApi +
        //     '?league=$id&season=$season&from=$formattedDate&to=$formattedNextTwoMonth&timezone=Asia/Singapore'),
        headers: FootballApi.footballHeaders);

    var body;

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      body = jsonDecode(response.body);

      List<dynamic> matchesList = body['response'];
      List<FootballMatchModel> matches = matchesList
          .map((dynamic item) => FootballMatchModel.fromJson(item))
          .toList();

      return matches;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<FootballMatchModel>> getAllIncomingMatch() async {
    DateTime date = DateTime.now();
    String formattedDate = Constant.formattedDate(date);
    final response = await http.get(
        WebUri(FootballApi.fixtureApi + '?live=all&timezone=Asia/Singapore'),
        headers: FootballApi.footballHeaders);

    var body;

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      body = jsonDecode(response.body);
      List<dynamic> matchesList = body['response'];
      List<FootballMatchModel> matches = matchesList
          .map((dynamic item) => FootballMatchModel.fromJson(item))
          .toList();

      // const allowedLeagues = [39, 135, 78, 140, 1];
      const allowedLeagues = [
        39, // Premier League
        78, // Bundesliga
        135, // Serie A
        140, // La Liga
        61, // Ligue 1
        2, // UEFA Champions League
        3, // UEFA Europa League
        848, // UEFA Europa Conference League
        5, // UEFA Nations League
        1, //
        850
      ];

      matches = matches.where((m) {
        return allowedLeagues.contains(m.league?.id);
      }).toList();

      return matches;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<FootballMatchModel>> getFixtureByRound(
      String round, String id, String season) async {
    final response = await http.get(
        WebUri(
            FootballApi.fixtureApi + '?league=$id&season=$season&round=$round'),
        headers: FootballApi.footballHeaders);

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      var body = jsonDecode(response.body);
      List<dynamic> matchesList = body['response'];
      List<FootballMatchModel> matches = matchesList
          .map((dynamic item) => FootballMatchModel.fromJson(item))
          .toList();

      return matches;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<String>> getFixtureRounds(String id, String season) async {
    final response = await http.get(
        WebUri(FootballApi.fixtureApi + '/rounds?league=$id&season=$season'),
        headers: FootballApi.footballHeaders);

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      var body = jsonDecode(response.body);

      List<dynamic> list = body['response'];
      List<String> matchesList = list.map((e) => e.toString()).toList();

      return matchesList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<String> getFixturesCurrentRound(String id, String season) async {
    final response = await http.get(
        WebUri(FootballApi.fixtureApi +
            '/rounds?league=$id&season=$season&current=true'),
        headers: FootballApi.footballHeaders);

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      var body = jsonDecode(response.body);

      List<dynamic> list = body['response'];

      List<String> matchesList = list.map((e) => e.toString()).toList();
      if (matchesList.length > 0) {
        return matchesList[0];
      } else {
        return '';
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<FootballMatchModel?> checkFixtureOnLive(
      FootballMatchModel ongoingMatch) async {
    String idParameter = ongoingMatch.league!.id.toString() +
        '-' +
        ongoingMatch.home.id.toString() +
        '-' +
        ongoingMatch.away.id.toString();
    final response = await http.get(
        WebUri(FootballApi.fixtureApi + '?live=$idParameter'),
        headers: FootballApi.footballHeaders);
    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      var body = jsonDecode(response.body);

      List<dynamic> list = body['response'];

      if (list.length > 0) {
        return FootballMatchModel.fromJson(list[0]);
      } else {
        return null;
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<FootballMatchModel>?> getIncomingLiveMatch() async {
    DateTime date = DateTime.now();
    String formattedDate = Constant.formattedDate(date);

    final response = await http.get(
        WebUri(FootballApi.fixtureApi +
            '?date=$formattedDate&timezone=Asia/Singapore'),

        // WebUri(FootballApi.fixtureApi +
        //     '?league=$id&season=$season&from=$formattedDate&to=$formattedNextTwoMonth&timezone=Asia/Singapore'),
        headers: FootballApi.footballHeaders);

    var body;

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      body = jsonDecode(response.body);

      List<dynamic> matchesList = body['response'];
      if (matchesList.length > 0) {
        List<FootballMatchModel> matches = matchesList
            .map((dynamic item) => FootballMatchModel.fromJson(item))
            .toList();

        // const allowedLeagues = [39, 135, 78, 140, 1];
        const allowedLeagues = [
          39, // Premier League
          78, // Bundesliga
          135, // Serie A
          140, // La Liga
          61, // Ligue 1
          2, // UEFA Champions League
          3, // UEFA Europa League
          848, // UEFA Europa Conference League
          5, // UEFA Nations League
          1, //
          850
        ];

        matches = matches.where((m) {
          return allowedLeagues.contains(m.league?.id);
        }).toList();

        return matches;
      } else {
        return [];
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<FootballMatchModel>> getFixtureBetweenDates(
      List<String> ids) async {
    String listId = ids.join('-');

    final response = await http.get(
        WebUri(FootballApi.fixtureApi + '?ids=$listId&timezone=Asia/Singapore'),
        headers: FootballApi.footballHeaders);

    var body;

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      body = jsonDecode(response.body);

      List<dynamic> matchesList = body['response'];
      List<FootballMatchModel> matches = matchesList
          .map((dynamic item) => FootballMatchModel.fromJson(item))
          .toList();

      return matches;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<FootballMatchModel>> getAllMatchByLeague(
      String id, String season) async {
    final response = await http.get(
        WebUri(FootballApi.fixtureApi + '?league=$id&season=$season'),
        // WebUri(FootballApi.fixtureApi + '?live=all&timezone=Asia/Singapore'),
        // WebUri(FootballApi.fixtureApi +
        //     '?league=$leageId&season=$seaason&from=$formattedLastTwoMonth&to=$formattedDate&timezone=Asia/Singapore'),
        headers: FootballApi.footballHeaders);

    var body;

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      body = jsonDecode(response.body);

      List<dynamic> matchesList = body['response'];
      List<FootballMatchModel> matches = matchesList
          .map((dynamic item) => FootballMatchModel.fromJson(item))
          .toList();

      // const allowedLeagues = [39, 135, 78, 140, 1];
      const allowedLeagues = [
        39, // Premier League
        78, // Bundesliga
        135, // Serie A
        140, // La Liga
        61, // Ligue 1
        2, // UEFA Champions League
        3, // UEFA Europa League
        848, // UEFA Europa Conference League
        5, // UEFA Nations League
        1, //
        850
      ];

      matches = matches.where((m) {
        return allowedLeagues.contains(m.league?.id);
      }).toList();

      return matches;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<List<Bet>>> getBetLog(String id) async {
    String url = "https://soccersport.club/wp-json/wl/v1/get_bet_details";
    final response = await http.post(WebUri(url),
        headers: {
          "content-type": 'application/json',
        },
        body: jsonEncode({
          'id': int.parse(id),
        }));
    List<List<Bet>> result = [];

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);

      result.add((jsonDecode(body['bet']) as List<dynamic>)
          .map((e) => Bet.fromJson(e))
          .toList());
      result.add((jsonDecode(body['betLog']) as List<dynamic>)
          .map((e) => Bet.fromJson(e))
          .toList());
      return result;
    } else {
      throw ServerException();
    }
    // Map<String, dynamic> test = {};
    // // Bet.fromJson(test)
    // return Future.value();
  }

  @override
  Future<List<List<Bet>>> updateBet(
      String id, List<Bet> bet, List<Bet> betLog) async {
    String url = "https://soccersport.club/wp-json/wl/v1/bet_fixtures";
    final response = await http.post(WebUri(url),
        headers: {
          "content-type": 'application/json',
        },
        body: jsonEncode({
          'id': int.parse(id),
          'bet': json.encode(bet.map((e) => e.toJson()).toList()),
          'betLog': json.encode(betLog.map((e) => e.toJson()).toList()),
        }));
    List<List<Bet>> result = [];

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      result.add((jsonDecode(body['bet']) as List<dynamic>)
          .map((e) => Bet.fromJson(e))
          .toList());
      result.add((jsonDecode(body['betLog']) as List<dynamic>)
          .map((e) => Bet.fromJson(e))
          .toList());
      return result;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> betWonUpdate(String id, int value, List<String> data) async {
    String url = "https://soccersport.club/wp-json/wl/v1/bet_won";
    final response = await http.post(WebUri(url),
        headers: {
          "content-type": 'application/json',
        },
        body: jsonEncode({
          'id': int.parse(id),
          'value': value,
          'data': data,
        }));

    if (response.statusCode == 200) {
      bool body = jsonDecode(response.body);

      return body;
    } else if (jsonDecode(response.body)['Error'] != null &&
        jsonDecode(response.body)['Error'] == '402') {
      throw NotEnugCoin();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<List<Bet>>> updateFinishedBet(
      String id, List<Bet> bet, List<Bet> betLog) async {
    String url = "https://soccersport.club/wp-json/wl/v1/update_bet";
    final response = await http.post(WebUri(url),
        headers: {
          "content-type": 'application/json',
        },
        body: jsonEncode({
          'id': int.parse(id),
          'bet': json.encode(bet.map((e) => e.toJson()).toList()),
          'betLog': json.encode(betLog.map((e) => e.toJson()).toList()),
        }));
    List<List<Bet>> result = [];

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      result.add((jsonDecode(body['bet']) as List<dynamic>)
          .map((e) => Bet.fromJson(e))
          .toList());
      result.add((jsonDecode(body['betLog']) as List<dynamic>)
          .map((e) => Bet.fromJson(e))
          .toList());
      return result;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<BetRanking>> getBetRanking() async {
    String url = "https://soccersport.club/wp-json/wv/v1/bet_rank";
    final response = await http.get(
      WebUri(url),
      headers: {
        "content-type": 'application/json',
      },
    );
    List<BetRanking> result = [];

    if (response.statusCode == 200) {
      var list = jsonDecode(response.body) as List;
      result = list.map((e) => BetRanking.fromJson(e)).toList();

      return result;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MatchStatsInfo>> getMatchStatsInfo(String id) async {
    DateTime date = DateTime.now();
    final response = await http.get(
        WebUri(FootballApi.fixtureApi + '/statistics?fixture=$id'),
        headers: FootballApi.footballHeaders);

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      var body = jsonDecode(response.body);

      List<dynamic> matchesList = body['response'];
      List<MatchStatsInfo> matches = matchesList
          .map((dynamic item) => MatchStatsInfo.fromMap(item))
          .toList();

      return matches;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MatchLineups>> getMatchLineups(String id) async {
    final response = await http.get(
        WebUri(FootballApi.fixtureApi + '/lineups?fixture=$id'),
        headers: FootballApi.footballHeaders);
    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      var body = jsonDecode(response.body);

      List<dynamic> matchesList = body['response'];
      List<MatchLineups> matches = matchesList
          .map((dynamic item) => MatchLineups.fromMap(item))
          .toList();

      return matches;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<MatchInjuries>> getMatchInjuries(String id) async {
    final response = await http.get(
        WebUri(FootballApi.injuriesApi + '?fixture=$id'),
        headers: FootballApi.footballHeaders);

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      var body = jsonDecode(response.body);

      List<dynamic> matchesList = body['response'];
      List<MatchInjuries> matches = matchesList
          .map((dynamic item) => MatchInjuries.fromMap(item))
          .toList();

      return matches;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<Event>> getMatchEvent(String id) async {
    final response = await http.get(
        WebUri(FootballApi.fixtureApi + '/events?fixture=$id'),
        headers: FootballApi.footballHeaders);

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      var body = jsonDecode(response.body);

      List<dynamic> matchesList = body['response'];
      List<Event> matches =
          matchesList.map((dynamic item) => Event.fromJson(item)).toList();

      return matches;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Predict> getMatchPredict(String id) async {
    final response = await http.get(
        WebUri(FootballApi.predictionsApi + '?fixture=$id'),
        headers: FootballApi.footballHeaders);

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      var body = jsonDecode(response.body);

      List<dynamic> matchesList = body['response'];
      Predict predict = Predict.fromMap(matchesList[0]);

      return predict;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<FootballMatchModel>> getFixturesByTeam(
      String id, String season) async {
    final response = await http.get(
        WebUri(FootballApi.fixtureApi + '?season=$season&team=$id'),
        headers: FootballApi.footballHeaders);

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      var body = jsonDecode(response.body);

      List<dynamic> matchesList = body['response'];
      List<FootballMatchModel> matches = matchesList
          .map((dynamic item) => FootballMatchModel.fromJson(item))
          .toList();

      return matches;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<PlayerStatsInfoV2>> getPlayerStatsInfo(
      String id, String season) async {
    final response = await http.get(
        WebUri("https://v3.football.api-sports.io/players/team/$id"),
        headers: FootballApi.footballHeaders);

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      var body = jsonDecode(response.body);

      List<dynamic> matchesList = body['api']['players'];
      List<PlayerStatsInfoV2> matches = matchesList
          .map((dynamic item) => PlayerStatsInfoV2.fromJson(item))
          .toList();
      List<PlayerStatsInfoV2> filteredMatch = matches.where((element) {
        DateTime today = DateTime.now();
        int minYear = today.year - 3;
        if (element.season.contains("-")) {
          List<int> splitYear =
              element.season.split("-").map((e) => int.parse(e)).toList();
          return splitYear[0] >= minYear;
        } else {
          return int.tryParse(element.season) != null
              ? int.parse(element.season) >= minYear
              : false;
        }
      }).toList();
      return matches;
    } else {
      throw ServerException();
    }
  }
}
