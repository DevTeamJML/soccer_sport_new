import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:rxdart/rxdart.dart';
import 'package:soccer_sport/authentication/domain/entities/wordpress_auth.dart';
import 'package:soccer_sport/banner/domain/entities/banner.dart';
import 'package:soccer_sport/customer/domain/entities/customer.dart';
import 'package:soccer_sport/customer/domain/entities/customer_reward_detail.dart';
import 'package:soccer_sport/footballMatch/domain/entities/bet_entities/bet.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/presentation/page/football_match_page.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/league/presentation/page/leagues_page.dart';
import 'package:soccer_sport/news/domain/entities/news.dart';
import 'package:soccer_sport/news/presentation/pages/news_page.dart';
import 'package:soccer_sport/products/domain/entities/cart_item.dart';
import 'package:soccer_sport/products/domain/entities/product.dart';
import 'package:soccer_sport/video/domain/entities/video_details.dart';

import '../../footballMatch/domain/entities/team.dart';

class FootballApi {
  static String fixtureApi =
      "https://api-football-v1.p.rapidapi.com/v3/fixtures";
  static String predictionsApi =
      "https://api-football-v1.p.rapidapi.com/v3/predictions";
  static String injuriesApi =
      "https://api-football-v1.p.rapidapi.com/v3/injuries";
  static String statistics =
      "https://api-football-v1.p.rapidapi.com/v3/statistics";

  static String standingsApi =
      "https://api-football-v1.p.rapidapi.com/v3/standings";
  static String leagueApi = "https://api-football-v1.p.rapidapi.com/v3/leagues";
  static String luckyDrawApi =
      'https://soccersport.club/wp-json/wl/v1/lucky_draw';
  static String customerUrl = 'customers';
  static String mycredURL = 'https://soccersport.club/wp-json/myc/v1/';
  static String points = 'points';
  static String categoriesURL = 'products/categories';
  static String productsURL = 'products';

  static String topScoreApi =
      "https://api-football-v1.p.rapidapi.com/v3/players/topscorers";

  static String newsApi = "https://soccersport.club/wp-json/wp/v2/posts";
  static String newsCustomApi = "https://soccersport.club/wp-json/wl/v1/posts";
  static String registerApi =
      "https://soccersport.club/wp-json/wl/v1/users/register";
  static String wcUrl = "https://soccersport.club/wp-json/wc/v3/";
  static String orderURL = 'orders';
  static String addToCartURL = 'addtocart';
  static String cartURL = 'cart';

  static String csKey = 'ck_6ae068a7c3f789d3612771509a6c4fce31ec52ab';
  static String csSecret = 'cs_efa044351327a8139714d8b84c747305ac725a6a';
  static String newsContentApi =
      "https://soccersport.club/wp-json/wl/v1/posts/content";
  static String videoUrl = 'https://www.scorebat.com/video-api/v3/feed/?token=';
  static String wordpressLoginApi =
      "https://soccersport.club/wp-json/jwt-auth/v1/token";
  static String bannerApi =
      "https://soccersport.club/wp-json/wl/v1/get_banner_url";
  static const footballHeaders = {
    'x-rapidapi-host': "api-football-v1.p.rapidapi.com",
    'x-rapidapi-key': "876902b94emsh77d0b36a425e854p10c55cjsnb35e634c87ad"
  };

  static const newsHeaders = {"Accept": "application/json"};
  static String deleteUserURL =
      'https://soccersport.club/wp-json/wp/v2/users/me';

  static const wordpressHeader = {
    "Content-type": "application/x-www-form-urlencoded"
  };

  static const String oneSignalId = 'dafcc052-9b89-4db1-89fc-55bc33c566de';
  static const String videoToken =
      'MjYyNzNfMTY2MjYwMjcxNV9lZjhiYWM3MWQ0OWE5YmFhZTNmYWIwNWEzYWY1YjEzMWMyZDliYzQ5';

  //
}

class Constant {
  static List<LeagueDetails> staticLeagues = [];
  static bool isLive = false;
  static int initialIndex = 0;
  static List<FootballMatch> favoriteList = [];
  static Map<String, List<Team>> favouriteTeam = {};
  static List<Team> favouriteTeamV2 = [];
  static Map<String, List<Team>> teamList = {};
  static List<String> teamPageListOfLeague = [];
  static List<List<Bet>> betList = [[], []];
  static List<News> staticNews = [];
  static News? staticLatestNews;
  static List<CartItem> cartItems = [];
  static List<CartItem> selectedCartList = [];
  static List<Product> allProduct = [];
  static String points = '';
  static CustomerRewardDetail? customerRewardDetail;
  static List<LeagueDetails> staticCurrentLeagues = [];
  static Color backgroundColor = Color.fromARGB(255, 7, 19, 37);
  static Color color1 = Color.fromARGB(255, 159, 0, 0);
  static Color color2 = Color.fromARGB(255, 255, 208, 0);
  static List<Map<String, List<LeagueDetails>>> leaguesSeasonList = [];
  static Customer? customer;
  static WordpressAuth? auth;
  static String updateDate = '';
  static BannerHtml? bannerHtml;
  static String payload = '';
  static bool shouldKeepAlive = true;
  static bool isMember = false;
  static bool isVerified = false;
  static bool p6_registered = false;
  static PageController? pageController;
  static BannerHtml? settingBanner;
  static List<BannerHtml>? newsBanner;
  static BannerHtml? eventBanner;
  static BehaviorSubject<List<FootballMatch>> liveData =
      BehaviorSubject<List<FootballMatch>>();
  static BehaviorSubject<String> testStream = BehaviorSubject<String>();
  static BehaviorSubject<int> test2Stream = BehaviorSubject<int>();
  static List<VideoDetails> recentFeeds = [];
  static GlobalKey settingIcon = GlobalKey();

  static GlobalKey favouriteIcon = GlobalKey();
  static GlobalKey matchIcon = GlobalKey();
  static GlobalKey videIcon = GlobalKey();
  static GlobalKey statsIcon = GlobalKey();

  static GlobalKey matchTabKey = GlobalKey();
  static GlobalKey liveTodayKey = GlobalKey();
  static GlobalKey matchIncomingKey = GlobalKey();
  static GlobalKey matchBetKey = GlobalKey();
  static GlobalKey dropdownButtonKey = GlobalKey();
  static GlobalKey statsGaolsKey = GlobalKey();
  static GlobalKey statsFixturesKey = GlobalKey();
  static GlobalKey favouriteTeamKey = GlobalKey();
  static GlobalKey betMatchInfo = GlobalKey();

  static bool showcaseBool = false;
  static TabController? matchTab;

  static String formattedDate(DateTime date) {
    // print(date.toLocal());
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static String formattedDateMonth(DateTime date) {
    // print(date.toLocal());
    return DateFormat('Md').format(date);
  }

  static String formattedHMTime(DateTime date) {
    // print(date.toLocal());
    return DateFormat('Hm').format(date);
  }

  static bool datetimeIsToday(String date) {
    return Constant.formattedDate(DateTime.parse(date)) ==
        Constant.formattedDate(DateTime.now());
  }

  static String formattedTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  static String dateName(DateTime date) {
    return DateFormat('EEEE').format(date);

    /// e.g Thursday
  }

  static Function deepEq = const DeepCollectionEquality.unordered().equals;
}
