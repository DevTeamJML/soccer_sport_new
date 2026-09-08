import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/bet_list.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_incoming_match_list.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_match_list.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';

import '../../../core/constant/analytics_service.dart';
import '../../../injection_container.dart';

class FootballMatchTabBarView extends StatefulWidget {
  final LeagueDetails league;

  const FootballMatchTabBarView({required this.league});

  @override
  State<FootballMatchTabBarView> createState() =>
      _FootballMatchTabBarViewState();
}

class _FootballMatchTabBarViewState extends State<FootballMatchTabBarView>
    with SingleTickerProviderStateMixin
// with AutomaticKeepAliveClientMixin<FootballMatchTabBarView>
{
  late TabController _tabController;
  List<int> availableBets = [39, 61, 78, 140];
  final GlobalKey _tabKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(
      vsync: this,
      // length: availableBets.contains(widget.league.league.id) ? 3 : 2,
      length: 2,
    );
    // tabList.addAll(tabBarWidget(leagueList, _tabController));
  }

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Padding(
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Constant.color2,
              height: 40,
              child: TabBar(
                  key: _tabKey,
                  controller: _tabController,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 3, color: Colors.white),
                  ),
                  tabs: [
                    Tab(
                        icon: Text('Match',
                            style: TextStyle(color: Colors.black))),
                    if (widget.league.league.id == 39)
                      Showcase(
                        key: Constant.matchIncomingKey,
                        description: "Click here to proceed",
                        onTargetClick: () {
                          setState(() {
                            _tabController.index = 1;
                          });
                        },
                        onToolTipClick: () {
                          setState(() {
                            _tabController.index = 1;
                          });
                        },
                        disposeOnTap: true,
                        // overlayPadding: EdgeInsets.symmetric(horizontal: 30),
                        child: Tab(
                            icon: Text('Incoming',
                                style: TextStyle(color: Colors.black))),
                      ),
                    if (widget.league.league.id != 39)
                      Tab(
                          icon: Text('Incoming',
                              style: TextStyle(color: Colors.black))),
                    // if (widget.league.league.id == 39)
                    //   Showcase(
                    //     key: Constant.matchBetKey,

                    //     description:
                    //         "Users can see list of the matches that has been bet, and the result of bet",
                    //     // overlayPadding: EdgeInsets.symmetric(horizontal: 30),
                    //     child: Tab(
                    //         icon: Text('Bet Log',
                    //             style: TextStyle(color: Colors.black))),
                    //   ),
                    // if (widget.league.league.id != 39 &&
                    //     availableBets.contains(widget.league.league.id))
                    //   Tab(
                    //       icon: Text('Bet Log',
                    //           style: TextStyle(color: Colors.black))),
                  ]),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  FootballMatchList(
                    league: this.widget.league,
                  ),
                  FootballIncomingMatchList(
                    league: this.widget.league,
                  ),
                  // if (availableBets.contains(widget.league.league.id))
                  //   BetList(id: this.widget.league.league.id)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
