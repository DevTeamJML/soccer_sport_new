import 'dart:collection';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/widgets/no_data_widget.dart';
import 'package:soccer_sport/footballMatch/data/model/football_match_model.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_incoming_live_match.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_live_match_list.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_match_league_seperator.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../favorite_match/presentation/bloc/favorite_match_bloc.dart';
import '../../../injection_container.dart';
import '../../domain/entities/event.dart';
import '../../domain/entities/live_match/live_match.dart';
import '../bloc/football_match_bloc.dart';
import 'football_away_widget.dart';
import 'football_events_text.dart';
import 'football_home_widget.dart';
import 'match_info/football_match_info.dart';

class FootballLiveMatchTab extends StatefulWidget {
  FootballLiveMatchTab({Key? key}) : super(key: key);

  @override
  State<FootballLiveMatchTab> createState() => _FootballLiveMatchTabState();
}

class _FootballLiveMatchTabState extends State<FootballLiveMatchTab>
    with SingleTickerProviderStateMixin {
  final _key2 = GlobalKey();
  bool matchOngoing = false;
  List<FootballMatch> footballMatches = [];
  List<FootballMatch> comingSoonMatches = [];
  List<FootballMatch> resultMatch = [];
  bool openAppForFirstTime = true;
  DateTime? selectedUpcomingDate;
  DateTime? selectedResultDate;
  late DateTime displayedCalendarMonth;

  final FavoriteMatchBloc _favoriteMatchBloc =
      serviceLocator<FavoriteMatchBloc>();

  DatabaseReference? database;
  TabController? _tabController;
  List<FootballMatch>? liveMatches;
  int test = 0;

  final FootballMatchBloc _footballMatchBloc =
      serviceLocator<FootballMatchBloc>();

  @override
  void initState() {
    super.initState();

    displayedCalendarMonth = DateTime(
      DateTime.now().year,
      DateTime.now().month,
    );

    database = FirebaseDatabase.instance.ref('62');
    _footballMatchBloc.add(GetIncomingLiveMatchRequest());
  }

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  List<DateTime> get _availableUpcomingDates {
    final today = _dateOnly(DateTime.now());
    final lastDay = today.add(const Duration(days: 60));

    final dates = comingSoonMatches
        .where((match) => match.fixture.status.short == 'NS')
        .map((match) => _dateOnly(DateTime.parse(match.fixture.date).toLocal()))
        .where((date) => !date.isBefore(today) && !date.isAfter(lastDay))
        .toSet()
        .toList()
      ..sort((a, b) => a.compareTo(b));

    return dates;
  }

  List<DateTime> get _availableResultDates {
    final today = _dateOnly(DateTime.now());
    final firstDay = today.subtract(const Duration(days: 60));

    return resultMatch
        .where((match) =>
            ['FT', 'AET', 'PEN'].contains(match.fixture.status.short))
        .map((match) => _dateOnly(DateTime.parse(match.fixture.date).toLocal()))
        .where((date) => !date.isBefore(firstDay) && !date.isAfter(today))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));
  }

  Widget resultMatchesView() {
    final dates = _availableResultDates;

    final selectedDate =
        selectedResultDate != null && dates.contains(selectedResultDate)
            ? selectedResultDate!
            : (dates.isNotEmpty ? dates.first : null);

    final filteredMatches = selectedDate == null
        ? <FootballMatch>[]
        : resultMatch.where((match) {
            final matchDate = _dateOnly(
              DateTime.parse(match.fixture.date).toLocal(),
            );

            return matchDate == selectedDate;
          }).toList();

    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 12, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  selectedDate == null
                      ? 'No results available'
                      : DateFormat('EEE, dd MMM yyyy').format(selectedDate),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () async {
                    final dates = _availableResultDates;
                    final today = _dateOnly(DateTime.now());

                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedResultDate ?? today,
                      firstDate: today.subtract(const Duration(days: 29)),
                      lastDate: today,
                      selectableDayPredicate: (date) {
                        return dates.contains(_dateOnly(date));
                      },
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.dark(
                              primary: Colors.yellow,
                              onPrimary: Colors.black,
                              surface: Color(0xFF172235),
                              onSurface: Colors.white,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (pickedDate != null && mounted) {
                      setState(() {
                        selectedResultDate = _dateOnly(pickedDate);
                      });
                    }
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFF172235),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.yellow,
                        width: 1.2,
                      ),
                    ),
                    child: const Icon(
                      Icons.calendar_month,
                      color: Colors.yellow,
                      size: 22,
                    ),
                  ),
                ),
              ],
            )),
        const Divider(color: Colors.white12, height: 8),
        Expanded(
          child: filteredMatches.isEmpty
              ? const Center(
                  child: Text(
                    'No results on this date',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : groupListView(filteredMatches),
        ),
      ],
    );
  }

  Widget upcomingMatchesView() {
    final dates = _availableUpcomingDates;
    final today = _dateOnly(DateTime.now());
    final lastDay = today.add(const Duration(days: 60));

    final selectedDate =
        selectedUpcomingDate != null && dates.contains(selectedUpcomingDate)
            ? selectedUpcomingDate!
            : (dates.isNotEmpty ? dates.first : null);

    final filteredMatches = selectedDate == null
        ? <FootballMatch>[]
        : comingSoonMatches.where((match) {
            final matchDate =
                _dateOnly(DateTime.parse(match.fixture.date).toLocal());

            return match.fixture.status.short == 'NS' &&
                matchDate == selectedDate;
          }).toList()
      ..sort((a, b) => DateTime.parse(a.fixture.date)
          .toLocal()
          .compareTo(DateTime.parse(b.fixture.date).toLocal()));

    Future<void> openCalendar() async {
      final dates = _availableUpcomingDates;
      final today = _dateOnly(DateTime.now());
      final lastDay = today.add(const Duration(days: 60));

      final pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedUpcomingDate ?? today,
        firstDate: today,
        lastDate: lastDay,
        selectableDayPredicate: (date) {
          return dates.contains(_dateOnly(date));
        },
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Colors.yellow,
                onPrimary: Colors.black,
                surface: Color(0xFF172235),
                onSurface: Colors.white,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedDate != null && mounted) {
        setState(() {
          selectedUpcomingDate = _dateOnly(pickedDate);
          displayedCalendarMonth = DateTime(
            pickedDate.year,
            pickedDate.month,
          );
        });
      }
    }

    // Compact date selector
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 12, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                selectedDate == null
                    ? 'Upcoming matches'
                    : DateFormat('EEE, dd MMM yyyy').format(selectedDate),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: dates.isEmpty ? null : openCalendar,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFF172235),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.yellow,
                      width: 1.2,
                    ),
                  ),
                  child: const Icon(
                    Icons.calendar_month,
                    color: Colors.yellow,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(color: Colors.white12, height: 8),
        Expanded(
          child: filteredMatches.isEmpty
              ? Center(
                  child: Text(
                    dates.isEmpty
                        ? 'No upcoming matches in the next 60 days'
                        : 'No matches on this date',
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                )
              : groupListView(filteredMatches),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<FootballMatchBloc>(
            create: (_) => _footballMatchBloc,
          ),
          BlocProvider(
            create: (context) => _favoriteMatchBloc,
          ),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<FootballMatchBloc, FootballMatchState>(
              listener: (context, state) {
                if (state is IncomingLiveMatchLoaded) {
                  setState(() {
                    footballMatches = state.footballMatches!;

                    footballMatches.sort((a, b) {
                      final dateA = DateTime.parse(a.fixture.date).toLocal();
                      final dateB = DateTime.parse(b.fixture.date).toLocal();
                      return dateA.compareTo(dateB);
                    });

                    comingSoonMatches = footballMatches
                        .where((match) => [
                              "NS",
                              "PST",
                              "CANC",
                              "ABD",
                            ].contains(match.fixture.status.short))
                        .toList()
                      ..sort((a, b) => DateTime.parse(a.fixture.date).compareTo(
                            DateTime.parse(b.fixture.date),
                          ));

                    resultMatch = footballMatches
                        .where((match) => ["FT", "AET", "PEN"]
                            .contains(match.fixture.status.short))
                        .toList()
                      ..sort((a, b) => DateTime.parse(a.fixture.date).compareTo(
                            DateTime.parse(b.fixture.date),
                          ));

                    final availableDates = _availableUpcomingDates;

                    if (selectedUpcomingDate == null ||
                        !availableDates.contains(selectedUpcomingDate)) {
                      selectedUpcomingDate = availableDates.isNotEmpty
                          ? availableDates.first
                          : null;
                    }

                    _tabController = TabController(
                      vsync: this,
                      length: 3,
                    );
                  });
                }
              },
            ),
            BlocListener<FavoriteMatchBloc, FavoriteMatchState>(
              listener: (context, state) {
                if (state is FavoriteMatchPersisted) {
                  if (state.footballMatches) {
                    setState(() {
                      Constant.favoriteList = Constant.favoriteList;
                    });
                  }
                }

                if (state is FavoriteMatchRemoved) {
                  if (state.footballMatches) {
                    setState(() {
                      Constant.favoriteList = Constant.favoriteList;
                    });
                  }
                }
              },
            ),
          ],
          child: StreamBuilder(
            stream: database != null ? database!.onValue : null,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingWidget();
              } else if (snapshot.hasData) {
                DatabaseEvent data = snapshot.data as DatabaseEvent;

                if (data.snapshot.value != null) {
                  var jsonvalue = Map<String, dynamic>.from(
                    data.snapshot.value as LinkedHashMap,
                  );

                  if (jsonvalue.isNotEmpty) {
                    liveMatches = jsonvalue.entries
                        .map(
                          (entry) => FootballMatchModel.fromJson(
                            jsonDecode(
                              jsonEncode(entry.value),
                            ),
                          ),
                        )
                        .toList();

                    Constant.liveData.add(
                      liveMatches != null ? liveMatches! : [],
                    );

                    if (liveMatches != null &&
                        liveMatches!.isNotEmpty &&
                        openAppForFirstTime &&
                        _tabController != null) {
                      _tabController!.animateTo(1);
                      openAppForFirstTime = false;
                    }
                  }
                }

                return Container(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.zero,
                    child: BlocBuilder(
                      bloc: _footballMatchBloc,
                      builder: (context, state) {
                        if (state is LoadIncomingLiveMatch) {
                          return LoadingWidget();
                        } else if (state is FootballMatchesError) {
                          return ErrorsWidget();
                        } else {
                          if (footballMatches.isNotEmpty) {
                            return Container(
                              height: double.infinity,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.white,
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                    width: double.infinity,
                                    child: TabBar(
                                      controller: _tabController,
                                      indicator: BoxDecoration(
                                        border: null,
                                      ),
                                      labelColor: Colors.yellow,
                                      unselectedLabelColor: Colors.grey,
                                      tabs: [
                                        Tab(text: "Result"),
                                        Tab(text: "Live"),
                                        Tab(text: "Upcoming"),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      resultMatchesView(),
                                      groupListView(liveMatches),
                                      upcomingMatchesView(),
                                    ],
                                  )),
                                ],
                              ),
                            );
                          } else {
                            return NoDataWidget();
                          }
                        }
                      },
                    ),
                  ),
                );
              } else {
                return NoDataWidget();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget groupListView(List<FootballMatch>? list) {
    return list != null
        ? GroupedListView<FootballMatch, String>(
            addAutomaticKeepAlives: false,
            shrinkWrap: true,
            elements: list,
            order: GroupedListOrder.ASC,
            sort: true,
            // groupBy: (match) {
            //   final date = DateTime.parse(match.fixture.date).toLocal();
            //   return DateFormat('yyyy-MM-dd').format(date);
            // },

            groupBy: (match) {
              return match.league?.name ?? 'Unknown League';
            },

            // groupSeparatorBuilder: (String date) {
            //   final parsedDate = DateFormat('yyyy-MM-dd').parse(date);

            //   return Padding(
            //     padding: const EdgeInsets.all(10),
            //     child: Text(
            //       DateFormat('dd MMM yyyy').format(parsedDate),
            //       style: const TextStyle(
            //         fontSize: 16,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.white,
            //       ),
            //     ),
            //   );
            // },

            groupSeparatorBuilder: (String leagueName) {
              final leagueMatch = list!.firstWhere(
                (match) => match.league?.name == leagueName,
              );

              final logoUrl = leagueMatch.league?.logo;

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (logoUrl != null && logoUrl.isNotEmpty)
                      Container(
                        width: 36,
                        height: 36,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Image.network(
                          logoUrl,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.emoji_events,
                              color: Colors.amber,
                              size: 24,
                            );
                          },
                        ),
                      ),
                    const SizedBox(width: 10),
                    Text(
                      leagueName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow,
                      ),
                    ),
                  ],
                ),
              );
            },

            indexedItemBuilder:
                (context, FootballMatch footballMatch, int index) {
              bool isLive = false;
              bool matchOngoing = false;
              FootballMatch match = footballMatch;

              if (liveMatches != null) {
                FootballMatch? onLive = liveMatches!.firstWhereOrNull(
                  (element) => element.fixture.id == match.fixture.id,
                );

                if (onLive != null) {
                  match = onLive;
                  isLive = true;
                }
              }

              int extraTime = 0;
              List<Event>? awayEvent;
              List<Event>? homeEvent;

              bool isFavorite = Constant.favoriteList.firstWhereOrNull(
                    (element) => element.fixture.id == match.fixture.id,
                  ) !=
                  null;

              if (match.events != null &&
                  match.events!.isNotEmpty &&
                  ((match.fixture.status.short == '1H' &&
                          match.fixture.status.elapsedTime == 45) ||
                      (match.fixture.status.short == '2H' &&
                          match.fixture.status.elapsedTime == 90)) &&
                  match.events!.last.time.extra != null) {
                extraTime = match.events!.last.time.extra!;
              } else {
                extraTime = 0;
              }

              if (match.events != null) {
                awayEvent = match.events!
                    .where((element) =>
                        element.team != null &&
                        element.team!.id == match.away.id)
                    .toList();

                homeEvent = match.events!
                    .where((element) =>
                        element.team != null &&
                        element.team!.id == match.home.id)
                    .toList();
              }

              matchOngoing = match.fixture.status.short != 'FT' &&
                  match.fixture.status.short != 'AET' &&
                  match.fixture.status.short != 'PEN';

              isFavorite = Constant.favoriteList.firstWhereOrNull(
                    (element) => element.fixture.id == match.fixture.id,
                  ) !=
                  null;

              return Container(
                key: ValueKey(match),
                padding: const EdgeInsets.all(5.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            FootballMatchInfoPage(match: match),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.11,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(20.0),
                                topRight: const Radius.circular(20.0),
                                bottomLeft: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                              ),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      FootballHomeWidget(
                                        team: match.home,
                                        gotEvents: false,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01,
                                            ),
                                            (match.fixture.status.short ==
                                                        '1H' ||
                                                    match.fixture.status
                                                            .short ==
                                                        '2H' ||
                                                    match.fixture.status
                                                            .short ==
                                                        'P' ||
                                                    match.fixture.status
                                                            .short ==
                                                        'ET' ||
                                                    match.fixture.status
                                                            .short ==
                                                        'BT' ||
                                                    match.fixture.status
                                                            .short ==
                                                        'HT')
                                                ? Text(
                                                    (match.fixture.status.elapsedTime != null
                                                            ? match.fixture.status
                                                                .elapsedTime
                                                                .toString()
                                                            : '') +
                                                        (match.events != null &&
                                                                ((match.fixture.status.short == '1H' &&
                                                                        match.fixture.status.elapsedTime ==
                                                                            45) ||
                                                                    (match.fixture.status.short == '2H' &&
                                                                        match.fixture.status.elapsedTime ==
                                                                            90))
                                                            ? '+'
                                                            : '') +
                                                        (extraTime != 0
                                                            ? extraTime
                                                                .toString()
                                                            : '') +
                                                        (match.fixture.status
                                                                    .elapsedTime !=
                                                                null
                                                            ? ' : '
                                                            : '') +
                                                        (extraTime != 0
                                                            ? match.fixture
                                                                .status.short!
                                                            : match.fixture
                                                                .status.long!),
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 12.0,
                                                    ),
                                                  )
                                                : SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.01,
                                                  ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02,
                                            ),
                                            (match.fixture.status.short ==
                                                        'CANC' ||
                                                    match.fixture.status
                                                            .short ==
                                                        'ABD')
                                                ? AutoSizeText(
                                                    match.fixture.status.long!,
                                                    wrapWords: false,
                                                    textAlign: TextAlign.center,
                                                    minFontSize: 5,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  )
                                                : match.fixture.status.short !=
                                                        'NS'
                                                    ? Text(
                                                        "${match.goal != null && match.goal!.home != null ? (match.score != null && match.score!.penalty != null ? (match.goal!.home! + match.score!.penalty!.home!) : match.goal!.home) : '0'} - ${match.goal != null && match.goal!.away != null ? (match.score != null && match.score!.penalty != null ? (match.goal!.away! + match.score!.penalty!.away!) : match.goal!.away) : '0'}",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16.0,
                                                        ),
                                                      )
                                                    : Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            DateFormat('HH:mm')
                                                                .format(
                                                              DateTime.parse(
                                                                match.fixture
                                                                    .date,
                                                              ).toLocal(),
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          Text(
                                                            DateFormat(
                                                                    'dd MMM yyyy')
                                                                .format(
                                                              DateTime.parse(
                                                                match.fixture
                                                                    .date,
                                                              ).toLocal(),
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 13.0,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                          ],
                                        ),
                                      ),
                                      FootballAwayWidget(
                                        team: match.away,
                                        gotEvents: false,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                            child: Text(
                              "Ongoing",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:
                                    MediaQuery.of(context).size.width > 768
                                        ? 15
                                        : 7,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          )
        : Center(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      FontAwesomeIcons.circleExclamation,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Currently no live match, go to 'Result' or 'Coming' to view today matches!",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
  }
}
