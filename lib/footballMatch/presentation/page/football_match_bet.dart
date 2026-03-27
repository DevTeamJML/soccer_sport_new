// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:soccer_sport/core/constant/constants.dart';
// import 'package:soccer_sport/core/widgets/loading_widget.dart';
// import 'package:soccer_sport/footballMatch/domain/entities/bet_entities/bet.dart';
// import 'package:soccer_sport/footballMatch/presentation/bloc/football_match_bloc.dart';
// import 'package:soccer_sport/footballMatch/presentation/widget/bet_list.dart';
// import 'package:soccer_sport/injection_container.dart';

// class FootballMatchBet extends StatefulWidget {
//   @override
//   State<FootballMatchBet> createState() => _FootballMatchBetState();
// }

// class _FootballMatchBetState extends State<FootballMatchBet> {
//   final FootballMatchBloc _footballMatchBloc =
//       serviceLocator<FootballMatchBloc>();

//   List<Bet> betList = [];
//   List<Bet> betLogs = [];

//   @override
//   void initState() {
//     super.initState();
//     if (Constant.auth != null)
//       _footballMatchBloc
//           .add(GetBetLogRequest(id: Constant.auth!.id.toString()));
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (Constant.auth != null) {
//       return DefaultTabController(
//         length: 2,
//         child: BlocProvider(
//           create: (context) => _footballMatchBloc,
//           child: BlocListener<FootballMatchBloc, FootballMatchState>(
//             listener: (context, state) {
//               // TODO: implement listener
//             },
//             child: BlocBuilder<FootballMatchBloc, FootballMatchState>(
//               builder: (context, state) {
//                 if (state is BetLogGet) {
//                   if (betList.length > 0) {
//                     return Container(
//                       width: double.infinity,
//                       height: double.infinity,
//                       child: Padding(
//                         padding: EdgeInsets.zero,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Container(
//                               color: Constant.color2,
//                               height: 40,
//                               child: TabBar(
//                                   indicator: UnderlineTabIndicator(
//                                     borderSide: BorderSide(
//                                         width: 3, color: Colors.white),
//                                   ),
//                                   tabs: [
//                                     Tab(
//                                         icon: Text('Match',
//                                             style: TextStyle(
//                                                 color: Colors.black))),
//                                     Tab(
//                                         icon: Text('Incoming',
//                                             style: TextStyle(
//                                                 color: Colors.black))),
//                                     Tab(
//                                         icon: Text('Bet Log',
//                                             style: TextStyle(
//                                                 color: Colors.black))),
//                                   ]),
//                             ),
//                             Expanded(
//                               child: TabBarView(
//                                 children: [
//                                   BetList(
//                                     betList: betList,
//                                   ),
//                                   // BetLog(
//                                   //   league: this.widget.league,
//                                   // ),
//                                   Container()
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   } else {
//                     return Center(
//                         child: Text('There is no order has been made so far',
//                             style: TextStyle(color: Colors.white)));
//                   }
//                 } else if (state is FootballMatchesError) {
//                   return Center(
//                       child: Text('Server exception',
//                           style: TextStyle(color: Colors.white)));
//                 } else {
//                   return LoadingWidget();
//                 }
//               },
//             ),
//           ),
//         ),
//       );
//     } else {
//       return Center(
//           child: Container(
//         child: Text('Log in to view fixtures list that you have bet before',
//             style: TextStyle(color: Colors.white)),
//       ));
//     }
//   }
// }
