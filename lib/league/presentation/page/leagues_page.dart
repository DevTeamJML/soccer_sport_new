import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:soccer_sport/core/constant/analytics_service.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/widgets/loading_dialog.dart';
import 'package:soccer_sport/league/domain/entities/league_details.dart';
import 'package:soccer_sport/league/presentation/widget/league_selection_dialog.dart';
import 'package:soccer_sport/league/presentation/widget/league_view.dart';
import 'package:collection/collection.dart'; // You have to add this manually, for some reason it cannot be added automatically

import '../../../injection_container.dart';

class LeaguePage extends StatefulWidget {
  @override
  _LeaguePageState createState() => _LeaguePageState();
}

class _LeaguePageState extends State<LeaguePage>
    with
        // AutomaticKeepAliveClientMixin<LeaguePage>,
        SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<LeagueDetails> leagueList = [];
  @override
  void initState() {
    super.initState();
    serviceLocator<AnalyticsService>().logScreens(name: '/statsPage');

    leagueList = List<LeagueDetails>.from(Constant.staticLeagues);
    final eplIndex =
        leagueList.indexWhere((element) => element.league.id == 39);
    final wcIndex = leagueList.indexWhere((element) => element.league.id == 1);
    final epl = leagueList[eplIndex];
    final wc = leagueList[wcIndex];
    leagueList.remove(epl);
    leagueList.remove(wc);
    leagueList.insert(0, epl);
    leagueList.insert(4, wc);
    if (Constant.auth != null) {
      List<LeagueDetails> cloneList = leagueList
          .where((element) => Constant.customerRewardDetail!.leagues
              .contains(element.league.id))
          .toList();
      leagueList.removeWhere((element) => cloneList.contains(element));
      leagueList.insertAll(0, cloneList);
    }
    _tabController = new TabController(
      vsync: this,
      length: leagueList.length,
    );
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        serviceLocator<AnalyticsService>().logScreens(
            name: '/statsPage/' + leagueList[_tabController.index].league.name);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Stats'),
        // bottom: TabBar(isScrollable: true, tabs: [
        //   Tab(icon: Text('EPL')),
        //   Tab(icon: Text('Laliga')),
        //   Tab(icon: Text('Bundesliga')),
        //   Tab(icon: Text('Ligue')),
        // ]),

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: tabBarWidget(leagueList),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return LeagueSelectionDialog(
                        selectedFunction: (int id) {
                          _tabController.index = leagueList.indexWhere((curr) {
                            return curr.league.id == id;
                          });
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  );
                },
                child:

                    //  Showcase(
                    //   key: Constant.dropdownButtonKey,
                    //   description:
                    //       "In statistic page, users can select up to 100 different league to see statistic. So users can click here to search and choose the desired league instead of scrolling it.",
                    //   child:

                    Container(
                  height: 30,
                  width: 40,
                  padding: EdgeInsets.only(right: 5),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Constant.color1.withOpacity(0.2),
                      Constant.color1
                    ]),
                  ),
                  alignment: Alignment.centerRight,
                  child: Icon(
                    FontAwesomeIcons.chevronDown,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              // ),
            ],
          ),
        ),
      ),
      body: TabBarView(
          controller: _tabController,
          children: leagueList.map((e) {
            return LeagueView(
              leagueDetails: e,
            );
          }).toList()),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

List<Widget> tabBarWidget(List<LeagueDetails> leagues) {
  return leagues
      .map((e) => Tab(
            icon: Text(e.league.id == 1 ? 'FIFA World Cup(tm)' : e.league.name),
          ))
      .toList();
}

//malaysia super league is 278, premier league is 279
