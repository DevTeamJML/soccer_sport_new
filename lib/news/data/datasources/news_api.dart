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
import 'package:soccer_sport/news/domain/entities/news.dart';
import 'package:soccer_sport/news/domain/entities/news_content.dart';
import 'package:soccer_sport/standings/data/model/league_standings_model.dart';
import 'package:wordpress_api/wordpress_api.dart';
import 'package:html/parser.dart';

abstract class NewsApiDataSource {
  // Future<List<LeagueDetailsModel>> getAllLeague();
  Future<List<News>> getNews(String page);
  Future<List<News>> refreshNews();
  Future<NewsContent> getNewContent(String id, int? userid);
  Future<News> getNewsBySlug(String slug);

  Future<List<News>> loadNews(String page);
}

class NewsApiDataSourceImpl implements NewsApiDataSource {
  final http.Client client;

  NewsApiDataSourceImpl({required this.client});

  @override
  Future<List<News>> getNews(String page) async {
    final response = await client.get(
        WebUri(FootballApi.newsCustomApi + '/$page'),
        headers: FootballApi.newsHeaders);
    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      List<dynamic> listDynamic = jsonDecode(response.body);
      List<News> newsList = listDynamic.map((e) => News.fromJson(e)).toList();
      return newsList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<News>> loadNews(String page) async {
    final response = await client.get(
        WebUri(FootballApi.newsCustomApi + '/$page'),
        headers: FootballApi.newsHeaders);
    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      List<dynamic> listDynamic = jsonDecode(response.body);
      List<News> newsList = listDynamic.map((e) => News.fromJson(e)).toList();
      return newsList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<News>> refreshNews() async {
    final response = await client.get(
        WebUri(FootballApi.newsCustomApi + '/1'),
        headers: FootballApi.newsHeaders);
    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      List<dynamic> listDynamic = jsonDecode(response.body);
      List<News> newsList = listDynamic.map((e) => News.fromJson(e)).toList();
      return newsList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<NewsContent> getNewContent(String id, int? userid) async {
    List<String> seperatedText = [];
    final response = await client.get(
        WebUri(FootballApi.newsContentApi +
            '?id=$id' +
            (userid != null ? '&&user_id=${userid.toString()}' : '')),
        headers: FootballApi.newsHeaders);
    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      Map<String, dynamic> body =
          jsonDecode(response.body) as Map<String, dynamic>;
      String contentWithHTML = body['content'];
      String content = parse(contentWithHTML).documentElement!.text;
      seperatedText = content.split('\n');

      NewsContent newsContent =
          NewsContent(content: seperatedText, get_points: body['get_point']);
      return newsContent;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<News> getNewsBySlug(String slug) async {
    final response = await client.post(
        WebUri("https://soccersport.club/wp-json/wv/v1/newsSlug" +
            '?slug=${slug}'),
        headers: FootballApi.newsHeaders);
    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      var json = jsonDecode(response.body);
      News news = News.fromJson(json);
      return news;
    } else {
      throw ServerException();
    }
  }
}
