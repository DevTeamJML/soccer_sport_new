import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:soccer_sport/authentication/presentation/page/login_page.dart';
import 'package:soccer_sport/banner/domain/entities/banner.dart';
import 'package:soccer_sport/banner/presentation/page/christmas_event_rule.dart';
import 'package:soccer_sport/core/constant/analytics_service.dart';
import 'package:soccer_sport/core/widgets/error_widget.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/core/widgets/no_data_widget.dart';
import 'package:soccer_sport/landingPage/presentation/page/bet_guide.dart';
import 'package:soccer_sport/landingPage/presentation/page/way_to_earn_coin.dart';
import 'package:soccer_sport/landingPage/presentation/widget/cny_event_page.dart';
import 'package:soccer_sport/landingPage/presentation/widget/daily_claims_dialog.dart';
import 'package:soccer_sport/landingPage/presentation/widget/daily_claims_page.dart';
import 'package:soccer_sport/lucky_draw/presentation/page/lucky_draw_page.dart';
import 'package:soccer_sport/news/domain/entities/news.dart';
import 'package:soccer_sport/news/presentation/bloc/news_bloc.dart';
import 'package:soccer_sport/news/presentation/pages/news_view_page.dart';
import 'package:soccer_sport/news/presentation/widget/event_not_started.dart';
import 'package:soccer_sport/news/presentation/widget/latest_news_listtile.dart';
import 'package:soccer_sport/news/presentation/widget/news_list_tile.dart';
import 'package:soccer_sport/setting/presentation/page/sign_up_page.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

import '../../../banner/presentation/widget/banner_widget.dart';
import '../../../core/constant/constants.dart';
import '../../../injection_container.dart';

class NewsListView extends StatefulWidget {
  NewsListView({Key? key}) : super(key: key);

  @override
  _NewsListViewState createState() => _NewsListViewState();
}

class _NewsListViewState extends State<NewsListView> {
  final _scrollController = ScrollController();
  final NewsBloc _newsBloc = serviceLocator<NewsBloc>();
  final _key1 = GlobalKey();
  final _key2 = GlobalKey();

  final _key3 = GlobalKey();

  String bannerHTML = '';
  // List<News> news = [];
  // List<News> latestNews = [];
  int _current_page = 1;
  bool current_no_data = false;
  List<int> _imgList = [];
  int _current_slide = 0;
  DateTime today = DateTime.now().toLocal();
  final CarouselController _controller = CarouselController();
  // int _curPage = AppApi.kDefaultPage;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback(
      (_) {
        if (Constant.staticNews.isEmpty && Constant.staticLatestNews == null) {
          _newsBloc.add(GetNewsRequest(page: _current_page.toString()));
        }

        // if (Constant.eventBanner != null && Constant.newsBanner != null) {
        //   bannerHTML = Constant.isMember
        //       ? Constant.eventBanner!.url != null
        //           ? Constant.eventBanner!.url!
        //           : ''
        //       : Constant.newsBanner!.url != null
        //           ? Constant.newsBanner!.url!
        //           : '';
        // }

        _scrollController.addListener(_handleScrollNotification);
        _imgList = Iterable<int>.generate(listOfSlider().length).toList();
        // if (Constant.showcaseBool)
        //   ShowCaseWidget.of(context)
        //       .startShowCase([_key1, _key2, Constant.matchIcon]);
      },
    );

    super.initState();
  }

  void _handleScrollNotification() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      this._fetchRecords();
    }
  }

  @override
  void dispose() {
    _newsBloc.close();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    // monitor network fetch
    _newsBloc.add(RefreshNewsRequest());
    return Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    // _refreshController.refreshCompleted();
  }

  void _fetchRecords() {
    setState(() {
      _current_page++;
      _newsBloc.add(LoadNewsRequest(page: _current_page.toString()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewsBloc>(
      create: (context) => _newsBloc,
      child: BlocListener<NewsBloc, NewsState>(
        listener: (context, state) {
          if (state is NewsLoaded) {
            setState(() {
              // Constant.staticNews = state.news;
              List<News> clone = List<News>.from(state.news);
              List<News> clone2 = List<News>.from(state.news);

              Constant.staticLatestNews = clone[0];

              Constant.staticNews = clone2;
            });
          }

          if (state is PaginationNewsLoaded) {
            setState(() {
              if (state.news.length == 0) {
                current_no_data = true;
              } else {
                Constant.staticNews.addAll(state.news);
              }
            });
          }
          // if (state is RefreshNewsLoaded) {
          //   print('got run refresh ');
          //   state.news.forEach((element) {
          //     if (!(news.contains(element))) {
          //       setState(() {
          //         news.insert(0, element);
          //       });
          //     }
          //   });
          // }
        },
        child: BlocBuilder<NewsBloc, NewsState>(
          bloc: _newsBloc,
          buildWhen: (pv, curr) {
            return !(pv is NewsLoaded && curr is LoadAllNews);
          },
          builder: (context, state) {
            if (state is LoadAllNews) {
              return Center(child: LoadingWidget());
            } else if (state is NewsError) {
              return ErrorsWidget();
            } else {
              if (Constant.staticNews.length > 0
                  // &&
                  // Constant.staticLatestNews.length > 0
                  ) {
                return SingleChildScrollView(
                  controller: _scrollController,
                  physics: ScrollPhysics(),
                  child: Column(children: [
                    // Container(
                    //     height: MediaQuery.of(context).size.height * 0.3,
                    //     child: Column(children: [
                    //       Expanded(
                    //         child: CarouselSlider.builder(
                    //           itemCount: listOfSlider().length,
                    //           options: CarouselOptions(
                    //             aspectRatio: 2.0,
                    //             enlargeCenterPage: true,
                    //             initialPage: 0,
                    //             autoPlay: true,
                    //             autoPlayInterval: Duration(seconds: 8),
                    //             autoPlayAnimationDuration:
                    //                 Duration(milliseconds: 800),
                    //             autoPlayCurve: Curves.fastOutSlowIn,
                    //             onPageChanged: (index, reason) {
                    //               setState(() {
                    //                 _current_slide = index;
                    //               });
                    //             },
                    //             scrollDirection: Axis.horizontal,
                    //           ),
                    //           itemBuilder: (BuildContext context, int itemIndex,
                    //               int pageViewIndex) {
                    //             // if (itemIndex == 0) {
                    //             //   return Container(
                    //             //     child: Image.asset('assets/Slide1.JPG'),
                    //             //   );
                    //             // } else if (itemIndex == 1) {
                    //             //   return Container(color: Colors.grey);
                    //             // } else {
                    //             //   return Container(color: Colors.blue);
                    //             // }
                    //             return listOfSlider()[itemIndex];
                    //           },
                    //         ),
                    //       ),
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: _imgList.map((entry) {
                    //           return GestureDetector(
                    //             onTap: () => _controller.animateToPage(entry),
                    //             child: Container(
                    //               width: 12.0,
                    //               height: 12.0,
                    //               margin: EdgeInsets.symmetric(
                    //                   vertical: 8.0, horizontal: 4.0),
                    //               decoration: BoxDecoration(
                    //                   shape: BoxShape.circle,
                    //                   color: Colors.grey.withOpacity(
                    //                       _current_slide == entry ? 0.9 : 0.4)),
                    //             ),
                    //           );
                    //         }).toList(),
                    //       ),
                    //     ])),
                    // ),

                    // BannerWidget(
                    //     imgSrc:
                    //         'http://soccersport.club/wp-content/uploads/2022/10/20221004_SSC-Play-store-728x90-1.jpg'),

                    // Container(
                    //   height: MediaQuery.of(context).size.height * 0.02,
                    // ),
                    // Container(
                    //   // child: Image.asset('assets/Slide1.JPG'),
                    //   child: FadeInImage.memoryNetwork(
                    //       placeholder: kTransparentImage,
                    //       image:
                    //           'https://soccersport.club/wp-content/uploads/2022/18/news_event.jpg',
                    //       imageErrorBuilder: (e, o, c) {
                    //         return Container();
                    //       }),
                    // ),

                    Container(
                      height:
                          (((MediaQuery.of(context).size.height * 0.135) + 10) *
                                  Constant.staticNews.length) +
                              (MediaQuery.of(context).size.height * 0.05),
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: Constant.staticNews.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (Constant.staticNews.length == index) {
                            if (current_no_data) {
                              return Container();
                            } else {
                              return Center(
                                child: Container(
                                    child: CircularProgressIndicator()),
                              );
                            }
                          } else {
                            return NewsListTile(
                              news: Constant.staticNews[index],
                            );
                          }
                        },
                      ),
                    ),
                    // ),
                  ]),
                );
              } else {
                return NoDataWidget();
              }
            }
          },
        ),
      ),
    );
  }

  List<Widget> listOfSlider() {
    return [
      // if (Constant.p6_registered == false)
      //   GestureDetector(
      //     onTap: () async {
      //       if (Constant.auth != null) {
      //         if (await canLaunch(
      //             "https://soccersport.club/p6-registration/")) {
      //           if (Constant.auth != null) {
      //             String url =
      //                 'https://soccersport.club/wp-json/wl/v1/p6_track?id=${Constant.auth!.id}';
      //             final response = await http.get(Uri.parse(url), headers: {
      //               "content-type": 'application/json',
      //             });

      //             if (response.statusCode == 200) {
      //               // this mean that we are connected to the data base
      //               print('satus is 220 ');
      //               serviceLocator<AnalyticsService>()
      //                   .logScreens(name: '/p6-registration');
      //               await launch("https://soccersport.club/p6-registration/");
      //             } else {
      //               print('satus is not 220 ');

      //               serviceLocator<AnalyticsService>()
      //                   .logScreens(name: '/p6-registration');
      //               await launch("https://soccersport.club/p6-registration/");
      //             }
      //           } else {
      //             print('auth  is null ');

      //             serviceLocator<AnalyticsService>()
      //                 .logScreens(name: '/p6-registration');
      //             await launch("https://soccersport.club/p6-registration/");
      //           }
      //         } else {
      //           throw 'Could not launch https://soccersport.club/p6-registration/';
      //         }
      //       } else {
      //         Navigator.of(context).push(
      //           MaterialPageRoute(builder: (context) => LoginPage()),
      //         );
      //       }
      //     },
      //     child: Container(
      //       // child: Image.asset('assets/Slide1.JPG'),
      //       child: FadeInImage.memoryNetwork(
      //           placeholder: kTransparentImage,
      //           image:
      //               'https://soccersport.club/wp-content/uploads/2022/18/p6_banner.jpg',
      //           imageErrorBuilder: (e, o, c) {
      //             return Container();
      //           }),
      //     ),
      //   ),

      // if ((today
      //     .toLocal()
      //     .difference(DateTime.fromMillisecondsSinceEpoch(1675699200000))
      //     .isNegative))
      //   cnyEventSlide(),
      luckDrawSlide(),
      eventSlide(),

      // betGuideSlide(),

      promoSlide(),
      newsTopBanner(),
      // betSlide(),
    ];
    //   return [
    //     // Container(
    //     //                       child: Image.asset('assets/Slide1.JPG'),
    //     //                     ),

    //     eventSlide(),
    //     // if (DateTime.now().toLocal().day -
    //     //         (DateTime(2022, 12, 26).toLocal().day) <
    //     //     0)
    //     //   christmasEventSlide(),
    //     newsTopBanner(),
    //   ];
    // }
  }

  Widget christmasEventSlide() {
    return GestureDetector(
        onTap: () => {
              if (today.day -
                      (DateTime.fromMillisecondsSinceEpoch(1671033600000).day) >
                  0)
                {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => ChristmasEventRule()),
                  )
                }
              else
                {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return EventNotStarted();
                    },
                  )
                }
            },
        child: Container(
          child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image:
                  'https://soccersport.club/wp-content/uploads/2022/18/christmas_banner.png',
              imageErrorBuilder: (e, o, c) {
                return Container();
              }),
        ));
  }

  Widget betGuideSlide() {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => BetGuideDemo()),
          );
        },
        child: Container(
          child: Image.asset('assets/bet_guide_banner.png'),
        ));
  }

  Widget newsTopBanner() {
    return GestureDetector(
        onTap: () => {
              if (Constant.staticLatestNews != null)
                {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        NewsViewPage(news: Constant.staticLatestNews!),
                  ))
                }
            },
        child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Constant.staticLatestNews != null
                ? Stack(children: [
                    FittedBox(
                      fit: BoxFit.fill,
                      child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: Constant.staticLatestNews!.image!,
                          imageErrorBuilder: (e, o, c) {
                            return Container();
                          }),
                    ),
                    if (Constant.staticLatestNews!.categories != null &&
                        Constant.staticLatestNews!.categories!.length > 0)
                      Align(
                        alignment: AlignmentDirectional.topEnd,
                        child: Container(
                          margin: EdgeInsets.all(5),
                          height: 25,
                          width: 200,
                          child: ListView.builder(
                              shrinkWrap: true,
                              reverse: true,
                              physics: ClampingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: Constant
                                      .staticLatestNews!.categories!.length +
                                  1,
                              itemBuilder: (context, index) {
                                if (index ==
                                    Constant
                                        .staticLatestNews!.categories!.length) {
                                  return Container();
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[800],
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          Constant.staticLatestNews!
                                              .categories![index],
                                          style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              }),
                        ),
                      ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: EdgeInsets.only(left: 15),
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Image.asset('assets/news_logo.png'),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: Container(
                          // decoration: BoxDecoration(
                          //   gradient: LinearGradient(
                          //     end: Alignment.bottomCenter,
                          //     begin: Alignment.topCenter,
                          //     colors: [
                          //       Colors.black38.withOpacity(0.5),
                          //       Colors.black45.withOpacity(0.5),
                          //     ],
                          //   ),
                          // ),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/news_title.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                          height: MediaQuery.of(context).size.height * 0.15,
                          // padding: EdgeInsets.all(15),
                          width: double.infinity,
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Center(
                                  child: AutoSizeText(
                                      Constant.staticLatestNews!.title!
                                          .toUpperCase(),
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      // softWrap: false,
                                      minFontSize: 6,
                                      style: TextStyle(
                                          // fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          )),
                    )
                  ])
                : Container()));
  }

  Widget cnyEventSlide() {
    return GestureDetector(
        onTap: () => {
              //
              if (Constant.auth != null)
                {
                  if (!(today
                      .toLocal()
                      .difference(
                          DateTime.fromMillisecondsSinceEpoch(1672934400000))
                      .isNegative))
                    {
                      serviceLocator<AnalyticsService>()
                          .logScreens(name: '/cny'),
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => CnyEventPage()),
                      )
                    }
                  else
                    {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return EventNotStarted();
                        },
                      )
                    }
                }
              else
                {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  )
                }
            },
        child: Container(
          child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image:
                  'http://soccersport.club/wp-content/uploads/2022/20/cny_banner.png',
              imageErrorBuilder: (e, o, c) {
                return Container();
              }),
        ));
  }

  Widget eventSlide() {
    return GestureDetector(
        onTap: () => {
              if (Constant.auth != null)
                {
                  serviceLocator<AnalyticsService>()
                      .logScreens(name: '/dailyclaim'),
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DailyClaimsPage()),
                  )
                }
              else
                {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  )
                }
            },
        child: Container(
          child: Image.asset('assets/event.JPG'),
        ));
  }

  Widget promoSlide() {
    List<String> imgList = [
      'https://soccersport.club/wp-content/uploads/2022/18/ssc_promo_shoe.png',
      'https://soccersport.club/wp-content/uploads/2022/18/ssc_promo_shirt.png',
      'https://soccersport.club/wp-content/uploads/2022/18/ssc_promo_leg.png'
    ];

    var random = new Random();
    int randomIndex = random.nextInt(imgList.length);
    String selectedImage = imgList[randomIndex];
    return GestureDetector(
        onTap: () => {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => WayToEarnMoreMoney()),
              )
            },
        child: Container(
          child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: selectedImage,
              imageErrorBuilder: (e, o, c) {
                return Container();
              }),
        ));
  }

  Widget betSlide() {
    List<String> imgList = [
      'https://soccersport.club/wp-content/uploads/2022/18/test.png',
    ];

    var random = new Random();
    int randomIndex = random.nextInt(imgList.length);
    String selectedImage = imgList[randomIndex];
    return GestureDetector(
        onTap: () => {
              // Navigator.of(context).push(
              //   MaterialPageRoute(builder: (context) => LuckyDrawPage()),
              // )
              serviceLocator<AnalyticsService>().logScreens(name: '/event/bet'),
              Constant.pageController!.jumpToPage(0)
            },
        child: Container(
          child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: selectedImage,
              imageErrorBuilder: (e, o, c) {
                return Container();
              }),
        ));
  }

  Widget luckDrawSlide() {
    return GestureDetector(
        onTap: () => {
              if (Constant.auth != null)
                {
                  serviceLocator<AnalyticsService>()
                      .logScreens(name: '/event/lucky_draw'),
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LuckyDrawPage()),
                  )
                }
              else
                {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  )
                }

              // Constant.pageController!.jumpToPage(2)
            },
        child: Container(
          child: Image.asset('assets/lucky_draw.png'),
        ));
  }
}
