// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:soccer_sport/core/constant/constants.dart';
// import 'package:soccer_sport/core/widgets/error_widget.dart';
// import 'package:soccer_sport/core/widgets/loading_widget.dart';
// import 'package:soccer_sport/core/widgets/no_data_widget.dart';
// import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
// import 'package:soccer_sport/footballMatch/presentation/bloc/football_match_bloc.dart';
// import 'package:soccer_sport/footballMatch/presentation/widget/football_incoming_match_nodata.dart';
// import 'package:soccer_sport/footballMatch/presentation/widget/football_live_match_list_tile.dart';
// import 'package:soccer_sport/footballMatch/presentation/widget/football_match_date_seperator.dart';
// import 'package:soccer_sport/footballMatch/presentation/widget/football_match_league_seperator.dart';
// import 'package:soccer_sport/footballMatch/presentation/widget/football_match_list_tile.dart';
// import 'package:grouped_list/grouped_list.dart';
// import 'package:soccer_sport/league/domain/entities/league_details.dart';
// import '../../../core/constant/analytics_service.dart';
// import '../../../injection_container.dart';

// class FootballIncomingLiveMatch extends StatefulWidget {
//   FootballIncomingLiveMatch();

//   @override
//   _FootballIncomingLiveMatchState createState() =>
//       _FootballIncomingLiveMatchState();
// }

// class _FootballIncomingLiveMatchState extends State<FootballIncomingLiveMatch> {
//   final FootballMatchBloc _footballMatchBloc =
//       serviceLocator<FootballMatchBloc>();
//   List<FootballMatch> footballMatches = [];

//   @override
//   void initState() {
//     _footballMatchBloc.add(GetIncomingLiveMatchRequest());
//     serviceLocator<AnalyticsService>()
//         .logScreens(name: '/footballMatchPage/' + 'live' + '/today');
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _footballMatchBloc.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: BlocProvider<FootballMatchBloc>(
//         create: (_) => _footballMatchBloc,
//         child: BlocListener<FootballMatchBloc, FootballMatchState>(
//           listener: (context, state) {
//             if (state is IncomingLiveMatchLoaded) {
//               footballMatches = state.footballMatches!;
//             }
//           },
//           child: Container(
//             width: double.infinity,
//             child: Padding(
//               padding: EdgeInsets.zero,
//               child: BlocBuilder(
//                   bloc: _footballMatchBloc,
//                   builder: (context, state) {
//                     if (state is LoadIncomingLiveMatch) {
//                       return LoadingWidget();
//                     } else if (state is FootballMatchesError) {
//                       return ErrorsWidget();
//                     } else {
//                       if (footballMatches.length > 0) {
//                         return GroupedListView<FootballMatch, String>(
//                             addAutomaticKeepAlives: false,
//                             shrinkWrap: true,
//                             // order: GroupedListOrder.DESC,
//                             itemComparator: (item1, item2) =>
//                                 DateTime.parse(item1.fixture.date).compareTo(
//                                     DateTime.parse(item2.fixture.date)),
//                             elements: footballMatches,
//                             groupBy: (match) => match.league!.id == 1
//                                 ? 'FIFA World Cup(tm)'
//                                 : match.league!.name,
//                             groupSeparatorBuilder: (String league) =>
//                                 FootballMatchLeagueSeperator(
//                                   league: league,
//                                   matchs: footballMatches,
//                                 ),
//                             indexedItemBuilder:
//                                 (context, FootballMatch match, int index) {
//                               return FootballMatchLiveListTile(
//                                 footballMatch: match,
//                               );
//                             });
//                       } else {
//                         return NoDataWidget();
//                       }
//                     }
//                   }),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
