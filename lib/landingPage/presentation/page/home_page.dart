import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:badges/badges.dart' as badges;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:circle_bottom_navigation_bar/circle_bottom_navigation_bar.dart';
import 'package:circle_bottom_navigation_bar/widgets/tab_data.dart';
import 'package:dartz/dartz_unsafe.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:in_app_review/in_app_review.dart';
// import 'package:new_version_plus/model/version_status.dart';
// import 'package:new_version_plus/new_version_plus.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:soccer_sport/authentication/presentation/page/login_page.dart';
import 'package:soccer_sport/banner/domain/entities/banner.dart';
import 'package:soccer_sport/banner/presentation/bloc/banner_bloc.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/constant/local_notification_service.dart';
import 'package:soccer_sport/customer/presentation/bloc/customer_bloc.dart';
import 'package:soccer_sport/favourite/presentation/page/favourite_page.dart';
import 'package:soccer_sport/footballMatch/data/model/football_match_model.dart';
import 'package:soccer_sport/footballMatch/presentation/page/football_match_page.dart';
import 'package:soccer_sport/footballMatch/presentation/page/testing_page.dart';
import 'package:soccer_sport/footballMatch/presentation/page/wc_2022_page.dart';
import 'package:soccer_sport/landingPage/presentation/page/bet_guide.dart';
import 'package:soccer_sport/landingPage/presentation/widget/cny_event_page.dart';
import 'package:soccer_sport/landingPage/presentation/widget/daily_claims_dialog.dart';
import 'package:soccer_sport/landingPage/presentation/widget/daily_claims_page.dart';
import 'package:soccer_sport/landingPage/presentation/widget/home_page_ads.dart';
import 'package:soccer_sport/landingPage/presentation/widget/is_live_dialog.dart';
import 'package:soccer_sport/landingPage/presentation/widget/not_verified_dialog.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/league/presentation/page/leagues_page.dart';
import 'package:soccer_sport/news/presentation/pages/news_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soccer_sport/news/presentation/pages/news_view_page_by_slug.dart';
import 'package:soccer_sport/news/presentation/widget/event_not_started.dart';
import 'package:soccer_sport/setting/presentation/page/setting.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:soccer_sport/setting/presentation/page/sign_up_page.dart';
import 'package:soccer_sport/video/presentation/page/video_tabbar.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../authentication/presentation/bloc/wordpress_auth_bloc.dart';
import '../../../banner/domain/entities/ssc_dialog.dart';
import '../../../banner/domain/entities/ssc_fab.dart';
import '../../../banner/presentation/widget/banner_widget.dart';
import '../../../core/constant/analytics_service.dart';
import '../../../core/constant/messaging_service.dart';
import '../../../injection_container.dart';
import '../../../video/presentation/bloc/video_details_bloc.dart';
import '../../../video/presentation/page/recent_video_page.dart';
import '../widget/ssc_dialog_widget.dart';
import '../widget/ssc_fab_wdiget.dart';

enum Availability { loading, available, unavailable }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  late PersistentTabController _controller;
  // final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  late InAppWebViewController controller;
  final BannerBloc _bannerBloc = serviceLocator<BannerBloc>();
  final WordpressAuthBloc _authBloc = serviceLocator<WordpressAuthBloc>();
  final CustomerBloc _customerBloc = serviceLocator<CustomerBloc>();
  final VideoDetailsBloc _videoDetailsBloc = serviceLocator<VideoDetailsBloc>();
  final _messageService = MessagingService();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  // final CarouselController _icon_controller = CarouselController();

  List<BannerHtml>? bannerHtml;
  BannerHtml? eventBanner;
  bool loadHomeInit = true;
  BannerHtml? liveBannerHtml;
  bool hideFAB = false;
  int _current_slide = 0;
  List<SscFab> fabList = [];
  List<SscFab> noAuthFabList = [];
  List<SscFab> authFabList = [];
  List<SscDialog> sscDialogs = [];
  bool? firstTimeInstall;
  // bool isMember = false;
  int videoIndex = 0;
  bool isLoading = true;
  StreamSubscription? _sub;
  Timer? timer;
  bool whatsappPopup = true;
  // bool p6_registered = false;
  final InAppReview _inAppReview = InAppReview.instance;
  // late DatabaseReference database;

  // final newVersion = NewVersionPlus(
  //   iOSId: 'com.SoccerSport.SSC',
  //   androidId: 'com.SoccerSport.SSC',
  // );
  Availability _availability = Availability.loading;
  Future<void> _requestReview() => _inAppReview.requestReview();
  bool appReviewAvailable = false;
  Future<void> _openStoreListing() => _inAppReview.openStoreListing(
        appStoreId: '1569544522',
      );

  // bool isVerified = false;
  final List<Widget> _pages = [
    // WC2022Page(),
    // TestingPage(),

    FootballMatchPage(),
    VideoTabbar(),
    // LeaguePage(),
    FavouritePage(),

    NewsPage(),

    SettingPage(),
  ];

  // late PageController _pageController;

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  //   setState(() {
  //     print('home page ios change ');
  //     isMember = Constant.isMember;
  //   });
  // }

  // Future<void> checkNewVersion() async {
  //   final status = await newVersion.getVersionStatus();

  //   if (status != null && status.canUpdate) {
  //     // newVersion.showAlertIfNecessary(context: context);

  //     // newVersion.showUpdateDialog(
  //     //   context: context,
  //     //   versionStatus: status,
  //     //   dialogTitle: 'Update required',
  //     //   dialogText: status.releaseNotes,
  //     //   updateButtonText: 'Update',
  //     //   dismissButtonText: 'Maybe Later',
  //     //   dismissAction: null,
  //     // );
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return WillPopScope(
  //             onWillPop: () async {
  //               return false;
  //             },
  //             child: updateDialog(status!));
  //       },
  //     );
  //   }

  //   // showDialog(
  //   //   context: context,
  //   //   barrierDismissible: false,
  //   //   builder: (BuildContext context) {
  //   //     return WillPopScope(
  //   //         onWillPop: () async {
  //   //           return false;
  //   //         },
  //   //         child: updateDialog(status!));
  //   //   },
  //   // );

  //   // newVersion.showUpdateDialog(
  //   //   context: context,
  //   //   versionStatus: status!,
  //   //   dialogTitle: 'Update required',
  //   //   dialogText: status.releaseNotes,
  //   //   updateButtonText: 'Update',
  //   //   dismissButtonText: 'Maybe Later',
  //   //   dismissAction: null,
  //   //   launchModeVersion: LaunchModeVersion.external,
  //   // );

  //   // if (status != null) {
  //   //   print(status.storeVersion);
  //   //   print('status 1= null');
  //   //   print(status.releaseNotes.toString());
  //   //   newVersion.showUpdateDialog(
  //   //     context: context,
  //   //     versionStatus: status,
  //   //     dialogTitle: status.storeVersion.toString(),
  //   //     dialogText: status.releaseNotes.toString(),
  //   //     updateButtonText: 'update',
  //   //     dismissButtonText: 'maybe later',
  //   //     dismissAction: () => {},
  //   //   );
  //   // }
  // }

  @override
  void initState() {
    super.initState();
    initUniLinks();
    timer = Timer(Duration(seconds: 15), () {
      setState(() {
        whatsappPopup = false;
      });
    });
    _messageService.init(context);

    // checkNewVersion();

    // OneSignal.shared.setNotificationOpenedHandler((message) {
    //   if (message.notification.additionalData != null) {
    //     if (message.notification.additionalData!['register_redirect'] != null &&
    //         message.notification.additionalData!['register_redirect'] ==
    //             'sign_up_page') {
    //       Navigator.of(context)
    //           .push(MaterialPageRoute(builder: (context) => LoginPage()));
    //     }
    //     if (message.notification.additionalData!['jump_to'] != null &&
    //         (message.notification.additionalData!['jump_to'] == '4' ||
    //             message.notification.additionalData!['jump_to'] == 4)) {
    //       Constant.pageController!.jumpToPage(3);
    //     }
    //   }
    // });
    // _authBloc.add(CheckFirstTimeLoginRequest());
    // _authBloc.add(CheckMemberRequest());

    _bannerBloc.add(
        GetBannerRequest(api: FootballApi.bannerApi, id: 'mobile-banner1'));

    // _bannerBloc.add(
    //     GetEventBanner(api: FootballApi.bannerApi, id: 'mobile-banner-member'));
    _bannerBloc.add(GetUpdateDateRequest());

    _bannerBloc.add(GetSscDialogRequest());
    _bannerBloc.add(GetSscFabRequest());
    _videoDetailsBloc.add(CheckSscLiveRequest());
    // if (Constant.auth != null) {
    //   _customerBloc.add(CheckVerifiedRequest(id: Constant.auth!.id.toString()));
    // }
    //  _bannerBloc.add(
    // GetBannerRequest(api: FootballApi.bannerApi, id: 'mobile-banner1'));

    // _bannerBloc.add(GetSettingBannerRequest(
    //     api: 'https://soccersport.club/setting-page-banner/',
    //     id: 'setting-banner-xx'));

    Constant.pageController = PageController(initialPage: currentPage);

    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   // OneSignal.shared.setInAppMessageClickedHandler((action) {
    //   //   if(action.firstClick){
    //   //     action.
    //   //   }
    //   // });
    //   // OneSignal.shared.completeNotification(notificationId, shouldDisplay)
    // });
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (DateTime.now().toLocal().compareTo(DateTime(2022, 12, 18).toLocal()) >
          0) {
        try {
          final isAvailable = await _inAppReview.isAvailable();

          setState(() {
            // This plugin cannot be tested on Android by installing your app
            // locally. See https://github.com/britannio/in_app_review#testing for
            // more information.
            appReviewAvailable = isAvailable;
            _availability = isAvailable && !Platform.isAndroid
                ? Availability.available
                : Availability.unavailable;
          });
        } catch (e) {
          setState(() => _availability = Availability.unavailable);
        }

        if (appReviewAvailable) {
          _requestReview();
        }
      }
    });
    // Timer(Duration(seconds: 2), () {
    //   if (Constant.payload != '' && Constant.pageController!.hasClients) {
    //     print('test payl oad ing ');
    //     Constant.pageController!.jumpToPage(1);
    //   }
    // });
    // database = FirebaseDatabase.instance.ref('live');
    // database.onValue.listen((event) {
    //   if (event.snapshot.exists) {
    //     var jsonvalue =
    //         Map<String, dynamic>.from(event.snapshot.value as LinkedHashMap);
    //     print(jsonvalue);
    //     if (jsonvalue['islive'] != null &&
    //         jsonvalue['islive'] &&
    //         jsonvalue['content'] != null &&
    //         jsonvalue['title'] != null &&
    //         currentPage != 4) {
    //       print('got ma ?');
    //       showDialog(
    //         context: context,
    //         barrierDismissible: true,
    //         builder: (BuildContext context) {
    //           return IsLiveDialog(
    //               content: jsonvalue['content'], title: jsonvalue['title']);
    //         },
    //       );
    //     }
    //   }
    // });
  }

  @override
  void dispose() {
    Constant.pageController!.dispose();
    _bannerBloc.close();
    _customerBloc.close();
    _authBloc.close();
    timer!.cancel();
    super.dispose();
  }

  Future<void> initUniLinks() async {
    // ... check initialLink

    // Attach a listener to the stream
    _sub = uriLinkStream.listen((Uri? link) {
      String? slug = link!.queryParameters['post'];
      if (slug != null) {
        print(slug);
        print('got bo');

        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => NewsViewPageBySlug(slug: slug)),
        );
      }
      // print(link!.queryParameters['post']);
      print(' is uni link');
      // Parse the link and warn the user, if it is not correct
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });

    // NOTE: Don't forget to call _sub.cancel() in dispose()
  }

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;

    final bool useMobileLayout = shortestSide < 600;

    return ShowCaseWidget(
        disableBarrierInteraction: true,
        builder: Builder(builder: (context) {
          return Scaffold(
            body: MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => _bannerBloc,
                ),
                BlocProvider(
                  create: (context) => _authBloc,
                ),
                BlocProvider(
                  create: (context) => _customerBloc,
                ),
                BlocProvider(create: (context) => _videoDetailsBloc),
              ],
              child: MultiBlocListener(
                listeners: [
                  BlocListener<BannerBloc, BannerState>(
                    bloc: _bannerBloc,
                    listener: (context, state) {
                      if (state is BannerLoaded) {
                        setState(() {
                          bannerHtml = state.html;

                          Constant.newsBanner = state.html;
                        });
                      }

                      if (state is SscFabGet) {
                        setState(() {
                          noAuthFabList = state.html
                              .where((e) => ((!e.showAuth && !e.showNoAuth) ||
                                  (!e.showAuth && e.showNoAuth)))
                              .toList();
                          authFabList = state.html
                              .where((e) => ((!e.showAuth && !e.showNoAuth) ||
                                  (e.showAuth && !e.showNoAuth)))
                              .toList();

                          fabList = Constant.auth != null
                              ? authFabList
                              : noAuthFabList;
                        });
                      }

                      if (state is SscDialogGet) {
                        setState(() {
                          sscDialogs = state.html;
                          sscDialogs.forEach((dialog) {
                            if (dialog.isAuth) {
                              if (Constant.auth != null)
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return WillPopScope(
                                        onWillPop: () async {
                                          return false;
                                        },
                                        child: SscDialogWidget(
                                          sscDialog: dialog,
                                        ));
                                  },
                                );
                            } else {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return WillPopScope(
                                      onWillPop: () async {
                                        return false;
                                      },
                                      child: SscDialogWidget(
                                        sscDialog: dialog,
                                      ));
                                },
                              );
                            }
                          });
                        });
                      }
                      // if (state is SettingBannerLoaded) {
                      //   print('got ma ???');
                      //   setState(() {
                      //     Constant.settingBanner = state.html;
                      //   });
                      // }

                      // if (state is EventBannerLoaded) {
                      //   print('got event banenr');
                      //   setState(() {
                      //     eventBanner = state.html;
                      //     Constant.eventBanner = eventBanner;
                      //   });
                      // }

                      if (state is UpdateDateGet) {
                        if (state.html != '') {
                          DateTime updateDate =
                              DateTime.parse(state.html).toLocal();
                          DateTime lastDate = DateTime(updateDate.year,
                              updateDate.month, updateDate.day);
                          DateTime todayValue = DateTime.now().toLocal();
                          DateTime todayDate = DateTime(todayValue.year,
                              todayValue.month, todayValue.day);
                          if (todayDate.difference(lastDate).inDays >= 1) {
                            _bannerBloc.add(PersistUpdateDateRequest(
                                date: Constant.formattedDate(DateTime.now())));
                          }
                        } else {
                          _bannerBloc.add(PersistUpdateDateRequest(
                              date: Constant.formattedDate(
                                  DateTime.now().toLocal())));
                        }
                      }

                      if (state is UpdateDatePersisted) {
                        // if (Constant.showcaseBool) {
                        if (state.html) {
                          // showDialog(
                          //   context: context,
                          //   barrierDismissible: false,
                          //   builder: (BuildContext context) {
                          //     return DailyClaimsDialog(
                          //       navigateToClaimPage: () {},
                          //     );
                          //   },
                          // );
                          if (Constant.auth != null &&
                              Constant.isVerified == false) {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return NotVerifiedDialog();
                              },
                            );
                          }
                          // }
                        }
                      }
                    },
                  ),
                  BlocListener<VideoDetailsBloc, VideoDetailsState>(
                    listener: (context, state) {
                      if (state is SscLiveChecked) {
                        setState(() {
                          Constant.isLive = state.isLive;
                        });
                      }
                    },
                  ),
                  BlocListener<WordpressAuthBloc, WordpressAuthState>(
                    bloc: _authBloc,
                    listener: (context, state) {
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
                      // if (state is MemberChecked) {
                      //   if (state.auth != null) {
                      //     setState(() {
                      //       // print('member check is ${state.auth!}');

                      //       Constant.isMember = state.auth!;
                      //       Constant.isMember = state.auth!;
                      //     });
                      //     if (Constant.auth != null) {
                      //       _customerBloc.add(GetCustomerDetailsRequest(
                      //           id: Constant.auth!.id));
                      //       _customerBloc.add(GetUserRewardDetailRequest(
                      //           id: Constant.auth!.id.toString()));
                      //     }
                      //   }
                      // }
                    },
                  ),
                  BlocListener<CustomerBloc, CustomerState>(
                    bloc: _customerBloc,
                    listener: (context, state) {
                      // if (state is CustomerDetailsLoaded) {
                      //   setState(() {
                      //     Constant.customer = state.customer;
                      //   });
                      // }

                      // if (state is UserRewardDetailGet) {
                      //   setState(() {
                      //     print('got get user rewad ');
                      //     Constant.customerRewardDetail = state.success;
                      //     print(
                      //         Constant.customerRewardDetail!.checkInCount < 30);
                      //   });
                      // }
                      // if (state is VerifiedChecked) {
                      //   setState(() {
                      //     Constant.isVerified = state.success.verified;
                      //     Constant.p6_registered = state.success.p6_registered;
                      //     Constant.p6_registered = state.success.p6_registered;

                      //   });
                      // }
                    },
                  ),
                ],
                child: PageView(
                  controller: Constant.pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: _pages,
                  onPageChanged: (index) {
                    setState(() {
                      Constant.isMember = Constant.isMember;
                      if (Constant.auth != null) {
                        fabList = authFabList;
                      } else {
                        fabList = noAuthFabList;
                      }

                      // Constant.customer = Constant.customer;

                      currentPage = index;
                    });
                  },
                ),
              ),
            ),

            // floatingActionButton: Container(
            //   height: 120,
            //   child: Column(
            //       mainAxisAlignment: MainAxisAlignment.spaceAround,
            //       children: [
            //         fabList.length > 0 && !hideFAB
            //             ? Container(
            //                 height: 50,
            //                 width: 50,
            //                 child: CarouselSlider.builder(
            //                   itemCount: fabList.length,
            //                   options: CarouselOptions(
            //                     aspectRatio: 2.0,
            //                     enlargeCenterPage: true,
            //                     viewportFraction: 1,
            //                     initialPage: 0,
            //                     autoPlay: fabList.length < 2 ? false : true,
            //                     autoPlayInterval: Duration(seconds: 8),
            //                     autoPlayAnimationDuration:
            //                         Duration(milliseconds: 800),
            //                     autoPlayCurve: Curves.fastOutSlowIn,
            //                     scrollDirection: Axis.horizontal,
            //                   ),
            //                   itemBuilder: (BuildContext context, int itemIndex,
            //                       int pageViewIndex) {
            //                     // if (itemIndex == 0) {
            //                     //   return Container(
            //                     //     child: Image.asset('assets/Slide1.JPG'),
            //                     //   );
            //                     // } else if (itemIndex == 1) {
            //                     //   return Container(color: Colors.grey);
            //                     // } else {
            //                     //   return Container(color: Colors.blue);
            //                     // }

            //                     return sscFabButton(fabList[itemIndex]);
            //                   },
            //                 ),
            //               )
            //             : Container(),
            //         fabList.length > 0
            //             ? Container(
            //                 width: 100,
            //                 child: Row(
            //                   children: [
            //                     Padding(
            //                         padding: const EdgeInsets.all(8.0),
            //                         child: Flexible(
            //                             child: Row(
            //                           mainAxisAlignment: MainAxisAlignment.end,
            //                           crossAxisAlignment:
            //                               CrossAxisAlignment.start,
            //                           children: [
            //                             Container(
            //                               padding: EdgeInsets.all(14),
            //                               decoration: BoxDecoration(
            //                                 color: Colors.grey[900],
            //                                 borderRadius: BorderRadius.only(
            //                                   topLeft: Radius.circular(18),
            //                                   bottomLeft: Radius.circular(18),
            //                                   bottomRight: Radius.circular(18),
            //                                 ),
            //                               ),
            //                               child: Text(
            //                                 'test',
            //                                 style: TextStyle(
            //                                     color: Colors.white,
            //                                     fontFamily: 'Monstserrat',
            //                                     fontSize: 14),
            //                               ),
            //                             ),
            //                             CustomPaint(
            //                                 painter:
            //                                     CustomShape(Colors.grey[900]!)),
            //                           ],
            //                         ))),
            //                     Container(
            //                       height: 50,
            //                       width: 50,
            //                       child: Container(
            //                         height: MediaQuery.of(context).size.height *
            //                             0.1,
            //                         width: MediaQuery.of(context).size.width *
            //                             0.25,
            //                         child: FadeInImage.memoryNetwork(
            //                             placeholder: kTransparentImage,
            //                             image: fabList[0].icon,
            //                             imageErrorBuilder: (e, o, c) {
            //                               return Container();
            //                             }),
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               )
            //             : Container(),
            //       ]),
            // ),

            floatingActionButton: Stack(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      fabList.length > 0 && !hideFAB
                          ? Container(
                              height: 50,
                              width: 50,
                              child: CarouselSlider.builder(
                                itemCount: fabList.length,
                                options: CarouselOptions(
                                  aspectRatio: 2.0,
                                  enlargeCenterPage: true,
                                  viewportFraction: 1,
                                  initialPage: 0,
                                  autoPlay: fabList.length < 2 ? false : true,
                                  autoPlayInterval: Duration(seconds: 8),
                                  autoPlayAnimationDuration:
                                      Duration(milliseconds: 800),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  scrollDirection: Axis.horizontal,
                                ),
                                itemBuilder: (BuildContext context,
                                    int itemIndex, int pageViewIndex) {
                                  // if (itemIndex == 0) {
                                  //   return Container(
                                  //     child: Image.asset('assets/Slide1.JPG'),
                                  //   );
                                  // } else if (itemIndex == 1) {
                                  //   return Container(color: Colors.grey);
                                  // } else {
                                  //   return Container(color: Colors.blue);
                                  // }

                                  return sscFabButton(fabList[itemIndex]);
                                },
                              ),
                            )
                          : Expanded(child: Container()),
                      GestureDetector(
                        onTap: () async {
                          const url =
                              "https://wa.me/+855312813765?text=Hi,%20how%20to%20claim%20football%20betting%20promotion?";
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch ${url}';
                          }
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          child: Image.asset('assets/ws.png'),
                        ),
                      ),
                    ],
                  ),
                ),
                if (whatsappPopup)
                  Positioned(
                    right: 35,
                    bottom: 25,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.all(14),
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.4),
                              decoration: BoxDecoration(
                                color: Colors.grey[350],
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(18),
                                  bottomLeft: Radius.circular(18),
                                  topRight: Radius.circular(18),
                                ),
                              ),
                              child: Text(
                                'Hi, ask us on how to get promotion.',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 10),
                                maxLines: 2,
                              ),
                            ),
                            CustomPaint(
                                painter: CustomShape(
                              Colors.grey[350]!,
                            )),
                          ],
                        )),
                  ),
              ],
            ),

            // floatingActionButton: (Constant.customerRewardDetail != null &&
            //             Constant.customerRewardDetail!.checkInCount < 30) &&
            //         currentPage != 4 &&
            //         hideFAB != true &&
            //         !(DateTime.now()
            //             .toLocal()
            //             .difference(
            //                 DateTime.fromMillisecondsSinceEpoch(1671033600000))
            //             .isNegative)
            //     ? Stack(alignment: AlignmentDirectional.topEnd, children: [
            //         GestureDetector(
            //           // mini: true,
            //           onTap: () {
            //             if (Constant.auth != null) {
            //               Navigator.of(context)
            //                   .push(
            //                     MaterialPageRoute(
            //                         builder: (context) => DailyClaimsPage()),
            //                   )
            //                   .then((_) => setState(() {
            //                         print('refres auth ');
            //                         Constant.customer = Constant.customer;
            //                         Constant.auth = Constant.auth;
            //                       }));
            //             } else {
            //               Navigator.of(context).push(
            //                 MaterialPageRoute(builder: (context) => LoginPage()),
            //               );
            //             }
            //           },

            //           child: Container(
            //             height: MediaQuery.of(context).size.height * 0.1,
            //             width: MediaQuery.of(context).size.width * 0.25,
            //             child: FadeInImage.memoryNetwork(
            //                 placeholder: kTransparentImage,
            //                 image:
            //                     'https://soccersport.club/wp-content/uploads/2022/18/fab_tran.gif',
            //                 imageErrorBuilder: (e, o, c) {
            //                   return Container();
            //                 }),
            //           ),
            //         ),
            //         GestureDetector(
            //           onTap: () {
            //             setState(() {
            //               hideFAB = true;
            //             });
            //           },
            //           child: Opacity(
            //             opacity: 0.7,
            //             child: Container(
            //               height: 20,
            //               width: 20,
            //               decoration: BoxDecoration(
            //                 shape: BoxShape.circle,
            //                 color: Colors.white,
            //               ),
            //               child: Center(
            //                 child: Icon(
            //                   CupertinoIcons.clear_circled_solid,
            //                   size: 20,
            //                   color: Colors.grey,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ])
            //     : Container(),

            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                  color: Constant.backgroundColor.withOpacity(0.2)),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    bannerHtml != null
                        ? Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width > 768
                                ? 768
                                : double.infinity,
                            child: CarouselSlider.builder(
                              itemCount: bannerHtml!.length,
                              options: CarouselOptions(
                                aspectRatio: 2.0,
                                enlargeCenterPage: false,
                                initialPage: 0,
                                enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                                disableCenter: true,
                                viewportFraction: 1.0,
                                autoPlay: true,
                                autoPlayInterval: Duration(seconds: 10),
                                autoPlayAnimationDuration:
                                    Duration(milliseconds: 100),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _current_slide = index;
                                  });
                                },
                                scrollDirection: Axis.horizontal,
                              ),
                              itemBuilder: (BuildContext context, int itemIndex,
                                  int pageViewIndex) {
                                // if (itemIndex == 0) {
                                //   return Container(
                                //     child: Image.asset('assets/Slide1.JPG'),
                                //   );
                                // } else if (itemIndex == 1) {
                                //   return Container(color: Colors.grey);
                                // } else {
                                //   return Container(color: Colors.blue);
                                // }
                                //  final double dist = (_currentIndex - index).abs() * 0.1;
                                final double opacity =
                                    itemIndex == _current_slide ? 1.0 : 0.0;

                                return AnimatedOpacity(
                                    opacity: opacity,
                                    duration: Duration(
                                        milliseconds:
                                            800), // Adjust duration as needed
                                    child: GestureDetector(
                                      onTap: () async {
                                        BannerHtml html =
                                            bannerHtml![itemIndex];
                                        // if (Constant.auth!) {
                                        //   if (html.href != null) {
                                        //     if (await canLaunch(html.href!)) {
                                        //       await launch(html.href!);
                                        //     } else {
                                        //       throw 'Could not launch ${html.href!}';
                                        //     }
                                        //   } else {
                                        //     Constant.pageController!.jumpToPage(1);
                                        //   }
                                        // } else {
                                        //   Navigator.of(context).push(
                                        //     MaterialPageRoute(
                                        //         builder: (context) => LoginPage()),
                                        //   );
                                        // }
                                        if (await canLaunch(html.href!)) {
                                          await launch(html.href!);
                                        } else {
                                          throw 'Could not launch ${html.href!}';
                                        }
                                      },
                                      child: BannerWidget(
                                          imgSrc:
                                              bannerHtml![itemIndex].url != null
                                                  ? bannerHtml![itemIndex].url!
                                                  : ''),
                                    ));
                                // return listOfSlider()[itemIndex];
                              },
                            ),
                          )
                        : Container(),
                    // bannerHtml != null && currentPage != 5 && currentPage != 4
                    //     ? GestureDetector(
                    //         onTap: () async {
                    //           BannerHtml html = bannerHtml![0];
                    //           if (Constant.isMember) {
                    //             if (html.href != null) {
                    //               if (await canLaunch(html.href!)) {
                    //                 await launch(html.href!);
                    //               } else {
                    //                 throw 'Could not launch ${html.href!}';
                    //               }
                    //             } else {
                    //               Constant.pageController!.jumpToPage(1);
                    //             }
                    //           } else {
                    //             Navigator.of(context).push(
                    //               MaterialPageRoute(
                    //                   builder: (context) => LoginPage()),
                    //             );
                    //           }
                    //         },
                    //         child: BannerWidget(
                    //             imgSrc: bannerHtml![0].url != null
                    //                 ? bannerHtml![0].url!
                    //                 : ''))
                    //     : Container(),
                    BottomNavigationBar(
                      type: BottomNavigationBarType.fixed, // Fixed
                      backgroundColor: Constant.backgroundColor,
                      unselectedItemColor: Colors.grey,

                      items: <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon:
                              //  Showcase(
                              //   key: Constant.matchIcon,
                              //   description: "Click here to proceed",
                              //   onTargetClick: () {
                              //     Constant.pageController!.jumpToPage(2);
                              //   },
                              //   disposeOnTap: true,
                              //   onToolTipClick: () {
                              //     Constant.pageController!.jumpToPage(2);
                              //   },
                              //   child:
                              Align(
                            alignment: Alignment.center,
                            child: Container(
                              padding: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: Icon(FontAwesomeIcons.futbol,
                                      color: currentPage == 0
                                          ? Colors.black
                                          : Colors.grey),
                                ),
                              ),
                            ),
                          ),
                          //     Stack(
                          //   children: [

                          //     Align(
                          //       alignment: Alignment.topRight,
                          //       child: Container(
                          //           padding: EdgeInsets.all(2),
                          //           decoration:
                          //               BoxDecoration(color: Constant.color1),
                          //           child: AutoSizeText(
                          //             'Scores',
                          //             style: TextStyle(fontSize: 6),
                          //             minFontSize: 5,
                          //             maxLines: 1,
                          //           )),
                          //     ),
                          //   ],
                          // ),
                          // ),
                          label: 'Match',
                        ),
                        BottomNavigationBarItem(
                          icon:

                              // Showcase(
                              //   key: Constant.videIcon,
                              //   description: "Click here to proceed",
                              //   onTargetClick: () {
                              //     Constant.pageController!.jumpToPage(3);
                              //   },
                              //   onToolTipClick: () {
                              //     Constant.pageController!.jumpToPage(3);
                              //   },
                              //   disposeOnTap: true,
                              //   child:

                              Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  FontAwesomeIcons.video,
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                    padding: EdgeInsets.all(2),
                                    decoration:
                                        BoxDecoration(color: Constant.color1),
                                    child: AutoSizeText(
                                      'Live',
                                      style: TextStyle(fontSize: 6),
                                      minFontSize: 5,
                                      maxLines: 1,
                                    )),
                              ),
                            ],
                          ),
                          //  ),
                          label: 'Video',
                        ),
                        // BottomNavigationBarItem(
                        //   icon:

                        //       // Showcase(
                        //       //   key: Constant.statsIcon,
                        //       //   description: "Click here to proceed",
                        //       //   onTargetClick: () {
                        //       //     Constant.pageController!.jumpToPage(4);
                        //       //   },
                        //       //   onToolTipClick: () {
                        //       //     Constant.pageController!.jumpToPage(4);
                        //       //   },
                        //       //   disposeOnTap: true,
                        //       //   child:
                        //       Icon(
                        //     FontAwesomeIcons.chartBar,
                        //   ),
                        //   // ),
                        //   label: 'Stats',
                        // ),
                        BottomNavigationBarItem(
                          icon:
                              // Showcase(
                              //   key: Constant.favouriteIcon,
                              //   description: "Click here to proceed",
                              //   onTargetClick: () {
                              //     Constant.pageController!.jumpToPage(1);
                              //   },
                              //   onToolTipClick: () {
                              //     Constant.pageController!.jumpToPage(1);
                              //   },
                              //   disposeOnTap: true,
                              //   child:

                              Icon(
                            Icons.star,
                          ),
                          // ),
                          label: 'Favourite',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(
                            FontAwesomeIcons.newspaper,
                          ),
                          label: 'News',
                        ),
                        BottomNavigationBarItem(
                          icon:

                              // Showcase(
                              //   key: Constant.settingIcon,
                              //   description: "Press here to proceed next tutorial",
                              //   onTargetClick: () {
                              //     Constant.pageController!.jumpToPage(5);
                              //   },
                              //   disposeOnTap: true,
                              //   onToolTipClick: () {
                              //     Constant.pageController!.jumpToPage(5);
                              //   },
                              //   child:

                              badges.Badge(
                            position: badges.BadgePosition.topEnd(),
                            // alignment: Alignment.bottomCenter,

                            badgeStyle: badges.BadgeStyle(
                              padding: useMobileLayout
                                  ? EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.02,
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                      right: MediaQuery.of(context).size.width *
                                          0.02,
                                      left: MediaQuery.of(context).size.width *
                                          0.01,
                                    )
                                  : EdgeInsets.all(5),
                              badgeColor: Constant.isMember
                                  ? Constant.backgroundColor
                                  : Colors.red,
                            ),

                            stackFit: StackFit.passthrough,
                            // elevation: 2,

                            // badgeContent: FittedBox(
                            //   fit: BoxFit.fitHeight,
                            //   child: AutoSizeText(Constant.cartItems.length.toString(),
                            //       maxFontSize: 18,
                            //       minFontSize: 4,
                            //       style: TextStyle(color: Colors.white, fontSize: 12)),
                            // ),
                            child: Icon(
                              Icons.settings,
                            ),
                          ),
                          // ),
                          label: 'Setting',
                        ),
                      ],
                      currentIndex: currentPage,

                      selectedItemColor: Constant.color2,
                      onTap: _onItemTapped,
                    ),
                  ]),
            ),
          );
        }));
  }

  void _onItemTapped(int index) {
    // if (index == 3) {
    //   if (Constant.auth != null) {
    //     setState(() {
    //       currentPage = index;
    //     });
    //   } else {
    //     Navigator.of(context).push(
    //       MaterialPageRoute(builder: (context) => LoginPage()),
    //     );
    //   }
    // } else {
    //   setState(() {
    //     currentPage = index;
    //   });
    // }
    setState(() {
      Constant.pageController!.jumpToPage(index);
      if (index == 0) {
        serviceLocator<AnalyticsService>().logScreens(name: '/newspage');
      } else if (index == 1) {
        serviceLocator<AnalyticsService>().logScreens(name: '/favouritematch');
      } else if (index == 2) {
        serviceLocator<AnalyticsService>()
            .logScreens(name: '/footballMatchPage');
      } else if (index == 3) {
        serviceLocator<AnalyticsService>().logScreens(name: '/video');
      } else if (index == 4) {
        serviceLocator<AnalyticsService>().logScreens(name: '/statsPage');
      } else if (index == 4) {
        serviceLocator<AnalyticsService>().logScreens(name: '/settingPage');
      }
    });
  }

  Widget sscFabButton(SscFab sscFab) {
    return Stack(alignment: AlignmentDirectional.topEnd, children: [
      GestureDetector(
        // mini: true,
        onTap: () async {
          if (sscFab.showDialog) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return SscFabDialog(
                  sscFab: sscFab,
                );
              },
            );
          } else {
            if (sscFab.isAuth) {
              if (Constant.auth != null) {
                if (await canLaunch(sscFab.callback)) {
                  await launch(sscFab.callback);
                } else {
                  throw 'Could not launch ${sscFab.callback}';
                }
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              }
            } else {
              if (await canLaunch(sscFab.callback)) {
                await launch(sscFab.callback);
              } else {
                throw 'Could not launch ${sscFab.callback}';
              }
            }
          }
        },

        child: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.25,
          child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: sscFab.icon,
              imageErrorBuilder: (e, o, c) {
                return Container();
              }),
        ),
      ),
      GestureDetector(
        onTap: () {
          setState(() {
            hideFAB = true;
          });
        },
        child: Opacity(
          opacity: 0.7,
          child: Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Center(
              child: Icon(
                CupertinoIcons.clear_circled_solid,
                size: 20,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  List<Widget?> fabSlider() {
    return [
      currentPage != 3 &&
              hideFAB != true &&
              (DateTime.now()
                  .toLocal()
                  .difference(
                      DateTime.fromMillisecondsSinceEpoch(1675699200000))
                  .isNegative)
          ? Stack(alignment: AlignmentDirectional.topEnd, children: [
              GestureDetector(
                // mini: true,
                onTap: () {
                  if (Constant.auth != null) {
                    if (!(DateTime.now()
                        .toLocal()
                        .toLocal()
                        .difference(
                            DateTime.fromMillisecondsSinceEpoch(1672934400000))
                        .isNegative)) {
                      serviceLocator<AnalyticsService>()
                          .logScreens(name: '/cny');
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => CnyEventPage()),
                      );
                    } else {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return EventNotStarted();
                        },
                      );
                    }
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  }
                },

                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Image.asset('assets/cny_button.png'),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    hideFAB = true;
                  });
                },
                child: Opacity(
                  opacity: 0.7,
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Icon(
                        CupertinoIcons.clear_circled_solid,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ])
          : null,
      (Constant.customerRewardDetail != null &&
                  Constant.customerRewardDetail!.checkInCount < 30) &&
              currentPage != 3 &&
              hideFAB != true &&
              !(DateTime.now()
                  .toLocal()
                  .difference(
                      DateTime.fromMillisecondsSinceEpoch(1671033600000))
                  .isNegative)
          ? Stack(alignment: AlignmentDirectional.topEnd, children: [
              GestureDetector(
                // mini: true,
                onTap: () {
                  if (Constant.auth != null) {
                    Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                              builder: (context) => DailyClaimsPage()),
                        )
                        .then((_) => setState(() {
                              Constant.customer = Constant.customer;
                              Constant.auth = Constant.auth;
                            }));
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  }
                },

                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image:
                          'https://soccersport.club/wp-content/uploads/2022/18/fab.gif',
                      imageErrorBuilder: (e, o, c) {
                        return Container();
                      }),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    hideFAB = true;
                  });
                },
                child: Opacity(
                  opacity: 0.7,
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Icon(
                        CupertinoIcons.clear_circled_solid,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ])
          : null,
      // currentPage != 3 && hideFAB != true
      //     ? Stack(alignment: AlignmentDirectional.topEnd, children: [
      //         GestureDetector(
      //           // mini: true,
      //           onTap: () {
      //             if (Constant.auth != null) {
      //               Constant.pageController!.jumpToPage(2);
      //             } else {
      //               Navigator.of(context).push(
      //                 MaterialPageRoute(builder: (context) => LoginPage()),
      //               );
      //             }
      //           },

      //           child: Container(
      //             height: MediaQuery.of(context).size.height * 0.1,
      //             width: MediaQuery.of(context).size.width * 0.25,
      //             child: FadeInImage.memoryNetwork(
      //                 placeholder: kTransparentImage,
      //                 image:
      //                     'https://soccersport.club/wp-content/uploads/2022bet_guide.gif',
      //                 imageErrorBuilder: (e, o, c) {
      //                   return Center(
      //                     child: Container(
      //                       child: Text('bet'),
      //                     ),
      //                   );
      //                 }),
      //           ),
      //         ),
      //         GestureDetector(
      //           onTap: () {
      //             setState(() {
      //               hideFAB = true;
      //             });
      //           },
      //           child: Opacity(
      //             opacity: 0.7,
      //             child: Container(
      //               height: 20,
      //               width: 20,
      //               decoration: BoxDecoration(
      //                 shape: BoxShape.circle,
      //                 color: Colors.white,
      //               ),
      //               child: Center(
      //                 child: Icon(
      //                   CupertinoIcons.clear_circled_solid,
      //                   size: 20,
      //                   color: Colors.grey,
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ),
      //       ])
      //     : null
    ];
  }

  // Widget updateDialog(VersionStatus status) {
  //   return Dialog(
  //       child: Container(
  //     height: MediaQuery.of(context).size.height * 0.2,
  //     width: MediaQuery.of(context).size.width * 0.8,
  //     child: Container(
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.all(Radius.circular(25.0)),
  //         ),
  //         child: Column(
  //           children: [
  //             Expanded(
  //               child: Container(
  //                 child: Column(children: [
  //                   Expanded(
  //                     child: Padding(
  //                       padding: const EdgeInsets.only(top: 10.0),
  //                       child: FittedBox(
  //                         fit: BoxFit.fitHeight,
  //                         child: Text(
  //                           'Update Required',
  //                           style: TextStyle(
  //                               fontSize: 17,
  //                               fontWeight: FontWeight.bold,
  //                               color: Colors.black),
  //                         ),
  //                       ),
  //                     ),
  //                   )
  //                 ]),
  //               ),
  //             ),
  //             Expanded(
  //               flex: 2,
  //               child: Container(
  //                 padding: EdgeInsets.symmetric(
  //                   horizontal: MediaQuery.of(context).size.width * 0.05,
  //                   vertical: MediaQuery.of(context).size.height * 0.01,
  //                 ),
  //                 child: Center(
  //                     child: Text(
  //                   'Please update immediately to ensure optimal performance to have better experience.',
  //                   style: TextStyle(
  //                     fontSize: 14,
  //                     color: Colors.black,
  //                   ),
  //                   textAlign: TextAlign.center,
  //                 )),
  //               ),
  //             ),
  //             Divider(),
  //             Expanded(
  //                 child: GestureDetector(
  //               onTap: () async {
  //                 if (await canLaunchUrl(Uri.parse(status.appStoreLink))) {
  //                   await launchUrl(Uri.parse(status.appStoreLink),
  //                       mode: LaunchMode.externalApplication);
  //                 } else {
  //                   throw 'Could not launch appStoreLink';
  //                 }
  //               },
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.all(Radius.circular(25.0)),
  //                 ),
  //                 child: Center(
  //                     child: Text(
  //                   'Update',
  //                   style: TextStyle(
  //                       color: Colors.blue,
  //                       fontSize: 17,
  //                       fontWeight: FontWeight.bold),
  //                 )),
  //               ),
  //             )),
  //           ],
  //         )),
  //   ));
  // }
}

class CustomShape extends CustomPainter {
  final Color bgColor;

  CustomShape(this.bgColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = bgColor;

    var path = Path();

    path.lineTo(0, -5);
    path.lineTo(5, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
