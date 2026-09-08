import 'dart:convert';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:http/http.dart' as http;
import 'package:soccer_sport/league/data/model/league_details_model.dart';
import 'package:soccer_sport/league/data/model/league_model.dart';
import 'package:soccer_sport/league/domain/entities/league.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/lucky_draw/domain/entities/lucky_draw_info.dart';

abstract class LuckyDrawApiDateSource {
  Future<LuckyDrawInfo> luckyDraw(LuckyDrawInfo luckyDraw);
  Future<LuckyDrawInfo> retrieveLuckyDraw(int id);
}

class LuckyDrawApiDateSourceImpl implements LuckyDrawApiDateSource {
  // final http.Client client;

  // LuckyDrawApiDateSourceImpl({required this.client});

  @override
  Future<LuckyDrawInfo> luckyDraw(LuckyDrawInfo luckyDraw) async {
    final response = await http.post(WebUri(FootballApi.luckyDrawApi),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(luckyDraw.toMap()));

    if (response.statusCode == 200 &&
        jsonDecode(response.body)['Error'] == null) {
      // this mean that we are connected to the data base
      var body = jsonDecode(response.body);
      LuckyDrawInfo luckyDraw = LuckyDrawInfo.fromMap(body);

      return luckyDraw;
    } else if (jsonDecode(response.body)['Error'] != null &&
        jsonDecode(response.body)['Error'] == '402') {
      throw NotEnugCoin();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<LuckyDrawInfo> retrieveLuckyDraw(int id) async {
    final response = await http.post(
        WebUri(FootballApi.luckyDrawApi + '_info'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({"ID": id}));

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      var body = jsonDecode(response.body);
      LuckyDrawInfo luckyDraw = LuckyDrawInfo.fromMap(body);

      return luckyDraw;
    } else {
      throw ServerException();
    }
  }
}
