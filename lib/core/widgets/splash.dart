import 'dart:async';
import 'dart:collection';

import 'package:cron/cron.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soccer_sport/authentication/presentation/bloc/wordpress_auth_bloc.dart';
import 'package:soccer_sport/authentication/presentation/page/login_page.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/customer/presentation/bloc/customer_bloc.dart';
import 'package:soccer_sport/favorite_match/presentation/bloc/favorite_match_bloc.dart';
import 'package:soccer_sport/favourite/domain/entities/league_team.dart';
import 'package:soccer_sport/favourite/presentation/bloc/favourite_bloc.dart';
import 'package:soccer_sport/footballMatch/data/model/team_model.dart';
import 'package:soccer_sport/footballMatch/domain/entities/team.dart';
import 'package:soccer_sport/landingPage/presentation/page/home_page.dart';
import 'package:soccer_sport/league/presentation/bloc/league_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:soccer_sport/notification/presentation/bloc/notification_bloc.dart';
import 'package:wordpress_api/wordpress_api.dart';

import '../../injection_container.dart';
import '../../setting/presentation/page/sign_up_page.dart';
import '../constant/analytics_service.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final LeagueBloc _leagueBloc = serviceLocator<LeagueBloc>();
  final WordpressAuthBloc _authBloc = serviceLocator<WordpressAuthBloc>();
  final NotificationBloc _notificationBloc = serviceLocator<NotificationBloc>();
  final FavoriteMatchBloc _favoriteMatchBloc =
      serviceLocator<FavoriteMatchBloc>();
  final CustomerBloc _customerBloc = serviceLocator<CustomerBloc>();

  late DatabaseReference database;
  late DataSnapshot testing;
  final FavouriteBloc _favouriteBloc = serviceLocator<FavouriteBloc>();
  final Map<String, List<dynamic>> leagueTeams = {};
  final cron = Cron();
  final sharedPreferences = SharedPreferences.getInstance();
  final now = DateTime.now();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    // sharedPreferences.then((value) =>
    //     value.clear().then((value) => print('has clear' + value.toString())));
    database = FirebaseDatabase.instance.ref('teams');
    awaitFirebaseData();
    _leagueBloc.add(GetLocalLeaguesRequest());
    _favoriteMatchBloc.add(GetFavoriteMatchRequest());
    _authBloc.add(CheckFirstTimeLoginRequest());
  }

  Future<void> awaitFirebaseData() async {
    testing = await database.get();
    var jsonvalue = Map<String, dynamic>.from(testing.value as LinkedHashMap);
    jsonvalue.forEach((key, value) {
      // print((Map<String, dynamic>.from(value as LinkedHashMap))
      //     .values
      //     .first
      //     .runtimeType);
      leagueTeams[key] = (Map<String, dynamic>.from(value as LinkedHashMap))
          .values
          .first as List<dynamic>;
    });
    cron.schedule(Schedule.parse('0 0 * * *'),
        () => {_favouriteBloc.add(PersistTeamListRequest(teams: leagueTeams))});
    _favouriteBloc.add(GetTeamListRequest());
  }

  @override
  void dispose() {
    _leagueBloc.close();
    _authBloc.close();
    _notificationBloc.close();
    _favouriteBloc.close();
    _favoriteMatchBloc.close();
    cron.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LeagueBloc>(
          create: (context) => _leagueBloc,
        ),
        BlocProvider<FavouriteBloc>(
          create: (context) => _favouriteBloc,
        ),
        BlocProvider<WordpressAuthBloc>(
          create: (context) => _authBloc,
        ),
        BlocProvider<NotificationBloc>(
          create: (context) => _notificationBloc,
        ),
        BlocProvider<FavoriteMatchBloc>(
          create: (context) => _favoriteMatchBloc,
        ),
        BlocProvider<CustomerBloc>(
          create: (context) => _customerBloc,
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          // BlocListener<LeagueBloc, LeagueState>(
          //   bloc: _leagueBloc,
          //   listener: (context, state) async {
          //     if (state is LeaguesLoaded) {
          //       DateTime now = DateTime.now();
          //       var tomorow = DateTime(now.year, now.month, now.day + 1);
          //       String updateDate = Constant.formattedDate(tomorow);
          //       Constant.updateDate = updateDate;

          //       _leagueBloc.add(PersistUpdateDateRequest(date: updateDate));
          //       _leagueBloc
          //           .add(PersistLocalLeaguesRequest(leagues: state.leagues));
          //     }
          //     if (state is PersistedLeaguesLoaded) {
          //       if (Constant.staticLeagues.length > 0) {
          //         print('got loaded');
          //         _leagueBloc.add(GetUpdateDateRequest());
          //       } else {
          //         print('request all leauge');
          //         _leagueBloc.add(GetAllLeagueRequest());
          //       }
          //     }

          //     if (state is UpdatedDateLoaded) {
          //       print('got update');
          //       DateTime now = DateTime.now();
          //       DateTime updateDate = DateTime.parse(state.date);
          //       String formattedUpdateDate = Constant.formattedDate(updateDate);
          //       String formattedDate = Constant.formattedDate(now);
          //       print(updateDate.toString());
          //       if (formattedUpdateDate == formattedDate ||
          //           updateDate.compareTo(now) < 0) {
          //         _leagueBloc.add(GetAllLeagueRequest());
          //       } else {
          //         print('is update navigation');
          //         // Navigator.pushReplacement(context,
          //         //     MaterialPageRoute(builder: (context) => HomePage()));
          //         _authBloc.add(CheckAuthRequest());
          //       }
          //     }
          //     if (state is PersistLeaguesSuccess) {
          //       print('persist success');
          //       _authBloc.add(CheckAuthRequest());

          //       // Navigator.pushReplacement(context,
          //       //     MaterialPageRoute(builder: (context) => HomePage()));
          //     }
          //   },
          // ),
          // BlocListener<WordpressAuthBloc, WordpressAuthState>(
          //     bloc: _authBloc,
          //     listener: (context, state) {
          //       if (state is AuthChecked) {
          //         if (state.auth) {
          //           _authBloc.add(ValidateAuthRequest());
          //         } else {
          //           Navigator.pushReplacement(context,
          //               MaterialPageRoute(builder: (context) => LoginPage()));
          //         }
          //       }

          //       if (state is AuthValidated) {
          //         if (state.auth) {
          //           _notificationBloc.add(GetNotificationRequest());
          //         } else {
          //           Navigator.pushReplacement(context,
          //               MaterialPageRoute(builder: (context) => LoginPage()));
          //         }
          //       }
          //     }),
          // BlocListener<NotificationBloc, NotificationState>(
          //     bloc: _notificationBloc,
          //     listener: (context, state) {
          //       if (state is NotificationLoaded) {
          //         if (state.notification != null) {
          //           // OneSignal.shared.disablePush(!(state.notification!));
          //           // OneSignal.shared.promptUserForPushNotificationPermission();
          //           print('got come here ??');
          //           Navigator.pushReplacement(context,
          //               MaterialPageRoute(builder: (context) => HomePage()));
          //         } else {
          //           _notificationBloc
          //               .add(PersistNotificationRequest(notification: true));
          //         }
          //       }

          //       if (state is NotificationPersisted) {
          //         print('is it perssited');
          //         OneSignal.shared.setAppId(FootballApi.oneSignalId);
          //         OneSignal.shared.disablePush(false);
          //         OneSignal.shared.promptUserForPushNotificationPermission();
          //         Navigator.pushReplacement(context,
          //             MaterialPageRoute(builder: (context) => HomePage()));
          //       }
          //     })
          BlocListener<FavouriteBloc, FavouriteState>(
              bloc: _favouriteBloc,
              listener: (context, state) {
                if (state is TeamListPersisted) {
                  if (state.teams) {
                    if (Constant.teamList.isEmpty) {
                      _favouriteBloc.add(GetTeamListRequest());
                    }
                  }
                }
                if (state is TeamListLoaded) {
                  if (state.teams.isNotEmpty) {
                    setState(() {
                      Constant.teamList = state.teams;
                      // print(state.teams.toString());
                    });
                  } else {
                    _favouriteBloc
                        .add(PersistTeamListRequest(teams: leagueTeams));
                  }
                }
              }),
          BlocListener<LeagueBloc, LeagueState>(
            bloc: _leagueBloc,
            listener: (context, state) async {
              if (state is LeaguesLoaded) {
                DateTime now = DateTime.now();
                var tomorow = DateTime(now.year, now.month, now.day + 1);
                String updateDate = Constant.formattedDate(tomorow);
                Constant.updateDate = updateDate;

                _leagueBloc.add(PersistUpdateDateRequest(date: updateDate));
                _leagueBloc
                    .add(PersistLocalLeaguesRequest(leagues: state.leagues));
              }
              if (state is PersistedLeaguesLoaded) {
                if (Constant.staticLeagues.length > 0) {
                  _leagueBloc.add(GetUpdateDateRequest());
                } else {
                  _leagueBloc.add(GetAllLeagueRequest());
                }
              }

              if (state is UpdatedDateLoaded) {
                DateTime now = DateTime.now();
                DateTime updateDate = DateTime.parse(state.date);
                String formattedUpdateDate = Constant.formattedDate(updateDate);
                String formattedDate = Constant.formattedDate(now);
                if (formattedUpdateDate == formattedDate ||
                    updateDate.compareTo(now) < 0) {
                  _leagueBloc.add(GetAllLeagueRequest());
                } else {
                  _authBloc.add(CheckAuthRequest());
                }
              }
              if (state is PersistLeaguesSuccess) {
                _authBloc.add(CheckAuthRequest());

                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) => HomePage()));
              }
              if (state is PersistLeaguesError) {
                _authBloc.add(CheckAuthRequest());

                // Navigator.pushReplacementNamed(context, '/homepage');
              }
            },
          ),
          BlocListener<WordpressAuthBloc, WordpressAuthState>(
              bloc: _authBloc,
              listener: (context, state) {
                if (state is FirstTimeInstallChecked) {
                  if (state.auth != null && state.auth.length > 0) {
                    if (state.auth[0] == null) {
                      _authBloc.add(SetFirstTimeInstallRequest());
                      // OneSignal.shared.sendTag('Non-Member', 'true');
                      OneSignal.User.addTagWithKey("Non-Member", "true");
                    }

                    if (state.auth[1] == null) {
                      _authBloc.add(SetBetGuideRequest());
                    }
                  }
                }

                if (state is AuthChecked) {
                  _notificationBloc.add(GetNotificationRequest());
                  if (state.auth) {
                    serviceLocator<AnalyticsService>()
                        .setUserId(userId: Constant.auth!.email);
                  }
                }

                if (state is FirstTimeInstallChecked) {
                  // if (Constant.showcaseBool) {
                  //   if (state.auth.length > 0) {
                  //     if (state.auth[1] != null && state.auth[1]!) {
                  //       Constant.showcaseBool = true;
                  //       Navigator.of(context).push(
                  //         MaterialPageRoute(
                  //             builder: (context) => BetGuideDemo()),
                  //       );
                  //     }
                  //   }
                  //   // if (state.auth[0] != null && state.auth[0]!) {
                  //   //   showDialog(
                  //   //     context: context,
                  //   //     barrierDismissible: false,
                  //   //     builder: (BuildContext context) {
                  //   //       return HomepageAds();
                  //   //     },
                  //   //   );
                  //   // }
                  // }
                }

                if (state is MemberChecked) {
                  if (state.auth != null) {
                    setState(() {
                      // print('member check is ${state.auth!}');

                      Constant.isMember = state.auth!;
                    });
                    if (Constant.auth != null) {
                      _customerBloc.add(
                          GetCustomerDetailsRequest(id: Constant.auth!.id));
                    }
                  }
                }
              }),

          BlocListener<CustomerBloc, CustomerState>(
            bloc: _customerBloc,
            listener: (context, state) {
              if (state is CustomerDetailsLoaded) {
                setState(() {
                  Constant.customer = state.customer;
                  _customerBloc.add(GetUserRewardDetailRequest(
                      id: Constant.auth!.id.toString()));
                });
              }

              if (state is UserRewardDetailGet) {
                setState(() {
                  Constant.customerRewardDetail = state.success;
                  _customerBloc.add(
                      CheckVerifiedRequest(id: Constant.auth!.id.toString()));
                });
              }
              if (state is VerifiedChecked) {
                setState(() {
                  Constant.isVerified = state.success.verified;
                  Constant.p6_registered = state.success.p6_registered;
                  Navigator.pushReplacementNamed(context, '/homepage');
                });
              }
            },
          ),
          BlocListener<NotificationBloc, NotificationState>(
              bloc: _notificationBloc,
              listener: (context, state) {
                if (state is NotificationLoaded) {
                  if (state.notification != null) {
                    // OneSignal.shared.disablePush(!(state.notification!));
                    // OneSignal.shared.promptUserForPushNotificationPermission();

                    //important
                    // Navigator.pushReplacementNamed(context, '/homepage');
                    // _authBloc.add(CheckFirstTimeLoginRequest());
                    if (Constant.auth != null) {
                      _authBloc.add(CheckMemberRequest());
                    } else {
                      Navigator.pushReplacementNamed(context, '/homepage');
                    }
                  } else {
                    _notificationBloc
                        .add(PersistNotificationRequest(notification: true));
                  }
                }

                if (state is NotificationPersisted) {
                  // OneSignal.shared.setAppId(FootballApi.oneSignalId);

                  // OneSignal.shared.disablePush(false);

                  // OneSignal.shared.promptUserForPushNotificationPermission();

                  OneSignal.initialize(FootballApi.oneSignalId);

                  // Enable push
                  OneSignal.User.pushSubscription.optIn();

                  // Request notification permission
                  OneSignal.Notifications.requestPermission(true);
                  
                  //important

                  // Navigator.pushReplacementNamed(context, '/homepage');
                  // _authBloc.add(CheckFirstTimeLoginRequest());
                  if (Constant.auth != null) {
                    _authBloc.add(CheckMemberRequest());
                  } else {
                    Navigator.pushReplacementNamed(context, '/homepage');
                  }
                }
              }),
          BlocListener<FavoriteMatchBloc, FavoriteMatchState>(
              bloc: _favoriteMatchBloc,
              listener: (context, state) {
                if (state is FavoriteMatchLoaded) {
                  if (state.footballMatches.length > 0) {
                    setState(() {
                      Constant.favoriteList = state.footballMatches;
                    });
                  }
                }
              })
        ],
        child: Scaffold(
          body: Container(
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/soccer_club_logo.png'),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    LoadingAnimationWidget.staggeredDotsWave(
                      color: Constant.color2,
                      size: 60,
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
