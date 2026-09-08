import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../../core/constant/constants.dart';
import '../../../../injection_container.dart';
import '../../../../league/domain/entities/league.dart';
import '../../../domain/entities/event.dart';
import '../../../domain/entities/football_match.dart';
import '../../../domain/entities/team.dart';
import '../../bloc/football_match_bloc.dart';
import '../football_away_widget.dart';
import '../football_home_widget.dart';
import '../football_match_league_seperator.dart';
import '../match_info/widget/h2h_list_tile.dart';
import 'league_dropdown_button.dart';

class TeamMatchesInfo extends StatefulWidget {
  final List<FootballMatch> matchList;
  final List<String> listOfLeague;
  const TeamMatchesInfo({required this.matchList, required this.listOfLeague});

  @override
  State<TeamMatchesInfo> createState() => _TeamMatchesInfoState();
}

class _TeamMatchesInfoState extends State<TeamMatchesInfo> {
  final FootballMatchBloc _footballMatchBloc =
      serviceLocator<FootballMatchBloc>();
  List<FootballMatch> matchList = [];
  List<FootballMatch> filteredMatches = [];
  FootballMatch? upcomingMatch;
  List<League?> listOfLeague = [null];
  List<DropdownMenuItem<String>> filterList = [];
  List<FootballMatch>? liveMatches;
  bool isUpcoming = false;
  String statusShort = "";
  String selectedValue = '';

  @override
  void initState() {
    // TODO: implement initState

    // _footballMatchBloc.add(GetFixtureByTeamRequest(
    //     id: widget.team.id.toString(),
    //     season: widget.season.seasons.toString()));
    matchList = widget.matchList;
    DateTime currentDate = DateTime.now();

    upcomingMatch = matchList.firstWhereOrNull((element) {
      DateTime matchDatetime = DateTime.parse(element.fixture.date);
      bool isNotStarted = element.fixture.status.short == "NS";
      return (matchDatetime.difference(currentDate).inMilliseconds >= 0) &&
          isNotStarted;
    });
    if (upcomingMatch != null)
      statusShort = upcomingMatch!.fixture.status.short != null
          ? upcomingMatch!.fixture.status.short!.toLowerCase()
          : "";
    if (upcomingMatch != null) {}
    var removedDuplicatedLeague = matchList
        .map((e) => e.league!)
        .toSet()
        .toList()
        .fold<List<League>>([], (a, b) {
      if (!a.any(
          (element) => (element.id == b.id && element.seasons == b.seasons))) {
        return [...a, b];
      }

      return a;
    });
    listOfLeague.addAll(removedDuplicatedLeague);
    selectedValue = "All League";
    filteredMatches = matchList;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _footballMatchBloc,
      child: BlocListener<FootballMatchBloc, FootballMatchState>(
        listener: (context, state) {},
        child: BlocBuilder<FootballMatchBloc, FootballMatchState>(
          builder: (context, state) {
            // if (state is LoadFixturesByTeam) {
            //   return LoadingWidget();
            // } else if (state is FootballMatchesError) {
            //   return ErrorWidget(state.message);
            // } else {

            // }
            return ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                if (upcomingMatch != null)
                  Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                              padding: EdgeInsets.all(10),
                              child: Text("Next Match",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        height: MediaQuery.of(context).size.height * 0.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      height: 30,
                                      width: 30,
                                      margin: EdgeInsets.only(right: 3),
                                      child: FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image: upcomingMatch!.home.logoUrl,
                                          imageErrorBuilder: (e, o, c) {
                                            return Container();
                                          }),
                                    ),
                                    Text(upcomingMatch!.home.name,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11))
                                  ],
                                )),
                            Expanded(
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    AutoSizeText(
                                        upcomingMatch!.fixture.status.short!
                                                        .toLowerCase() !=
                                                    "ns" &&
                                                upcomingMatch!
                                                        .fixture.status.short!
                                                        .toLowerCase() !=
                                                    "tbd"
                                            ? (upcomingMatch!.goal != null
                                                ? ((upcomingMatch!.goal!.home != null
                                                        ? upcomingMatch!
                                                            .goal!.home!
                                                            .toString()
                                                        : "0") +
                                                    " -" +
                                                    (upcomingMatch!.goal!.away !=
                                                            null
                                                        ? upcomingMatch!
                                                            .goal!.away!
                                                            .toString()
                                                        : "0"))
                                                : "0 - 0")
                                            : DateFormat("hh:mma").format(
                                                DateTime.parse(upcomingMatch!.fixture.date)
                                                    .toLocal()),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxFontSize: 20,
                                        minFontSize: 14),
                                    Text(
                                      upcomingMatch!.fixture.status.short!
                                                      .toLowerCase() !=
                                                  "ns" &&
                                              upcomingMatch!
                                                      .fixture.status.short!
                                                      .toLowerCase() !=
                                                  "tbd"
                                          ? (statusShort != "ft" &&
                                                  statusShort != "aet" &&
                                                  statusShort != "pen"
                                              ? (upcomingMatch!.fixture.status
                                                      .elapsedTime
                                                      .toString() +
                                                  "'")
                                              : upcomingMatch!
                                                  .fixture.status.long!)
                                          : DateFormat("d MMM").format(
                                              DateTime.parse(upcomingMatch!
                                                      .fixture.date)
                                                  .toLocal()),
                                      style: TextStyle(
                                          color: upcomingMatch!
                                                          .fixture.status.short!
                                                          .toLowerCase() !=
                                                      "ns" &&
                                                  upcomingMatch!
                                                          .fixture.status.short!
                                                          .toLowerCase() !=
                                                      "tbd"
                                              ? statusShort != "ft" &&
                                                      statusShort != "aet" &&
                                                      statusShort != "pen"
                                                  ? Colors.green
                                                  : Colors.black
                                              : Colors.black,
                                          fontSize: 12),
                                      textAlign: TextAlign.center,
                                    ),
                                  ]),
                            ),
                            Expanded(
                                flex: 2,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      height: 30,
                                      width: 30,
                                      margin: EdgeInsets.only(right: 3),
                                      child: FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image: upcomingMatch!.away.logoUrl,
                                          imageErrorBuilder: (e, o, c) {
                                            return Container();
                                          }),
                                    ),
                                    Text(upcomingMatch!.away.name,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11))
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                if (selectedValue != "")
                  Column(
                    children: [
                      // LeagueDropdownButton(
                      //   selectedValue: selectedValue,
                      //   listOfLeague: listOfLeague,
                      //   matchList: matchList,
                      //   onChange: (value) {
                      //     setState(() {
                      //       selectedValue = value as String;
                      //       if (value == "All League") {
                      //         filteredMatches = matchList;
                      //       } else {
                      //         filteredMatches = matchList
                      //             .where((e) => e.league!.name == value)
                      //             .toList();
                      //       }
                      //     });
                      //   },
                      // ),

                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                // hint:
                                customButton: Container(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.6,
                                    maxHeight: 50,
                                  ),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.list,
                                        color: Colors.white,
                                      ),
                                      if (selectedValue != "All League")
                                        Container(
                                          height: 30,
                                          width: 30,
                                          color: Colors.white,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: FadeInImage.memoryNetwork(
                                              placeholder: kTransparentImage,
                                              image: listOfLeague
                                                  .firstWhere((e) => e != null
                                                      ? (e.name +
                                                              " " +
                                                              e.seasons!
                                                                  .toString()) ==
                                                          selectedValue
                                                      : false)!
                                                  .logo!,
                                              imageErrorBuilder: (e, o, c) {
                                                return Container();
                                              }),
                                        ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: AutoSizeText(
                                            selectedValue,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            minFontSize: 7,
                                            maxFontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        FontAwesomeIcons.caretDown,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                                menuItemStyleData: MenuItemStyleData(
                                  // customHeights: [48, 48, 48],
                                  height: 48,
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                ),
                                // customItemsHeight: 4,
                                dropdownStyleData: DropdownStyleData(
                                  width: 300,
                                  maxHeight: 500,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.white,
                                  ),
                                  elevation: 8,
                                  offset: const Offset(0, 8),
                                ),
                                items: listOfLeague
                                    .map(
                                      (item) => DropdownMenuItem<String>(
                                        value: item == null
                                            ? "All League"
                                            : item.name +
                                                " " +
                                                item.seasons!.toString(),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (item != null)
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 3),
                                                child: Container(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      FadeInImage.memoryNetwork(
                                                          placeholder:
                                                              kTransparentImage,
                                                          image: item.logo!,
                                                          imageErrorBuilder:
                                                              (e, o, c) {
                                                            return Container();
                                                          }),
                                                ),
                                              ),
                                            Expanded(
                                              child: AutoSizeText(
                                                item != null
                                                    ? item.name +
                                                        " " +
                                                        item.seasons!.toString()
                                                    : "All League",
                                                style: TextStyle(
                                                  color: selectedValue == item
                                                      ? Constant.color1
                                                      : Colors.black,
                                                ),
                                                minFontSize: 7,
                                                maxFontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    selectedValue = value as String;
                                    if (value == "All League") {
                                      filteredMatches = matchList;
                                    } else {
                                      filteredMatches = matchList
                                          .where((e) =>
                                              (e.league!.name +
                                                  " " +
                                                  e.league!.seasons!
                                                      .toString()) ==
                                              value)
                                          .toList();
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isUpcoming) {
                                      isUpcoming = false;
                                    }
                                  });
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                      border: Border.all(
                                          color: Colors.white, width: 0.5),
                                      color: !isUpcoming
                                          ? Colors.white
                                          : Colors.transparent,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 15),
                                    child: Center(
                                        child: Text(
                                      "Results",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: !isUpcoming
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    )))),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (!isUpcoming) {
                                      isUpcoming = true;
                                    }
                                  });
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                      border: Border.all(
                                          color: Colors.white, width: 0.5),
                                      color: isUpcoming
                                          ? Colors.white
                                          : Colors.transparent,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 15),
                                    child: Center(
                                        child: Text(
                                      "Upcoming",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isUpcoming
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    )))),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                      groupListView(
                          filteredMatches.where((e) {
                            String status = e.fixture.status.short != null
                                ? e.fixture.status.short!
                                : "";
                            bool isResultsMatch = status == "FT" ||
                                status == "AET" ||
                                status == "PEN";
                            if (isUpcoming) {
                              return !isResultsMatch;
                            } else {
                              return isResultsMatch;
                            }
                          }).toList(),
                          isUpcoming)
                    ],
                  )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget groupListView(List<FootballMatch> list, bool isUpComing) {
    return GroupedListView<FootballMatch, String>(
        physics: NeverScrollableScrollPhysics(),
        addAutomaticKeepAlives: false,
        shrinkWrap: true,
        elements: list,
        order: GroupedListOrder.DESC,
        sort: true,
        groupBy: (match) =>
            match.league!.id == 1 ? 'FIFA World Cup(tm)' : match.league!.name,
        groupSeparatorBuilder: (String league) => FootballMatchLeagueSeperator(
              league: league,
              matchs: list,
            ),
        itemComparator: (a, b) {
          if (isUpComing) {
            return DateTime.parse(b.fixture.date)
                .compareTo(DateTime.parse(a.fixture.date));
          } else {
            return DateTime.parse(a.fixture.date)
                .compareTo(DateTime.parse(b.fixture.date));
          }
        },
        indexedItemBuilder: (context, FootballMatch footballMatch, int index) {
          bool isLive = false;
          bool matchOngoing = false;
          FootballMatch match = footballMatch;
          if (liveMatches != null) {
            FootballMatch? onLive = liveMatches!.firstWhereOrNull(
                (element) => element.fixture.id == match.fixture.id);
            if (onLive != null) {
              match = onLive;
              isLive = true;
            }
          }

          int extraTime = 0;
          List<Event>? awayEvent;
          List<Event>? homeEvent;
          bool isFavorite = Constant.favoriteList.firstWhereOrNull(
                  (element) => element.fixture.id == match.fixture.id) !=
              null;

          if (match.events != null &&
              match.events!.length > 0 &&
              (match.fixture.status.short == '1H' &&
                      match.fixture.status.elapsedTime == 45 ||
                  match.fixture.status.short == '2H' &&
                      match.fixture.status.elapsedTime == 90) &&
              match.events!.last.time.extra != null) {
            extraTime = match.events!.last.time.extra!;
          } else {
            extraTime = 0;
          }

          if (match.events != null) {
            awayEvent = match.events!
                .where((element) =>
                    element.team != null && element.team!.id == match.away.id)
                .toList();
            homeEvent = match.events!
                .where((element) =>
                    element.team != null && element.team!.id == match.home.id)
                .toList();
          }

          matchOngoing = (match.fixture.status.short != 'FT' &&
              match.fixture.status.short != 'AET' &&
              match.fixture.status.short != 'PEN');
          isFavorite = Constant.favoriteList.firstWhereOrNull(
                  (element) => element.fixture.id == match.fixture.id) !=
              null;

          // return FootballMatchLiveListTile(
          //   footballMatch: match,
          // );

          return H2HListtile(
            key: ValueKey(match.fixture.id),
            footballMatch: match,
          );
          return Container(
            key: ValueKey(match),
            padding: const EdgeInsets.all(5.0),
            child: GestureDetector(
              onTap: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //       builder: (context) =>
                //           FootballMatchInfoPage(match: match)),
                // );
              },
              child: Stack(
                children: [
                  Column(children: [
                    Container(
                      height: match.events != null
                          ? MediaQuery.of(context).size.height * 0.11
                          : MediaQuery.of(context).size.height * 0.11,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(20.0),
                            topRight: const Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          )),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              Constant.formattedDate(
                                  DateTime.parse(match.fixture.date)),
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FootballHomeWidget(
                                team: match.home,
                                gotEvents: false,
                              ),
                              Expanded(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.01,
                                  ),
                                  (match.fixture.status.short == '1H' ||
                                          match.fixture.status.short == '2H' ||
                                          match.fixture.status.short == 'P' ||
                                          match.fixture.status.short == 'ET' ||
                                          match.fixture.status.short == 'BT' ||
                                          match.fixture.status.short == 'HT')
                                      ? Text(
                                          (match.fixture.status.elapsedTime != null
                                                  ? match
                                                      .fixture.status.elapsedTime
                                                      .toString()
                                                  : '') +
                                              (match.events != null &&
                                                      ((match.fixture.status.short ==
                                                                  '1H' &&
                                                              match
                                                                      .fixture
                                                                      .status
                                                                      .elapsedTime ==
                                                                  45) ||
                                                          (match.fixture.status
                                                                      .short ==
                                                                  '2H' &&
                                                              match
                                                                      .fixture
                                                                      .status
                                                                      .elapsedTime ==
                                                                  90))
                                                  ? '+'
                                                  : '') +
                                              (extraTime != 0
                                                  ? extraTime.toString()
                                                  : '') +
                                              (match.fixture.status.elapsedTime !=
                                                      null
                                                  ? ' : '
                                                  : '') +
                                              (extraTime != 0
                                                  ? match.fixture.status.short!
                                                  : match.fixture.status.long!),
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 12.0,
                                          ),
                                        )
                                      : SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  (match.fixture.status.short == 'CANC' ||
                                          match.fixture.status.short == 'ABD')
                                      ? AutoSizeText(
                                          match.fixture.status.long!,
                                          wrapWords: false,
                                          textAlign: TextAlign.center,
                                          minFontSize: 5,
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        )
                                      : match.fixture.status.short != 'NS'
                                          ? Text(
                                              //                 "////////////${match.goal != null && match.goal!.home != null ? (homeEvent != null && match.goal!.home! > homeEvent!.map((e) => e.type.toLowerCase() == 'goal').length ? match.goal!.home! : homeEvent!.map((e) => e.type.toLowerCase() == 'goal').length) : '0'} - ${match.goal != null && match.goal!.away != null ? match.goal!.away : '0'}",

                                              "${match.goal != null && match.goal!.home != null ? (match.score != null && match.score!.penalty != null ? (match.goal!.home! + match.score!.penalty!.home!) : match.goal!.home) : '0'} - ${match.goal != null && match.goal!.away != null ? (match.score != null && match.score!.penalty != null ? (match.goal!.away! + match.score!.penalty!.away!) : match.goal!.away) : '0'}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0,
                                              ),
                                            )
                                          : Text(
                                              Constant.formattedTime(
                                                  DateTime.parse(
                                                          match.fixture.date)
                                                      .toLocal()),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0,
                                              ),
                                            ),
                                ],
                              )),
                              FootballAwayWidget(
                                team: match.away,
                                gotEvents: false,
                              )
                            ],
                          ),
                        ),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: [
                        //     Column(
                        //       children: [

                        //         Text(
                        //           Constant.formattedHMTime(
                        //               DateTime.parse(match.fixture.date)),
                        //           style: TextStyle(color: Colors.black),
                        //         )
                        //       ],
                        //     )
                        //   ],
                        // )
                      ]),
                    ),

                    // if (matchOngoing)
                    //   GestureDetector(
                    //     onTap: () {
                    //       setState(() {
                    //         if (isFavorite) {
                    //           _favoriteMatchBloc.add(
                    //               RemoveFavoriteMatchRequest(match: match));
                    //         } else {
                    //           _favoriteMatchBloc.add(
                    //               PersistFavoriteMatchRequest(match: match));
                    //         }
                    //       });
                    //     },
                    //     child: Container(
                    //       padding: EdgeInsets.all(1),
                    //       width: double.infinity,
                    //       decoration: BoxDecoration(
                    //           color: Colors.grey,
                    //           borderRadius: new BorderRadius.only(
                    //               bottomLeft: const Radius.circular(20.0),
                    //               bottomRight: const Radius.circular(20.0))
                    //               ),
                    //       child: Icon(
                    //         isFavorite
                    //             ? Icons.star
                    //             : Icons.star_border_outlined,
                    //         color: Colors.yellow,
                    //       ),
                    //     ),
                    //   )
                  ]),
                  if (isLive)
                    Positioned(
                        right: 5,
                        top: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Constant.color1,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          padding: EdgeInsets.all(5),
                          child: Text("Ongoing",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width > 768
                                          ? 15
                                          : 7,
                                  fontWeight: FontWeight.bold)),
                        ))
                ],
              ),
            ),
          );
        });
  }
}
