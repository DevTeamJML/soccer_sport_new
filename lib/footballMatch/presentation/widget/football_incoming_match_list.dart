import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:outline_search_bar/outline_search_bar.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/widgets/error_widget.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/core/widgets/no_data_widget.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/presentation/bloc/football_match_bloc.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_incoming_match_nodata.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_match_date_seperator.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_match_list_tile.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/statistics_button.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import '../../../core/constant/analytics_service.dart';
import '../../../injection_container.dart';

class FootballIncomingMatchList extends StatefulWidget {
  final LeagueDetails league;
  FootballIncomingMatchList({required this.league});

  @override
  _FootballIncomingMatchListState createState() =>
      _FootballIncomingMatchListState();
}

class _FootballIncomingMatchListState extends State<FootballIncomingMatchList> {
  final FootballMatchBloc _footballMatchBloc =
      serviceLocator<FootballMatchBloc>();

  List<FootballMatch> footballMatches = [];
  List<FootballMatch> cloneList = [];
  List<FootballMatch> searchedMatches = [];
  List<FootballMatch> liveMatches = [];
  List<String> dateList = ['All'];
  String selectedDate = 'All';
  List<int> availableBets = [39, 61, 78, 140];

  final TextEditingController _controller = TextEditingController();
  String searchValue = '';

  @override
  void initState() {
    _footballMatchBloc.add(GetIncomingFixturesByLeagueRequest(
        leagueId: widget.league.league.id.toString(),
        season: widget.league.seasons!.last.year.toString()));
    serviceLocator<AnalyticsService>().logScreens(
        name: '/footballMatchPage/' + widget.league.league.name + '/incoming');

    super.initState();
  }

  Future<void> _onRefresh() async {
    // monitor network fetch
    _footballMatchBloc.add(GetIncomingFixturesByLeagueRequest(
        leagueId: widget.league.league.id.toString(),
        season: widget.league.seasons!.last.year.toString()));
    return await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    // _refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    _footballMatchBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: BlocProvider<FootballMatchBloc>(
        create: (_) => _footballMatchBloc,
        child: BlocListener<FootballMatchBloc, FootballMatchState>(
          listener: (context, state) {
            if (state is FootballMatchesLoaded) {
              setState(() {
                footballMatches = state.footballMatches;
                cloneList = List.from(footballMatches);
                dateList.addAll(Set.from(
                  footballMatches.map(
                    (e) => Constant.formattedDate(
                      (DateTime.parse(e.fixture.date).toLocal()),
                    ),
                  ),
                ));

                if (Constant.auth != null &&
                    Constant.showcaseBool == false &&
                    availableBets.contains(widget.league.league.id))
                  _footballMatchBloc
                      .add(GetBetLogRequest(id: Constant.auth!.id.toString()));
              });
            }

            if (state is BetLogGet) {
              setState(() {
                Constant.betList = state.bet;
              });
            }
          },
          child: Container(
            width: double.infinity,
            child: Column(children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(color: Colors.white)),
                    child: GestureDetector(
                        onTap: () {
                          showPicker(context);
                        },
                        child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                selectedDate,
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlineSearchBar(
                  textEditingController: _controller,
                  onClearButtonPressed: (v) {
                    setState(() {
                      searchedMatches.clear();
                      cloneList = List.from(footballMatches);
                      searchValue = '';
                    });
                  },
                  onSearchButtonPressed: (value) {
                    setState(() {
                      // cloneList.map((e) {
                      //   if (e.league!.name
                      //       .replaceAll(' ', '')
                      //       .toLowerCase()
                      //       .contains(value.replaceAll(' ', '').toLowerCase())) {
                      //     return e;
                      //   }
                      // }).toList();
                      searchedMatches = cloneList
                          .where((e) =>
                              e.away.name
                                  .replaceAll(' ', '')
                                  .toLowerCase()
                                  .contains(value
                                      .replaceAll(' ', '')
                                      .toLowerCase()) ||
                              e.home.name
                                  .replaceAll(' ', '')
                                  .toLowerCase()
                                  .contains(
                                      value.replaceAll(' ', '').toLowerCase()))
                          .toList();
                      // searchedMatches = cloneList;
                      searchValue = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: BlocBuilder(
                    bloc: _footballMatchBloc,
                    builder: (context, state) {
                      if (state is GettingBetLog) {
                        return LoadingWidget();
                      } else if (state is FootballMatchesError) {
                        return ErrorsWidget();
                      } else {
                        if (footballMatches.length > 0) {
                          // return RefreshIndicator(
                          //   onRefresh: _onRefresh,
                          //   child:
                          // );

                          if (searchValue != '') {
                            if (searchedMatches.length > 0) {
                              return GroupedListView<FootballMatch, String>(
                                elements: selectedDate == 'All'
                                    ? searchedMatches
                                    : searchedMatches.where((e) {
                                        return Constant.formattedDate(
                                                (DateTime.parse(e.fixture.date)
                                                    .toLocal())) ==
                                            selectedDate;
                                      }).toList(),
                                itemComparator: (item1, item2) =>
                                    DateTime.parse(item1.fixture.date)
                                        .compareTo(
                                            DateTime.parse(item2.fixture.date)),
                                groupBy: (match) => Constant.formattedDate(
                                    (DateTime.parse(match.fixture.date)
                                        .toLocal())),
                                groupSeparatorBuilder: (String date) =>
                                    FootballMatchDateSeperator(
                                  date: date,
                                ),
                                indexedItemBuilder:
                                    (context, FootballMatch match, index) {
                                  return FootballMatchListTile(
                                    key: ValueKey(match.fixture.id),
                                    footballMatch: match,
                                    isIncoming: true,
                                    showcasebool: index == 0,
                                    live: false,
                                    availableToBet: availableBets
                                        .contains(widget.league.league.id),
                                  );
                                },
                              );
                            } else {
                              return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: Text('No search result'),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    StatisticsButton(),
                                  ]);
                            }
                          } else {
                            return GroupedListView<FootballMatch, String>(
                              elements: selectedDate == 'All'
                                  ? footballMatches
                                  : footballMatches.where((e) {
                                      return Constant.formattedDate(
                                              (DateTime.parse(e.fixture.date)
                                                  .toLocal())) ==
                                          selectedDate;
                                    }).toList(),
                              itemComparator: (item1, item2) =>
                                  DateTime.parse(item1.fixture.date).compareTo(
                                      DateTime.parse(item2.fixture.date)),
                              groupBy: (match) => Constant.formattedDate(
                                  (DateTime.parse(match.fixture.date)
                                      .toLocal())),
                              groupSeparatorBuilder: (String date) =>
                                  FootballMatchDateSeperator(
                                date: date,
                              ),
                              indexedItemBuilder:
                                  (context, FootballMatch match, index) {
                                return FootballMatchListTile(
                                    key: ValueKey(match.fixture.id),
                                    footballMatch: match,
                                    isIncoming: true,
                                    showcasebool: index == 0,
                                    live: false,
                                    availableToBet: availableBets
                                        .contains(widget.league.league.id),
                                    refresh: refreshBet);
                              },
                            );
                          }
                        } else {
                          return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FootballIncomingMatchNodata(),
                                SizedBox(
                                  height: 10,
                                ),
                                StatisticsButton(),
                              ]);
                        }
                      }
                    }),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  showPicker(
    BuildContext context,
  ) {
    Picker(
        adapter: PickerDataAdapter<String>(
            data: dateList
                .map((e) => PickerItem(text: Text(e), value: e))
                .toList()),
        reversedOrder: false,
        changeToFirst: true,
        selecteds: [0],
        textAlign: TextAlign.left,
        columnPadding: const EdgeInsets.all(8.0),
        onConfirm: (Picker picker, List value) {
          setState(() {
            selectedDate = picker.getSelectedValues()[0];
          });
        }).showModal(this.context);
  }

  refreshBet() {
    setState(() {
      Constant.betList = Constant.betList;
      Constant.customer = Constant.customer;
    });
  }
}
