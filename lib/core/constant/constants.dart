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
      "https://v3.football.api-sports.io/fixtures";
  static String predictionsApi =
      "https://v3.football.api-sports.io/predictions";
  static String injuriesApi =
      "https://v3.football.api-sports.io/injuries";
  static String statistics =
      "https://v3.football.api-sports.io/statistics";

  static String standingsApi =
      "https://v3.football.api-sports.io/standings";
  static String leagueApi = "https://v3.football.api-sports.io/leagues";
  static String luckyDrawApi =
      'https://soccersport.club/wp-json/wl/v1/lucky_draw';
  static String customerUrl = 'customers';
  static String mycredURL = 'https://soccersport.club/wp-json/myc/v1/';
  static String points = 'points';
  static String categoriesURL = 'products/categories';
  static String productsURL = 'products';

  static String topScoreApi =
      "https://v3.football.api-sports.io/players/topscorers";

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
//   static const footballHeaders = {
//      "x-apisports-key": "c1d890ace076bef9b4a6199f081ed86a",
//   };
    static const footballHeaders = {
     "x-apisports-key": "7471276e8579f09d3a832f173d738621",
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

  static const List<int> footballLeagues = [
  39,  // Premier League
  78,  // Bundesliga
  135, // Serie A
  140, // La Liga
  61,  // Ligue 1
  2,   // UEFA Champions League
  3,   // UEFA Europa League
  848, // UEFA Europa Conference League
  5,   // UEFA Nations LeagueR
  1,

  // England
  40, // Championship
  45, // FA Cup
  48, // League Cup

  // Spain
  141, // Segunda Division
  143, // Copa del Rey

  // Germany
  79, // 2. Bundesliga
  81, // DFB Pokal

  // Italy
  136, // Serie B
  137, // Coppa Italia

  // France
  62, // Ligue 2
  66, // Coupe de France

  // Netherlands, Portugal, Belgium
  88,  // Eredivisie
  94,  // Primeira Liga
  144, // Belgian Pro League

  // Other European leagues
  179, // Scottish Premiership
  203, // Turkish Super Lig
  197, // Greek Super League
  218, // Austrian Bundesliga
  207, // Swiss Super League
  119, // Danish Superliga
  103, // Norwegian Eliteserien
  113, // Swedish Allsvenskan
  106, // Polish Ekstraklasa
  283, // Ukrainian Premier League
  286, // Romanian Liga I

  // South America
  71,  // Brazilian Serie A
  72,  // Brazilian Serie B
  128, // Argentine Primera Division
  239, // Colombian Primera A
  265, // Chilean Primera Division
  268, // Uruguayan Primera Division
  242, // Ecuadorian LigaPro
  281, // Peruvian Liga 1
  13,  // Copa Libertadores
  11,  // Copa Sudamericana

  // North America
  253, // MLS
  262, // Liga MX
  16,  // CONCACAF Champions Cup
  22,  // CONCACAF Gold Cup

  // Asia and Oceania
  98,  // J1 League
  292, // K League 1
  188, // Australian A-League
  169, // Chinese Super League
  307, // Saudi Pro League
  323, // Indian Super League

  // Africa
  12,  // CAF Champions League
  20,  // CAF Confederation Cup
  233, // Egyptian Premier League
  289, // South African Premiership

  // International competitions
  4,  // UEFA European Championship
  15, // FIFA Club World Cup

  // Additional popular competitions
  6,   // Africa Cup of Nations
  7,   // AFC Asian Cup
  9,   // Copa America
  10,  // Friendlies
  21,  // Confederations Cup
  29,  // World Cup Qualification Africa
  30,  // World Cup Qualification Asia
  31,  // World Cup Qualification CONCACAF
  32,  // World Cup Qualification Europe
  33,  // World Cup Qualification Oceania
  34,  // World Cup Qualification South America
  41,  // League One
  42,  // League Two
  43,  // National League
  73,  // Copa do Brasil
  75,  // Brazilian Serie C
  76,  // Brazilian Serie D
  89,  // Eerste Divisie
  90,  // KNVB Cup
  95,  // Liga Portugal 2
  99,  // J2 League
  100, // J3 League
  104, // Norwegian First Division
  107, // Polish I Liga
  114, // Swedish Superettan
  120, // Danish First Division
  129, // Argentine Primera Nacional
  130, // Copa Argentina
  145, // Belgian Challenger Pro League
  170, // Chinese League One
  180, // Scottish Championship
  204, // Turkish First League
  208, // Swiss Challenge League
  219, // Austrian 2. Liga
  255, // USL Championship
  256, // USL League One
  293, // K League 2
  308, // Saudi First Division
  324, // Indian I-League
];

  static Function deepEq = const DeepCollectionEquality.unordered().equals;
}
