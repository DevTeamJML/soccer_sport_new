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
import 'package:soccer_sport/topscore/domain/entities/top_score.dart';

abstract class TopScoreApiDataSource {
  // Future<List<LeagueDetailsModel>> getAllLeague();
  Future<List<TopScore>> getTopScoreByLeague(String id, String season);
}

class TopScoreApiDataSourceImpl implements TopScoreApiDataSource {
  final http.Client client;

  TopScoreApiDataSourceImpl({required this.client});

  @override
  Future<List<TopScore>> getTopScoreByLeague(String id, String season) async {
    final response = await http.get(
        WebUri(FootballApi.topScoreApi + '?league=$id&season=$season'),
        headers: FootballApi.footballHeaders);

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      var body = jsonDecode(response.body);
      List<dynamic> topScoreList = body['response'];
      List<TopScore> matches =
          topScoreList.map((dynamic item) => TopScore.fromMap(item)).toList();

      return matches;
    } else {
      throw ServerException();
    }
  }
}
