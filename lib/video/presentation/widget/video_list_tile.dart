import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:soccer_sport/core/constant/analytics_service.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/injection_container.dart';
import 'package:soccer_sport/video/domain/entities/video_details.dart';
import 'package:soccer_sport/video/presentation/page/video_page.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:timeago/timeago.dart' as timeago;

class VideoListtile extends StatefulWidget {
  final String league;
  final List<VideoDetails> videos;

  const VideoListtile({required this.league, required this.videos});

  @override
  State<VideoListtile> createState() => _VideoListtileState();
}

class _VideoListtileState extends State<VideoListtile> {
  late List<VideoDetails> videos;
  late List<VideoDetails> allVideos;
  @override
  void initState() {
    super.initState();
    videos =
        widget.videos.where((v) => v.competition == widget.league).toList();
    allVideos = widget.videos;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      height: MediaQuery.of(context).size.height * 0.35,
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.02),
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.05,
          top: MediaQuery.of(context).size.height * 0.01,
          bottom: MediaQuery.of(context).size.height * 0.02),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(widget.league,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                // controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: videos.length,
                itemBuilder: (BuildContext context, int index) {
                  List<VideoDetails> clone = List.from(allVideos);
                  VideoDetails video = videos[index];
                  return GestureDetector(
                    onTap: () {
                      serviceLocator<AnalyticsService>().logScreens(
                          name:
                              '/video/recentvideo/${video.competition}/${video.title}');
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            VideoPage(videoDetails: video, clone: clone),
                      ));
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.05,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey[800]),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 5,
                              child: video.thumbnail != null
                                  ? Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft:
                                                  const Radius.circular(10.0),
                                              topRight:
                                                  const Radius.circular(10.0)),
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: FadeInImage.memoryNetwork(
                                                placeholder: kTransparentImage,
                                                image: video.thumbnail!,
                                                imageErrorBuilder: (e, o, c) {
                                                  return Container(
                                                    color: Colors.grey,
                                                    child: Image.asset(
                                                        'assets/image-loading.jpg'),
                                                  );
                                                }).image,
                                          )),
                                    )
                                  : Container(
                                      color: Colors.grey,
                                      child: Image.asset(
                                          'assets/image-loading.jpg'),
                                    ),
                            ),
                            Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Text(
                                              video.title != null
                                                  ? video.title!
                                                  : "title",
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
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: 3, bottom: 3),
                                          child: AutoSizeText(
                                            timeago.format(
                                                DateTime.parse(video.date!)
                                                    .toLocal()),
                                            wrapWords: false,
                                            style: TextStyle(
                                                fontSize: 8,
                                                color: Colors.grey),
                                            overflow: TextOverflow.ellipsis,
                                          ),
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
  }
}
