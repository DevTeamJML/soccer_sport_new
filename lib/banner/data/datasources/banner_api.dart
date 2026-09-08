import 'dart:convert';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:soccer_sport/authentication/domain/entities/wordpress_auth.dart';
import 'package:soccer_sport/banner/domain/entities/banner.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:soccer_sport/footballMatch/data/model/football_match_model.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

import '../../domain/entities/ssc_dialog.dart';
import '../../domain/entities/ssc_fab.dart';

abstract class BannerApiDataSource {
  Future<List<BannerHtml>> getBanner(String api, id);
  Future<List<SscFab>> getSscFab();
  Future<List<SscDialog>> getSscDialog();
}

class BannerApiDataSourceImpl implements BannerApiDataSource {
  final http.Client client;

  BannerApiDataSourceImpl({required this.client});

  @override
  Future<List<BannerHtml>> getBanner(String api, id) async {
    // final response = await client.get(WebUri(FootballApi.bannerApi));

    final response = await client.get(WebUri(api));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body) as List<dynamic>;
      var bannerList = body.map((e) {
        return BannerHtml(
            url: "https://soccersport.club/wp-content/uploads/2023/banner/" +
                e['url'],
            href: e['href']);
      }).toList();
      return bannerList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<SscDialog>> getSscDialog() async {
    // final response = await client.get(WebUri(FootballApi.bannerApi));

    final response = await client.get(
        WebUri("https://soccersport.club/wp-json/wv/v1/get_ssc_dialog"));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body) as List<dynamic>;
      var dialogList = body.map((e) {
        return SscDialog.fromJson(e);
      }).toList();
      return dialogList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<SscFab>> getSscFab() async {
    final response = await client
        .get(WebUri("https://soccersport.club/wp-json/wv/v1/get_ssc_fab"));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body) as List<dynamic>;
      var dialogList = body.map((e) {
        return SscFab.fromJson(e);
      }).toList();
      return dialogList;
    } else {
      throw ServerException();
    }
  }
}
