import 'dart:collection';
import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/footballMatch/data/model/football_match_model.dart';
import 'package:soccer_sport/footballMatch/domain/entities/event.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/presentation/bloc/football_match_bloc.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/match_info/widget/football_match_h2h.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/match_info/widget/football_match_lineups_widget.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/match_info/widget/football_match_stats_widget.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/match_info/widget/football_match_summary.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/match_info/widget/football_match_table.dart';
import 'package:soccer_sport/injection_container.dart';
import 'package:soccer_sport/video/domain/entities/video_details.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:autoscale_tabbarview/autoscale_tabbarview.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../favorite_match/presentation/bloc/favorite_match_bloc.dart';
import '../../../../video/presentation/bloc/video_details_bloc.dart';
import '../../page/football_team_page.dart';

class FootballMatchInfoPage extends StatefulWidget {
  final FootballMatch match;

  const FootballMatchInfoPage({
    required this.match,
  });

  @override
  State<FootballMatchInfoPage> createState() => _FootballMatchInfoPageState();
}

class _FootballMatchInfoPageState extends State<FootballMatchInfoPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final FootballMatchBloc _footballMatchBloc =
      serviceLocator<FootballMatchBloc>();
  final VideoDetailsBloc _videoDetailsBloc = serviceLocator<VideoDetailsBloc>();

  late FootballMatch match;
  late ScrollController _scrollController;
  bool fixedScroll = false;
  List<Event> events = [];
  bool isAfter = false;
  VideoDetails? highlight;
  bool showHighlight = false;
  YoutubePlayerController? _ytController;
  bool isFavorite = false;
  final FavoriteMatchBloc _favoriteMatchBloc =
      serviceLocator<FavoriteMatchBloc>();
  late TabController _tabController;

  @override
  void dispose() {
    super.dispose();
    if (_ytController != null) _ytController!.dispose();
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.

    super.deactivate();
    if (_ytController != null) _ytController!.pause();
  }

  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    var matchTime = DateTime.parse(widget.match.fixture.date).toLocal();
    isAfter = now.isAfter(matchTime);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    match = widget.match;

    isFavorite = Constant.favoriteList.firstWhereOrNull(
            (element) => element.fixture.id == match.fixture.id) !=
        null;
    _tabController = new TabController(
      vsync: this,
      length: isAfter ? 5 : 3,
    );
    // _tabController.addListener(_smoothScrollToTop);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;

      _smoothScrollToTop();
    });
    // highlight = Constant.recentFeeds.firstWhereOrNull(
    //     (e) => e.competition == "CHAMPIONS LEAGUE: Semifinal");

    // List<String> hightlightTitle = highlight!.title!.split(" - ");
    // List<String> seperateString =
    //     highlight!.competition!.toLowerCase().split(":");
    // bool bothTeamNameSame = (hightlightTitle[0].toLowerCase().split(" ").any(
    //         (element) =>
    //             match.home.name.toLowerCase().split(" ").contains(element)) &&
    //     hightlightTitle[1].toLowerCase().split(" ").any((element) =>
    //         match.away.name.toLowerCase().split(" ").contains(element)));
    // bool isLeagueNameInsteadOfCountry = (seperateString[0]
    //         .split(" ")
    //         .where((element) =>
    //             match.league!.name.toLowerCase().split(" ").contains(element))
    //         .toList()
    //         .length >=
    //     1);
    // RegExp regex = RegExp(
    //     '${seperateString[1].toLowerCase().replaceAll(' ', '').replaceAll('-', '')}(?:s)?');

    // bool isSameRound = match.league!.round != null
    //     ? regex.hasMatch(match.league!.round!
    //         .toLowerCase()
    //         .replaceAll(' ', '')
    //         .replaceAll('-', ''))
    //     : false;
    // bool validationForWorld =
    //     isLeagueNameInsteadOfCountry && bothTeamNameSame && isSameRound;
    // print('country');
    // print(isLeagueNameInsteadOfCountry);
    // print("title");
    // print(bothTeamNameSame);
    // print("team");
    // print(isSameRound);

    highlight = Constant.recentFeeds.firstWhereOrNull((e) {
      List<String> hightlightTitle = e.title!.split(" - ");
      List<String> seperateString = e.competition!.toLowerCase().split(":");
      List<String> homeNameSplit = match.home.name.toLowerCase().split(" ");
      List<String> awayNameSplit = match.away.name.toLowerCase().split(" ");

      bool sameLeagueName = seperateString.length > 1
          ? (match.league!.name.toLowerCase() == seperateString[1].trim())
          : (match.league!.name.toLowerCase() == seperateString[0].trim());
      // bool bothTeamNameSame = (hightlightTitle[0].toLowerCase().split(" ").any(
      //         (element) =>
      //             match.home.name.toLowerCase().split(" ").contains(element)) &&
      //     hightlightTitle[1].toLowerCase().split(" ").any((element) =>
      //         match.away.name.toLowerCase().split(" ").contains(element)));

      bool bothTeamNameSame = hightlightTitle.every((element) {
        return element
                .toLowerCase()
                .split(" ")
                .any((element) => homeNameSplit.contains(element)) ||
            element
                .toLowerCase()
                .split(" ")
                .any((element) => awayNameSplit.contains(element));
      });
      bool countryNameSame = seperateString.length > 0
          ? (seperateString[0] == match.league!.country!.toLowerCase())
          : false;
      bool isLeagueNameInsteadOfCountry = (seperateString.length > 0
          ? seperateString[0]
                  .split(" ")
                  .where((element) => match.league!.name
                      .toLowerCase()
                      .split(" ")
                      .contains(element))
                  .toList()
                  .length >=
              1
          : false);
      String lessThanOneCondition =
          seperateString.length > 1 ? seperateString[1] : seperateString[0];
      RegExp regex = RegExp(
          '${lessThanOneCondition.toLowerCase().replaceAll(' ', '').replaceAll('-', '')}(?:s)?');

      bool isSameRound = match.league!.round != null
          ? regex.hasMatch(match.league!.round!
              .toLowerCase()
              .replaceAll(' ', '')
              .replaceAll('-', ''))
          : false;

      bool validationForLeague =
          sameLeagueName && bothTeamNameSame && (countryNameSame);

      bool validationForWorld =
          isLeagueNameInsteadOfCountry && bothTeamNameSame && isSameRound;
      bool isTrue =
          validationForLeague ? validationForLeague : validationForWorld;

      return isTrue;
    });

    // if (highlight != null) {
    //   _videoDetailsBloc.add(GetYtUrlFromApiRequest(
    //     url: highlight!.videos![0].ytLink!,
    //   ));
    // }
    if (highlight?.videos?.isNotEmpty == true &&
        highlight!.videos![0].ytLink != null) {
      _videoDetailsBloc.add(GetYtUrlFromApiRequest(
        url: highlight!.videos![0].ytLink!,
      ));
    }
  }

  void initialYtController(String url) {
    String? videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId != null) {
      _ytController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            loop: true,
          ));
      showHighlight = true;
    }
  }

  _scrollListener() {
    if (fixedScroll) {
      _scrollController.jumpTo(0);
    }
  }

  _smoothScrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300), 
        curve: Curves.ease,
      );
    }

    // _scrollController.animateTo(
    //   0,
    //   duration: Duration(microseconds: 300),
    //   curve: Curves.ease,
    // );

    setState(() {
      fixedScroll = _tabController.index == 2 || _tabController.index == 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => _footballMatchBloc,
            ),
            BlocProvider(
              create: (context) => _videoDetailsBloc,
            ),
            BlocProvider(
              create: (context) => _favoriteMatchBloc,
            ),
          ],
          child: MultiBlocListener(
            listeners: [
              BlocListener<FavoriteMatchBloc, FavoriteMatchState>(
                listener: (context, state) {
                  if (state is FavoriteMatchPersisted) {
                    if (state.footballMatches) {
                      setState(() {
                        isFavorite = Constant.favoriteList.firstWhereOrNull(
                                (element) =>
                                    element.fixture.id == match.fixture.id) !=
                            null;

                        Flushbar(
                          // title:  "Hey Ninja",
                          backgroundColor: Colors.green,
                          mainButton: Icon(FontAwesomeIcons.circleXmark,
                              color: Colors.white),
                          onTap: (v) {
                            v.dismiss(true);
                          },
                          message: "This match has added in favourite.",
                          margin: EdgeInsets.fromLTRB(8, kToolbarHeight, 8, 8),
                          duration: Duration(seconds: 3),
                        )..show(context);
                      });
                    }
                  }

                  if (state is FavoriteMatchRemoved) {
                    if (state.footballMatches) {
                      setState(() {
                        isFavorite = Constant.favoriteList.firstWhereOrNull(
                                (element) =>
                                    element.fixture.id == match.fixture.id) !=
                            null;
                        Flushbar(
                          // title:  "Hey Ninja",
                          backgroundColor: Constant.color1,
                          mainButton: Icon(FontAwesomeIcons.circleXmark,
                              color: Colors.white),
                          onTap: (v) {
                            v.dismiss(true);
                          },
                          message: "This match has removed from favourite.",
                          margin: EdgeInsets.fromLTRB(8, kToolbarHeight, 8, 8),
                          duration: Duration(seconds: 3),
                        )..show(context);
                      });
                    }
                  }
                },
              ),
              BlocListener<FootballMatchBloc, FootballMatchState>(
                bloc: _footballMatchBloc,
                listener: (context, state) {
                  if (state is MatchEventGet) {
                    setState(() {
                      events = state.stats;
                    });
                  }
                },
              ),
              BlocListener<VideoDetailsBloc, VideoDetailsState>(
                bloc: _videoDetailsBloc,
                listener: (context, state) {
                  if (state is YtUrlFromApiLoaded && _ytController != null) {
                    setState(() {
                      initialYtController(state.url);
                    });
                  }
                },
              ),
            ],
            child: StreamBuilder<List<FootballMatch>>(
                stream: Constant.liveData.stream,
                builder: (context, snapshot) {
                  List<FootballMatch> liveMatches =
                      snapshot.data != null ? snapshot.data! : [];
                  FootballMatch? uMatch = liveMatches.firstWhereOrNull((e) {
                    return e.fixture.id == widget.match.fixture.id;
                  });
                  String statusShort = match.fixture.status.short != null
                      ? match.fixture.status.short!.toLowerCase()
                      : "";
                  match = uMatch != null ? uMatch : widget.match;
                  if (uMatch != null && match.events != null) {
                    events = match.events!;
                  }
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    child: NestedScrollView(
                      headerSliverBuilder: (context, value) {
                        return [
                          SliverToBoxAdapter(
                              child: Column(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.065,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Row(
                                  children: [
                                    Container(
                                      color: Colors.white,
                                      height: 30,
                                      width: 30,
                                      margin: EdgeInsets.only(right: 10),
                                      child: FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image: match.league?.logo ?? '',
                                          imageErrorBuilder: (e, o, c) {
                                            return Container();
                                          }),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  match.league!.id == 1
                                                      ? 'FIFA World Cup(tm)'
                                                      : match.league!.name,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  match.league!.country!,
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (highlight != null)
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            showHighlight = !showHighlight;
                                          });
                                        },
                                        child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Icon(FontAwesomeIcons.video,
                                                color: showHighlight
                                                    ? Constant.color2
                                                    : Colors.white)),
                                      ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (isFavorite) {
                                            _favoriteMatchBloc.add(
                                                RemoveFavoriteMatchRequest(
                                                    match: match));
                                          } else {
                                            _favoriteMatchBloc.add(
                                                PersistFavoriteMatchRequest(
                                                    match: match));
                                          }
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(1),
                                        child: Icon(
                                          isFavorite
                                              ? Icons.star
                                              : Icons.star_border_outlined,
                                          color: Colors.yellow,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              if (showHighlight)
                                BlocBuilder<VideoDetailsBloc,
                                        VideoDetailsState>(
                                    bloc: _videoDetailsBloc,
                                    builder: ((context, state) {
                                      if (state is YtUrlFromApiLoaded && _ytController != null) {
                                        return YoutubePlayerBuilder(
                                            player: YoutubePlayer(
                                              controller: _ytController!,
                                              aspectRatio: 16 / 9,
                                              showVideoProgressIndicator: true,
                                              progressIndicatorColor:
                                                  Constant.color1,
                                              progressColors: ProgressBarColors(
                                                playedColor: Constant.color1,
                                                handleColor: Constant.color1,
                                              ),
                                              bottomActions: [
                                                CurrentPosition(),
                                                ProgressBar(
                                                  isExpanded: true,
                                                  colors: ProgressBarColors(
                                                    playedColor:
                                                        Constant.color1,
                                                    handleColor:
                                                        Constant.color1,
                                                  ),
                                                ),
                                                FullScreenButton(),
                                              ],
                                              onEnded: (v) {},
                                            ),
                                            builder: (v, player) {
                                              return player;
                                            });
                                      } else {
                                        return Container();
                                      }
                                    })),
                              Container(
                                margin: EdgeInsets.all(10),
                                padding: EdgeInsets.all(10),
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
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
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      FootballTeamPage(
                                                    team: match.home,
                                                    league: match.league!,
                                                  ),
                                                ));
                                              },
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                margin:
                                                    EdgeInsets.only(right: 3),
                                                child:
                                                    FadeInImage.memoryNetwork(
                                                        placeholder:
                                                            kTransparentImage,
                                                        image:
                                                            match.home.logoUrl,
                                                        imageErrorBuilder:
                                                            (e, o, c) {
                                                          return Container();
                                                        }),
                                              ),
                                            ),
                                            Text(match.home.name,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            AutoSizeText(
                                                match.fixture.status.short!
                                                                .toLowerCase() !=
                                                            "ns" &&
                                                        match.fixture.status.short!
                                                                .toLowerCase() !=
                                                            "tbd"
                                                    ? (match.goal != null
                                                        ? ((match.goal!.home != null
                                                                ? match
                                                                    .goal!.home!
                                                                    .toString()
                                                                : "0") +
                                                            " -" +
                                                            (match.goal!.away != null
                                                                ? match
                                                                    .goal!.away!
                                                                    .toString()
                                                                : "0"))
                                                        : "0 - 0")
                                                    : DateFormat("hh:mma").format(
                                                        DateTime.parse(match.fixture.date)
                                                            .toLocal()),
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxFontSize: 20,
                                                minFontSize: 14),
                                            Text(
                                              match.fixture.status.short!
                                                              .toLowerCase() !=
                                                          "ns" &&
                                                      match.fixture.status
                                                              .short!
                                                              .toLowerCase() !=
                                                          "tbd"
                                                  ? (statusShort != "ft" &&
                                                          statusShort !=
                                                              "aet" &&
                                                          statusShort != "pen"
                                                      ? (match.fixture.status
                                                              .elapsedTime
                                                              .toString() +
                                                          "'")
                                                      : match
                                                          .fixture.status.long!)
                                                  : DateFormat("d MMM").format(
                                                      DateTime.parse(match
                                                              .fixture.date)
                                                          .toLocal()),
                                              style: TextStyle(
                                                  color: match.fixture.status
                                                                  .short!
                                                                  .toLowerCase() !=
                                                              "ns" &&
                                                          match.fixture.status
                                                                  .short!
                                                                  .toLowerCase() !=
                                                              "tbd"
                                                      ? statusShort != "ft" &&
                                                              statusShort !=
                                                                  "aet" &&
                                                              statusShort !=
                                                                  "pen"
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
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      FootballTeamPage(
                                                    team: match.away,
                                                    league: match.league!,
                                                  ),
                                                ));
                                              },
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                margin:
                                                    EdgeInsets.only(right: 3),
                                                child:
                                                    FadeInImage.memoryNetwork(
                                                        placeholder:
                                                            kTransparentImage,
                                                        image:
                                                            match.away.logoUrl,
                                                        imageErrorBuilder:
                                                            (e, o, c) {
                                                          return Container();
                                                        }),
                                              ),
                                            ),
                                            Text(match.away.name,
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
                          )),
                          SliverToBoxAdapter(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                color: Colors.white,
                                width: 0.8,
                              ))),
                              height: MediaQuery.of(context).size.height * 0.08,
                              width: double.infinity,
                              child: TabBar(
                                  controller: _tabController,
                                  isScrollable: true,
                                  indicatorColor: Colors.transparent,
                                  tabs: [
                                    if (isAfter)
                                      Tab(
                                          icon: Text('Summary',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                    if (isAfter)
                                      Tab(
                                          icon: Text('Stats',
                                              style: TextStyle(
                                                  color: Colors.white))),
                                    Tab(
                                        icon: Text('H2H',
                                            style: TextStyle(
                                                color: Colors.white))),
                                    Tab(
                                        icon: Text('Line-Ups',
                                            style: TextStyle(
                                                color: Colors.white))),
                                    Tab(
                                        icon: Text('Standings',
                                            style: TextStyle(
                                                color: Colors.white))),
                                  ]),
                            ),
                          ),
                        ];
                      },
                      body: TabBarView(
                        // physics: NeverScrollableScrollPhysics(),
                        controller: _tabController,
                        children: [
                          if (isAfter)
                            FootballMatchSummary(
                              match: match,
                              bloc: _footballMatchBloc,
                              events: events,
                            ),
                          if (isAfter)
                            FootballMatchStatsWidget(
                              match: match,
                            ),
                          FootballMatchH2H(
                            bloc: _footballMatchBloc,
                            match: match,
                          ),
                          FootballMatchLineupsWidget(
                            match: match,
                            bloc: _footballMatchBloc,
                            events: events,
                          ),
                          Container(
                            child: FootballMatchStanding(
                              match: match,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
