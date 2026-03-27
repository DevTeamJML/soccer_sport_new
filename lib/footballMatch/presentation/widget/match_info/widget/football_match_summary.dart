import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/core/widgets/no_data_widget.dart';
import 'package:soccer_sport/footballMatch/domain/entities/event.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/presentation/bloc/football_match_bloc.dart';

class FootballMatchSummary extends StatefulWidget {
  final FootballMatch match;

  final FootballMatchBloc bloc;
  final List<Event> events;

  const FootballMatchSummary({
    required this.match,
    required this.bloc,
    required this.events,
  });

  @override
  State<FootballMatchSummary> createState() => _FootballMatchSummaryState();
}

class _FootballMatchSummaryState extends State<FootballMatchSummary> {
  late FootballMatchBloc _footballMatchBloc;
  List<Event> events = [];
  // int homeGoal = 0;
  // int awayGoal = 0;

  int? firstHalf;
  int? secondHalf;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _footballMatchBloc = widget.bloc;
    events = widget.events;
    if (events.length == 0) {
      _footballMatchBloc
          .add(GetMatchEventRequest(id: widget.match.fixture.id.toString()));
    } else {
      events = widget.events
          .where((element) =>
              (element.type != null && element.type!.toLowerCase() != "subst"))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<FootballMatch>>(
        stream: Constant.liveData.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<FootballMatch> liveMatches =
                snapshot.data != null ? snapshot.data! : [];
            FootballMatch? uMatch = liveMatches.firstWhereOrNull((e) {
              return e.fixture.id == widget.match.fixture.id;
            });

            if (uMatch != null) {
              events = uMatch != null
                  ? (uMatch.events != null
                      ? uMatch.events!
                          .where((element) => (element.type != null &&
                              element.type!.toLowerCase() != "subst"))
                          .toList()
                      : [])
                  : [];
            }
          }
          return BlocListener<FootballMatchBloc, FootballMatchState>(
              bloc: _footballMatchBloc,
              listener: (context, state) {
                if (state is MatchEventGet) {
                  setState(() {
                    events = state.stats
                        .where((element) => (element.type != null &&
                            element.type!.toLowerCase() != "subst"))
                        .toList();
                  });
                }
              },
              child: BlocBuilder<FootballMatchBloc, FootballMatchState>(
                bloc: _footballMatchBloc,
                builder: (context, state) {
                  if (state is GettingMatchEvent) {
                    return Container(
                        height: MediaQuery.of(context).size.height * 0.75,
                        width: double.infinity,
                        child: LoadingWidget());
                  } else if (state is FootballMatchesError) {
                    return Container(
                        height: MediaQuery.of(context).size.height * 0.75,
                        width: double.infinity,
                        child: ErrorWidget(state.message));
                  } else {
                    if (events.length > 0) {
                      var height = MediaQuery.of(context).size.height;
                      return Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).padding.bottom),
                        child: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            Container(
                              // height: ((height * 0.05) * (events.length)),
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                  border: Border.all(
                                      color: Colors.white, width: 0.5)),
                              child:

                                  // ListView.builder(
                                  //     physics: NeverScrollableScrollPhysics(),
                                  //     shrinkWrap: true,
                                  //     itemCount: events.length,
                                  //     itemBuilder: (context, index) {
                                  GroupedListView<Event, String>(
                                      physics: NeverScrollableScrollPhysics(),
                                      addAutomaticKeepAlives: false,
                                      shrinkWrap: true,
                                      itemComparator: (item1, item2) => item1
                                          .time.elapsed
                                          .compareTo(item2.time.elapsed),
                                      elements: events,
                                      groupBy: (event) =>
                                          event.time.elapsed > 45
                                              ? "2nd Half"
                                              : "1st Half",
                                      sort: true,
                                      groupSeparatorBuilder: (String name) {
                                        return seperator(
                                            events, name, widget.match);
                                      },
                                      indexedItemBuilder:
                                          (context, Event match, int index) {
                                        Event event = events[index];
                                        bool isHome = event.team!.id ==
                                            widget.match.home.id;
                                        List<Event> sublist =
                                            events.sublist(0, index + 1);
                                        int homeGoal = sublist
                                            .where((element) =>
                                                (element.team!.id ==
                                                    widget.match.home.id) &&
                                                (element.detail != null &&
                                                    (element.detail!.toLowerCase() ==
                                                            "normal goal" ||
                                                        element.detail!
                                                                .toLowerCase() ==
                                                            "own goal" ||
                                                        element.detail!
                                                                .toLowerCase() ==
                                                            "penalty")))
                                            .toList()
                                            .length;
                                        int awayGoal = sublist
                                            .where((element) =>
                                                (element.team!.id ==
                                                    widget.match.away.id) &&
                                                (element.detail != null &&
                                                    (element.detail!.toLowerCase() ==
                                                            "normal goal" ||
                                                        element.detail!
                                                                .toLowerCase() ==
                                                            "own goal" ||
                                                        element.detail!
                                                                .toLowerCase() ==
                                                            "penalty")))
                                            .toList()
                                            .length;

                                        // if (isHome && event.type.toLowerCase() == "goal") {
                                        //   if (event.detail.toLowerCase() == "normal goal" ||
                                        //       event.detail.toLowerCase() == "own goal" ||
                                        //       event.detail.toLowerCase() == "penalty") {
                                        //     homeGoal += 1;
                                        //   }
                                        // }
                                        // if (!isHome && event.type.toLowerCase() == "goal") {
                                        //   if (event.detail.toLowerCase() == "normal goal" ||
                                        //       event.detail.toLowerCase() == "own goal" ||
                                        //       event.detail.toLowerCase() == "penalty") {
                                        //     awayGoal += 1;
                                        //   }
                                        // }

                                        return Container(
                                          height: height * 0.06,
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                            color: Colors.white,
                                            width: 0.5,
                                          ))),
                                          width: double.infinity,
                                          child: Row(children: [
                                            Container(
                                              width: 40,
                                              child: Center(
                                                child: Text(
                                                  event.time.elapsed
                                                          .toString() +
                                                      (event.time.extra != null
                                                          ? "+" +
                                                              event.time.extra
                                                                  .toString()
                                                          : "") +
                                                      "'",
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(children: [
                                                Expanded(
                                                  child: isHome
                                                      ? Row(
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Text(
                                                                      (event.player != null &&
                                                                              event.player!.name !=
                                                                                  null
                                                                          ? event
                                                                              .player!
                                                                              .name!
                                                                          : event.detail != null
                                                                              ? event.detail!
                                                                              : ""),
                                                                      maxLines:
                                                                          event.player != null && event.player!.name != null
                                                                              ? 1
                                                                              : 2,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              11,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                    if (event.assist !=
                                                                            null &&
                                                                        event.assist!.name !=
                                                                            null)
                                                                      Text(
                                                                        event
                                                                            .assist!
                                                                            .name!,
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              11,
                                                                        ),
                                                                      ),
                                                                  ]),
                                                            ),
                                                            if (event.type !=
                                                                    null &&
                                                                event.type!
                                                                        .toLowerCase() ==
                                                                    "card" &&
                                                                event.detail !=
                                                                    null)
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            8),
                                                                decoration:
                                                                    BoxDecoration(
                                                                        color: event.detail!.toLowerCase() ==
                                                                                "yellow card"
                                                                            ? Colors
                                                                                .yellow
                                                                            : Colors
                                                                                .red,
                                                                        borderRadius:
                                                                            BorderRadius.all(
                                                                          Radius.circular(
                                                                              2.0),
                                                                        )),
                                                                height: 15,
                                                                width: 11,
                                                              ),
                                                            if (event.type !=
                                                                    null &&
                                                                (event.type!.toLowerCase() ==
                                                                        "goal" ||
                                                                    event.type!
                                                                            .toLowerCase() ==
                                                                        "var") &&
                                                                event.detail !=
                                                                    null)
                                                              Stack(
                                                                children: [
                                                                  Container(
                                                                    padding: EdgeInsets
                                                                        .symmetric(
                                                                            horizontal:
                                                                                8),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        if (event.detail!.toLowerCase() ==
                                                                            "own goal")
                                                                          Text(
                                                                            "OG",
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                                                                          ),
                                                                        if (event.detail !=
                                                                                null &&
                                                                            (event.detail!.toLowerCase() == "goal cancelled" &&
                                                                                event.type!.toLowerCase() == "var"))
                                                                          Text(
                                                                            "VAR",
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                                                                          ),
                                                                        if (event.detail !=
                                                                                null &&
                                                                            (event.detail!.toLowerCase() == "penalty" ||
                                                                                event.detail!.toLowerCase() == "missed penalty"))
                                                                          Text(
                                                                            "PEN",
                                                                            style:
                                                                                TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                                                                          ),
                                                                        Container(
                                                                          height:
                                                                              15,
                                                                          width:
                                                                              15,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          child: Icon(
                                                                              FontAwesomeIcons.futbol,
                                                                              color: event.detail!.toLowerCase() == "own goal" ? Colors.red : Colors.black,
                                                                              size: 15),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  if (event.detail !=
                                                                          null &&
                                                                      (event.detail!.toLowerCase() == "penalty" ||
                                                                          event.detail!.toLowerCase() ==
                                                                              "missed penalty" ||
                                                                          event.detail!.toLowerCase() ==
                                                                              "goal cancelled" ||
                                                                          event.detail!.toLowerCase() ==
                                                                              "penalty confirmed"))
                                                                    Positioned(
                                                                      right: 2,
                                                                      bottom: 6,
                                                                      child: (event.detail != null &&
                                                                              (event.detail!.toLowerCase() == "penalty" || event.detail!.toLowerCase() == "penalty confirmed"))
                                                                          ? Container(
                                                                              height: 10,
                                                                              width: 10,
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.black,
                                                                                borderRadius: BorderRadius.circular(5),
                                                                              ),
                                                                              child: Icon(CupertinoIcons.check_mark_circled_solid, color: Colors.green, size: 10),
                                                                            )
                                                                          : Container(
                                                                              height: 10,
                                                                              width: 10,
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.black,
                                                                                borderRadius: BorderRadius.circular(5),
                                                                              ),
                                                                              child: Icon(CupertinoIcons.clear_circled_solid, color: Colors.red, size: 10),
                                                                            ),
                                                                    )
                                                                ],
                                                              ),
                                                          ],
                                                        )
                                                      : Container(),
                                                ),
                                                (event.type != null &&
                                                        event.type!
                                                                .toLowerCase() ==
                                                            "goal")
                                                    ? Container(
                                                        width: 40,
                                                        child: Center(
                                                          child: Text(
                                                            homeGoal.toString() +
                                                                " - " +
                                                                awayGoal
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(width: 40),
                                                Expanded(
                                                  child: Row(children: [
                                                    Expanded(
                                                      child: !isHome
                                                          ? Row(
                                                              children: [
                                                                if (event.type !=
                                                                        null &&
                                                                    event.type!
                                                                            .toLowerCase() ==
                                                                        "card" &&
                                                                    event.detail !=
                                                                        null)
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .symmetric(
                                                                            horizontal:
                                                                                8),
                                                                    height: 12,
                                                                    width: 8,
                                                                    color: event.detail!.toLowerCase() ==
                                                                            "yellow card"
                                                                        ? Colors
                                                                            .yellow
                                                                        : Colors
                                                                            .red,
                                                                  ),
                                                                if (event.type !=
                                                                        null &&
                                                                    (event.type!.toLowerCase() ==
                                                                            "goal" ||
                                                                        event.type!.toLowerCase() ==
                                                                            "var"))
                                                                  Stack(
                                                                    children: [
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 8),
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            if (event.detail != null &&
                                                                                (event.detail!.toLowerCase() == "goal cancelled" || event.detail!.toLowerCase() == "penalty confirmed"))
                                                                              Text(
                                                                                "VAR",
                                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                                                                              ),
                                                                            if (event.detail != null &&
                                                                                (event.detail!.toLowerCase() == "own goal"))
                                                                              Text(
                                                                                "OG",
                                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                                                                              ),
                                                                            if (event.detail != null &&
                                                                                (event.detail!.toLowerCase() == "penalty" || event.detail!.toLowerCase() == "missed penalty"))
                                                                              Text(
                                                                                "PEN",
                                                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                                                                              ),
                                                                            Container(
                                                                              height: 15,
                                                                              width: 15,
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                                borderRadius: BorderRadius.circular(10),
                                                                              ),
                                                                              child: Icon(FontAwesomeIcons.futbol, color: (event.detail != null && (event.detail!.toLowerCase()) == "own goal") ? Colors.red : Colors.black, size: 15),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      if (event.detail !=
                                                                              null &&
                                                                          (event.detail!.toLowerCase() == "penalty" ||
                                                                              event.detail!.toLowerCase() == "missed penalty" ||
                                                                              event.detail!.toLowerCase() == "goal cancelled" ||
                                                                              event.detail!.toLowerCase() == "penalty confirmed"))
                                                                        Positioned(
                                                                          right:
                                                                              2,
                                                                          bottom:
                                                                              6,
                                                                          child: (event.detail != null && (event.detail!.toLowerCase() == "penalty" || event.detail!.toLowerCase() == "penalty confirmed"))
                                                                              ? Container(
                                                                                  height: 10,
                                                                                  width: 10,
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.black,
                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                  ),
                                                                                  child: Icon(CupertinoIcons.check_mark_circled_solid, color: Colors.green, size: 10),
                                                                                )
                                                                              : Container(
                                                                                  height: 10,
                                                                                  width: 10,
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.black,
                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                  ),
                                                                                  child: Icon(CupertinoIcons.clear_circled_solid, color: Colors.red, size: 10),
                                                                                ),
                                                                        )
                                                                    ],
                                                                  ),
                                                                Expanded(
                                                                  child: Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          event.player != null && event.player!.name != null
                                                                              ? event.player!.name!
                                                                              : event.detail != null
                                                                                  ? event.detail!
                                                                                  : "",
                                                                          maxLines: event.player != null && event.player!.name != null
                                                                              ? 1
                                                                              : 2,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style: TextStyle(
                                                                              fontSize: 11,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        if (event.assist !=
                                                                                null &&
                                                                            event.assist!.name !=
                                                                                null)
                                                                          Text(
                                                                            event.assist!.name!,
                                                                            maxLines:
                                                                                1,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 11,
                                                                            ),
                                                                          ),
                                                                      ]),
                                                                ),
                                                              ],
                                                            )
                                                          : Container(),
                                                    ),
                                                  ]),
                                                )
                                              ]),
                                            )
                                          ]),
                                        );
                                      }),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                              border:
                                  Border.all(color: Colors.white, width: 0.5)),
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: Center(
                            child:
                                Text("Events will display here as they happen"),
                          ));
                    }
                  }
                },
              ));
        });
  }

  Widget seperator(List<Event> events, String name, FootballMatch match) {
    String totalValue = "";
    String homeV = '';
    String awayV = '';
    if (name == "1st Half") {
      var firstHalfE = events.where((element) => element.time.elapsed <= 45);
      homeV = firstHalfE
          .where((element) =>
              (element.team!.id == match.home.id) &&
              (element.detail != null &&
                  (element.detail!.toLowerCase() == "normal goal" ||
                      element.detail!.toLowerCase() == "own goal" ||
                      element.detail!.toLowerCase() == "penalty")))
          .length
          .toString();
      awayV = firstHalfE
          .where((element) =>
              (element.team!.id == match.away.id) &&
              (element.detail != null &&
                  (element.detail!.toLowerCase() == "normal goal" ||
                      element.detail!.toLowerCase() == "own goal" ||
                      element.detail!.toLowerCase() == "penalty")))
          .length
          .toString();
    } else {
      var firstHalfE = events.where((element) => element.time.elapsed > 45);
      homeV = events
          .where((element) =>
              (element.team!.id == match.home.id) &&
              (element.detail != null &&
                  (element.detail!.toLowerCase() == "normal goal" ||
                      element.detail!.toLowerCase() == "own goal" ||
                      element.detail!.toLowerCase() == "penalty")))
          .length
          .toString();
      awayV = events
          .where((element) =>
              (element.team!.id == match.away.id) &&
              (element.detail != null &&
                  (element.detail!.toLowerCase() == "normal goal" ||
                      element.detail!.toLowerCase() == "own goal" ||
                      element.detail!.toLowerCase() == "penalty")))
          .length
          .toString();
    }

    return Center(
      child: Container(
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.white, width: 0.5)),
            color: Colors.grey[700]),
        width: double.infinity,
        padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(name),
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(homeV + " - " + awayV),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
