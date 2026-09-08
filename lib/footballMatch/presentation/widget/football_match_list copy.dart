// import 'dart:async';
// import 'dart:collection';
// import 'dart:convert';

// import 'package:advance_notification/advance_notification.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:collection/collection.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_picker/flutter_picker.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:outline_search_bar/outline_search_bar.dart';
// import 'package:showcaseview/showcaseview.dart';
// import 'package:soccer_sport/authentication/presentation/widget/login_loading_dialog.dart';
// import 'package:soccer_sport/core/constant/constants.dart';
// import 'package:soccer_sport/core/widgets/error_widget.dart';
// import 'package:soccer_sport/core/widgets/loading_widget.dart';
// import 'package:soccer_sport/core/widgets/no_data_widget.dart';
// import 'package:soccer_sport/customer/presentation/bloc/customer_bloc.dart';
// import 'package:soccer_sport/footballMatch/data/model/football_match_model.dart';
// import 'package:soccer_sport/footballMatch/domain/entities/bet_entities/bet.dart';
// import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
// import 'package:soccer_sport/footballMatch/presentation/bloc/football_match_bloc.dart';
// import 'package:soccer_sport/footballMatch/presentation/widget/dialog/loading_bet.dart';
// import 'package:soccer_sport/footballMatch/presentation/widget/dialog/predict_result.dart';
// import 'package:soccer_sport/footballMatch/presentation/widget/dialog/testing_dialog.dart';
// import 'package:soccer_sport/footballMatch/presentation/widget/football_match_date_seperator.dart';
// import 'package:soccer_sport/footballMatch/presentation/widget/football_match_list_tile.dart';
// import 'package:grouped_list/grouped_list.dart';
// import 'package:soccer_sport/footballMatch/presentation/widget/statistics_button.dart';
// import 'package:soccer_sport/league/domain/entities/league_details.dart';
// import '../../../core/constant/analytics_service.dart';
// import '../../../injection_container.dart';

// class FootballMatchListTest extends StatefulWidget {
//   final LeagueDetails league;
//   final List<FootballMatch> footballMatches;
//   final List<FootballMatch>? liveMatches;
//   FootballMatchListTest({
//     required this.league,
//     required this.footballMatches,
//     this.liveMatches,
//   });

//   @override
//   _FootballMatchListTestState createState() => _FootballMatchListTestState();
// }

// class _FootballMatchListTestState extends State<FootballMatchListTest>
//     with WidgetsBindingObserver {
//   final FootballMatchBloc _footballMatchBloc =
//       serviceLocator<FootballMatchBloc>();
//   final CustomerBloc _customerBloc = serviceLocator<CustomerBloc>();

//   // List<FootballMatch> footballMatches = [];

//   List<Bet> updatedBet = [];
//   final _key1 = GlobalKey();
//   final _key2 = GlobalKey();

//   List<String> dateList = ['All'];
//   String selectedDate = 'All';

//   DatabaseReference? testing;
//   final TextEditingController _controller = TextEditingController();
//   String searchValue = '';
//   int totalValue = 0;
//   @override
//   void initState() {
//     super.initState();

//     print('=== INIT STATE ===');
//     print(widget.league.league.name);
//     print(widget.league.seasons);
//     print(widget.league.seasons?.length);
//     WidgetsBinding.instance!.addObserver(this);
//     // FirebaseDatabase.instance.ref('62').get().then((value) {
//     //   FootballMatchModel test = FootballMatchModel.fromJson(
//     //       jsonDecode(jsonEncode(value.children.first.value)));
//     //   print(test.fixture.id);
//     // });

//     // Query query = FirebaseDatabase.instance
//     //     .ref('62')
//     //     .orderByChild('fixture/id')
//     //     .equalTo('720006');
//     // print(query.get());

//     serviceLocator<AnalyticsService>().logScreens(
//         name: '/footballMatchPage/' + widget.league.league.name + '/match');
//     super.initState();
//   }

//   Future<void> _onRefresh() async {
//     // monitor network fetch
//     if (widget.league.seasons == null || widget.league.seasons!.isEmpty) {
//       print('EMPTY SEASONS');
//       return;
//     }
//     _footballMatchBloc.add(GetFixturesByLeagueRequest(
//         leagueId: widget.league.league.id.toString(),
//         season: widget.league.seasons!.last.year.toString()));
//     return Future.delayed(Duration(milliseconds: 1000));
//     // if failed,use refreshFailed()
//     // _refreshController.refreshCompleted();
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance!.removeObserver(this);
//     _footballMatchBloc.close();
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       setState(() {
//         _footballMatchBloc.add(GetFixturesByLeagueRequest(
//             leagueId: widget.league.league.id.toString(),
//             season: widget.league.seasons!.last.year.toString()));
//         showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (BuildContext context) {
//             return LoginLoadingDialog();
//           },
//         );
//         Timer(
//           const Duration(seconds: 1),
//           () {
//             Navigator.of(context).pop();
//           },
//         );
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: widget.liveMatches != null
//           ? widget.liveMatches!.length
//           : widget.footballMatches.length,
//       itemBuilder: (context, index) {
//         if (widget.liveMatches != null) {
//           return FootballMatchListTile(
//             key: ValueKey(widget.liveMatches![index].fixture.id),
//             footballMatch: widget.liveMatches![index],
//             isIncoming: false,
//             live: true,
//             showcasebool: true,
//           );
//         }

//         final match = widget.footballMatches[index];

//         if (match.fixture.status.short == '2H' &&
//             match.fixture.status.elapsedTime == 90) {
//           match.fixture.status.short = 'FT';
//         }

//         return FootballMatchListTile(
//           key: ValueKey(match.fixture.id),
//           footballMatch: match,
//           isIncoming: false,
//           live: false,
//           showcasebool: true,
//         );
//       },
//     );
//     // return ListView.builder(
//     //     addAutomaticKeepAlives: false,
//     //     shrinkWrap: true,
//     //     // itemCount: widget.liveMatches != null
//     //     //     ? widget.liveMatches!.length
//     //     //     : widget.footballMatches.length,

//     //     // order: GroupedListOrder.DESC,
//     //     // itemComparator: (item1, item2) => DateTime.parse(item1.fixture.date)
//     //     //     .compareTo(DateTime.parse(item2.fixture.date)),
//     //     // elements: widget.footballMatches,
//     //     // groupBy: (match) => Constant.formattedDate(
//     //     //     (DateTime.parse(match.fixture.date).toLocal())),
//     //     // groupSeparatorBuilder: (String date) => FootballMatchDateSeperator(
//     //     //       date: date,
//     //     //     ),

//     //     itemBuilder: (context, index) {
//     //       if (widget.liveMatches != null) {
//     //         return FootballMatchListTile(
//     //           key: ValueKey(widget.liveMatches![index].fixture.id),
//     //           footballMatch: widget.liveMatches![index],
//     //           isIncoming: false,
//     //           live: true,
//     //           showcasebool: true,
//     //         );
//     //       }

//     //       final match = widget.footballMatches[index];

//     //       if (match.fixture.status.short == '2H' &&
//     //           match.fixture.status.elapsedTime == 90) {
//     //         match.fixture.status.short = 'FT';
//     //       }

//     //       return FootballMatchListTile(
//     //         key: ValueKey(match.fixture.id),
//     //         footballMatch: match,
//     //         isIncoming: false,
//     //         live: false,
//     //         showcasebool: true,
//     //       );
//     //     }

//     //     // itemBuilder: (context, int index) {
//     //     //   var match = widget.footballMatches[index];
//     //     //   // FootballMatch? liveMatch = widget.liveMatches != null
//     //     //   //     ? widget.liveMatches!
//     //     //   //         .firstWhereOrNull((v) => v.fixture.id == match.fixture.id)
//     //     //   //     : null;
//     //     //   if (widget.liveMatches != null) {
//     //     //     return GestureDetector(
//     //     //       onTap: () {},
//     //     //       child: FootballMatchListTile(
//     //     //         key: ValueKey(widget.liveMatches![index].fixture.id),
//     //     //         footballMatch: widget.liveMatches![index],
//     //     //         isIncoming: false,
//     //     //         live: true,
//     //     //         showcasebool: true,
//     //     //       ),
//     //     //     );
//     //     //   } else {
//     //     //     if (match.fixture.status.short == '2H' &&
//     //     //         match.fixture.status.elapsedTime == 90) {
//     //     //       match.fixture.status.short = 'FT';
//     //     //     }
//     //     //     return FootballMatchListTile(
//     //     //       key: ValueKey(match.fixture.id),
//     //     //       footballMatch: match,
//     //     //       isIncoming: false,
//     //     //       live: false,
//     //     //       showcasebool: true,
//     //     //     );
//     //     //   }
//     //     // }
//     //     );
//   }

//   showPicker(
//     BuildContext context,
//   ) {
//     Picker(
//         adapter: PickerDataAdapter<String>(
//             data: dateList
//                 .map((e) => PickerItem(text: Text(e), value: e))
//                 .toList()),
//         reversedOrder: false,
//         changeToFirst: true,
//         selecteds: [0],
//         textAlign: TextAlign.left,
//         columnPadding: const EdgeInsets.all(8.0),
//         onConfirm: (Picker picker, List value) {
//           setState(() {
//             selectedDate = picker.getSelectedValues()[0];
//           });
//         }).showModal(this.context);
//   }
// }
