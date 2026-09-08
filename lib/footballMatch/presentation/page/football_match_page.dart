import 'dart:async';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:soccer_sport/authentication/presentation/page/login_page.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/footballMatch/presentation/bloc/football_match_bloc.dart';
import 'package:soccer_sport/footballMatch/presentation/page/bet_rank_page.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_live_match_tab.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_match_list.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_match_tab_bar_view.dart';
import 'package:soccer_sport/landingPage/presentation/page/personalize_page.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/league/presentation/widget/league_selection_dialog.dart';
import 'package:soccer_sport/video/presentation/bloc/video_details_bloc.dart';
import 'package:super_banners/super_banners.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../core/constant/analytics_service.dart';
import '../../../injection_container.dart';

class FootballMatchPage extends StatefulWidget {
  // FootballMatchPage({Key? key}) : super(key: key);

  @override
  _FootballMatchPageState createState() => _FootballMatchPageState();
}

class _FootballMatchPageState extends State<FootballMatchPage>
    with SingleTickerProviderStateMixin {
  final FootballMatchBloc _footballMatchBloc =
      serviceLocator<FootballMatchBloc>();
  final VideoDetailsBloc _videoDetailsBloc = serviceLocator<VideoDetailsBloc>();
  final _key1 = GlobalKey();
  bool rankingHover = false;
  List<LeagueDetails> leagueList = [];
  List<Widget> listWidget = [FootballLiveMatchTab()];
  // List<Widget> listWidget = [];

  List<Widget> tabList = [
    Tab(
      icon: Text('Today'),
    )
  ];
  TabController? _tabController;
  // premier 39
  // Ligue 61
  // BundesLiga 78
  // Wolrd 1
  // Laliga 140
  // Serie A 135
  List<int> leaguesID = [39, 135, 78, 140, 1];
  List<int> betable = [39, 135, 78, 140];
  double _width = 30;
  double _height = 30;

  bool changeAnimation = false;
  bool backFromPage = false;
  // ignore: prefer_final_fields
  // late TabController _tabController;

  @override
  void initState() {
    super.initState();

    leagueList = Constant.staticLeagues
        .where((e) => leaguesID.contains(e.league.id))
        .toList();

    listWidget.addAll(
      leagueList.map(
        (e) => FootballMatchTabBarView(league: e),
      ),
    );

    tabList.addAll(
      leagueList.map(
        (e) => Tab(
          text: e.league.name,
        ),
      ),
    );
    
    _tabController = TabController(
      vsync: this,
      length: listWidget.length,
    );
  }

  // @override
  // void initState() {
  //   super.initState();
  //   List<LeagueDetails> cloneList =
  //       List<LeagueDetails>.from(Constant.staticLeagues);

  //   leagueList = cloneList.where((e) {
  //     return leaguesID.contains(e.league.id);
  //   }).toList();

  //   final eplIndex =
  //       leagueList.indexWhere((element) => element.league.id == 39);

  //   if (eplIndex != -1) {
  //     final epl = leagueList.removeAt(eplIndex);
  //     leagueList.insert(0, epl);
  //   }

  //   final wcIndex = leagueList.indexWhere((element) => element.league.id == 1);

  //   if (wcIndex != -1) {
  //     final wc = leagueList.removeAt(wcIndex);
  //     leagueList.insert(
  //       leagueList.length >= 4 ? 4 : leagueList.length,
  //       wc,
  //     );
  //   }

  //   // final eplIndex =
  //   //     leagueList.indexWhere((element) => element.league.id == 39);
  //   // final wcIndex =
  //   //     (leagueList.indexWhere((element) => element.league.id == 1));

  //   // final epl = leagueList[eplIndex];
  //   // final wc = leagueList[wcIndex];
  //   // leagueList.remove(epl);
  //   // leagueList.remove(wc);

  //   // leagueList.insert(0, epl);
  //   // // leagueList.insert(4, wc);
  //   // leagueList.insert(
  //   //   leagueList.length >= 4 ? 4 : leagueList.length,
  //   //   wc,
  //   // );
  //   if (Constant.auth != null &&
  //       Constant.customerRewardDetail!.leagues.length > 0) {
  //     final personalizeList = cloneList
  //         .where((element) => Constant.customerRewardDetail!.leagues
  //             .contains(element.league.id))
  //         .toList();
  //     leagueList.insertAll(0, personalizeList);
  //   }

  //   listWidget.addAll(leagueList
  //       .map((e) => FootballMatchTabBarView(
  //             league: e,
  //           ))
  //       .toList());

  //   _tabController = new TabController(
  //     vsync: this,
  //     length: listWidget.length,
  //   );

  //   tabList.addAll(leagueList
  //       .map(
  //         (e) => Stack(
  //             fit: StackFit.passthrough,
  //             alignment: AlignmentDirectional.bottomEnd,
  //             children: [
  //               Tab(
  //                 icon: Row(
  //                   children: [
  //                     // Container(
  //                     //   height: 30,
  //                     //   width: 30,
  //                     //   color: e.country!.flag == null
  //                     //       ? Colors.white
  //                     //       : Colors.transparent,
  //                     //   margin: EdgeInsets.only(right: 3),
  //                     //   padding: EdgeInsets.all(5),
  //                     //   child: e.country!.flag == null
  //                     //       ? FadeInImage.memoryNetwork(
  //                     //           placeholder: kTransparentImage,
  //                     //           image: e.league.logo!,
  //                     //           imageErrorBuilder: (e, o, c) {
  //                     //             return Container();
  //                     //           })
  //                     //       : SvgPicture.network(
  //                     //           e.country!.flag!,
  //                     //           // placeholderBuilder: (BuildContext context) => Container(
  //                     //           //     padding: const EdgeInsets.all(30.0),
  //                     //           //     child: const CircularProgressIndicator()),
  //                     //         ),
  //                     // ),
  //                     Column(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           e.league.id == 1
  //                               ? 'FIFA World Cup(tm)'
  //                               : e.league.name,
  //                           style: TextStyle(fontWeight: FontWeight.bold),
  //                         ),
  //                         Text(
  //                           e.country!.name,
  //                           style: TextStyle(fontSize: 10),
  //                         ),
  //                       ],
  //                     ),
  //                     if (leagueList.last.league.id == e.league.id)
  //                       Container(
  //                         width: 70,
  //                       )
  //                   ],
  //                 ),
  //               ),
  //               // Container(
  //               //   color: Constant.color2,
  //               //   padding: EdgeInsets.all(2),
  //               //   child: AutoSizeText(
  //               //     "Bet",
  //               //     style: TextStyle(fontSize: 10, color: Colors.black),
  //               //     minFontSize: 6,
  //               //     maxLines: 1,
  //               //   ),
  //               // )
  //               // if (betable.contains(e.league.id))
  //               //   CornerBanner(
  //               //     bannerPosition: CornerBannerPosition.bottomRight,
  //               //     bannerColor: Constant.color2.withOpacity(0.5),
  //               //     child: AutoSizeText(
  //               //       "Bet",
  //               //       style: TextStyle(fontSize: 10, color: Colors.black),
  //               //       minFontSize: 6,
  //               //       maxLines: 1,
  //               //     ),
  //               //   ),
  //             ]),
  //       )
  //       .toList());

  //   // if (Constant.customerRewardDetail != null && Constant.customerRewardDetail!.leagues.length >0) {
  //   //   print('got pay load bo?');
  //   //   if (leagueList.firstWhereOrNull(
  //   //           (e) => e.league.id.toString() == Constant.payload) !=
  //   //       null) {
  //   //     print('is not null pay load');
  //   //     _tabController.animateTo((leagueList
  //   //             .indexWhere((e) => e.league.id.toString() == Constant.payload) +
  //   //         1));
  //   //     Constant.payload = '';
  //   //   } else {
  //   //     print('is null');

  //   //     _tabController.animateTo(0);
  //   //     Constant.payload = '';
  //   //   }
  //   // }
  //   // _tabController = TabController(
  //   //   vsync: this,
  //   //   length: 5,
  //   // );

  //   // _tabController.addListener(() {
  //   //   if (_tabController.indexIsChanging) {
  //   //     serviceLocator<AnalyticsService>().logScreens(
  //   //         name: '/footballMatchPage/' +
  //   //             leagueList[_tabController.index].league.name);
  //   //   }
  //   // });

  //   // _footballMatchBloc.add(CheckMatchTutorialRequest());
  //   // _videoDetailsBloc.add(GetRecentFeedRequest());

  //   // WidgetsBinding.instance?.addPostFrameCallback((_) {
  //   //   ShowCaseWidget.of(context).startShowCase([
  //   //     Constant.matchTabKey,
  //   //     // _key2,
  //   //     // Constant.matchBetKey,
  //   //     // Constant.favouriteIcon,
  //   //   ]);
  //   // });
  //   //   },
  //   // );
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    _footballMatchBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return Scaffold(
      appBar: AppBar(
        // title: Text(
        //   "Matches",
        // ),
        // leading: GestureDetector(
        //     onTap: () {
        //       setState(() {
        //         // WidgetsBinding.instance?.addPostFrameCallback((_) {
        //         //   _tabController.animateTo(0);
        //         //   // _tabController.animateTo(leagueList.indexWhere(
        //         //   //     (element) => element.league.id == betable[0]));
        //         //   // _tabController = (leagueList.indexWhere(
        //         //   //     (element) => element.league.id == betable[0]));
        //         //   ShowCaseWidget.of(context).startShowCase([
        //         //     Constant.matchTabKey,
        //         //     // _key2,
        //         //     // Constant.matchBetKey,
        //         //     // Constant.favouriteIcon,
        //         //   ]);
        //         // });
        //         // _tabController.animateTo(0);
        //         _tabController!.animateTo((leagueList
        //             .indexWhere((element) => element.league.id == betable[0])));
        //         Constant.showcaseBool = true;

        //         // _tabController.animateTo(leagueList.indexWhere(
        //         //     (element) => element.league.id == betable[0]));
        //         // _tabController = (leagueList.indexWhere(
        //         //     (element) => element.league.id == betable[0]));
        //         ShowCaseWidget.of(context).startShowCase([
        //           Constant.matchTabKey,
        //         ]);
        //       });
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.only(right: 15.0),
        //       child: Showcase(
        //           key: Constant.betMatchInfo,
        //           onTargetClick: () {
        //             setState(() {
        //               Constant.showcaseBool = false;
        //             });
        //           },
        //           onToolTipClick: () {
        //             setState(() {
        //               Constant.showcaseBool = false;
        //             });
        //           },
        //           disposeOnTap: true,
        //           description:
        //               "If forgotten how to bet match can tap on this to review again. That all for the tutorial",
        //           child: Icon(Icons.info)),
        //     )),
        centerTitle: true,
        actions: [
          // GestureDetector(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => BetRankPage()),
          //     );
          //   },
          //   child: Padding(
          //     padding: EdgeInsets.only(right: 15.0),
          //     child: AnimatedContainer(
          //         duration: Duration(seconds: 1),
          //         child: ShaderMask(
          //           shaderCallback: (Rect bounds) {
          //             return LinearGradient(
          //               colors: [Color(0xffdc9139), Color(0xfffff514)],
          //               begin: Alignment.bottomCenter,
          //               end: Alignment.topCenter,
          //             ).createShader(bounds);
          //           },
          //           child: Icon(
          //             Icons.emoji_events,
          //             color: Colors.white,
          //             size: 30,
          //           ),
          //         )
          //         //         Icon(
          //         //           FontAwesomeIcons.trophy,
          //         //           // color: Constant.color2,

          //         //           color:LinearGradient(
          //         //   colors: [Color(0xffdc9139), Color(0xffd7c100)],
          //         //   begin: Alignment.bottomCenter,
          //         //   end: Alignment.topCenter,
          //         // )

          //         //         ),
          //         ),
          //   ),
          // )

          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //   child: ElevatedButton(
          //       onPressed: () {},
          //       style: ElevatedButton.styleFrom(
          //           primary: Constant.color1,
          //           // shape: const CircleBorder(),
          //           side: BorderSide(color: Colors.white, width: 0.3)),
          //       child: Text("Add League")

          //       //  Text('Add league', style: TextStyle(color: Colors.black)),
          //       ),
          //   //     AnimatedContainer(
          //   //   duration: Duration(seconds: 1),
          //   //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //   //   width: 50,
          //   //   height: 50,
          //   //   decoration: BoxDecoration(
          //   //       color: Colors.orange,
          //   //       shape:
          //   //           changeAnimation ? BoxShape.rectangle : BoxShape.circle),
          //   //   child: changeAnimation
          //   //       ? Center(child: Text("Add League"))
          //   //       : Icon(Icons.add),
          //   // ),
          // )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: tabList),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 0),
              //   child: ElevatedButton(
              //     onPressed: () {},
              //     style: ElevatedButton.styleFrom(
              //       primary: Constant.color1,
              //       minimumSize: Size(40, 40),
              //       shape: const CircleBorder(),
              //       side: BorderSide(color: Colors.white, width: 0.5),
              //     ),
              //     child: Center(child: Icon(Icons.add)),
              //   ),
              // ),
              Container(
                  width: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Constant.color1.withOpacity(0.2),
                        Constant.color1
                      ],
                      stops: [0, 1],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  // child: Row(
                  //   children: [
                  //     Container(
                  //       width: 15,
                  //       color: Colors.transparent,
                  //     ),
                  //     Container(
                  //       child: Icon(Icons.add),
                  //     )
                  //   ],
                  // ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 25,
                      ),
                      Expanded(
                          child:

                              // ElevatedButton(
                              //   onPressed: () {},
                              //   style: ElevatedButton.styleFrom(
                              //     primary: Constant.color1,
                              //     minimumSize: Size(30, 30),
                              //     shape: const CircleBorder(),
                              //     side: BorderSide(color: Colors.white, width: 0.5),
                              //   ),
                              //   child: Center(
                              //       child: Icon(
                              //     Icons.add,
                              //     size: 20,
                              //   )),
                              // ),

                              GestureDetector(
                        onTap: () {
                          if (Constant.auth != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PersonalizePage(
                                        settingPage: true,
                                      )),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          }
                        },
                        child: Container(
                            height: 30,
                            width: 30,
                            child:
                                // FloatingActionButton(
                                //   backgroundColor: Constant.color2,
                                //   onPressed: () {},
                                //   child: Center(
                                //       child:
                                // ),
                                Container(
                              color: Constant.color1,
                              child: Icon(
                                Icons.add,
                                size: 30,
                                color: Colors.white,
                              ),
                            )),
                      )),
                    ],
                  ))
              // GestureDetector(
              //   onTap: () {
              //     showDialog(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return LeagueSelectionDialog(
              //           leagues: leagueList,
              //           selectedFunction: (int id) {
              //             _tabController!.index = leagueList.indexWhere((curr) {
              //               return curr.league.id == id;
              //             });
              //             Navigator.of(context).pop();
              //           },
              //         );
              //       },
              //     );
              //   },
              //   child:

              //       //  Showcase(
              //       //   key: Constant.dropdownButtonKey,
              //       //   description:
              //       //       "In statistic page, users can select up to 100 different league to see statistic. So users can click here to search and choose the desired league instead of scrolling it.",
              //       //   child:

              //       Container(
              //     height: 30,
              //     width: 40,
              //     padding: EdgeInsets.only(right: 5),
              //     decoration: BoxDecoration(
              //       gradient: LinearGradient(colors: [
              //         Constant.color1.withOpacity(0.2),
              //         Constant.color1
              //       ]),
              //     ),
              //     alignment: Alignment.centerRight,
              //     child: Icon(
              //       FontAwesomeIcons.search,
              //       color: Colors.white,
              //       size: 20,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => _footballMatchBloc,
            ),
            BlocProvider(
              create: (context) => _videoDetailsBloc,
            ),
          ],
          child: TabBarView(
            controller: _tabController,
            children: listWidget,
          )
          // MultiBlocListener(
          //   listeners: [
          //     // BlocListener<FootballMatchBloc, FootballMatchState>(
          //     //   listener: (context, state) {
          //     //     if (state is MatchTutorialChecked) {
          //     //       if (!state.bet) {
          //     //         _footballMatchBloc.add(PersistMatchTutorialRequest());
          //     //       }
          //     //     }

          //     //     if (state is MatchTutorialPersisted) {
          //     //       if (state.bet) {
          //     //         setState(() {
          //     //           Constant.showcaseBool = true;
          //     //         });
          //     //         // ShowCaseWidget.of(context).startShowCase([
          //     //         //   Constant.matchTabKey,
          //     //         //   // _key2,
          //     //         //   // Constant.matchBetKey,
          //     //         //   // Constant.favouriteIcon,
          //     //         // ]);
          //     //       }
          //     //     }
          //     //     // TODO: implement listener
          //     //   },
          //     // ),
          //     // BlocListener<VideoDetailsBloc, VideoDetailsState>(
          //     //   listener: (context, state) {
          //     //     if (state is RecentFeedLoaded) {
          //     //       setState(() {
          //     //         Constant.recentFeeds = state.videos;
          //     //       });
          //     //     }
          //     //   },
          //     // ),
          //   ],
          //   child: TabBarView(controller: _tabController, children: listWidget),
          // ),
          ),

      //  TabBarView(
      //   children: [
      //     FootballMatchTabBarView(
      //       leagueId: '39',
      //     ),
      //     FootballMatchTabBarView(
      //       leagueId: '140',
      //     ),
      //     FootballMatchTabBarView(
      //       leagueId: '78',
      //     ),
      //     FootballMatchTabBarView(
      //       leagueId: '61',
      //     ),
      //   ],
      // ),
    );
  }
}

// List<Widget> tabBarWidget(
//   List<LeagueDetails> leagues,
//   TabController controller,
//   List<int> betable,
// ) {
//   // return leagues
//   //     .map(
//   //       (e) => e.league.id == 39
//   //           ? Showcase.withWidget(
//   //               width: 0,
//   //               height: 30,
//   //               key: Constant.matchTabKey,
//   //               // child: Text(
//   //               //   "we have bet system for users to earn more coin, tap on the league tab to proceed.",
//   //               // ),
//   //               // overlayPadding: EdgeInsets.symmetric(horizontal: 10),
//   //               // description:
//   //               //     "we have bet system for users to earn more coin, tap on the league tab to proceed.",
//   //               onTargetClick: () {
//   //                 controller.animateTo((leagues.indexWhere(
//   //                         (element) => element.league.id == betable[0]) +
//   //                     1));
//   //               },
//   //               // onToolTipClick: () {
//   //               //   controller.animateTo((leagues.indexWhere(
//   //               //           (element) => element.league.id == betable[0]) +
//   //               //       1));
//   //               // },
//   //               disposeOnTap: true,
//   //               container: Center(
//   //                 child: GestureDetector(
//   //                   onTap: () {
//   //                     controller.animateTo(1);
//   //                     ShowCaseWidget.of(Constant.matchTabKey.currentContext!)
//   //                         .dismiss();
//   //                   },
//   //                   child: Container(
//   //                     width: 200,
//   //                     padding: EdgeInsets.all(10),
//   //                     margin: EdgeInsets.only(right: 20),
//   //                     decoration: BoxDecoration(
//   //                       borderRadius: BorderRadius.circular(10.0),
//   //                       color: Colors.white,
//   //                     ),
//   //                     // margin: EdgeInsets.only(left: 20),
//   //                     child: Column(children: [
//   //                       Text(
//   //                           'we have bet system for users to earn more coin, tap on the league tab to proceed.',
//   //                           textAlign: TextAlign.justify,
//   //                           style: TextStyle(
//   //                             color: Colors.black,
//   //                             fontWeight: FontWeight.w500,
//   //                           )),
//   //                       // ElevatedButton(
//   //                       //     style: ElevatedButton.styleFrom(
//   //                       //       primary: Constant.color1,
//   //                       //     ),
//   //                       //     onPressed: () {},
//   //                       //     child: Text("Next"))
//   //                     ]),
//   //                   ),
//   //                 ),
//   //               ),
//   //               child: Stack(
//   //                   fit: StackFit.passthrough,
//   //                   alignment: AlignmentDirectional.bottomEnd,
//   //                   children: [
//   //                     Tab(
//   //                         icon: Text(
//   //                       e.league.id == 1 ? 'FIFA World Cup(tm)' : e.league.name,
//   //                       style: TextStyle(fontWeight: FontWeight.bold),
//   //                     )),
//   //                     // Container(
//   //                     //   color: Constant.color2,
//   //                     //   padding: EdgeInsets.all(2),
//   //                     //   child: AutoSizeText(
//   //                     //     "Bet",
//   //                     //     style: TextStyle(fontSize: 10, color: Colors.black),
//   //                     //     minFontSize: 6,
//   //                     //     maxLines: 1,
//   //                     //   ),
//   //                     // )
//   //                     // if (betable.contains(e.league.id))
//   //                     //   CornerBanner(
//   //                     //     bannerPosition: CornerBannerPosition.bottomRight,
//   //                     //     bannerColor: Constant.color2.withOpacity(0.5),
//   //                     //     child: AutoSizeText(
//   //                     //       "Bet",
//   //                     //       style: TextStyle(fontSize: 10, color: Colors.black),
//   //                     //       minFontSize: 6,
//   //                     //       maxLines: 1,
//   //                     //     ),
//   //                     //   ),
//   //                   ]))
//   //           : Stack(
//   //               fit: StackFit.passthrough,
//   //               alignment: AlignmentDirectional.bottomEnd,
//   //               children: [
//   //                   Row(
//   //                     children: [
//   //                       Expanded(
//   //                         child: Tab(
//   //                           icon: Text(
//   //                             e.league.id == 1
//   //                                 ? 'FIFA World Cup(tm)'
//   //                                 : e.league.name,
//   //                             style: TextStyle(fontWeight: FontWeight.bold),
//   //                           ),
//   //                         ),
//   //                       ),
//   //                       if (leagues.last.league.id == e.league.id)
//   //                         Container(
//   //                           color: Colors.yellow,
//   //                           width: 100,
//   //                           height: 10,
//   //                         )
//   //                     ],
//   //                   ),
//   //                   // Container(
//   //                   //   color: Constant.color2,
//   //                   //   padding: EdgeInsets.all(2),
//   //                   //   child: AutoSizeText(
//   //                   //     "Bet",
//   //                   //     style: TextStyle(fontSize: 10, color: Colors.black),
//   //                   //     minFontSize: 6,
//   //                   //     maxLines: 1,
//   //                   //   ),
//   //                   // )
//   //                   // if (betable.contains(e.league.id))
//   //                   //   CornerBanner(
//   //                   //     bannerPosition: CornerBannerPosition.bottomRight,
//   //                   //     bannerColor: Constant.color2.withOpacity(0.5),
//   //                   //     child: AutoSizeText(
//   //                   //       "Bet",
//   //                   //       style: TextStyle(fontSize: 10, color: Colors.black),
//   //                   //       minFontSize: 6,
//   //                   //       maxLines: 1,
//   //                   //     ),
//   //                   //   ),
//   //                 ]),
//       // )
//       // .toList();
// }
