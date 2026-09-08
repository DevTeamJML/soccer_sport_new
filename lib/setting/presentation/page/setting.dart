import 'package:advance_notification/advance_notification.dart';
import 'package:auto_size_text/auto_size_text.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:soccer_sport/authentication/domain/entities/wordpress_auth.dart';
import 'package:soccer_sport/authentication/presentation/bloc/wordpress_auth_bloc.dart';
import 'package:soccer_sport/authentication/presentation/page/login_page.dart';
import 'package:soccer_sport/banner/domain/entities/banner.dart';
import 'package:soccer_sport/checkout/presentation/page/my_order_page.dart';
import 'package:soccer_sport/core/constant/analytics_service.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/core/widgets/splash.dart';
import 'package:soccer_sport/customer/domain/entities/customer.dart';
import 'package:soccer_sport/customer/presentation/page/edit_address_page.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/presentation/bloc/football_match_bloc.dart';
import 'package:soccer_sport/landingPage/presentation/page/bet_guide.dart';
import 'package:soccer_sport/landingPage/presentation/page/home_page.dart';
import 'package:soccer_sport/landingPage/presentation/page/personalize_page.dart';
import 'package:soccer_sport/notification/presentation/bloc/notification_bloc.dart';
import 'package:soccer_sport/products/presentation/page/product_page.dart';
import 'package:soccer_sport/setting/presentation/page/about_us.dart';
import 'package:soccer_sport/setting/presentation/page/sign_up_page.dart';
import 'package:soccer_sport/setting/presentation/page/terms_condition.dart';
import 'package:soccer_sport/setting/presentation/page/test.dart';
import 'package:soccer_sport/setting/presentation/page/test2.dart';
import 'package:soccer_sport/setting/presentation/widget/read_news.dart';
import 'package:soccer_sport/setting/presentation/widget/refer_friends_widget.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../banner/presentation/bloc/banner_bloc.dart';
import '../../../banner/presentation/widget/banner_widget.dart';
import '../../../core/constant/local_notification_service.dart';
import '../../../favorite_match/presentation/bloc/favorite_match_bloc.dart';
import '../../../favourite/presentation/bloc/favourite_bloc.dart';
import '../../../footballMatch/domain/entities/team.dart';
import '../../../injection_container.dart';
import '../../../landingPage/presentation/widget/cny_event_page.dart';
import 'logout_loading_dialog.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class SettingPage extends StatefulWidget {
  SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage>
    with AutomaticKeepAliveClientMixin<SettingPage> {
  final WordpressAuthBloc _authBloc = serviceLocator<WordpressAuthBloc>();
  final NotificationBloc _notificationBloc = serviceLocator<NotificationBloc>();
  final FavouriteBloc _favouriteBloc = serviceLocator<FavouriteBloc>();
  final FavoriteMatchBloc _favoriteMatchBloc =
      serviceLocator<FavoriteMatchBloc>();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final BannerBloc _bannerBloc = serviceLocator<BannerBloc>();
  final InAppReview _inAppReview = InAppReview.instance;
  final _key1 = GlobalKey();
  final _key2 = GlobalKey();
  final _key3 = GlobalKey();
  final _key4 = GlobalKey();
  final _key5 = GlobalKey();
  final _key6 = GlobalKey();

  BannerHtml? bannerHtml;
  bool notificationBool = true;
  Customer? customer;
  Map<String, List<Team>> favouritetTeams = {};
  List<FootballMatch> favouritetMatches = [];

  Future<void> _openStoreListing() => _inAppReview.openStoreListing(
        appStoreId: '1569544522',
      );
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    // updateKeepAlive();

    _notificationBloc.add(GetNotificationRequest());
    _favouriteBloc.add(GetAllFavouritesRequest());
    // if (Constant.auth == null && Constant.bannerHtml == null)
    //   _bannerBloc.add(GetBannerRequest(
    //       api: 'https://soccersport.club/setting-page-banner/',
    //       id: 'setting-banner-xx'));
    // if (Constant.bannerHtml != null) {
    //   bannerHtml = Constant.bannerHtml;
    // }
    // if (Constant.customer != null) {
    //   customer = Constant.customer;
    // }

    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   if (Constant.showcaseBool)
    //     ShowCaseWidget.of(context).startShowCase([
    //       _key1,
    //       _key2,
    //       _key3,
    //       _key4,
    //       _key5,
    //       _key6,
    //     ]);
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _favoriteMatchBloc.close();
    _notificationBloc.close();
    _bannerBloc.close();
    _authBloc.close();
    _favouriteBloc.close();

    super.dispose();
  }

  // @override
  // void updateKeepAlive() {
  //   // TODO: implement updateKeepAlive
  //   super.updateKeepAlive();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: Colors.white,
        //   ),
        //   onPressed: () async {
        //     OSDeviceState? test = await OneSignal.shared.getDeviceState();
        //     if (test != null) {
        //       print(test.pushDisabled);
        //       print(test.subscribed.toString() + ' is iit subb');
        //       print(test.hasNotificationPermission);
        //       print('userid sssqq');
        //       print(test.userId!);
        //     } else {
        //       print('is empty test');
        //     }
        //   },
        // ),
        actions: [
          // Showcase(
          //   key: _key5,
          //   description:
          //       "Users can go to 'Shop' section by tap here for redeem prize with coins that obtained in events",
          //   overlayPadding: EdgeInsets.only(left: 15),
          //   child:
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ProductPage()),
              );
            },
            child: Container(
              padding: EdgeInsets.only(right: 15),
              child: Icon(
                FontAwesomeIcons.shoppingCart,
              ),
            ),
          ),
          // ),
        ],
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<WordpressAuthBloc>(
            create: (context) => _authBloc,
          ),
          BlocProvider<NotificationBloc>(
            create: (context) => _notificationBloc,
          ),
          BlocProvider<FavouriteBloc>(
            create: (context) => _favouriteBloc,
          ),
          BlocProvider<FavoriteMatchBloc>(
            create: (context) => _favoriteMatchBloc,
          ),
          BlocProvider<BannerBloc>(
            create: (context) => _bannerBloc,
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<WordpressAuthBloc, WordpressAuthState>(
              bloc: _authBloc,
              listener: (context, state) {
                if (state is WordpressLogoutSuccess) {
                  if (state.auth) {
                    setState(() {
                      Constant.auth = null;
                      Constant.cartItems = [];
                      Constant.customer = null;
                      Constant.betList = [[], []];
                      Constant.customerRewardDetail = null;
                    });

                    Navigator.popUntil(
                        context, ModalRoute.withName('/homepage'));
                    Constant.pageController!.jumpToPage(0);

                    // Navigator.popAndPushNamed(context, '/homepage');
                  }
                }

                if (state is AccountDeleted) {
                  if (state.auth) {
                    print('delete success');
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      useRootNavigator: false,
                      barrierDismissible: false,
                      builder: (context) => StatefulBuilder(
                          builder: (ctx, setState) => LogoutLoadingDialog()),
                    );
                    _authBloc.add(WordpressLogoutRequest());
                  } else {
                    AdvanceSnackBar(
                            mode: Mode.ADVANCE,
                            message: "Delete Account fail",
                            bgColor: Colors.red)
                        .show(context);
                  }
                }
              },
            ),
            BlocListener<FavouriteBloc, FavouriteState>(
              bloc: _favouriteBloc,
              listener: (context, state) {
                if (state is AllFavouritesLoaded) {
                  setState(() {
                    favouritetTeams = Constant.favouriteTeam;
                    favouritetMatches = Constant.favoriteList;
                  });
                }
                if (state is FavouriteTeamLoaded) {
                  favouritetTeams = state.teams;
                }
              },
            ),

            BlocListener<BannerBloc, BannerState>(
              bloc: _bannerBloc,
              listener: (context, state) {
                // if (state is BannerLoaded) {
                //   setState(() {
                //     bannerHtml = state.html;
                //     Constant.bannerHtml = bannerHtml;
                //   });
                // }
              },
            ),
            // BlocListener<FavoriteMatchBloc, FavoriteMatchState>(
            //   bloc: _favoriteMatchBloc,
            //   listener: (context, state) {},
            // ),
            // add new bloc listener and create subscribe topic
            BlocListener<NotificationBloc, NotificationState>(
                bloc: _notificationBloc,
                listener: (context, state) {
                  if (state is NotificationLoaded) {
                    setState(() {
                      if (state.notification != null) {
                        notificationBool = state.notification!;
                      }
                    });
                  }

                  if (state is NotificationPersisted) {
                    setState(() {
                      notificationBool = state.notification;
                      // OneSignal.shared.disablePush(!notificationBool);
                      if (notificationBool) {
                         OneSignal.User.pushSubscription.optIn();
                        if (Constant.favoriteList.length > 0) {
                          Constant.favoriteList.forEach((element) async {
                            await LocalNotificationService
                                .createReminderNotifications(
                                    date: DateTime.parse(element.fixture.date)
                                        .toLocal(),
                                    id: element.fixture.id,
                                    title: (element.home.name +
                                        ' vs ' +
                                        element.away.name),
                                    body: 'The match will begin soon',
                                    payload: {
                                  'value': element.league!.id.toString(),
                                });

                            _fcm.subscribeToTopic(
                                "fixtures" + element.fixture.id.toString());
                          });
                        }
                        if (favouritetTeams.isNotEmpty) {
                          favouritetTeams.forEach((key, value) {
                            value.forEach((element) {
                              _fcm.subscribeToTopic(
                                  "team" + element.id.toString());
                            });
                          });
                        }
                      } else {
                        OneSignal.User.pushSubscription.optOut();
                        if (Constant.favoriteList.length > 0) {
                          LocalNotificationService
                              .cancelAllScheduleNotification();
                          Constant.favoriteList.forEach((element) {
                            _fcm.unsubscribeFromTopic(
                                "fixtures" + element.fixture.id.toString());
                          });
                        }
                        if (favouritetTeams.isNotEmpty) {
                          favouritetTeams.forEach((key, value) {
                            value.forEach((element) {
                              _fcm.unsubscribeFromTopic(
                                  "team" + element.id.toString());
                            });
                          });
                        }
                      }
                    });
                  }

                  if (state is NotificationRemoved) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => LoginPage(),
                            settings: RouteSettings(name: '/loginpage')),
                        (Route<dynamic> route) => false);
                  }
                }),
          ],
          child: SingleChildScrollView(
            child: Container(
              color: Colors.grey[200],
              child: Column(children: [
                Container(
                  height: Constant.auth != null
                      ? MediaQuery.of(context).size.height * 0.53
                      : MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                    color: Constant.backgroundColor,
                    // borderRadius: new BorderRadius.only(
                    //     bottomLeft: const Radius.circular(40.0),
                    //     bottomRight: const Radius.circular(40.0)),
                  ),
                  child: Constant.auth != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                // color: Colors.red,
                                padding: Constant.auth != null
                                    ? EdgeInsets.only(left: 20)
                                    : EdgeInsets.zero,
                                child: Row(children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                "Profile",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 24,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 15),
                                              // padding: EdgeInsets.all(5),

                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.045,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Constant.color2),
                                                color: Colors.black,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0)),
                                              ),
                                              child: Row(children: [
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 10),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.025,
                                                  // width: MediaQuery.of(context).size.width * 0.04,
                                                  child: Center(
                                                    child: FadeInImage
                                                        .memoryNetwork(
                                                            placeholder:
                                                                kTransparentImage,
                                                            image:
                                                                'https://soccersport.club/wp-content/uploads/2021/12/Jan22-SSC-Coin-icon-150x150-1.png',
                                                            imageErrorBuilder:
                                                                (e, o, c) {
                                                              return Container();
                                                            }),
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 5.0),
                                                  child: Center(
                                                    child: AutoSizeText(
                                                      Constant.customer != null
                                                          ? Constant.customer!
                                                              .diamonds
                                                          : '0',
                                                      minFontSize: 10,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                )),
                                              ]),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Username: ' +
                                                        (Constant.auth != null
                                                            ? Constant
                                                                .auth!.username
                                                            : ''),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text('Email: ' +
                                                      (Constant.auth != null
                                                          ? Constant.auth!.email
                                                          : '')),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  //normal style
                                  //  Container(
                                  //                                     margin: EdgeInsets.only(right: 15),
                                  //                                     padding: EdgeInsets.all(5),
                                  //                                     width: MediaQuery.of(context).size.width *
                                  //                                         0.25,
                                  //                                     decoration: BoxDecoration(
                                  //                                       border:
                                  //                                           Border.all(color: Constant.color2),
                                  //                                       color: Colors.black,
                                  //                                       borderRadius: BorderRadius.all(
                                  //                                           Radius.circular(10.0)),
                                  //                                     ),
                                  //                                     child: Row(children: [
                                  //                                       Container(
                                  //                                         margin: EdgeInsets.symmetric(
                                  //                                             horizontal: 10),
                                  //                                         height:
                                  //                                             MediaQuery.of(context).size.height *
                                  //                                                 0.025,
                                  //                                         // width: MediaQuery.of(context).size.width * 0.04,
                                  //                                         child: Center(
                                  //                                           child: FadeInImage.memoryNetwork(
                                  //                                               placeholder: kTransparentImage,
                                  //                                               image:
                                  //                                                   'https://soccersport.club/wp-content/uploads/2021/12/Jan22-SSC-Coin-icon-150x150-1.png',
                                  //                                               imageErrorBuilder: (e, o, c) {
                                  //                                                 return Container();
                                  //                                               }),
                                  //                                         ),
                                  //                                       ),
                                  //                                       Expanded(
                                  //                                           child: Row(
                                  //                                               mainAxisAlignment:
                                  //                                                   MainAxisAlignment.center,
                                  //                                               children: [
                                  //                                             Text(Constant.customer != null
                                  //                                                 ? '1'
                                  //                                                 : '0')
                                  //                                           ])),
                                  //                                     ]),
                                  //                                   ),
                                  //maple style
                                  //      Container(
                                  //       margin: EdgeInsets.only(right: 15),
                                  //       height: MediaQuery.of(context).size.height *
                                  //           0.035,
                                  //       width: MediaQuery.of(context).size.width *
                                  //           0.25,
                                  //       decoration: BoxDecoration(
                                  //         border:
                                  //             Border.all(color: Constant.color2),
                                  //         color: Constant.color1,
                                  //         borderRadius: BorderRadius.all(
                                  //             Radius.circular(10.0)),
                                  //       ),
                                  //       child: Row(children: [
                                  //         Container(
                                  //           margin: EdgeInsets.symmetric(
                                  //               horizontal: 10),
                                  //           height:
                                  //               MediaQuery.of(context).size.height *
                                  //                   0.025,
                                  //           // width: double.infinity,
                                  //           child: Center(
                                  //             child: FadeInImage.memoryNetwork(
                                  //                 placeholder: kTransparentImage,
                                  //                 image:
                                  //                     'https://soccersport.club/wp-content/uploads/2021/12/Jan22-SSC-Coin-icon-150x150-1.png',
                                  //                 imageErrorBuilder: (e, o, c) {
                                  //                   return Container();
                                  //                 }),
                                  //           ),
                                  //         ),
                                  //         Expanded(
                                  //             child: Container(
                                  //           height: double.infinity,
                                  //           decoration: BoxDecoration(
                                  //             color: Constant.backgroundColor,
                                  //             // border: Border(
                                  //             //     left: BorderSide(
                                  //             //   color: Constant.color2,
                                  //             // )),
                                  //             borderRadius: BorderRadius.only(
                                  //               topRight: Radius.circular(10.0),
                                  //               bottomRight: Radius.circular(10.0),
                                  //             ),
                                  //           ),
                                  //           child: Row(
                                  //               mainAxisAlignment:
                                  //                   MainAxisAlignment.center,
                                  //               children: [
                                  //                 Text(Constant.customer != null
                                  //                     ? '1'
                                  //                     : '0')
                                  //               ]),
                                  //         )),
                                  //       ]),
                                  //     ),
                                  //   ]),
                                  // ),
                                ]),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(children: [
                                ReferFriendsWidget(),
                                ReadNews(),
                              ]),
                            )
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "You aren't logged in yet.",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.03,
                                  ),
                                  // Showcase(
                                  //   key: _key6,
                                  //   description:
                                  //       "That all for the tutorial, and start login or register to enjoy our app. Thanks",
                                  //   onTargetClick: () {
                                  //     setState(() {
                                  //       Constant.showcaseBool = false;
                                  //     });
                                  //   },
                                  //   disposeOnTap: true,
                                  //   onToolTipClick: () {
                                  //     setState(() {
                                  //       Constant.showcaseBool = false;
                                  //     });
                                  //   },
                                  //   child:
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Showcase(
                                      //   key: _key1,
                                      //   description:
                                      //       "Users can click here to login",
                                      //   child:

                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          // shadowColor: Colors.white,
                                          // side: BorderSide(color: Colors.white, width: 0.2)
                                        ),
                                        // color: Theme.of(context).primaryColor,
                                        // shape: RoundedRectangleBorder(
                                        //   borderRadius:
                                        //       BorderRadius.circular(30.0),
                                        // ),
                                        // textColor: Colors.white,
                                        child: Text(
                                          'Login',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginPage(),
                                                  settings: RouteSettings(
                                                      name: '/loginpage')));
                                        },
                                        // ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                      ),
                                      // Showcase(
                                      //   key: _key2,
                                      //   description:
                                      //       "For those who haven't register can click here to register.",
                                      //   child:

                                      ElevatedButton(
                                        // color: Theme.of(context).primaryColor,
                                        // shape: RoundedRectangleBorder(
                                        //   borderRadius:
                                        //       BorderRadius.circular(30.0),
                                        // ),
                                        // textColor: Colors.white,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          // shadowColor: Colors.white,
                                          // side: BorderSide(color: Colors.white, width: 0.2)
                                        ),
                                        child: Text(
                                          'Sign Up',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SignUpPage(),
                                                  settings: RouteSettings(
                                                      name: '/signup')));
                                        },
                                      ),
                                      // ),
                                    ],
                                  ),
                                  // ),
                                ],
                              ),
                            ),
                            // bannerHtml != null
                            //     ? GestureDetector(
                            //         onTap: () async {
                            //           if (bannerHtml!.href != null) {
                            //             if (await canLaunch(
                            //                 bannerHtml!.href!)) {
                            //               await launch(bannerHtml!.href!);
                            //             } else {
                            //               throw 'Could not launch ${bannerHtml!.href!}';
                            //             }
                            //           } else {
                            //             Navigator.of(context).push(
                            //               MaterialPageRoute(
                            //                   builder: (context) =>
                            //                       LoginPage()),
                            //             );
                            //           }
                            //         },
                            //         child: BannerWidget(
                            //             imgSrc: bannerHtml!.url!))
                            //     : Container(),
                          ],
                        ),
                ),

                if ((DateTime.now()
                    .toLocal()
                    .difference(
                        DateTime.fromMillisecondsSinceEpoch(1675699200000))
                    .isNegative))
                  GestureDetector(
                    onTap: () async {
                      if (Constant.auth != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => CnyEventPage()),
                        );
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      }
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: double.infinity,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        // child: Image.asset('assets/p6_banner.jpg')
                        child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image:
                                'https://soccersport.club/wp-content/uploads/2022/18/cny_setting.png',
                            imageErrorBuilder: (e, o, c) {
                              return Container();
                            }),
                      ),
                    ),
                  ),

                // if (Constant.p6_registered == false)
                //   GestureDetector(
                //     onTap: () async {
                //       if (Constant.auth != null) {
                //         if (await canLaunch(
                //             "https://soccersport.club/p6-registration/")) {
                //           if (Constant.auth != null) {
                //             String url =
                //                 'https://soccersport.club/wp-json/wl/v1/p6_track?id=${Constant.auth!.id}';
                //             final response =
                //                 await http.get(Uri.parse(url), headers: {
                //               "content-type": 'application/json',
                //             });

                //             if (response.statusCode == 200) {
                //               // this mean that we are connected to the data base
                //               print('satus is 220 ');
                //               serviceLocator<AnalyticsService>()
                //                   .logScreens(name: '/p6-registration');
                //               await launch(
                //                   "https://soccersport.club/p6-registration/");
                //             } else {
                //               print('satus is not 220 ');

                //               serviceLocator<AnalyticsService>()
                //                   .logScreens(name: '/p6-registration');
                //               await launch(
                //                   "https://soccersport.club/p6-registration/");
                //             }
                //           } else {
                //             print('auth  is null ');

                //             serviceLocator<AnalyticsService>()
                //                 .logScreens(name: '/p6-registration');
                //             await launch(
                //                 "https://soccersport.club/p6-registration/");
                //           }
                //         } else {
                //           throw 'Could not launch https://soccersport.club/p6-registration/';
                //         }
                //       } else {
                //         Navigator.of(context).push(
                //           MaterialPageRoute(
                //               builder: (context) => LoginPage()),
                //         );
                //       }
                //     },
                //     child: Container(
                //       height: MediaQuery.of(context).size.height * 0.07,
                //       width: double.infinity,
                //       child: FittedBox(
                //         fit: BoxFit.fitWidth,
                //         // child: Image.asset('assets/p6_banner.jpg')
                //         child: FadeInImage.memoryNetwork(
                //             placeholder: kTransparentImage,
                //             image:
                //                 'https://soccersport.club/wp-content/uploads/2022/18/p6_banner_mini.jpg',
                //             imageErrorBuilder: (e, o, c) {
                //               return Container();
                //             }),
                //       ),
                //     ),
                //   ),
                SettingsList(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  lightTheme: SettingsThemeData(
                      settingsListBackground: Constant.backgroundColor),
                  darkTheme: SettingsThemeData(
                      settingsListBackground: Constant.backgroundColor),
                  platform: DevicePlatform.iOS,
                  sections: [
                    if (Constant.auth != null)
                      SettingsSection(
                        title: Text('Settings',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        tiles: <SettingsTile>[
                          SettingsTile.navigation(
                            leading: Icon(FontAwesomeIcons.addressBook),
                            onPressed: (v) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditAddressPage()),
                              ).then((_) => setState(() {
                                    Constant.customer = Constant.customer;
                                  }));
                            },
                            title: Text("Edit Address"),
                          ),
                          SettingsTile.navigation(
                            leading: Icon(
                              FontAwesomeIcons.file,
                            ),
                            onPressed: (v) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyOrderPage()),
                              ).then((_) => setState(() {
                                    Constant.customer = Constant.customer;
                                  }));
                            },
                            title: Text("Orders"),
                          ),
                        ],
                      ),
                    // SettingsSection(
                    //   title: Text('General Policies'),
                    //   tiles: <SettingsTile>[
                    //     SettingsTile.navigation(
                    //       leading: Icon(Icons.privacy_tip),
                    //       title: Text('Privacy Statement'),
                    //     ),
                    //     SettingsTile.navigation(
                    //       leading: Icon(FontAwesomeIcons.file),
                    //       title: Text('Terms & Conditions'),
                    //     ),
                    //   ],
                    // ),

                    SettingsSection(
                      title:

                          // Showcase(
                          //   key: _key3,
                          //   description:
                          //       "User can at more's section to look through bet guide and terms & conditions, and rate us thus send feedback to us.",
                          //   overlayPadding: EdgeInsets.only(
                          //     top: 20,
                          //     left: 10,
                          //     bottom: 2,
                          //     right: 5,
                          //   ),
                          //   child:

                          Text('More',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                      // ),
                      tiles: <SettingsTile>[
                        // SettingsTile.navigation(
                        //   leading: Icon(FontAwesomeIcons.infoCircle),
                        //   title: Text('Bet guide'),
                        //   onPressed: (v) {
                        //     Navigator.of(context).push(
                        //       MaterialPageRoute(
                        //           builder: (context) => TestingPaga()),
                        //     );
                        //   },
                        // ),

                        SettingsTile.navigation(
                          leading: Icon(FontAwesomeIcons.file),
                          title: Text('Terms & Conditions'),
                          onPressed: (v) {
                            Navigator.of(context)
                                .pushNamed('/settingPage/term&conditions');
                          },
                        ),
                        SettingsTile.navigation(
                          leading: Icon(FontAwesomeIcons.users),
                          title: Text('About Us'),
                          onPressed: (v) {
                            // TermsConditionPage
                            Navigator.of(context)
                                .pushNamed('/settingPage/aboutus');
                          },
                        ),
                        SettingsTile.navigation(
                          leading: Icon(
                            FontAwesomeIcons.star,
                          ),
                          title: Text('Rate Us'),
                          onPressed: (v) {
                            // TermsConditionPage
                            _openStoreListing();
                          },
                        ),
                        SettingsTile.navigation(
                          leading: Icon(
                            Icons.feedback,
                          ),
                          title: Text('Feedback'),
                          onPressed: (v) async {
                            if (await canLaunch(
                                "https://soccersport.club/feedback")) {
                              await launch("https://soccersport.club/feedback");
                            } else {
                              throw 'Could not launch https://soccersport.club/feedback';
                            }
                            //                   "https://soccersport.club/p6-registration/");
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => FeedbackPage()),
                            // );
                          },
                        ),
                        // if (Constant.auth != null)
                        //   SettingsTile.navigation(
                        //     leading: Icon(
                        //       FontAwesomeIcons.solidListAlt,
                        //     ),
                        //     title: Text('League Preferences'),
                        //     onPressed: (v) async {
                        //       Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => PersonalizePage(
                        //                   settingPage: true,
                        //                 )),
                        //       );
                        //     },
                        //   ),
                        if (Constant.auth != null)
                          SettingsTile.navigation(
                            leading: Icon(FontAwesomeIcons.userMinus),
                            onPressed: (v) {
                              // showDialog(
                              //   context: context,
                              //   useRootNavigator: false,
                              //   barrierDismissible: false,
                              //   builder: (context) => StatefulBuilder(
                              //       builder: (ctx, setState) =>
                              //           LogoutLoadingDialog()),
                              // );
                              showDialog(
                                  context: context,
                                  useRootNavigator: false,
                                  barrierDismissible: false,
                                  builder: (context) =>
                                      StatefulBuilder(builder: (ctx, ss) {
                                        return Dialog(
                                            child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: Container(
                                              child: Column(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: Column(children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 10.0),
                                                        child: FittedBox(
                                                          fit: BoxFit.fitHeight,
                                                          child: AutoSizeText(
                                                            'Delete Account',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                            maxFontSize: 40,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ]),
                                                ),
                                              ),
                                              Divider(),
                                              Expanded(
                                                flex: 2,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                    vertical:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.01,
                                                  ),
                                                  child: Container(
                                                      child: AutoSizeText(
                                                    "After delete account can't be undo or recover, you still want to delete this account?",
                                                    maxFontSize: 39,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 17),
                                                  )),
                                                ),
                                              ),
                                              Expanded(
                                                  child: Container(
                                                width: double.infinity,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: BlocBuilder<
                                                          WordpressAuthBloc,
                                                          WordpressAuthState>(
                                                        bloc: _authBloc,
                                                        builder:
                                                            (context, state) {
                                                          return GestureDetector(
                                                            onTap: (state
                                                                    is DeletingAccount)
                                                                ? null
                                                                : () {
                                                                    _authBloc.add(
                                                                        DeleteAccountRequest());
                                                                  },
                                                            child: Container(
                                                              color: Constant
                                                                  .color1,
                                                              child: Center(
                                                                  child: (state
                                                                          is DeletingAccount)
                                                                      ? LoadingWidget()
                                                                      : Text(
                                                                          'Delete',
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold),
                                                                        )),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Container(
                                                          color: Colors.grey,
                                                          child: Center(
                                                              child: Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )),
                                            ],
                                          )),
                                        ));
                                      }));
                            },
                            title: Text("Delete Account"),
                          ),
                        if (Constant.auth != null)
                          SettingsTile.navigation(
                            leading: Icon(Icons.logout),
                            onPressed: (v) {
                              // OneSignal.shared.logoutEmail();
                              // OneSignal.shared.disablePush(true);
                              showDialog(
                                context: context,
                                useRootNavigator: false,
                                barrierDismissible: false,
                                builder: (context) => StatefulBuilder(
                                    builder: (ctx, setState) =>
                                        LogoutLoadingDialog()),
                              );
                              _authBloc.add(WordpressLogoutRequest());
                            },
                            title: Text('Logout'),
                          ),
                      ],
                    ),
                    SettingsSection(
                      title:

                          // Showcase(
                          //   key: _key4,
                          //   description:
                          //       "Users can disable the all notifications at here",
                          //   child:

                          Text('Notifications',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                      // ),
                      tiles: [
                        // SettingsTile.navigation(
                        //   leading: Icon(Icons.notifications),
                        //   title: Text('Notification'),
                        // ),
                        SettingsTile.switchTile(
                          leading: Icon(Icons.notifications),
                          initialValue: notificationBool,
                          onToggle: (v) {
                            _notificationBloc.add(
                                PersistNotificationRequest(notification: v));
                            if (v) {
                              _fcm.subscribeToTopic('league39');
                              _fcm.subscribeToTopic('league61');
                              _fcm.subscribeToTopic('league78');
                              _fcm.subscribeToTopic('league140');
                              _fcm.subscribeToTopic('league1');

                              // OneSignal.shared.disablePush(false);
                              // enable push
                              OneSignal.User.pushSubscription.optIn();

                            } else {
                              _fcm.unsubscribeFromTopic('league39');
                              _fcm.unsubscribeFromTopic('league61');
                              _fcm.unsubscribeFromTopic('league78');
                              _fcm.unsubscribeFromTopic('league140');
                              _fcm.unsubscribeFromTopic('league1');
                              // OneSignal.shared.disablePush(true);
                              OneSignal.User.pushSubscription.optOut();
                            }
                          },
                          title: Text('Notification'),
                        )
                      ],
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}
