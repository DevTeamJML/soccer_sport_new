import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:soccer_sport/favourite/presentation/page/favourite_team_page.dart';
import 'package:soccer_sport/favourite/presentation/widget/favourite_match_tab.dart';
import 'package:soccer_sport/favourite/presentation/widget/favourite_team_dialog.dart';

import '../../../core/constant/analytics_service.dart';
import '../../../core/constant/constants.dart';
import '../../../injection_container.dart';

class FavouritePage extends StatefulWidget {
  FavouritePage({Key? key}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool floatingButton = false;

  late List<Widget> tabList;

  @override
  void didChangeDependencies() {
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    _tabController = new TabController(
      vsync: this,
      length: 2,
    );
    tabList = [
      Tab(
        icon: Text('Match'),
      ),
      // Showcase(
      //   key: Constant.favouriteTeamKey,
      //   description: "Click here to proceed",
      //   overlayPadding: EdgeInsets.symmetric(horizontal: 30),
      //   onTargetClick: () {
      //     _tabController.animateTo(1);
      //   },
      //   onToolTipClick: () {
      //     _tabController.animateTo(1);
      //   },
      //   disposeOnTap: true,
      //   child:
      Tab(
        icon: Text('Team'),
      ),
      // ),
    ];
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          if (_tabController.index == 1) {
            floatingButton = true;
            serviceLocator<AnalyticsService>()
                .logScreens(name: '/favourite/team');
          } else {
            floatingButton = false;
            serviceLocator<AnalyticsService>()
                .logScreens(name: '/favourite/match');
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favourite",
        ),
        centerTitle: true,
        bottom: TabBar(controller: _tabController, tabs: tabList),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FavouriteMatchTab(),
          FavouriteTeamPage(),
        ],
      ),
      // floatingActionButton: floatingButton
      //     ? FloatingActionButton(
      //         backgroundColor: Constant.color1,
      //         child: Icon(
      //           Icons.add,
      //           color: Colors.white,
      //           size: 20,
      //         ),
      //         onPressed: () {
      //           showDialog(
      //             context: context,
      //             builder: (BuildContext context) {
      //               return FavouriteTeamDialog();
      //             },
      //           );
      //         },
      //       )
      //     : null,
    );
  }
}
