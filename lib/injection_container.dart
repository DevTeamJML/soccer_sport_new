import 'package:soccer_sport/authentication/data/datasources/wordpress_auth_api.dart';
import 'package:soccer_sport/authentication/data/datasources/wordpress_auth_local.dart';
import 'package:soccer_sport/authentication/data/repositories/auth_repository_impl.dart';
import 'package:soccer_sport/authentication/domain/repositories/auth_repository.dart';
import 'package:soccer_sport/authentication/domain/usecases/check_auth.dart';
import 'package:soccer_sport/authentication/domain/usecases/check_first_time_login.dart';
import 'package:soccer_sport/authentication/domain/usecases/check_member.dart';
import 'package:soccer_sport/authentication/domain/usecases/delete_account.dart';
import 'package:soccer_sport/authentication/domain/usecases/get_auth.dart';
import 'package:soccer_sport/authentication/domain/usecases/persist_auth.dart';
import 'package:soccer_sport/authentication/domain/usecases/register_user.dart';
import 'package:soccer_sport/authentication/domain/usecases/remove_bet_guide.dart';
import 'package:soccer_sport/authentication/domain/usecases/remove_first_time_install.dart';
import 'package:soccer_sport/authentication/domain/usecases/set_bet_guide.dart';
import 'package:soccer_sport/authentication/domain/usecases/set_first_time_install.dart';
import 'package:soccer_sport/authentication/domain/usecases/wordpress_login.dart';
import 'package:soccer_sport/authentication/domain/usecases/wordpress_logout.dart';
import 'package:soccer_sport/authentication/presentation/bloc/wordpress_auth_bloc.dart';
import 'package:soccer_sport/banner/data/datasources/banner_local.dart';
import 'package:soccer_sport/banner/data/repositories/banner_repository_impl.dart';
import 'package:soccer_sport/banner/domain/usecases/get_banner.dart';
import 'package:soccer_sport/banner/domain/usecases/get_ssc_dialog.dart';
import 'package:soccer_sport/banner/domain/usecases/get_ssc_fab.dart';
import 'package:soccer_sport/banner/domain/usecases/get_update_date.dart';
import 'package:soccer_sport/banner/domain/usecases/persist_update_date.dart';
import 'package:soccer_sport/checkout/data/datasources/checkout_api.dart';
import 'package:soccer_sport/checkout/data/repository/checkout_repository_impl.dart';
import 'package:soccer_sport/checkout/domain/repository/checkout_repository.dart';
import 'package:soccer_sport/checkout/domain/usecase/check_limit_checkout.dart';
import 'package:soccer_sport/checkout/domain/usecase/create_order.dart';
import 'package:soccer_sport/checkout/domain/usecase/get_orders.dart';
import 'package:soccer_sport/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:soccer_sport/core/constant/analytics_service.dart';
import 'package:soccer_sport/customer/data/datasources/customer_api.dart';
import 'package:soccer_sport/customer/data/repositories/customer_repository_impl.dart';
import 'package:soccer_sport/customer/domain/repositories/customer_repository.dart';
import 'package:soccer_sport/customer/domain/usecase/add_daily_reward.dart';
import 'package:soccer_sport/customer/domain/usecase/check_verified.dart';
import 'package:soccer_sport/customer/domain/usecase/cny_add_reward.dart';
import 'package:soccer_sport/customer/domain/usecase/cny_get_detail.dart';
import 'package:soccer_sport/customer/domain/usecase/edit_address.dart';
import 'package:soccer_sport/customer/domain/usecase/get_customer_details.dart';
import 'package:soccer_sport/customer/domain/usecase/get_daily_reward.dart';
import 'package:soccer_sport/customer/domain/usecase/get_user_balance.dart';
import 'package:soccer_sport/customer/domain/usecase/get_user_reward_detail.dart';
import 'package:soccer_sport/customer/domain/usecase/purchase_reward.dart';
import 'package:soccer_sport/customer/domain/usecase/send_verification_email.dart';
import 'package:soccer_sport/customer/domain/usecase/update_personalize.dart';
import 'package:soccer_sport/customer/presentation/bloc/customer_bloc.dart';
import 'package:soccer_sport/favorite_match/data/datasource/favorite_match_local.dart';
import 'package:soccer_sport/favorite_match/data/repository/favorite_match_repository_impl.dart';
import 'package:soccer_sport/favorite_match/domain/repository/favorite_match_repository.dart';
import 'package:soccer_sport/favorite_match/domain/usecases/get_favorite_matches.dart';
import 'package:soccer_sport/favorite_match/domain/usecases/persist_favorite_match.dart';
import 'package:soccer_sport/favorite_match/domain/usecases/remove_favorite_match.dart';
import 'package:soccer_sport/favorite_match/presentation/bloc/favorite_match_bloc.dart';
import 'package:soccer_sport/favourite/data/datasource/favourite_team_local.dart';
import 'package:soccer_sport/favourite/data/repository/favourite_team_repository_impl.dart';
import 'package:soccer_sport/favourite/domain/repository/favourite_team_repository.dart';
import 'package:soccer_sport/favourite/domain/usecase/get_all_favourites.dart';
import 'package:soccer_sport/favourite/domain/usecase/get_favourite_team.dart';
import 'package:soccer_sport/favourite/domain/usecase/get_team_list.dart';
import 'package:soccer_sport/favourite/domain/usecase/persist_favourite_team.dart';
import 'package:soccer_sport/favourite/domain/usecase/persist_favourite_team_v2.dart';
import 'package:soccer_sport/favourite/domain/usecase/persist_team_list.dart';
import 'package:soccer_sport/favourite/domain/usecase/remove_favourite_team.dart';
import 'package:soccer_sport/favourite/domain/usecase/remove_favourite_team_v2.dart';
import 'package:soccer_sport/favourite/presentation/bloc/favourite_bloc.dart';
import 'package:soccer_sport/footballMatch/data/datasources/football_match_api.dart';
import 'package:soccer_sport/footballMatch/data/datasources/football_match_local.dart';
import 'package:soccer_sport/footballMatch/data/repository/football_match_repositories_impl.dart';
import 'package:soccer_sport/footballMatch/domain/repository/football_match_repositories.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/bet_won_update.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/check_fixture_on_live.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/check_match_tutorial.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/filter_fixture_by_round.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_all_incoming_match.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_all_match.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_all_match_by_league.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_bet_log.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_bet_ranking.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_fixture_between_dates.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_fixture_by_league.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_fixture_rounds.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_fixtures_by_team.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_fixtures_current_round.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_incoming_fixtures_by_league.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_incoming_live_match.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_match_event.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_match_injuries.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_match_lineups.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_match_predict.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_match_stats_info.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/get_player_stats_info.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/persist_match_tutorial.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/update_bet.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/update_finished_bet.dart';
import 'package:soccer_sport/footballMatch/presentation/bloc/football_match_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:soccer_sport/league/data/datasources/league_api.dart';
import 'package:soccer_sport/league/data/datasources/league_local.dart';
import 'package:soccer_sport/league/domain/repositories/league_repositories.dart';
import 'package:soccer_sport/league/domain/usecases/check_local_leagues.dart';
import 'package:soccer_sport/league/domain/usecases/get_all_league.dart';
import 'package:soccer_sport/league/domain/usecases/get_league_by_name.dart';
import 'package:soccer_sport/league/domain/usecases/get_local_leagues.dart';
import 'package:soccer_sport/league/domain/usecases/get_team_season.dart';
import 'package:soccer_sport/league/domain/usecases/get_update_date.dart';
import 'package:soccer_sport/league/domain/usecases/persist_local_leagues.dart';
import 'package:soccer_sport/league/domain/usecases/persist_update_date.dart';
import 'package:soccer_sport/league/presentation/bloc/league_bloc.dart';
import 'package:soccer_sport/lucky_draw/data/datasources/lucky_draw_api.dart';
import 'package:soccer_sport/lucky_draw/data/datasources/lucky_draw_local.dart';
import 'package:soccer_sport/lucky_draw/data/repository/lucky_draw_repo_impl.dart';
import 'package:soccer_sport/lucky_draw/domain/repository/lucky_draw_repo.dart';
import 'package:soccer_sport/lucky_draw/domain/usecase/lucky_draw.dart';
import 'package:soccer_sport/lucky_draw/domain/usecase/persist_coupons.dart';
import 'package:soccer_sport/lucky_draw/domain/usecase/retrieve_coupons.dart';
import 'package:soccer_sport/lucky_draw/domain/usecase/retrieve_lucky_draw.dart';
import 'package:soccer_sport/lucky_draw/presentation/bloc/lucky_draw_bloc.dart';
import 'package:soccer_sport/news/data/datasources/news_api.dart';
import 'package:soccer_sport/news/data/repositories/news_repository_impl.dart';
import 'package:soccer_sport/news/domain/repositories/news_repository.dart';
import 'package:soccer_sport/news/domain/usecases/get_new_by_slug.dart';
import 'package:soccer_sport/news/domain/usecases/get_news.dart';
import 'package:soccer_sport/news/domain/usecases/load_news.dart';
import 'package:soccer_sport/news/domain/usecases/refresh_news.dart';
import 'package:soccer_sport/news/presentation/bloc/news_bloc.dart';
import 'package:soccer_sport/notification/data/repository/notification_repository_impl.dart';
import 'package:soccer_sport/notification/domain/repository/notification_repository.dart';
import 'package:soccer_sport/notification/domain/usecases/get_notification.dart';
import 'package:soccer_sport/notification/domain/usecases/persist_notification.dart';
import 'package:soccer_sport/notification/domain/usecases/remove_notification.dart';
import 'package:soccer_sport/notification/presentation/bloc/notification_bloc.dart';
import 'package:soccer_sport/products/data/datasource/product_api.dart';
import 'package:soccer_sport/products/domain/usecase/apply_coupon.dart';
import 'package:soccer_sport/products/domain/usecase/generate_coupon.dart';
import 'package:soccer_sport/products/domain/usecase/get_product_variations.dart';
import 'package:soccer_sport/products/presentation/bloc/product_bloc.dart';
import 'package:soccer_sport/setting/data/datasources/feedback_api.dart';
import 'package:soccer_sport/setting/data/repo/feedback_repo_impl.dart';
import 'package:soccer_sport/setting/domain/repo/feedback_repo.dart';
import 'package:soccer_sport/setting/domain/usecase/send_feedback.dart';
import 'package:soccer_sport/standings/data/datasources/standing_api.dart';
import 'package:soccer_sport/standings/data/repositories/standing_repositories_impl.dart';
import 'package:soccer_sport/standings/domain/repositories/standing_repositories.dart';
import 'package:soccer_sport/standings/domain/usecases/get_standing_by_team.dart';
import 'package:soccer_sport/standings/domain/usecases/get_standing_by_league.dart';
import 'package:soccer_sport/standings/presentation/bloc/standing_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soccer_sport/topscore/data/datasources/top_score_api.dart';
import 'package:soccer_sport/topscore/data/repositories/top_score_repositories_impl.dart';
import 'package:soccer_sport/topscore/domain/repositories/top_score_repositories.dart';
import 'package:soccer_sport/topscore/domain/usecases/get_top_score_by_league.dart';
import 'package:soccer_sport/topscore/presentation/bloc/top_score_bloc.dart';
import 'package:soccer_sport/video/data/datasources/video_details_api.dart';
import 'package:soccer_sport/video/data/repositories/video_details_repository_impl.dart';
import 'package:soccer_sport/video/domain/repositories/video_details_repository.dart';
import 'package:soccer_sport/video/domain/usecases/check_ssc_live.dart';
import 'package:soccer_sport/video/domain/usecases/get_recent_feed.dart';
import 'package:soccer_sport/video/domain/usecases/get_yt_url_from_api.dart';
import 'package:soccer_sport/video/presentation/bloc/video_details_bloc.dart';

import 'authentication/domain/usecases/validate_auth.dart';
import 'banner/data/datasources/banner_api.dart';
import 'banner/domain/repositories/banner_repository.dart';
import 'banner/presentation/bloc/banner_bloc.dart';
import 'favorite_match/domain/usecases/persist_update_favourite_match.dart';
import 'favourite/domain/usecase/get_favourite_team_v2.dart';
import 'league/data/repositories/league_repositories_impl.dart';
import 'news/domain/usecases/get_new_content.dart';
import 'notification/data/datasources/notification_local.dart';
import 'products/data/repository/product_repository_impl.dart';
import 'products/domain/repository/product_repository.dart';
import 'products/domain/usecase/add_to_cart.dart';
import 'products/domain/usecase/get_all_categories.dart';
import 'products/domain/usecase/get_all_products.dart';
import 'products/domain/usecase/get_cart_items.dart';
import 'products/domain/usecase/get_category_products.dart';
import 'products/domain/usecase/get_products.dart';
import 'setting/presentation/bloc/feedback_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  //external
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => http.Client());
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => AnalyticsService());
  //========== Features - Football Match ==========
  //======================================

  serviceLocator.registerLazySingleton<FootballMatchApiDataSource>(
    () => FootballMatchApiDataSourceImpl(),
  );

  serviceLocator.registerLazySingleton<FootballMatchLocalDataSource>(
    () => FootballMatchLocalDataSourceImpl(
      sharedPreferences: serviceLocator(),
    ),
  );

  // Bloc
  serviceLocator.registerFactory(
    () => FootballMatchBloc(
      getAllMatch: serviceLocator(),
      getAllIncomingMatch: serviceLocator(),
      getFixtureByLeague: serviceLocator(),
      getIncomingFixtureByLeague: serviceLocator(),
      getFixtureByRound: serviceLocator(),
      getFixtureRounds: serviceLocator(),
      getFixturesCurrentRound: serviceLocator(),
      checkFixtureOnLive: serviceLocator(),
      getIncomingLiveMatch: serviceLocator(),
      getFixtureBetweenDates: serviceLocator(),
      getAllMatchByLeague: serviceLocator(),
      getBetLog: serviceLocator(),
      updateBet: serviceLocator(),
      betWonUpdate: serviceLocator(),
      updateFinishedBet: serviceLocator(),
      checkMatchTutorial: serviceLocator(),
      persistMatchTutorial: serviceLocator(),
      getBetRanking: serviceLocator(),
      getMatchStatsInfo: serviceLocator(),
      getMatchLineups: serviceLocator(),
      getMatchInjuries: serviceLocator(),
      getMatchEvent: serviceLocator(),
      getMatchPredict: serviceLocator(),
      getFixturesByTeam: serviceLocator(),
      getPlayerStatsInfo: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<FootballMatchRepository>(
    () => FootballMatchRepositoryImpl(
      apiDataSource: serviceLocator(),
      localDataSource: serviceLocator(),
    ),
  );

  // Use cases
  serviceLocator.registerLazySingleton(() => GetAllMatch(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetAllIncomingMatch(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetFixtureByLeague(serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => GetIncomingFixtureByLeague(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetFixtureRounds(serviceLocator()));

  serviceLocator
      .registerLazySingleton(() => GetFixtureByRound(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetFixturesCurrentRound(serviceLocator()));

  serviceLocator
      .registerLazySingleton(() => CheckFixtureOnLive(serviceLocator()));

  serviceLocator
      .registerLazySingleton(() => GetIncomingLiveMatch(serviceLocator()));

  serviceLocator
      .registerLazySingleton(() => GetFixtureBetweenDates(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetAllMatchByLeague(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetBetLog(serviceLocator()));
  serviceLocator.registerLazySingleton(() => UpdateBet(serviceLocator()));
  serviceLocator.registerLazySingleton(() => BetWonUpdate(serviceLocator()));

  serviceLocator.registerLazySingleton(() => GetBetRanking(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => UpdateFinishedBet(serviceLocator()));

  serviceLocator
      .registerLazySingleton(() => CheckMatchTutorial(serviceLocator()));

  serviceLocator
      .registerLazySingleton(() => PersistMatchTutorial(serviceLocator()));

  serviceLocator
      .registerLazySingleton(() => GetMatchStatsInfo(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetMatchLineups(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetMatchInjuries(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetMatchEvent(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetMatchPredict(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetFixturesByTeam(serviceLocator()));

  serviceLocator
      .registerLazySingleton(() => GetPlayerStatInfo(serviceLocator()));

  // Repository

// Data sources
  // API

//========== Features - Football Match ==========
  //======================================

//========== Features - League ==========
  //======================================
  serviceLocator.registerLazySingleton<LeagueApiDataSource>(
    () => LeagueApiDataSourceImpl(),
  );

  serviceLocator.registerLazySingleton<LeagueLocalDataSource>(
    () => LeagueLocalDataSourceImpl(
      sharedPreferences: serviceLocator(),
    ),
  );
  // Bloc
  serviceLocator.registerFactory(
    () => LeagueBloc(
      getAllLeague: serviceLocator(),
      getLeagueByName: serviceLocator(),
      checkLocalLeagues: serviceLocator(),
      getLocalLeagues: serviceLocator(),
      persistLeagues: serviceLocator(),
      getUpdateDate: serviceLocator(),
      persistUpdateDate: serviceLocator(),
      getTeamSeason: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<LeagueRepository>(
    () => LeagueRepositoryImpl(
      apiDataSource: serviceLocator(),
      localDataSource: serviceLocator(),
    ),
  );

  // Use cases
  serviceLocator.registerLazySingleton(() => GetAllLeague(serviceLocator()));

  serviceLocator.registerLazySingleton(() => GetLeagueByName(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetLocalLeagues(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => CheckLocalLeagues(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => PersistLocalLeagues(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetUpdateDate(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => PersistUpdateDate(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetTeamSeason(serviceLocator()));
//========== Features - League ==========
  //======================================

  //========== Features - Standing ==========
  //======================================

//api

  serviceLocator.registerLazySingleton<StandingApiDataSource>(
    () => StandingApiDataSourceImpl(
      client: serviceLocator(),
    ),
  );

// Bloc
  serviceLocator.registerFactory(
    () => StandingBloc(
      getStandingByLeague: serviceLocator(),
      getStandingByTeam: serviceLocator(),
    ),
  );

  //repo

  serviceLocator.registerLazySingleton<StandingRepository>(
    () => StandingRepositoryImpl(
      apiDataSource: serviceLocator(),
    ),
  );
  //

  // Use cases
  serviceLocator
      .registerLazySingleton(() => GetStandingByLeague(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetStandingByTeam(serviceLocator()));
  //========== Features - Standing ==========
  //======================================

  //========== Features - TopScore ==========
  //======================================

  //api

  serviceLocator.registerLazySingleton<TopScoreApiDataSource>(
    () => TopScoreApiDataSourceImpl(
      client: serviceLocator(),
    ),
  );

// Bloc
  serviceLocator.registerFactory(
    () => TopScoreBloc(
      getTopScoreByLeague: serviceLocator(),
    ),
  );

  //repo

  serviceLocator.registerLazySingleton<TopScoreRepository>(
    () => TopScoreRepositoryImpl(
      apiDataSource: serviceLocator(),
    ),
  );
  //

  // Use cases
  serviceLocator
      .registerLazySingleton(() => GetTopScoreByLeague(serviceLocator()));
  //========== Features - TopScore ==========
  //======================================

  //========== Features - News ==========
  //======================================

  serviceLocator.registerLazySingleton<NewsApiDataSource>(
    () => NewsApiDataSourceImpl(
      client: serviceLocator(),
    ),
  );

// Bloc
  serviceLocator.registerFactory(
    () => NewsBloc(
      getNews: serviceLocator(),
      loadNews: serviceLocator(),
      refreshNews: serviceLocator(),
      getNewContent: serviceLocator(),
      getNewsBySlug: serviceLocator(),
    ),
  );

  //repo

  serviceLocator.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(
      apiDataSource: serviceLocator(),
    ),
  );
  //

// Use cases
  serviceLocator.registerLazySingleton(() => GetNews(serviceLocator()));
  serviceLocator.registerLazySingleton(() => LoadNews(serviceLocator()));
  serviceLocator.registerLazySingleton(() => RefreshNews(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetNewContent(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetNewsBySlug(serviceLocator()));

  //========== Features - News ==========
  //======================================

  //========== Features - Auth ==========
  //======================================
//api

  serviceLocator.registerLazySingleton<WordpressAuthApiDataSource>(
    () => WordpressAuthApiDataSourceImpl(
      client: serviceLocator(),
    ),
  );

//local

  serviceLocator.registerLazySingleton<WordpressAuthLocalDataSource>(
    () => WordpressAuthLocalDataSourceImpl(
      sharedPreferences: serviceLocator(),
    ),
  );

// Bloc
  serviceLocator.registerFactory(
    () => WordpressAuthBloc(
      checkMember: serviceLocator(),
      registerUser: serviceLocator(),
      deleteAccount: serviceLocator(),
      checkAuth: serviceLocator(),
      getAuth: serviceLocator(),
      persistAuth: serviceLocator(),
      wordpressLogin: serviceLocator(),
      wordpressLogout: serviceLocator(),
      validateAuth: serviceLocator(),
      checkFirstTimeLogin: serviceLocator(),
      setFirstTimeInstall: serviceLocator(),
      removeFirstTimeInstall: serviceLocator(),
      setBetGuide: serviceLocator(),
      removeBetGuide: serviceLocator(),
    ),
  );

  //repo

  serviceLocator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      apiDataSource: serviceLocator(),
      localDataSource: serviceLocator(),
    ),
  );
  //

  // Use cases
  serviceLocator.registerLazySingleton(() => RegisterUser(serviceLocator()));

  serviceLocator.registerLazySingleton(() => CheckAuth(serviceLocator()));
  serviceLocator.registerLazySingleton(() => DeleteAccount(serviceLocator()));
  serviceLocator.registerLazySingleton(() => CheckMember(serviceLocator()));

  serviceLocator.registerLazySingleton(() => GetAuth(serviceLocator()));
  serviceLocator.registerLazySingleton(() => PersistAuth(serviceLocator()));
  serviceLocator.registerLazySingleton(() => WordpressLogin(serviceLocator()));
  serviceLocator.registerLazySingleton(() => WordpressLogout(serviceLocator()));
  serviceLocator.registerLazySingleton(() => ValidateAuth(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => SetFirstTimeInstall(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => CheckFirstTimeLogin(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => RemoveFirstTimeInstall(serviceLocator()));
  serviceLocator.registerLazySingleton(() => SetBetGuide(serviceLocator()));
  serviceLocator.registerLazySingleton(() => RemoveBetGuide(serviceLocator()));

  //========== Features - Auth ==========
  //======================================

  //========== Features - Notification ==========
  //======================================

  //local
  serviceLocator.registerLazySingleton<NotificationLocalDataSource>(
    () => NotificationLocalDataSourceImpl(
      sharedPreferences: serviceLocator(),
    ),
  );

// Bloc
  serviceLocator.registerFactory(
    () => NotificationBloc(
      getNotification: serviceLocator(),
      persistNotification: serviceLocator(),
      removeNotification: serviceLocator(),
    ),
  );

  //repo

  serviceLocator.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      localDataSource: serviceLocator(),
    ),
  );
  //

  // Use cases
  serviceLocator.registerLazySingleton(() => GetNotification(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => RemoveNotification(serviceLocator()));

  serviceLocator
      .registerLazySingleton(() => PersistNotification(serviceLocator()));

  //========== Features - Notification ==========
  //======================================

  //========== Features - Favorite Match ==========
  //======================================

  //local
  serviceLocator.registerLazySingleton<FavoriteMatchLocalDataSource>(
    () => FavoriteMatchLocalDataSourceImpl(
      sharedPreferences: serviceLocator(),
    ),
  );

// Bloc
  serviceLocator.registerFactory(
    () => FavoriteMatchBloc(
      getFavoriteMatch: serviceLocator(),
      persistFavoriteMatch: serviceLocator(),
      removeFavoriteMatch: serviceLocator(),
      persistUpdateFavoriteMatch: serviceLocator(),
    ),
  );

  //repo

  serviceLocator.registerLazySingleton<FavoriteMatchRepository>(
    () => FavoriteMatchRepositoryImpl(
      localDataSource: serviceLocator(),
    ),
  );
  //

  // Use cases
  serviceLocator
      .registerLazySingleton(() => GetFavoriteMatches(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => PersistFavoriteMatch(serviceLocator()));
  serviceLocator.registerLazySingleton(
      () => PersistUpdateFavoriteMatch(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => RemoveFavoriteMatch(serviceLocator()));

  //========== Features - Favorite Match ==========
  //======================================

  //========== Features - Favorite Team ==========
  //======================================

//local
  serviceLocator.registerLazySingleton<FavouriteTeamLocalDataSource>(
    () => FavouriteTeamLocalDataSourceImpl(
      sharedPreferences: serviceLocator(),
    ),
  );

// Bloc
  serviceLocator.registerFactory(
    () => FavouriteBloc(
      getFavouriteTeam: serviceLocator(),
      getTeamList: serviceLocator(),
      persistFavouriteTeam: serviceLocator(),
      persistTeamList: serviceLocator(),
      removeFavouriteTeam: serviceLocator(),
      getAllFavouriteMatch: serviceLocator(),
      getFavouriteTeamV2: serviceLocator(),
      persistFavouriteTeamV2: serviceLocator(),
      removeFavouriteTeamV2: serviceLocator(),
    ),
  );

  //repo

  serviceLocator.registerLazySingleton<FavouriteTeamRepository>(
    () => FavouriteTeamRepositoryImpl(
      localDataSource: serviceLocator(),
    ),
  );
  //

  // Use cases
  serviceLocator
      .registerLazySingleton(() => GetFavouriteTeam(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetTeamList(serviceLocator()));

  serviceLocator
      .registerLazySingleton(() => PersistFavouriteTeam(serviceLocator()));

  serviceLocator.registerLazySingleton(() => PersistTeamList(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => RemoveFavouriteTeam(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetAllFavouriteTeam(serviceLocator()));

  serviceLocator
      .registerLazySingleton(() => GetFavouriteTeamV2(serviceLocator()));

  serviceLocator
      .registerLazySingleton(() => PersistFavouriteTeamV2(serviceLocator()));

  serviceLocator
      .registerLazySingleton(() => RemoveFavouriteTeamV2(serviceLocator()));

  //========== Features - Favorite Team ==========
  //======================================

  //========== Features - Video Details ==========
  //======================================
//api
  serviceLocator.registerLazySingleton<VideoDetailsApiDataSource>(
    () => VideoDetailsApiDataSourceImpl(
      client: serviceLocator(),
    ),
  );

// Bloc
  serviceLocator.registerFactory(
    () => VideoDetailsBloc(
      getRecentFeed: serviceLocator(),
      getYtUrlFromApi: serviceLocator(),
      checkSscLive: serviceLocator(),
    ),
  );

  //repo

  serviceLocator.registerLazySingleton<VideoDetailsRepository>(
    () => VideoDetailsRepositoryImpl(
      apiDataSource: serviceLocator(),
    ),
  );
  //

  // Use cases
  serviceLocator.registerLazySingleton(() => GetRecentFeed(serviceLocator()));

  serviceLocator.registerLazySingleton(() => GetYtUrlFromApi(serviceLocator()));

  serviceLocator.registerLazySingleton(() => CheckSscLive(serviceLocator()));

  //========== Features - Video Details ==========
//======================================

  //========== Features - Banner ==========
//======================================
//api
  serviceLocator.registerLazySingleton<BannerApiDataSource>(
    () => BannerApiDataSourceImpl(
      client: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<BannerLocalDataSource>(
    () => BannerLocalDataSourceImpl(
      sharedPreferences: serviceLocator(),
    ),
  );

// Bloc
  serviceLocator.registerFactory(
    () => BannerBloc(
      getBanner: serviceLocator(),
      getUpdateDate: serviceLocator(),
      persistUpdateDate: serviceLocator(),
      getSscDialog: serviceLocator(),
      getSscFab: serviceLocator(),
    ),
  );

  //repo

  serviceLocator.registerLazySingleton<BannerRepository>(
    () => BannerRepositoryImpl(
      apiDataSource: serviceLocator(),
      localDataSource: serviceLocator(),
    ),
  );
  //

  // Use cases
  serviceLocator.registerLazySingleton(() => GetBanner(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetDailyUpdateDate(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => PersistDailyUpdateDate(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetSscDialog(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetSscFab(serviceLocator()));
  //========== Features - Banner ==========
//======================================

  //========== Features - Customer ==========
  //======================================

//api

  serviceLocator.registerLazySingleton<CustomerApiDataSource>(
    () => CustomerApiDataSourceImpl(
      client: serviceLocator(),
    ),
  );
// Bloc
  serviceLocator.registerFactory(
    () => CustomerBloc(
      updatePersonalize: serviceLocator(),
      getCustomerDetails: serviceLocator(),
      purchaseReward: serviceLocator(),
      checkVerified: serviceLocator(),
      getDailyReward: serviceLocator(),
      getUserRewardDetail: serviceLocator(),
      addDailyReward: serviceLocator(),
      sendVerificationEmail: serviceLocator(),
      cnyAddReward: serviceLocator(),
      cnyGetDetail: serviceLocator(),
      // convertDiamonds: serviceLocator(),
      editAddress: serviceLocator(), getUserBalance: serviceLocator(),
      // changePassword: serviceLocator(),
      // removeFirstLogin: serviceLocator(),
    ),
  );

  //repo

  serviceLocator.registerLazySingleton<CustomerRepository>(
    () => CustomerRepositoryImpl(
      apiDataSource: serviceLocator(),
      // localDataSource: serviceLocator(),
    ),
  );
  //

  // Use cases
  serviceLocator
      .registerLazySingleton(() => GetCustomerDetails(serviceLocator()));
  // serviceLocator.registerLazySingleton(() => ConvertDiamonds(serviceLocator()));
  serviceLocator.registerLazySingleton(() => PurchaseReward(serviceLocator()));
  serviceLocator.registerLazySingleton(() => EditAddress(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetUserBalance(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetDailyReward(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetUserRewardDetail(serviceLocator()));
  serviceLocator.registerLazySingleton(() => AddDailyReward(serviceLocator()));
  serviceLocator.registerLazySingleton(() => CheckVerified(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => SendVerificationEmail(serviceLocator()));
  serviceLocator.registerLazySingleton(() => CnyGetDetail(serviceLocator()));
  serviceLocator.registerLazySingleton(() => CnyAddReward(serviceLocator()));

  serviceLocator
      .registerLazySingleton(() => UpdatePersonalize(serviceLocator()));

  // serviceLocator.registerLazySingleton(() => ChangePassword(serviceLocator()));
  // serviceLocator
  //     .registerLazySingleton(() => RemoveFirstLogin(serviceLocator()));

  //========== Features - Customer ==========
  //======================================

//========== Features - Checkout ==========
  //======================================
//api

  serviceLocator.registerLazySingleton<OrderApiDataSource>(
    () => OrderApiDataSourceImpl(
      client: serviceLocator(),
    ),
  );
//Bloc

  serviceLocator.registerFactory(
    () => CheckoutBloc(
      createOrder: serviceLocator(),
      getOrders: serviceLocator(),
      checkLimitCheckout: serviceLocator(),
    ),
  );

  //repo

  serviceLocator.registerLazySingleton<CheckoutRepository>(
    () => CheckoutRepositoryImpl(
      apiDataSource: serviceLocator(),
      // localDataSource: serviceLocator(),
    ),
  );
  //

  // Use cases
  serviceLocator.registerLazySingleton(() => CreateOrder(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetOrders(serviceLocator()));

  serviceLocator
      .registerLazySingleton(() => CheckLimitCheckout(serviceLocator()));

  //========== Features - Checkout ==========
  //======================================

  //========== Features - Product ==========
  //======================================
//api

  serviceLocator.registerLazySingleton<ProductApiDataSource>(
    () => ProductApiDataSourceImpl(
      client: serviceLocator(),
    ),
  );

//local

  // serviceLocator.registerLazySingleton<ProductLocalDataSource>(
  //   () => ProductLocalDataSourceImpl(
  //     sharedPreferences: serviceLocator(),
  //   ),
  // );

// Bloc
  serviceLocator.registerFactory(
    () => ProductBloc(
      getAllCategories: serviceLocator(),
      getProducts: serviceLocator(),
      getAllProducts: serviceLocator(),
      addToCart: serviceLocator(),
      getCartItems: serviceLocator(),
      getCategoryProducts: serviceLocator(),
      getProductVariations: serviceLocator(),
      applyCoupon: serviceLocator(),
      generateCoupon: serviceLocator(),
    ),
  );

  //repo

  serviceLocator.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      apiDataSource: serviceLocator(),
      // localDataSource: serviceLocator(),
    ),
  );
  //

  // Use cases
  serviceLocator
      .registerLazySingleton(() => GetAllCategories(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetProducts(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetAllProducts(serviceLocator()));
  serviceLocator.registerLazySingleton(() => AddToCart(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetCartItems(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetCategoryProducts(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => GetProductVariations(serviceLocator()));
  serviceLocator.registerLazySingleton(() => ApplyCoupon(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GenerateCoupon(serviceLocator()));

  //========== Features - Product ==========
  //======================================

  //========== Features - Lucky Draw ==========
  //======================================

  serviceLocator.registerLazySingleton<LuckyDrawApiDateSource>(
    () => LuckyDrawApiDateSourceImpl(),
  );

  serviceLocator.registerLazySingleton<LuckyDrawLocalSource>(
    () => LuckyDrawLocalSourceImpl(
      sharedPreferences: serviceLocator(),
    ),
  );
//local

  // serviceLocator.registerLazySingleton<ProductLocalDataSource>(
  //   () => ProductLocalDataSourceImpl(
  //     sharedPreferences: serviceLocator(),
  //   ),
  // );

// Bloc
  serviceLocator.registerFactory(
    () => LuckyDrawBloc(
      luckyDraw: serviceLocator(),
      retrieveLuckyDraw: serviceLocator(),
      persistCoupons: serviceLocator(),
      retrieveCoupons: serviceLocator(),
    ),
  );

  //repo

  serviceLocator.registerLazySingleton<LuckyDrawRepository>(
    () => LuckyDrawRepositoryImpl(
      apiDataSource: serviceLocator(), localDataSource: serviceLocator(),
      // localDataSource: serviceLocator(),
    ),
  );
  //

  // Use cases
  serviceLocator.registerLazySingleton(() => LuckyDraw(serviceLocator()));
  serviceLocator
      .registerLazySingleton(() => RetrieveLuckyDraw(serviceLocator()));
  serviceLocator.registerLazySingleton(() => PersistCoupons(serviceLocator()));
  serviceLocator.registerLazySingleton(() => RetrieveCoupons(serviceLocator()));
  //========== Features - Lucky Draw ==========
  //======================================

  //========== Features - Feedback  ==========
  //======================================

  serviceLocator.registerLazySingleton<FeedbackApiDataSource>(
    () => FeedbackApiDataSourceImpl(client: serviceLocator()),
  );

// Bloc
  serviceLocator.registerFactory(
    () => FeedbackBloc(
      sendFeedback: serviceLocator(),
    ),
  );

  //repo

  serviceLocator.registerLazySingleton<FeedbackRepository>(
    () => FeedbackRepositoryImpl(
      apiDataSource: serviceLocator(),
      // localDataSource: serviceLocator(),
    ),
  );
  //

  // Use cases
  serviceLocator.registerLazySingleton(() => SendFeedback(serviceLocator()));

  //========== Features - Feedback ==========
  //======================================
}
