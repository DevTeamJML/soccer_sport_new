import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/widgets/error_widget.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/core/widgets/no_data_widget.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/presentation/bloc/football_match_bloc.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';

import '../../../injection_container.dart';

class LeagueFixturesTab extends StatefulWidget {
  final LeagueDetails league;
  final List<FootballMatch> footballMatch;
  final List<String> fixtureRounds;
  final String currentRound;
  final String season;
  LeagueFixturesTab(
      {required this.league,
      required this.footballMatch,
      required this.fixtureRounds,
      required this.currentRound,
      required this.season});

  @override
  State<LeagueFixturesTab> createState() => _LeagueFixturesTabState();
}

class _LeagueFixturesTabState extends State<LeagueFixturesTab> {
  List<String> fixtureRounds = [];
  List<FootballMatch> footballMatch = [];
  String currentRound = '';
  final _key1 = GlobalKey();
  final _key2 = GlobalKey();
  final _key3 = GlobalKey();
  final _key4 = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    currentRound = widget.currentRound;
    fixtureRounds = widget.fixtureRounds;
    footballMatch = widget.footballMatch;
    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   if (Constant.showcaseBool)
    //     ShowCaseWidget.of(context).startShowCase([
    //       _key1,
    //       _key2,
    //       _key3,
    //       _key4,
    //       Constant.settingIcon,
    //     ]);
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
        // Showcase(
        //   key: _key1,
        //   description:
        //       "Users can also see fixtures at here too, but it can be filter by the round at here",
        //   child:

        Column(children: [
      Container(
        color: Constant.color2,
        padding: EdgeInsets.symmetric(vertical: 5),
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child:
                  //  Showcase(
                  //   key: _key3,
                  //   description:
                  //       "By tap on here can choose the previous round of the current round",
                  //   overlayPadding: EdgeInsets.symmetric(vertical: 5),
                  //   child:

                  fixtureRounds.first != currentRound
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              currentRound = fixtureRounds[
                                  fixtureRounds.indexOf(currentRound) - 1];
                              BlocProvider.of<FootballMatchBloc>(context).add(
                                  GetFixtureByRoundRequest(
                                      round: currentRound,
                                      leagueId:
                                          widget.league.league.id.toString(),
                                      season: widget.season));
                            });
                          },
                          child: Center(
                              child: Text(
                            '< Previous',
                            style: TextStyle(color: Colors.black),
                          )))
                      : Container(),
              // )
            ),
            Expanded(
              flex: 2,
              child:
                  //  Showcase(
                  //   key: _key2,
                  //   description:
                  //       "Here will show current or lastest round, and user filter the fixtures by select round at here.",
                  //   overlayPadding: EdgeInsets.symmetric(vertical: 5),
                  //   child:
                  Center(
                child: GestureDetector(
                    onTap: () {
                      showPicker(context, fixtureRounds);
                    },
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentRound,
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            FontAwesomeIcons.chevronDown,
                            size: 10,
                          ),
                        ])),
              ),
              // ),
            ),
            Expanded(
              flex: 1,
              child:
                  // Showcase(
                  //   key: _key4,
                  //   description:
                  //       "And click here will show the next round of the current round's fixtures",
                  //   overlayPadding: EdgeInsets.symmetric(vertical: 5),
                  //   child:
                  fixtureRounds.last != currentRound
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              currentRound = fixtureRounds[
                                  fixtureRounds.indexOf(currentRound) + 1];
                              BlocProvider.of<FootballMatchBloc>(context).add(
                                  GetFixtureByRoundRequest(
                                      round: currentRound,
                                      leagueId:
                                          widget.league.league.id.toString(),
                                      season: widget.season));
                            });
                          },
                          child: Center(
                              child: Text(
                            'Next >',
                            style: TextStyle(color: Colors.black),
                          )))
                      : Container(),
              // )
            ),
          ],
        ),
      ),
      Expanded(
        child: ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: footballMatch.length,
            itemBuilder: (context, index) {
              // League
              FootballMatch match = footballMatch[index];
              return Card(
                child: Container(
                  padding: EdgeInsets.only(left: 5),
                  height: MediaQuery.of(context).size.height * 0.09,
                  width: double.infinity,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(flex: 1, child: Container()),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: AutoSizeText(
                                    Constant.formattedDate(
                                        DateTime.parse(match.fixture.date)
                                            .toLocal()),
                                    wrapWords: false,
                                    minFontSize: 6,
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black)),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: AutoSizeText(
                                  match.home.name,
                                  wrapWords: false,
                                  textAlign: TextAlign.center,
                                  minFontSize: 6,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              Image.network(
                                match.home.logoUrl,
                                width: 36.0,
                              ),
                              Expanded(
                                child: AutoSizeText(
                                  "${match.goal != null && match.goal!.home != null ? match.goal!.home : '0'} - ${match.goal != null && match.goal!.away != null ? match.goal!.away : '0'}",
                                  textAlign: TextAlign.center,
                                  wrapWords: false,
                                  minFontSize: 6,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                              Image.network(
                                match.away.logoUrl,
                                width: 36.0,
                              ),
                              Expanded(
                                child: AutoSizeText(
                                  match.away.name,
                                  textAlign: TextAlign.center,
                                  wrapWords: false,
                                  minFontSize: 6,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(flex: 2, child: Container())
                      ]),
                ),
              );
            }),
      ),
    ]);
    // );
  }

  showPicker(BuildContext context, List<String> rounds) {
    Picker(
        adapter: PickerDataAdapter<String>(
            data: rounds
                .map((String e) => PickerItem(text: Text(e), value: e))
                .toList()),
        reversedOrder: false,
        changeToFirst: true,
        selecteds: [rounds.indexOf(currentRound)],
        textAlign: TextAlign.left,
        columnPadding: const EdgeInsets.all(8.0),
        onConfirm: (Picker picker, List value) {
          setState(() {
            currentRound = picker.getSelectedValues()[0];
            print(currentRound);
            BlocProvider.of<FootballMatchBloc>(context).add(
                GetFixtureByRoundRequest(
                    round: currentRound,
                    leagueId: widget.league.league.id.toString(),
                    season: widget.season));
            // _footballMatchBloc.add(GetFixture(
            //     id:widget.league.league.id.toString(),
            //     season: int.parse(season)));
          });
        }).showModal(this.context);
  }
}
