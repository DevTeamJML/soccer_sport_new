import 'dart:convert';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:soccer_sport/authentication/domain/entities/user.dart';
import 'package:soccer_sport/authentication/domain/entities/wordpress_auth.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:soccer_sport/footballMatch/data/model/football_match_model.dart';
import 'package:http/http.dart' as http;

abstract class WordpressAuthApiDataSource {
  Future<WordpressAuth?> wordpressLogin(String username, String password);
  Future<bool> validateAuth();
  Future<bool> deleteAccount();
  Future<User?> registerUser(String username, email, password);
}

class WordpressAuthApiDataSourceImpl implements WordpressAuthApiDataSource {
  final http.Client client;

  WordpressAuthApiDataSourceImpl({required this.client});

  @override
  Future<WordpressAuth?> wordpressLogin(
      String username, String password) async {
    final response = await client.post(WebUri(FootballApi.wordpressLoginApi),
        headers: FootballApi.wordpressHeader,
        body: {
          'username': username,
          'password': password,
        });
    print(response.body);
    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      var body = jsonDecode(response.body);

      WordpressAuth auth = WordpressAuth.fromMap(body);
      Constant.auth = auth;
      return auth;
    } else if (response.statusCode == 403) {
      return null;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> wordpressLogout() async {
    final response = await client.get(WebUri(FootballApi.fixtureApi),
        headers: FootballApi.footballHeaders);

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      var body = jsonDecode(response.body);
      List<dynamic> list = body['response'];

      List<String> matchesList = list.map((e) => e.toString()).toList();

      return true;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> validateAuth() async {
    final response = await client
        .post(WebUri(FootballApi.wordpressLoginApi + '/validate'), headers: {
      'Host': 'soccersport.club',
      'Authorization': 'Bearer ' + Constant.auth!.token
    });

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      var body = jsonDecode(response.body);

      return true;
    } else if (response.statusCode == 403) {
      return false;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> deleteAccount() async {
    var deleteUserURL;
    final response = await client.delete(
        WebUri(FootballApi.deleteUserURL + '?reassign=0&force=true'),
        headers: {
          'Host': 'soccersport.club',
          'Authorization': 'Bearer ' + Constant.auth!.token
        });

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      var body = jsonDecode(response.body);
      return true;
    } else if (response.statusCode == 403) {
      return false;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<User?> registerUser(String username, email, password) async {
    var deleteUserURL;
    final response = await client.post(
      WebUri(FootballApi.registerApi +
          '?username=$username&email=$email&password=$password'),
    );
    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      // var body = jsonDecode(response.body);

      String url = 'https://soccersport.club/wp-admin/API/ssc_verify_email.php';

      final response2 = await client.post(WebUri(url),
          headers: {
            "content-type": 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode({
            "email": email,
            "name": username,
          }));

      if (response2.statusCode == 200) {
        // this mean that we are connected to the data base
        // int body = jsonDecode(response.body) as int;
      }

      return User(username: username, password: password);
    } else if (response.statusCode == 400) {
      return null;
    } else {
      throw ServerException();
    }
  }
}
