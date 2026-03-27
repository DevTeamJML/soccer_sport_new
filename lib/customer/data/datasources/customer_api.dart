import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:soccer_sport/checkout/domain/entities/reference.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/error/exception.dart';
import 'package:soccer_sport/customer/domain/entities/cny_detail.dart';
import 'package:soccer_sport/customer/domain/entities/customer.dart';
import 'package:soccer_sport/customer/domain/entities/customer_reward_detail.dart';
import 'package:soccer_sport/customer/domain/entities/shipping.dart';
import 'package:soccer_sport/customer/domain/entities/verified_detail.dart';
import 'package:soccer_sport/customer/domain/usecase/check_verified.dart';
import 'package:soccer_sport/customer/domain/usecase/update_personalize.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

abstract class CustomerApiDataSource {
  Future<Customer> getCustomerDetails(int userID);
  Future<int> getUserBalance(int userID);

  Future<Reference> purchaseReward(int price, int productID);
  Future<int> getDailyReward(CustomerRewardDetail customerRewardDetail);
  Future<bool> addDailyReward(String points);
  Future<CustomerRewardDetail> getUserRewardDetail(String id);
  Future<bool> cnyAddReward(CnyRewardDetail points);

  Future<CnyRewardDetail> cnyGetDetail(String id);

  // Future<bool> convertDiamonds(int diamonds);
  // Future<bool> changePassword(String password);
  // Future<bool> removeFirstLogin();
  Future<VerifiedDetail> checkVerified(String id);
  Future<bool> sendVerificationEmail(String id);
  Future<CustomerRewardDetail> updatePersonalize(String id, List<int> leagues);

  Future<Customer> editAddress(Shipping shipping);
}

class CustomerApiDataSourceImpl implements CustomerApiDataSource {
  final http.Client client;

  CustomerApiDataSourceImpl({required this.client});

  @override
  @override
  Future<Customer> getCustomerDetails(int userID) async {
    String url = FootballApi.wcUrl +
        FootballApi.customerUrl +
        '/${Constant.auth!.id}?consumer_key=${FootballApi.csKey}&consumer_secret=${FootballApi.csSecret}';
    final response = await client.get(WebUri(url), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      Map<String, dynamic> body =
          jsonDecode(response.body) as Map<String, dynamic>;
      Customer customer = Customer.fromMap(body);
      return customer;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Reference> purchaseReward(int price, int productID) async {
    String url = FootballApi.mycredURL +
        FootballApi.points +
        '/deduct?user_id=${Constant.auth!.id}&${FootballApi.csSecret}&value=$price&id=$productID';
    final response = await client.get(WebUri(url), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      Map<String, dynamic> body =
          jsonDecode(response.body) as Map<String, dynamic>;
      Reference ref = Reference.fromMap(body);
      return ref;
    } else {
      throw ServerException();
    }
  }

  // @override
  // Future<bool> convertDiamonds(int diamonds) async {
  //   String url = FootballApi.mycredURL +
  //       FootballApi.points +
  //       '/convert?user_id=${Constant.auth!.id}&access_key=${FootballApi.mycredKey}&${FootballApi.csSecret}&value=$diamonds';
  //   print(url);
  //   final response = await client.get(WebUri(url), headers: {
  //     HttpHeaders.contentTypeHeader: 'application/json',
  //   });
  //
  //   if (response.statusCode == 200) {
  //     // this mean that we are connected to the data base
  //     Map<String, dynamic> body =
  //         jsonDecode(response.body) as Map<String, dynamic>;
  //     if (body['value']) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } else {
  //     throw ServerException();
  //   }
  // }

  @override
  Future<Customer> editAddress(Shipping shipping) async {
    if (Constant.auth != null) {
      var authToken = base64
          .encode(utf8.encode(FootballApi.csKey + ':' + FootballApi.csSecret));
      String url =
          FootballApi.wcUrl + FootballApi.customerUrl + '/${Constant.auth!.id}';
      final response = await client.put(WebUri(url),
          headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: 'application/json',
          },
          body: json.encode({'billing': shipping.toMap()}));

      if (response.statusCode == 200) {
        // this mean that we are connected to the data base
        Map<String, dynamic> body =
            jsonDecode(response.body) as Map<String, dynamic>;
        Customer customer = Customer.fromMap(body);
        return customer;
      } else {
        throw ServerException();
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<int> getUserBalance(int userID) async {
    String url =
        'https://soccersport.club/wp-json/myc/v1/points?user_id=${userID}';

    final response = await client.get(WebUri(url), headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      int body = jsonDecode(response.body) as int;

      return body;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<int> getDailyReward(CustomerRewardDetail customerRewardDetail) async {
    String url = 'https://soccersport.club/wp-admin/API/redeem.php';

    if (Constant.customerRewardDetail != null) {
      final response = await client.post(WebUri(url),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode({
            'ID': Constant.auth!.id,
            'check_in_count': customerRewardDetail.checkInCount,
            'last_check_in': customerRewardDetail.lastCheckIn.toString(),
            'event_period': json.encode(customerRewardDetail.eventPeriod)
          }));

      if (response.statusCode == 200) {
        // this mean that we are connected to the data base
        // int body = jsonDecode(response.body) as int;

        return 200;
      } else {
        throw ServerException();
      }
    } else {
      return 500;
    }
  }

  @override
  Future<bool> addDailyReward(String points) async {
    String url = FootballApi.mycredURL + 'points/add';

    final response = await client.post(WebUri(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        encoding: Encoding.getByName('utf-8'),
        body: {'user_id': Constant.auth!.id.toString(), 'points': points});

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      var body = jsonDecode(response.body) as LinkedHashMap;

      if (body['value'] != null) {
        return body['value']!;
      } else {
        return false;
      }
    } else {
      throw ServerException();
    }
  }

  @override
  Future<CustomerRewardDetail> getUserRewardDetail(String id) async {
    String url = 'https://soccersport.club/wp-admin/API/getData.php';

    final response = await client.post(WebUri(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'ID': Constant.auth!.id,
        }));

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      var list = jsonDecode(response.body) as List;
      var body = CustomerRewardDetail.fromMap(list[0]);

      return body;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<VerifiedDetail> checkVerified(String id) async {
    String url =
        'https://soccersport.club/wp-json/wl/v1/check_verified?user_id=$id';

    final response = await client.get(
      WebUri(url),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      Map<String, dynamic> list = jsonDecode(response.body);
      VerifiedDetail data = VerifiedDetail.fromMap(list);
      return data;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> sendVerificationEmail(String id) async {
    String url =
        'https://soccersport.club/wp-admin/API/send_verification_email.php';

    final response = await client.post(WebUri(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'customer_id': Constant.auth!.id,
        }));

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      // int body = jsonDecode(response.body) as int;
      String result =
          jsonDecode(response.body) is String ? jsonDecode(response.body) : '';
      return result.toLowerCase() == "success" ? true : false;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<bool> cnyAddReward(CnyRewardDetail detail) async {
    String url = 'https://soccersport.club/wp-admin/API/dailySignIn.php';

    final response = await client.post(WebUri(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(detail.toMap()));
    if (response.statusCode == 200) {
      String value = json.decode(response.body) is String
          ? json.decode(response.body)
          : '';
      return value.toLowerCase() == 'success' ? true : false;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<CnyRewardDetail> cnyGetDetail(String id) async {
    String url = 'https://soccersport.club/wp-admin/API/checkDailyRedeem.php';

    final response = await client.post(WebUri(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'ID': id,
        }));
    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      var body = CnyRewardDetail.fromMap(jsonDecode(response.body));

      return body;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<CustomerRewardDetail> updatePersonalize(
      String id, List<int> leagues) async {
    String url = 'https://soccersport.club/wp-json/wv/v1/personal';

    final response = await client.post(WebUri(url),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(
            {'id': Constant.auth!.id, 'personal': jsonEncode(leagues)}));

    if (response.statusCode == 200) {
      // this mean that we are connected to the data base
      var list = jsonDecode(response.body) as List;
      var body = CustomerRewardDetail.fromMap(list[0]);

      return body;
    } else {
      throw ServerException();
    }
  }

  // @override
  // Future<bool> changePassword(String password) async {
  //   final response = await client.post(
  //     WebUri(FootballApi.userURL +
  //         Constant.customer!.id.toString() +
  //         '?password=' +
  //         password),
  //     headers: {
  //       'Host': 'u-buy.zone',
  //       'Authorization': 'Bearer ' + Constant.auth!.token,
  //     },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     // this mean that we are connected to the data base
  //     // Map<String, dynamic> body =
  //     //     jsonDecode(response.body) as Map<String, dynamic>;
  //     // Customer customer = Customer.fromMap(body);
  //     return true;
  //   } else {
  //     throw ServerException();
  //   }
  // }

  // @override
  // Future<bool> removeFirstLogin() async {
  //   final response = await client.get(
  //     WebUri(FootballApi.firstLoginURL + '?id=${Constant.customer!.id}'),
  //     headers: {
  //       HttpHeaders.contentTypeHeader: 'application/json',
  //     },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     bool result = jsonDecode(
  //         response.body); // this mean that we are connected to the data base
  //     // Map<String, dynamic> body =
  //     //     jsonDecode(response.body) as Map<String, dynamic>;
  //     // Customer customer = Customer.fromMap(body);
  //     return result;
  //   } else {
  //     throw ServerException();
  //   }
  // }
}
