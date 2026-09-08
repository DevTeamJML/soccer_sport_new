import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/widgets/error_widget.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/core/widgets/no_data_widget.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/standings/domain/entities/league_standings.dart';
import 'package:soccer_sport/standings/domain/entities/score.dart';
import 'package:soccer_sport/standings/domain/entities/standing.dart';
import 'package:soccer_sport/standings/presentation/bloc/standing_bloc.dart';

import '../../../footballMatch/domain/entities/team.dart';
import '../../../injection_container.dart';

class LeagueTablesTab extends StatefulWidget {
  final LeagueStandings standings;
  final String? selection;
  final FootballMatch? match;
  final Team? team;
  // LeagueDetails league;
  LeagueTablesTab({
    required this.standings,
    this.selection,
    this.match,
    this.team,
  });

  @override
  State<LeagueTablesTab> createState() => _LeagueTablesTabState();
}

class _LeagueTablesTabState extends State<LeagueTablesTab>
    with AutomaticKeepAliveClientMixin<LeagueTablesTab> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: List.generate(widget.standings.standings.length + 1, (
        index,
      ) {
        if (index == 0) {
          return Expanded(
            child: Container(
              height: (MediaQuery.of(context).size.height * 0.04),
              color: Constant.color2,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        child: Text("#", style: TextStyle(color: Colors.black)),
                      )),
                  Expanded(
                    flex: 6,
                    child: Center(
                        child: Text(
                      'Team',
                      style: TextStyle(color: Colors.black),
                    )),
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                        child: Center(
                          child: Text(
                            'P',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          'W',
                          style: TextStyle(color: Colors.black),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          'D',
                          style: TextStyle(color: Colors.black),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          'L',
                          style: TextStyle(color: Colors.black),
                        ),
                      )),
                  Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          'F' + '/' + 'A',
                          style: TextStyle(color: Colors.black),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Text(
                        'GD',
                        style: TextStyle(color: Colors.black),
                      )),
                  Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          'Pts',
                          style: TextStyle(color: Colors.black),
                        ),
                      )),
                ],
              ),
            ),
          );
        } else {
          var list = widget.standings.standings;
          if (widget.selection == "home") {
            list.sort(((a, b) => countPTS(b.home).compareTo(countPTS(a.home))));
          }
          if (widget.selection == "away") {
            list.sort(((a, b) => countPTS(b.away).compareTo(countPTS(a.away))));
          }
          if (widget.selection == null) {
            list.sort(((a, b) => b.points.compareTo(a.points)));
          }

          Standing standing = list[index - 1];
          bool isEqualTeam = (widget.match != null &&
                  (widget.match!.home.id == standing.team.id ||
                      widget.match!.away.id == standing.team.id)) ||
              (widget.team != null && widget.team!.id == standing.team.id);
          Color textColors = Colors.white;
          return Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: widget.match != null || widget.team != null
                      ? (isEqualTeam ? Colors.grey[700] : Colors.transparent)
                      : Colors.transparent,
                  border: Border(
                      bottom: BorderSide(color: Colors.white, width: 0.3))),
              padding: EdgeInsets.only(left: 5),
              height: MediaQuery.of(context).size.height * 0.05,
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Text(
                        (index).toString(),
                        style: TextStyle(
                          color: textColors,
                          fontWeight:
                              widget.match != null || widget.team != null
                                  ? (isEqualTeam
                                      ? FontWeight.bold
                                      : FontWeight.normal)
                                  : FontWeight.normal,
                        ),
                      )),
                  Expanded(
                      flex: 6,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Image.network(
                              standing.team.logoUrl,
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                              flex: 5,
                              child: Text(
                                standing.team.name,
                                style: TextStyle(
                                  color: textColors,
                                  fontSize: 13,
                                  fontWeight: widget.match != null ||
                                          widget.team != null
                                      ? (isEqualTeam
                                          ? FontWeight.bold
                                          : FontWeight.normal)
                                      : FontWeight.normal,
                                ),
                              )),
                        ],
                      )),
                  Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          widget.selection == null
                              ? standing.all.played.toString()
                              : (widget.selection == "home"
                                  ? standing.home.played.toString()
                                  : standing.away.played.toString()),
                          style: TextStyle(
                            color: textColors,
                            fontSize: 11,
                            fontWeight:
                                widget.match != null || widget.team != null
                                    ? (isEqualTeam
                                        ? FontWeight.bold
                                        : FontWeight.normal)
                                    : FontWeight.normal,
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          widget.selection == null
                              ? standing.all.win.toString()
                              : (widget.selection == "home"
                                  ? standing.home.win.toString()
                                  : standing.away.win.toString()),
                          style: TextStyle(
                            color: textColors,
                            fontSize: 11,
                            fontWeight:
                                widget.match != null || widget.team != null
                                    ? (isEqualTeam
                                        ? FontWeight.bold
                                        : FontWeight.normal)
                                    : FontWeight.normal,
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          widget.selection == null
                              ? standing.all.draw.toString()
                              : (widget.selection == "home"
                                  ? standing.home.draw.toString()
                                  : standing.away.draw.toString()),
                          style: TextStyle(
                            color: textColors,
                            fontSize: 11,
                            fontWeight:
                                widget.match != null || widget.team != null
                                    ? (isEqualTeam
                                        ? FontWeight.bold
                                        : FontWeight.normal)
                                    : FontWeight.normal,
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          widget.selection == null
                              ? standing.all.lose.toString()
                              : (widget.selection == "home"
                                  ? standing.home.lose.toString()
                                  : standing.away.lose.toString()),
                          style: TextStyle(
                            color: textColors,
                            fontSize: 11,
                            fontWeight:
                                widget.match != null || widget.team != null
                                    ? (isEqualTeam
                                        ? FontWeight.bold
                                        : FontWeight.normal)
                                    : FontWeight.normal,
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          widget.selection == null
                              ? (standing.all.goals!.goalsFor.toString() +
                                  '/' +
                                  standing.all.goals!.against.toString())
                              : (widget.selection == "home"
                                  ? (standing.home.goals!.goalsFor.toString() +
                                      '/' +
                                      standing.home.goals!.against.toString())
                                  : (standing.away.goals!.goalsFor.toString() +
                                      '/' +
                                      standing.away.goals!.against.toString())),
                          style: TextStyle(
                            color: textColors,
                            fontSize: 11,
                            fontWeight:
                                widget.match != null || widget.team != null
                                    ? (isEqualTeam
                                        ? FontWeight.bold
                                        : FontWeight.normal)
                                    : FontWeight.normal,
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Center(
                        child: Center(
                          child: Text(
                            widget.selection == null
                                ? (standing.all.goals!.goalsFor! -
                                        standing.all.goals!.against!)
                                    .toString()
                                : (widget.selection == "home"
                                    ? ((standing.home.goals!.goalsFor != null
                                                ? standing.home.goals!.goalsFor!
                                                : 0) -
                                            standing.home.goals!.against!)
                                        .toString()
                                    : (standing.away.goals!.goalsFor! -
                                            standing.away.goals!.against!)
                                        .toString()),
                            style: TextStyle(
                              color: textColors,
                              fontSize: 11,
                              fontWeight:
                                  widget.match != null || widget.team != null
                                      ? (isEqualTeam
                                          ? FontWeight.bold
                                          : FontWeight.normal)
                                      : FontWeight.normal,
                            ),
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Container(
                        child: Center(
                          child: Text(
                            widget.selection == null
                                ? standing.points.toString()
                                : (widget.selection == "home"
                                    ? countPTS(standing.home).toString()
                                    : countPTS(standing.away).toString()),
                            style: TextStyle(
                              color: textColors,
                              fontSize: 11,
                              fontWeight:
                                  widget.match != null || widget.team != null
                                      ? (isEqualTeam
                                          ? FontWeight.bold
                                          : FontWeight.normal)
                                      : FontWeight.normal,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          );
        }
      }).toList(),
    );
    // return ListView.builder(
    //     physics: NeverScrollableScrollPhysics(),
    //     // addAutomaticKeepAlives: false,
    //     primary: false,
    //     shrinkWrap: true,
    //     itemCount: widget.standings.standings.length + 1,
    //     itemBuilder: (context, index) {
    //       // League
    //       if (index == 0) {
    //         return Container(
    //           height: (MediaQuery.of(context).size.height * 0.04),
    //           color: Constant.color2,
    //           padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
    //           width: double.infinity,
    //           child: Row(
    //             children: [
    //               Expanded(
    //                   flex: 1,
    //                   child: Container(
    //                     child: Text("#", style: TextStyle(color: Colors.black)),
    //                   )),
    //               Expanded(
    //                 flex: 6,
    //                 child: Center(
    //                     child: Text(
    //                   'Team',
    //                   style: TextStyle(color: Colors.black),
    //                 )),
    //               ),
    //               Expanded(
    //                   flex: 1,
    //                   child: Container(
    //                     child: Center(
    //                       child: Text(
    //                         'P',
    //                         style: TextStyle(color: Colors.black),
    //                       ),
    //                     ),
    //                   )),
    //               Expanded(
    //                   flex: 1,
    //                   child: Center(
    //                     child: Text(
    //                       'W',
    //                       style: TextStyle(color: Colors.black),
    //                     ),
    //                   )),
    //               Expanded(
    //                   flex: 1,
    //                   child: Center(
    //                     child: Text(
    //                       'D',
    //                       style: TextStyle(color: Colors.black),
    //                     ),
    //                   )),
    //               Expanded(
    //                   flex: 1,
    //                   child: Center(
    //                     child: Text(
    //                       'L',
    //                       style: TextStyle(color: Colors.black),
    //                     ),
    //                   )),
    //               Expanded(
    //                   flex: 2,
    //                   child: Center(
    //                     child: Text(
    //                       'F' + '/' + 'A',
    //                       style: TextStyle(color: Colors.black),
    //                     ),
    //                   )),
    //               Expanded(
    //                   flex: 1,
    //                   child: Text(
    //                     'GD',
    //                     style: TextStyle(color: Colors.black),
    //                   )),
    //               Expanded(
    //                   flex: 1,
    //                   child: Center(
    //                     child: Text(
    //                       'Pts',
    //                       style: TextStyle(color: Colors.black),
    //                     ),
    //                   )),
    //             ],
    //           ),
    //         );
    //       } else {
    //         var list = widget.standings.standings;
    //         if (widget.selection == "home") {
    //           list.sort(
    //               ((a, b) => countPTS(b.home).compareTo(countPTS(a.home))));
    //         }
    //         if (widget.selection == "away") {
    //           list.sort(
    //               ((a, b) => countPTS(b.away).compareTo(countPTS(a.away))));
    //         }
    //         if (widget.selection == null) {
    //           list.sort(((a, b) => b.points.compareTo(a.points)));
    //         }
    //         Standing standing = list[index - 1];
    //         Color textColors = Colors.white;
    //         return Container(
    //           decoration: BoxDecoration(
    //               color: widget.match != null
    //                   ? (widget.match!.home.id == standing.team.id ||
    //                           widget.match!.away.id == standing.team.id
    //                       ? Colors.grey[700]
    //                       : Colors.transparent)
    //                   : Colors.transparent,
    //               border: Border(
    //                   bottom: BorderSide(color: Colors.white, width: 0.3))),
    //           padding: EdgeInsets.only(left: 5),
    //           height: MediaQuery.of(context).size.height * 0.05,
    //           width: double.infinity,
    //           child: Row(
    //             children: [
    //               Expanded(
    //                   flex: 1,
    //                   child: Text(
    //                     (index).toString(),
    //                     style: TextStyle(
    //                       color: textColors,
    //                       fontWeight: widget.match != null
    //                           ? (widget.match!.home.id == standing.team.id ||
    //                                   widget.match!.away.id == standing.team.id
    //                               ? FontWeight.bold
    //                               : FontWeight.normal)
    //                           : FontWeight.normal,
    //                     ),
    //                   )),
    //               Expanded(
    //                   flex: 6,
    //                   child: Row(
    //                     children: [
    //                       Expanded(
    //                         flex: 1,
    //                         child: Image.network(
    //                           standing.team.logoUrl,
    //                           height: MediaQuery.of(context).size.height * 0.05,
    //                         ),
    //                       ),
    //                       SizedBox(
    //                         width: 5,
    //                       ),
    //                       Expanded(
    //                           flex: 5,
    //                           child: Text(
    //                             standing.team.name,
    //                             style: TextStyle(
    //                               color: textColors,
    //                               fontSize: 13,
    //                               fontWeight: widget.match != null
    //                                   ? (widget.match!.home.id ==
    //                                               standing.team.id ||
    //                                           widget.match!.away.id ==
    //                                               standing.team.id
    //                                       ? FontWeight.bold
    //                                       : FontWeight.normal)
    //                                   : FontWeight.normal,
    //                             ),
    //                           )),
    //                     ],
    //                   )),
    //               Expanded(
    //                   flex: 1,
    //                   child: Center(
    //                     child: Text(
    //                       widget.selection == null
    //                           ? standing.all.played.toString()
    //                           : (widget.selection == "home"
    //                               ? standing.home.played.toString()
    //                               : standing.away.played.toString()),
    //                       style: TextStyle(
    //                         color: textColors,
    //                         fontSize: 11,
    //                         fontWeight: widget.match != null
    //                             ? (widget.match!.home.id == standing.team.id ||
    //                                     widget.match!.away.id ==
    //                                         standing.team.id
    //                                 ? FontWeight.bold
    //                                 : FontWeight.normal)
    //                             : FontWeight.normal,
    //                       ),
    //                     ),
    //                   )),
    //               Expanded(
    //                   flex: 1,
    //                   child: Center(
    //                     child: Text(
    //                       widget.selection == null
    //                           ? standing.all.win.toString()
    //                           : (widget.selection == "home"
    //                               ? standing.home.win.toString()
    //                               : standing.away.win.toString()),
    //                       style: TextStyle(
    //                         color: textColors,
    //                         fontSize: 11,
    //                         fontWeight: widget.match != null
    //                             ? (widget.match!.home.id == standing.team.id ||
    //                                     widget.match!.away.id ==
    //                                         standing.team.id
    //                                 ? FontWeight.bold
    //                                 : FontWeight.normal)
    //                             : FontWeight.normal,
    //                       ),
    //                     ),
    //                   )),
    //               Expanded(
    //                   flex: 1,
    //                   child: Center(
    //                     child: Text(
    //                       widget.selection == null
    //                           ? standing.all.draw.toString()
    //                           : (widget.selection == "home"
    //                               ? standing.home.draw.toString()
    //                               : standing.away.draw.toString()),
    //                       style: TextStyle(
    //                         color: textColors,
    //                         fontSize: 11,
    //                         fontWeight: widget.match != null
    //                             ? (widget.match!.home.id == standing.team.id ||
    //                                     widget.match!.away.id ==
    //                                         standing.team.id
    //                                 ? FontWeight.bold
    //                                 : FontWeight.normal)
    //                             : FontWeight.normal,
    //                       ),
    //                     ),
    //                   )),
    //               Expanded(
    //                   flex: 1,
    //                   child: Center(
    //                     child: Text(
    //                       widget.selection == null
    //                           ? standing.all.lose.toString()
    //                           : (widget.selection == "home"
    //                               ? standing.home.lose.toString()
    //                               : standing.away.lose.toString()),
    //                       style: TextStyle(
    //                         color: textColors,
    //                         fontSize: 11,
    //                         fontWeight: widget.match != null
    //                             ? (widget.match!.home.id == standing.team.id ||
    //                                     widget.match!.away.id ==
    //                                         standing.team.id
    //                                 ? FontWeight.bold
    //                                 : FontWeight.normal)
    //                             : FontWeight.normal,
    //                       ),
    //                     ),
    //                   )),
    //               Expanded(
    //                   flex: 2,
    //                   child: Center(
    //                     child: Text(
    //                       widget.selection == null
    //                           ? (standing.all.goals!.goalsFor.toString() +
    //                               '/' +
    //                               standing.all.goals!.against.toString())
    //                           : (widget.selection == "home"
    //                               ? (standing.home.goals!.goalsFor.toString() +
    //                                   '/' +
    //                                   standing.home.goals!.against.toString())
    //                               : (standing.away.goals!.goalsFor.toString() +
    //                                   '/' +
    //                                   standing.away.goals!.against.toString())),
    //                       style: TextStyle(
    //                         color: textColors,
    //                         fontSize: 11,
    //                         fontWeight: widget.match != null
    //                             ? (widget.match!.home.id == standing.team.id ||
    //                                     widget.match!.away.id ==
    //                                         standing.team.id
    //                                 ? FontWeight.bold
    //                                 : FontWeight.normal)
    //                             : FontWeight.normal,
    //                       ),
    //                     ),
    //                   )),
    //               Expanded(
    //                   flex: 1,
    //                   child: Center(
    //                     child: Center(
    //                       child: Text(
    //                         widget.selection == null
    //                             ? (standing.all.goals!.goalsFor! -
    //                                     standing.all.goals!.against!)
    //                                 .toString()
    //                             : (widget.selection == "home"
    //                                 ? (standing.home.goals!.goalsFor! -
    //                                         standing.home.goals!.against!)
    //                                     .toString()
    //                                 : (standing.away.goals!.goalsFor! -
    //                                         standing.away.goals!.against!)
    //                                     .toString()),
    //                         style: TextStyle(
    //                           color: textColors,
    //                           fontSize: 11,
    //                           fontWeight: widget.match != null
    //                               ? (widget.match!.home.id ==
    //                                           standing.team.id ||
    //                                       widget.match!.away.id ==
    //                                           standing.team.id
    //                                   ? FontWeight.bold
    //                                   : FontWeight.normal)
    //                               : FontWeight.normal,
    //                         ),
    //                       ),
    //                     ),
    //                   )),
    //               Expanded(
    //                   flex: 1,
    //                   child: Container(
    //                     child: Center(
    //                       child: Text(
    //                         widget.selection == null
    //                             ? standing.points.toString()
    //                             : (widget.selection == "home"
    //                                 ? countPTS(standing.home).toString()
    //                                 : countPTS(standing.away).toString()),
    //                         style: TextStyle(
    //                           color: textColors,
    //                           fontSize: 11,
    //                           fontWeight: widget.match != null
    //                               ? (widget.match!.home.id ==
    //                                           standing.team.id ||
    //                                       widget.match!.away.id ==
    //                                           standing.team.id
    //                                   ? FontWeight.bold
    //                                   : FontWeight.normal)
    //                               : FontWeight.normal,
    //                         ),
    //                       ),
    //                     ),
    //                   )),
    //             ],
    //           ),
    //         );
    //       }
    //     });
  }

  int countPTS(Score score) {
    return (score.win != null ? score.win! * 3 : 0) +
        (score.draw != null ? score.draw! * 1 : 0);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  // @override
  // // TODO: implement wantKeepAlive
  // bool get wantKeepAlive => true;
}
