import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soccer_sport/core/constant/analytics_service.dart';
import 'package:soccer_sport/core/widgets/error_widget.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/injection_container.dart';
import 'package:soccer_sport/video/presentation/bloc/video_details_bloc.dart';
import 'package:soccer_sport/video/presentation/page/live_video_page.dart';
import 'package:soccer_sport/video/presentation/page/recent_video_page.dart';
import 'package:soccer_sport/video/presentation/page/video_list_page.dart';
import 'package:http/http.dart' as http;

import '../../../core/constant/constants.dart';

class VideoTabbar extends StatefulWidget {
  @override
  State<VideoTabbar> createState() => _VideoTabbarState();
}

class _VideoTabbarState extends State<VideoTabbar>
    with AutomaticKeepAliveClientMixin<VideoTabbar>, TickerProviderStateMixin {
  TabController? _tabController;
  int initialTab = 0;
  List<Widget> tabList = [
    // Tab(
    //   icon: Text('Live'),
    // ),
    Tab(
      icon: Text('Recent Video'),
    ),
  ];
  @override
  void initState() {
    initialTab = Constant.initialIndex;
    if (Constant.isLive){
    tabList.add(
        Tab(
          icon: Text('Live'),
        ),
      );
          initialTab = 1;

    }
  
    _tabController = new TabController(
      initialIndex: initialTab,
      vsync: this,
      length: Constant.isLive ? 2 : 1,
    );
    Constant.initialIndex = 1;
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      // _videoDetailsBloc.add(CheckSscLiveRequest());

      // check_ssc_live();
      // if (isLive)
      //   tabList.add(
      //     Tab(
      //       icon: Text('Live'),
      //     ),
      //   );
      // _tabController = new TabController(
      //   vsync: this,
      //   length: isLive ? 1 : 2,
      // );
    });

    // _tabController.addListener(() {
    //   if (_tabController.indexIsChanging) {
    //     switch (_tabController.index) {
    //       case 2:
    //         serviceLocator<AnalyticsService>().logScreens(name: '/video/live');
    //         break;
    //       case 0:
    //         serviceLocator<AnalyticsService>()
    //             .logScreens(name: '/video/recentvideo');
    //         break;
    //       default:
    //         break;
    //     }
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return BlocProvider(
    //   // create: (context) => _videoDetailsBloc,
    //   child: BlocListener<VideoDetailsBloc, VideoDetailsState>(
    //     listener: (context, state) {
    //       if (state is SscLiveChecked) {
    //         setState(() {
    //           isLive = state.isLive;

    //         });
    //       }
    //     },
    //     child: BlocBuilder<VideoDetailsBloc, VideoDetailsState>(
    //       builder: (context, state) {
    //         if (state is CheckingSscLive) {
    //           return LoadingWidget();
    //         } else if (state is VideoDetailsError) {
    //           return ErrorsWidget();
    //         } else {
    //           if (_tabController != null) {
    //             return Scaffold(
    //               appBar: AppBar(
    //                 title: TabBar(controller: _tabController, tabs: tabList),
    //                 centerTitle: true,
    //               ),
    //               body: TabBarView(
    //                 physics: NeverScrollableScrollPhysics(),
    //                 controller: _tabController,
    //                 children: [
    //                   // LiveVideoPage(),
    //                   // RecentVideoPage(),
    //                   VideoListPage(),
    //                   if (isLive) LiveVideoPage(),
    //                 ],
    //               ),
    //             );
    //           } else {
    //             return Scaffold(
    //               appBar: AppBar(
    //                 title: Text("Recent Video"),
    //                 centerTitle: true,
    //               ),
    //               body: VideoListPage(),
    //             );
    //           }
    //         }
    //       },
    //     ),
    //   ),
    // );
    return Scaffold(
      appBar: AppBar(
        title: TabBar(controller: _tabController, tabs: tabList),
        centerTitle: true,
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          // LiveVideoPage(),
          // RecentVideoPage(),
          VideoListPage(),
          if (Constant.isLive) LiveVideoPage(),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
