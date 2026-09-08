// import 'package:collection/collection.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:soccer_sport/footballMatch/domain/entities/team_info/player_stats.dart';
// import 'package:transparent_image/transparent_image.dart';

// import '../../../../core/constant/constants.dart';
// import '../../../../league/domain/entities/league.dart';
// import '../../../../standings/domain/entities/league_standings.dart';
// import '../../../domain/entities/football_match.dart';
// import '../../../domain/entities/team_info/player_stats_info.dart';

// class LeagueDropdownButton extends StatelessWidget {
//   final String selectedValue;
//   final List<League> listOfLeague;
//   final List<dynamic> matchList;
//   final Function(dynamic) onChange;
//   const LeagueDropdownButton({
//     required this.selectedValue,
//     required this.listOfLeague,
//     required this.matchList,
//     required this.onChange,
//   });

//   @override
//   Widget build(BuildContext context) {
//     dynamic selectedMatch = matchList is List<FootballMatch>
//         ? (matchList as List<FootballMatch>)
//             .firstWhereOrNull((e) => e.league!.name == selectedValue)
//         : matchList is List<LeagueStandings>
//             ? (matchList as List<LeagueStandings>)
//                 .firstWhereOrNull((e) => e.name == selectedValue)
//             : matchList is List<PlayerStatsInfo>
//                 ? (matchList as List<PlayerStatsInfo>).firstWhereOrNull((e) =>
//                     e.playerStats.firstWhereOrNull(
//                         (element) => element.league.name == selectedValue) !=
//                     null)
//                 : null;
//     return Row(
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton2(
//               // hint:
//               customButton: Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10.0),
//                   border: Border.all(
//                     color: Colors.white,
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(
//                       FontAwesomeIcons.list,
//                       color: Colors.white,
//                     ),
//                     if (matchList is List<FootballMatch> &&
//                         selectedValue != "All League")
//                       Container(
//                         height: 30,
//                         width: 30,
//                         margin: EdgeInsets.only(right: 3),
//                         child: FadeInImage.memoryNetwork(
//                             placeholder: kTransparentImage,
//                             image: (matchList as List<FootballMatch>)
//                                 .firstWhere(
//                                     (e) => e.league!.name == selectedValue)
//                                 .league!
//                                 .logo!,
//                             imageErrorBuilder: (e, o, c) {
//                               return Container();
//                             }),
//                       ),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 10),
//                       child: Text(selectedValue,
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                     ),
//                     Icon(
//                       FontAwesomeIcons.caretDown,
//                       color: Colors.white,
//                     ),
//                   ],
//                 ),
//               ),
//               menuItemStyleData: MenuItemStyleData(
//                 // customHeights: [48, 48, 48],
//                 height: 48,
//                 padding: const EdgeInsets.only(left: 16, right: 16),
//               ),
//               // customItemsHeight: 4,
//               dropdownStyleData: DropdownStyleData(
//                 width: 300,
//                 maxHeight: 500,
//                 padding: const EdgeInsets.symmetric(vertical: 6),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(4),
//                   color: Colors.white,
//                 ),
//                 elevation: 8,
//                 offset: const Offset(0, 8),
//               ),
//               items: listOfLeague
//                   .map(
//                     (item) => DropdownMenuItem<String>(
//                       value: item,
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           if (selectedMatch != null)
//                             Padding(
//                               padding: EdgeInsets.symmetric(horizontal: 3),
//                               child: Container(
//                                 height: 20,
//                                 width: 20,
//                                 child: FadeInImage.memoryNetwork(
//                                     placeholder: kTransparentImage,
//                                     image: (selectedMatch is FootballMatch)
//                                         ? selectedMatch.league!.logo!
//                                         : (selectedMatch is LeagueStandings)
//                                             ? selectedMatch.logo!
//                                             : (selectedMatch is PlayerStatsInfo)
//                                                 ? selectedMatch.playerStats
//                                                     .firstWhere((element) =>
//                                                         element.league.name ==
//                                                         selectedValue)
//                                                     .league
//                                                     .logo!
//                                                 : "",
//                                     imageErrorBuilder: (e, o, c) {
//                                       return Container();
//                                     }),
//                               ),
//                             ),
//                           Text(
//                             item,
//                             style: TextStyle(
//                               color: selectedValue == item
//                                   ? Constant.color1
//                                   : Colors.black,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                   .toList(),
//               onChanged: (value) {
//                 onChange(value);
//                 // setState(() {
//                 //   selectedValue = value as String;
//                 //   if (value == "All League") {
//                 //     filteredMatches = matchList;
//                 //   } else {
//                 //     filteredMatches = matchList
//                 //         .where(
//                 //             (e) => e.league!.name == value)
//                 //         .toList();
//                 //   }
//                 // });
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
