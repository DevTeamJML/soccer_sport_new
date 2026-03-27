import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/footballMatch/presentation/page/football_match_page.dart';
import 'package:soccer_sport/news/domain/entities/news.dart';
import 'package:soccer_sport/news/presentation/pages/news_view_page.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';
import 'package:wordpress_api/wordpress_api.dart';

class LatestNewsListtile extends StatelessWidget {
  final News news;
  const LatestNewsListtile({required this.news});

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Constant.backgroundColor,
        shadowColor: Colors.grey,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NewsViewPage(news: news),
            ));
          },
          child: Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width * 0.6,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                      child: news.image != null
                          ? Center(
                              child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: news.image!,
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
                                child: Image.asset('assets/image-loading.jpg'),
                              ),
                            )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        alignment: AlignmentDirectional.topStart,
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          news.title!,
                          textAlign: TextAlign.start,
                          // wrapWords: false,
                          // minFontSize: 8,
                          style: TextStyle(
                            color: Constant.color2,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Text(
                      //   news.description!,
                      //   style: TextStyle(fontSize: 12),
                      //   overflow: TextOverflow.ellipsis,
                      //   maxLines: 3,
                      // ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.01,
                        ),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.027,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Stack(
                                      alignment: Alignment.centerRight,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              physics: ClampingScrollPhysics(),
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  news.categories!.length + 1,
                                              itemBuilder: (context, index) {
                                                if (index ==
                                                    news.categories!.length) {
                                                  return Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.05,
                                                  );
                                                } else {
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 2),
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 4),
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[800],
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(8.0),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          news.categories![
                                                              index],
                                                          style: TextStyle(
                                                              fontSize: 9,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                            right: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                          ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.1,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [
                                              Constant.backgroundColor
                                                  .withOpacity(0.0),
                                              Constant.backgroundColor
                                                  .withOpacity(0.5),
                                              Constant.backgroundColor
                                                  .withOpacity(1),
                                            ]),
                                          ),
                                        ),
                                      ]),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(2),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.12,
                                    // height: MediaQuery.of(context).size.height * 0.01,
                                    alignment:
                                        AlignmentDirectional.bottomCenter,
                                    child: AutoSizeText(
                                      timeago.format(
                                          DateTime.parse(news.date!).toLocal()),
                                      wrapWords: false,
                                      minFontSize: 2,
                                      // style: TextStyle(fontSize: 11),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                              ]),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
