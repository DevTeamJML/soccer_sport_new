import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:html/parser.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:http/http.dart' as http;
import 'package:soccer_sport/league/data/model/league_details_model.dart';
import 'package:soccer_sport/league/data/model/league_model.dart';
import 'package:soccer_sport/league/domain/entities/league.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';

import '../../domain/entities/video_details.dart';

abstract class VideoDetailsApiDataSource {
  // Future<List<LeagueDetailsModel>> getAllLeague();
  Future<List<VideoDetails>> getRecentFeed();
  Future<bool> checkSscLive();

  Future<String> getYtUrlFromApi(String api);
}

class VideoDetailsApiDataSourceImpl implements VideoDetailsApiDataSource {
  final http.Client client;

  VideoDetailsApiDataSourceImpl({required this.client});

  @override
  Future<List<VideoDetails>> getRecentFeed() async {
    final response = await http.get(
        WebUri(FootballApi.videoUrl + FootballApi.videoToken),
        headers: {
          "Accept": "*/*",
        });

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      var body = jsonDecode(response.body);
      List<dynamic> VideoDetailsList = body['response'];
      List<VideoDetails> matches =
          VideoDetailsList.map((dynamic item) => VideoDetails.fromJson(item))
              .toList();

      return matches;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<String> getYtUrlFromApi(String api) async {
    final response = await http.get(WebUri(api));
    if (response.statusCode == 200) {
      String html = response.body;
      List<String> splittedHtml = html.split('bt.href');
      if (splittedHtml.length > 1) {
        var bthref = splittedHtml[1];
        var stringIncludedYt = bthref.split("'");
        if (stringIncludedYt.length > 1) {
          if (stringIncludedYt[1].contains('www.youtube.com')) {
            return stringIncludedYt[1];
          } else {
            return '';
          }
        } else {
          return '';
        }
      } else {
        return '';
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> checkSscLive() async {
    final response = await http.get(
      WebUri("https://soccersport.club/wp-json/wv/v1/check_ssc_live"),
    );
    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      var body = jsonDecode(response.body);

      var isLive = body == "1" || body == 1 ? true : false;

      return isLive;
    } else {
      throw ServerException();
    }
  }
}
