import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:outline_search_bar/outline_search_bar.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:soccer_sport/core/constant/analytics_service.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/video/domain/entities/video_details.dart';
import 'package:soccer_sport/video/presentation/bloc/video_details_bloc.dart';
import 'package:soccer_sport/video/presentation/page/video_page.dart';
import 'package:soccer_sport/video/presentation/widget/video_list_tile.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:transparent_image/transparent_image.dart';

import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/no_data_widget.dart';
import '../../../injection_container.dart';
import '../widget/recent_video_list_tile.dart';

class VideoListPage extends StatefulWidget {
  const VideoListPage();

  @override
  State<VideoListPage> createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  final VideoDetailsBloc _videoDetailsBloc = serviceLocator<VideoDetailsBloc>();
  List<VideoDetails> videoDetails = [];
  List<String> leagueList = [];
  String searchValue = '';
  List<String> frontList = [
    "FRANCE: Ligue 1",
    "GERMANY: Bundesliga",
    "SPAIN: La Liga",
    "ENGLAND: Premier League"
  ];
  final TextEditingController _controller = TextEditingController();
  final _key1 = GlobalKey();
  final _key2 = GlobalKey();
  @override
  void initState() {
    if (Constant.recentFeeds.length == 0) {
      _videoDetailsBloc.add(GetRecentFeedRequest());
    } else {
      videoDetails = Constant.recentFeeds;
      List<String> removedList = videoDetails
          .where((e) => !(frontList.contains(e.competition!)))
          .map((e) => e.competition ?? '')
          .where((e) => e.isNotEmpty)
          .toSet()
          .toList();
      frontList.forEach((element) {
        var contained =
            videoDetails.firstWhereOrNull((e) => element == e.competition!);
        if (contained != null) {
          removedList.insert(0, element);
        }
      });
      leagueList = removedList;
    }
    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   if (Constant.showcaseBool)
    //     ShowCaseWidget.of(context).startShowCase([
    //       _key1,
    //       _key2,
    //       Constant.statsIcon,
    //     ]);
    // });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _videoDetailsBloc.close();
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _videoDetailsBloc,
      child: BlocListener<VideoDetailsBloc, VideoDetailsState>(
        listener: (context, state) {
          if (state is RecentFeedLoaded) {
            setState(() {
              videoDetails = state.videos;

              List<String> removedList = videoDetails
                  .where((e) => !(frontList.contains(e.competition!)))
                  .map((e) => e.competition ?? '')
                  .where((e) => e.isNotEmpty)
                  .toSet()
                  .toList();
              frontList.forEach((element) {
                removedList.insert(0, element);
              });
              leagueList = removedList;
            });
          }
        },
        child: BlocBuilder<VideoDetailsBloc, VideoDetailsState>(
          builder: (context, state) {
            if (state is LoadingRecentFeed) {
              return LoadingWidget();
            } else if (state is VideoDetailsError) {
              return ErrorsWidget();
            } else {
              // return ListView.builder(
              //     // controller: _scrollController,
              //     itemCount: videoDetails.length,
              //     itemBuilder: (BuildContext context, int index) {
              //       List<VideoDetails> clone = List.from(videoDetails);
              //       return RecentVideoListTile(
              //         videoDetails: videoDetails[index],
              //         clone: clone,
              //       );
              //     });

              return
                  // Showcase(
                  //   key: _key1,
                  //   description:
                  //       "Users can see different league's video & highlight at here.",
                  //   child:
                  

                  leagueList.length > 0 && videoDetails.length > 0
                      ? Column(
                          children: [
                            // Showcase(
                            //   key: _key2,
                            //   description:
                            //       "Users can search desired league's video by enter the league name",
                            //   child:

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: OutlineSearchBar(
                                textEditingController: _controller,
                                onClearButtonPressed: (v) {
                                  setState(() {
                                    searchValue = '';
                                  });
                                },
                                onSearchButtonPressed: (value) {
                                  setState(() {
                                    searchValue = value;
                                  });
                                },
                              ),
                              // ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                  itemCount: searchValue != ''
                                      ? leagueList
                                          .where((e) =>
                                              checkStringArray(e, searchValue))
                                          .toList()
                                          .length
                                      : leagueList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    List<String> filterString =
                                        searchValue != ''
                                            ? leagueList
                                                .where((e) => checkStringArray(
                                                    e, searchValue))
                                                .toList()
                                            : leagueList;
                                    String leagueString = filterString[index];
                                    List<VideoDetails> videos = videoDetails
                                        .where((v) => v.competition != null && v.competition == leagueString)
                                        .toList();

                                    return Container(
                                      color: Colors.grey[900],
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.35,
                                      margin: EdgeInsets.symmetric(
                                          vertical: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02),
                                      padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(leagueString,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16))
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: videos.isEmpty
                                                ? Container(
                                                    decoration: BoxDecoration(),
                                                    child: Center(
                                                        child: Row(
                                                      children: [
                                                        Icon(FontAwesomeIcons
                                                            .circleExclamation),
                                                        Text(
                                                            "This month don't have any highlight video for this league."),
                                                      ],
                                                    )),
                                                  )
                                                : ListView.builder(
                                                    // controller: _scrollController,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount: videos.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      List<VideoDetails> clone =
                                                          List.from(
                                                              videoDetails);
                                                      VideoDetails video =
                                                          videos[index];
                                                      return GestureDetector(
                                                        onTap: () {
                                                          serviceLocator<
                                                                  AnalyticsService>()
                                                              .logScreens(
                                                                  name:
                                                                      '/video/recentvideo/${video.competition}/${video.title}');
                                                          Navigator.of(context)
                                                              .push(
                                                                  MaterialPageRoute(
                                                            builder: (context) =>
                                                                VideoPage(
                                                                    videoDetails:
                                                                        video,
                                                                    clone:
                                                                        clone),
                                                          ));
                                                        },
                                                        child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.8,
                                                            margin:
                                                                EdgeInsets.only(
                                                              right: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.05,
                                                            ),
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                                color: Colors
                                                                    .grey[800]),
                                                            child: Column(
                                                              children: [
                                                                Expanded(
                                                                  flex: 5,
                                                                  child: video.thumbnail !=
                                                                          null
                                                                      ? Container(
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.only(topLeft: const Radius.circular(10.0), topRight: const Radius.circular(10.0)),
                                                                              image: DecorationImage(
                                                                                fit: BoxFit.fill,
                                                                                image: FadeInImage.memoryNetwork(
                                                                                    placeholder: kTransparentImage,
                                                                                    image: video.thumbnail!,
                                                                                    imageErrorBuilder: (e, o, c) {
                                                                                      return Container(
                                                                                        color: Colors.grey,
                                                                                        child: Image.asset('assets/image-loading.jpg'),
                                                                                      );
                                                                                    }).image,
                                                                              )),
                                                                        )
                                                                      : Container(
                                                                          color:
                                                                              Colors.grey,
                                                                          child:
                                                                              Image.asset('assets/image-loading.jpg'),
                                                                        ),
                                                                ),
                                                                Expanded(
                                                                    flex: 2,
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              8),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.stretch,
                                                                        children: [
                                                                          Expanded(
                                                                            flex:
                                                                                2,
                                                                            child:
                                                                                Align(
                                                                              alignment: Alignment.topLeft,
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                                                                child: Text(
                                                                                  video.title != null ? video.title! : "title",
                                                                                  style: TextStyle(
                                                                                    // color: Constant.color2,
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                  maxLines: 2,
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Align(
                                                                            alignment:
                                                                                Alignment.bottomRight,
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsets.only(right: 3, bottom: 3),
                                                                              child: AutoSizeText(
                                                                                  (video.date != null && video.date!.isNotEmpty)
                                                                                      ? timeago.format(DateTime.parse(video.date!).toLocal())
                                                                                      : '',
                                                                                  wrapWords: false,
                                                                                  style: TextStyle(fontSize: 8, color: Colors.grey),
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                ),
                                                                              // child: AutoSizeText(
                                                                              //   timeago.format(DateTime.parse(video.date!).toLocal()),
                                                                              //   wrapWords: false,
                                                                              //   style: TextStyle(fontSize: 8, color: Colors.grey),
                                                                              //   overflow: TextOverflow.ellipsis,
                                                                              // ),
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ))
                                                              ],
                                                            )),
                                                      );
                                                    }),
                                          ),
                                        ],
                                      ),
                                    );
                                    return VideoListtile(
                                        league: filterString[index],
                                        videos: videoDetails);
                                  }),
                            ),
                            // Column(
                            //     children: searchValue != ''
                            //         ? leagueList
                            //             .where(
                            //                 (e) => checkStringArray(e, searchValue))
                            //             .map((e) => VideoListtile(
                            //                 league: e, videos: videoDetails))
                            //             .toList()
                            //         : leagueList
                            //             .map((e) => VideoListtile(
                            //                 league: e, videos: videoDetails))
                            //             .toList()),
                          ],
                        )
                      : NoDataWidget()
                  // );
                  ;
            }
          },
        ),
      ),
    );
  }

  bool checkStringArray(String value, String search) {
    List<String> arrayString = value.split(RegExp(r'[:,]'));
    String? containString = arrayString
        .firstWhereOrNull((element) => element.toLowerCase().contains(search));
    if (containString != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
