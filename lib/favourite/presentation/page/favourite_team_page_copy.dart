// import 'dart:collection';
// import 'dart:convert';

// import 'package:collection/collection.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:group_list_view/group_list_view.dart';
// import 'package:grouped_list/grouped_list.dart';
// import 'package:showcaseview/showcaseview.dart';
// import 'package:soccer_sport/core/constant/analytics_service.dart';
// import 'package:soccer_sport/core/widgets/no_data_widget.dart';
// import 'package:soccer_sport/favourite/presentation/bloc/favourite_bloc.dart';
// import 'package:soccer_sport/favourite/presentation/widget/favourite_team_dialog.dart';
// import 'package:soccer_sport/favourite/presentation/widget/favourite_team_group_header.dart';
// import 'package:soccer_sport/favourite/presentation/widget/no_favourite_team.dart';
// import 'package:soccer_sport/footballMatch/data/model/team_model.dart';
// import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';

// import '../../../core/constant/constants.dart';
// import '../../../core/widgets/loading_widget.dart';
// import '../../../footballMatch/data/model/football_match_model.dart';
// import '../../../footballMatch/domain/entities/team.dart';
// import '../../../footballMatch/presentation/widget/football_live_match_list_tile.dart';
// import '../../../footballMatch/presentation/widget/football_match_league_seperator.dart';
// import '../../../footballMatch/presentation/widget/football_match_no_live_data.dart';
// import '../../../footballMatch/presentation/widget/statistics_button.dart';
// import '../../../injection_container.dart';
// import '../../domain/entities/league_team.dart';
// import '../widget/favourite_team_listtile.dart';

// class FavouriteTeamPage extends StatefulWidget {
//   // FavouriteTeamPage({Key? key}) : super(key: key);

//   @override
//   State<FavouriteTeamPage> createState() => _FavouriteTeamPageState();
// }

// class _FavouriteTeamPageState extends State<FavouriteTeamPage> {
//   final _key1 = GlobalKey();
//   final _key2 = GlobalKey();

//   late DatabaseReference database;
//   late Map<String, List<Team>> teamList;
//   List<LeagueTeam> favouriteList = [];
//   Map<String, List<Team>> favouriteTeam = {};
//   final FavouriteBloc _favouriteBloc = serviceLocator<FavouriteBloc>();
//   List<FootballMatch> favouriteTeamLiveMatch = [];
//   List<FootballMatch> livesMatch = [];
//   Map<String, String> leagueMap = {
//     '1': 'FIFA World Cup(tm)',
//     '39': 'Premier League',
//     '61': 'Ligue 1',
//     '78': 'Bundesliga',
//     '140': 'La Liga',
//   };
//   @override
//   void initState() {
//     super.initState();
//     teamList = Constant.teamList;
//     _favouriteBloc.add(GetFavouriteTeamRequest());
//     database = FirebaseDatabase.instance.ref('62');
//     serviceLocator<AnalyticsService>().logScreens(name: '/favourite/teams');
//     // WidgetsBinding.instance?.addPostFrameCallback((_) {
//     //   if (Constant.showcaseBool)
//     //     ShowCaseWidget.of(context).startShowCase([
//     //       _key1,
//     //       _key2,
//     //       Constant.videIcon,
//     //     ]);
//     // });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _favouriteBloc.close();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // return StreamBuilder(
//     //     stream: database.onValue,
//     //     builder: (context, snapshot) {
//     //       if (snapshot.connectionState == ConnectionState.waiting) {
//     //         return LoadingWidget();
//     //       } else if (snapshot.hasData) {
//     //         DatabaseEvent data = snapshot.data as DatabaseEvent;
//     //         if (data.snapshot.value != null) {
//     //           var jsonvalue = Map<String, dynamic>.from(
//     //               data.snapshot.value as LinkedHashMap);
//     //           // print(jsonvalue);
//     //           if (jsonvalue.isNotEmpty) {
//     //             livesMatch = jsonvalue.entries
//     //                 .map((entry) => FootballMatchModel.fromJson(
//     //                     jsonDecode(jsonEncode(entry.value))))
//     //                 .toList();
//     //           }
//     //         }
//     //         if (livesMatch.length > 0) {
//     //           return Container(
//     //             width: double.infinity,
//     //             height: double.infinity,
//     //             child: Padding(
//     //               padding: EdgeInsets.zero,
//     //               child: Column(
//     //                 mainAxisAlignment: MainAxisAlignment.center,
//     //                 crossAxisAlignment: CrossAxisAlignment.center,
//     //                 children: [
//     //                   Expanded(
//     //                     child: GroupedListView<FootballMatch, String>(
//     //                         addAutomaticKeepAlives: false,
//     //                         shrinkWrap: true,
//     //                         order: GroupedListOrder.DESC,
//     //                         sort: true,
//     //                         itemComparator: (item1, item2) =>
//     //                             DateTime.parse(item1.fixture.date)
//     //                                 .toLocal()
//     //                                 .compareTo(
//     //                                     DateTime.parse(item2.fixture.date)
//     //                                         .toLocal()),
//     //                         elements: livesMatch,
//     //                         groupBy: (match) => match.league!.name,
//     //                         groupSeparatorBuilder: (String league) =>
//     //                             FootballMatchLeagueSeperator(
//     //                               league: league,
//     //                               matchs: livesMatch,
//     //                             ),
//     //                         indexedItemBuilder:
//     //                             (context, FootballMatch match, int index) {
//     //                           return FootballMatchLiveListTile(
//     //                             footballMatch: match,
//     //                           );
//     //                         }),
//     //                   )
//     //                 ],
//     //               ),
//     //             ),
//     //           );
//     //         } else {
//     //           return Column(
//     //               mainAxisAlignment: MainAxisAlignment.center,
//     //               children: [
//     //                 FootballMatchNoLiveData(),
//     //                 SizedBox(
//     //                   height: 10,
//     //                 ),
//     //                 StatisticsButton(),
//     //               ]);
//     //         }
//     //       } else {
//     //         return NoDataWidget();
//     //       }
//     //     });

//     return BlocProvider<FavouriteBloc>(
//       create: (context) => _favouriteBloc,
//       child: BlocListener<FavouriteBloc, FavouriteState>(
//           listener: (context, state) {
//             if (state is FavouriteTeamLoaded) {
//               print('got state at here ???');
//               setState(() {
//                 favouriteList = [];
//                 state.teams.forEach((key, value) {
//                   favouriteList.add(LeagueTeam(id: key, team: value));
//                 });
//                 favouriteTeam = state.teams;
//               });
//             }

//             if (state is FavouriteTeamRemoved) {
//               print('got or not ');
//               print(state.teams);
//               if (state.teams) {
//                 print('true or not');

//                 _favouriteBloc.add(GetFavouriteTeamRequest());
//               }
//             }
//           },
//           child: StreamBuilder(
//               stream: database.onValue,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return LoadingWidget();
//                 } else {
//                   DatabaseEvent data = snapshot.data as DatabaseEvent;
//                   if (data.snapshot.value != null) {
//                     var jsonvalue = Map<String, dynamic>.from(
//                         data.snapshot.value as LinkedHashMap);
//                     // print(jsonvalue);
//                     if (jsonvalue.isNotEmpty) {
//                       livesMatch = jsonvalue.entries
//                           .map((entry) => FootballMatchModel.fromJson(
//                               jsonDecode(jsonEncode(entry.value))))
//                           .toList();
//                     }
//                   }
//                 }

//                 return Stack(
//                   children: [
//                     // Showcase(
//                     //   key: _key2,
//                     //   description:
//                     //       "Those favourited team will add at here, and will show ongoing match",
//                     //   child:

//                     favouriteTeam.length > 0
//                         ? Container(
//                             width: double.infinity,
//                             height: MediaQuery.of(context).size.height,
//                             child: Padding(
//                               padding: EdgeInsets.zero,
//                               child: GroupedListView<LeagueTeam, String>(
//                                   addAutomaticKeepAlives: false,
//                                   shrinkWrap: true,
//                                   order: GroupedListOrder.DESC,
//                                   sort: true,
//                                   elements: favouriteList,
//                                   groupBy: (match) => leagueMap[match.id]!,
//                                   groupSeparatorBuilder: (String league) =>
//                                       FavouriteTeamGroupHeader(name: league),
//                                   indexedItemBuilder:
//                                       (context, LeagueTeam match, int index) {
//                                     List<FootballMatch> filterList = livesMatch
//                                         .where(
//                                           (element) =>
//                                               element.away.id == match.id ||
//                                               element.home.id == match.id,
//                                         )
//                                         .toList();
//                                     return Column(
//                                         // shrinkWrap: true,
//                                         children: match.team
//                                             .map((e) => FavouriteTeamListtile(
//                                                 team: e,
//                                                 liveMatch: filterList,
//                                                 favouriteBloc: _favouriteBloc,
//                                                 id: match.id))
//                                             .toList());
//                                     //  return FavouriteTeamListtile(
//                                     //                 team: match,
//                                     //                 liveMatch: livesMatch,
//                                     //                 favouriteBloc: _favouriteBloc,
//                                     //                 id: favouriteTeam.keys
//                                     //                     .toList()[index.section]);
//                                   }),
//                             ),
//                           )
//                         : NoFavouriteTeam(),
//                     // ),
//                     Positioned(
//                       right: 20,
//                       bottom: 20,
//                       child:

//                           //  Showcase(
//                           //   key: _key1,
//                           //   description:
//                           //       "Users also can favourite team within the selected league by click on this button",
//                           //   child:

//                           FloatingActionButton(
//                         backgroundColor: Constant.color1,
//                         child: Icon(
//                           Icons.add,
//                           color: Colors.white,
//                           size: 20,
//                         ),
//                         onPressed: () {
//                           print('got sohw ??? dialogf ');
//                           showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return FavouriteTeamDialog(
//                                   favouriteBloc: _favouriteBloc);
//                             },
//                           );
//                         },
//                       ),
//                       // ),
//                     ),
//                   ],
//                 );
//               })),
//     );
//   }
// }
