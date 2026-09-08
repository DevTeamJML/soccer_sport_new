import 'package:expand_widget/expand_widget.dart';
import 'package:expandable/expandable.dart';
// import 'package:expandable_group/expandable_group_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soccer_sport/favourite/presentation/bloc/favourite_bloc.dart';

import '../../../core/constant/constants.dart';
import '../../../footballMatch/domain/entities/football_match.dart';
import '../../../footballMatch/domain/entities/team.dart';
import '../../../footballMatch/presentation/widget/football_live_match_list_tile.dart';

class FavouriteTeamListtile extends StatefulWidget {
  final Team team;
  final List<FootballMatch> liveMatch;
  final FavouriteBloc favouriteBloc;
  // final String id;
  FavouriteTeamListtile({
    required this.team,
    required this.liveMatch,
    required this.favouriteBloc,
    // required this.id
  });

  @override
  State<FavouriteTeamListtile> createState() => _FavouriteTeamListtileState();
}

class _FavouriteTeamListtileState extends State<FavouriteTeamListtile> {
  List<FootballMatch> liveMatch = [];
  @override
  void initState() {
    setState(() {
      liveMatch = widget.liveMatch;
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    liveMatch = widget.liveMatch;

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(children: [
          // Container(
          //   height: MediaQuery.of(context).size.height * 0.05,
          //   width: double.infinity,
          //   color: Constant.color1,
          //   // decoration: BoxDecoration(
          //   //     color: Constant.color1,
          //   //     borderRadius: new BorderRadius.only(
          //   //       topLeft: const Radius.circular(20.0),
          //   //       topRight: const Radius.circular(20.0),
          //   //       bottomLeft: Radius.circular(20.0),
          //   //       bottomRight: Radius.circular(20.0),
          //   //     )),
          //   child: Center(child: Text(widget.team.name)),
          // )
          Container(
              height: MediaQuery.of(context).size.height * 0.07,
              width: double.infinity,
              // color: Constant.color1,

              decoration: BoxDecoration(
                  color: Constant.color1,
                  boxShadow: [
                    BoxShadow(
                      color: Constant.color1,
                      offset: Offset(
                        0.0,
                        0.0,
                      ),
                      blurRadius: 0.5,
                      spreadRadius: 0.5,
                    ), //
                  ],
                  borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20.0),
                      topRight: const Radius.circular(20.0))),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Image.network(
                            widget.team.logoUrl,
                            width: 36.0,
                          ),
                        ),
                        Text(widget.team.name),
                      ],
                    )),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: InkWell(
                          onTap: () {
                            widget.favouriteBloc.add(
                                RemoveFavouriteTeamRequestV2(
                                    teams: widget.team));
                          },
                          child: Icon(Icons.star, color: Colors.yellow)),
                    )
                  ],
                ),
              )),
          Container(
              width: double.infinity,
              child: liveMatch.length > 0
                  ? Container(
                      decoration: BoxDecoration(
                        // color: Colors.grey[600],
                        color: Constant.backgroundColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                          topLeft: Radius.zero,
                          topRight: Radius.zero,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(
                              0.0,
                              0.0,
                            ),
                            blurRadius: 0.5,
                            spreadRadius: 0.5,
                          ), //
                        ],
                      ),
                      child: Column(
                        children: liveMatch
                            .map(
                              (e) => Container(
                                  child: FootballMatchLiveListTile(
                                      footballMatch: e)),
                            )
                            .toList(),
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        // color: Colors.grey[600],
                        color: Constant.backgroundColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                          topLeft: Radius.zero,
                          topRight: Radius.zero,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(
                              0.0,
                              0.0,
                            ),
                            blurRadius: 0.5,
                            spreadRadius: 0.5,
                          ), //
                        ],
                      ),
                      height: MediaQuery.of(context).size.height * 0.04,
                      child:
                          Center(child: Text("Don't have relevant team match")),
                    )),

          // ExpandChild(
          //     arrowColor: Colors.white,
          //     indicatorBuilder: (context, onTap, expanded) => InkWell(
          //         onTap: onTap,
          //         child: Container(
          //           decoration: BoxDecoration(
          //               color: Colors.grey[600],
          //               borderRadius: BorderRadius.only(
          //                   bottomLeft: const Radius.circular(20.0),
          //                   bottomRight: const Radius.circular(20.0))),
          //           child: Center(
          //               child: Icon(
          //             expanded
          //                 ? FontAwesomeIcons.chevronUp
          //                 : FontAwesomeIcons.chevronDown,
          //             color: Colors.grey[400],
          //           )),
          //         )),
          //     child: Container(
          //       decoration: BoxDecoration(
          //         border: Border(
          //           left: BorderSide(width: 1.0, color: Colors.grey),
          //           right: BorderSide(width: 1.0, color: Colors.grey),
          //         ),
          //       ),
          //       // color: Constant.color1,
          //       width: double.infinity,
          //       child: Column(
          //         children: liveMatch.length > 0
          //             ? liveMatch
          //                 .map((e) => Padding(
          //                       padding: const EdgeInsets.all(8.0),
          //                       child:
          //                           FootballMatchLiveListTile(footballMatch: e),
          //                     ))
          //                 .toList()
          //             : [
          //                 Container(
          //                   height: MediaQuery.of(context).size.height * 0.04,
          //                   child: Center(
          //                       child: Text("Don't have relevant team match")),
          //                 )
          //               ],
          //       ),
          //     ))
        ]));
  }
}
