import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:soccer_sport/core/constant/analytics_service.dart';
import 'package:soccer_sport/injection_container.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../core/constant/constants.dart';
import '../../domain/entities/video_details.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../page/video_page.dart';

class RecentVideoListTile extends StatelessWidget {
  final VideoDetails videoDetails;
  final List<VideoDetails> clone;
  const RecentVideoListTile({required this.videoDetails, required this.clone});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Constant.backgroundColor,
        shadowColor: Colors.grey,
        child: GestureDetector(
          onTap: () {
            serviceLocator<AnalyticsService>().logScreens(
                name:
                    '/video/recentvideo/${videoDetails.competition}/${videoDetails.title}');
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  VideoPage(videoDetails: videoDetails, clone: clone),
            ));
          },
          child: Container(
            padding: EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height * 0.125,
            child: Row(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    padding: EdgeInsets.only(right: 5),
                    child: Stack(
                      children: [
                        // Image.asset('assets/image-loading.jpg'),
                        videoDetails.thumbnail != null
                            ? Center(
                                child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: videoDetails.thumbnail!,
                                    imageErrorBuilder: (e, o, c) {
                                      return Container(
                                        color: Colors.grey,
                                        child: Image.asset(
                                            'assets/image-loading.jpg'),
                                      );
                                    }),
                              )
                            : Center(
                                child: Container(
                                  color: Colors.grey,
                                  child:
                                      Image.asset('assets/image-loading.jpg'),
                                ),
                              )
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: AlignmentDirectional.topStart,
                              child: AutoSizeText(
                                videoDetails.title!,
                                textAlign: TextAlign.start,
                                wrapWords: false,
                                style: TextStyle(
                                  color: Constant.color2,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          // Text(
                          //   news.description!,
                          //   style: TextStyle(fontSize: 12),
                          //   overflow: TextOverflow.ellipsis,
                          //   maxLines: 3,
                          // ),

                          Expanded(
                            flex: 1,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    alignment:
                                        AlignmentDirectional.bottomCenter,
                                    child: AutoSizeText(
                                      timeago.format(
                                          DateTime.parse(videoDetails.date!)
                                              .toLocal()),
                                      wrapWords: false,
                                      style: TextStyle(fontSize: 11),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ]),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ));
  }
}
