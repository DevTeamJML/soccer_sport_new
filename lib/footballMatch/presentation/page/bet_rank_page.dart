import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/footballMatch/domain/entities/bet_ranking/bet_ranking.dart';
import 'package:soccer_sport/footballMatch/presentation/bloc/football_match_bloc.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/bet_rank_listtile.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/dialog/rank_rewards_dialog.dart';
import 'package:soccer_sport/injection_container.dart';

class BetRankPage extends StatefulWidget {
  // const BetRankPage({super.key});

  @override
  State<BetRankPage> createState() => _BetRankPageState();
}

class _BetRankPageState extends State<BetRankPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<BetRanking> betRanking = [];
  List<BetRanking> winCountRanking = [];
  BetRanking? myWinCount;
  BetRanking? myBetCount;

  final FootballMatchBloc _footballMatchBloc =
      serviceLocator<FootballMatchBloc>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(
      vsync: this,
      length: 2,
    );

    _footballMatchBloc.add(GetBetRankingRequest());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Ranking"),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () async {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            Padding(
              padding: EdgeInsets.all(5),
              child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return RankRewardsDialog();
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 139, 0, 0),
                      shadowColor: Colors.white,
                      side: BorderSide(color: Colors.white, width: 0.2)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return LinearGradient(
                            colors: [Color(0xffdc9139), Color(0xfffff514)],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ).createShader(bounds);
                        },
                        child: Icon(
                          Icons.emoji_events,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      Text("Reward")
                    ],
                  )),
            )
          ],
          // bottom: TabBar(
          //     controller: _tabController, isScrollable: true, tabs: [

          //     ]),
        ),
        body: BlocProvider(
          create: (context) => _footballMatchBloc,
          child: BlocListener<FootballMatchBloc, FootballMatchState>(
            listener: (context, state) {
              // TODO: implement listener

              if (state is BetRankLoaded) {
                setState(() {
                  betRanking = List<BetRanking>.from(state.bet);
                  winCountRanking = List<BetRanking>.from(state.bet);

                  winCountRanking.sort((a, b) {
                    if (a.total_win < b.total_win) {
                      return 1;
                    } else if (a.total_win > b.total_win) {
                      return -1;
                    } else {
                      if (a.last_bet > b.last_bet) {
                        return 1;
                      } else {
                        return -1;
                      }
                    }
                  });

                  betRanking.sort((a, b) {
                    if (a.total_coin < b.total_coin) {
                      return 1;
                    } else if (a.total_coin > b.total_coin) {
                      return -1;
                    } else {
                      if (a.last_bet > b.last_bet) {
                        return 1;
                      } else {
                        return -1;
                      }
                    }
                  });

                  if (Constant.auth != null) {
                    myWinCount = winCountRanking.firstWhereOrNull(
                        (element) => element.name == Constant.auth!.username);
                    myBetCount = betRanking.firstWhereOrNull(
                        (element) => element.name == Constant.auth!.username);
                  }
                });
              }
            },
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: SegmentedTabControl(
                    controller: _tabController,
                    backgroundColor: Colors.grey[700],
                    tabTextColor: Colors.white,
                    selectedTabTextColor: Colors.white,
                    indicatorColor: Constant.color1,
                    tabs: [
                      SegmentTab(
                        label: "Win Count",
                      ),
                      SegmentTab(
                        label: "Coin Amount",
                      ),
                    ],
                  ),
                ),

                BlocBuilder<FootballMatchBloc, FootballMatchState>(
                  builder: (context, state) {
                    if (state is LoadingBetRank) {
                      return Expanded(
                          child: Center(
                        child: LoadingWidget(),
                      ));
                    } else if (state is FootballMatchesError) {
                      return ErrorWidget(state.message);
                    } else {
                      return Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            betRankTabView(winCountRanking, myWinCount, true),
                            betRankTabView(betRanking, myBetCount, false)
                          ],
                        ),
                      );
                    }
                  },
                )
                // SegmentedTabControl(
                //   controller: _tabController,
                //   backgroundColor: Colors.grey.shade300,
                //   indicatorColor: Colors.orange.shade200,
                //   tabTextColor: Colors.black45,
                //   selectedTabTextColor: Colors.white,
                //   tabs: [
                //     SegmentTab(
                //       label: 'ACCOUNT',
                //       color: Colors.red.shade200,
                //     ),
                //     SegmentTab(
                //       label: 'HOME',
                //       backgroundColor: Colors.blue.shade100,
                //       selectedTextColor: Colors.black45,
                //       textColor: Colors.black26,
                //     ),
                //     const SegmentTab(label: 'NEW'),
                //   ],
                // ),
                // ListView.builder(
                // itemCount: 1,
                // itemBuilder: (context, index) {
                //   return Container();
                // }),
              ],
            ),
          ),
        ));
  }

  Widget betRankTabView(
      List<BetRanking> betRank, BetRanking? myRanking, bool winCount) {
    return Column(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text("My Ranking",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 21)),
                ),
              ],
            ),
            if (myRanking != null)
              BetRankListtile(
                betRanking: myRanking,
                index: betRank.indexOf(myRanking) + 1,
                isWinCount: winCount,
                isMe: true,
              ),
            if (myRanking == null)
              Container(
                  margin: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.01,
                      horizontal: MediaQuery.of(context).size.width * 0.02),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Constant.color2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "You haven't participate in this game yet.",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      )
                    ],
                  ))
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Global Ranking",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 21)),
                ],
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: betRank.length,
                    itemBuilder: (context, index) {
                      BetRanking rank = betRank[index];
                      return BetRankListtile(
                        betRanking: rank,
                        index: index + 1,
                        isWinCount: winCount,
                      );
                    }),
              ),
            ],
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: double.infinity,
          padding: EdgeInsets.only(
            top: 20,
            left: 10,
            right: 10,
          ),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Terms & Conditions",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Text(
                "1) Only users with verified email can participate the bet ranking leaderboard",
                textAlign: TextAlign.start,
                style: TextStyle(wordSpacing: 5),
              ),
              Text(
                "2) The leaderboard starts on April 5, ends on October 5. The leaderboard points wouldn't increase before and after the event if user's bet has won.",
                textAlign: TextAlign.start,
              ),
              Text(
                "3) If two or more users get the same score, the user who claim the bet won first will get a higher rank than the user with the same score.",
                textAlign: TextAlign.start,
              ),
            ],
          ),
        )
      ],
    );
  }
}
