import 'package:advance_notification/advance_notification.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soccer_sport/authentication/presentation/page/login_page.dart';
import 'package:soccer_sport/authentication/presentation/widget/login_loading_dialog.dart';
import 'package:soccer_sport/banner/domain/entities/banner.dart';
import 'package:soccer_sport/banner/presentation/widget/banner_widget.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/customer/domain/entities/customer_reward_detail.dart';
import 'package:soccer_sport/injection_container.dart';
import 'package:soccer_sport/landingPage/presentation/widget/coin_widget.dart';
import 'package:soccer_sport/setting/presentation/page/sign_up_page.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wordpress_api/wordpress_api.dart';

import '../../../customer/presentation/bloc/customer_bloc.dart';

class DailyClaimsPage extends StatefulWidget {
  @override
  State<DailyClaimsPage> createState() => _DailyClaimsPageState();
}

class _DailyClaimsPageState extends State<DailyClaimsPage> {
  final CustomerBloc customerBloc = serviceLocator<CustomerBloc>();
  // final ScrollController _controller =
  //     ScrollController(keepScrollOffset: false);
  String bannerHTML = '';
  bool loading = false;
  String claimablePoints = '';
  bool has_claimed = false;
  @override
  void initState() {
    // TODO: implement initState
    // if (Constant.eventBanner != null && Constant.newsBanner != null) {
    //   bannerHTML = Constant.isMember
    //       ? Constant.eventBanner!.url != null
    //           ? Constant.eventBanner!.url!
    //           : ''
    //       : Constant.newsBanner!.url != null
    //           ? Constant.newsBanner!.url!
    //           : '';
    // }
    claimablePoints = '';
    var lastCheckIn = DateTime.fromMillisecondsSinceEpoch(
        Constant.customerRewardDetail!.lastCheckIn);

    DateTime lastDate =
        DateTime(lastCheckIn.year, lastCheckIn.month, lastCheckIn.day);
    DateTime todayValue = DateTime.now().toLocal();
    DateTime todayDate =
        DateTime(todayValue.year, todayValue.month, todayValue.day);
    bool dateRequirement = Constant.customerRewardDetail != null
        ? todayDate.difference(lastDate).inDays >= 1
        : false;
    has_claimed =
        Constant.customerRewardDetail != null ? dateRequirement : false;
    customerBloc
        .add(GetUserRewardDetailRequest(id: Constant.auth!.id.toString()));

    super.initState();
  }

  DateTime today = DateTime.now().toLocal();
  String pointCalculated(int day) {
    if (day < 3 && day >= 0) {
      return '10';
    } else if (day >= 3 && day < 6) {
      return '20';
    } else if (day >= 6 && day < 9) {
      return '30';
    } else if (day >= 9 && day < 12) {
      return '40';
    } else if (day >= 12 && day < 15) {
      return '50';
    } else if (day >= 15 && day < 18) {
      return '60';
    } else if (day >= 18 && day < 21) {
      return '70';
    } else if (day >= 21 && day < 24) {
      return '80';
    } else if (day >= 24 && day < 27) {
      return '90';
    } else if (day >= 27 && day < 30) {
      return '100';
    } else if (day == 30) {
      return '238';
    } else {
      return '0';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Daily Check In'),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: BlocProvider(
          create: (context) => customerBloc,
          child: BlocListener<CustomerBloc, CustomerState>(
            listener: (context, state) {
              if (state is UserRewardDetailGet) {
                setState(() {
                  Constant.customerRewardDetail = state.success;
                  if (claimablePoints != '') {
                    customerBloc
                        .add(GetCustomerDetailsRequest(id: Constant.auth!.id));
                  }
                });
              }

              if (state is DailyRewardGet) {
                customerBloc
                    .add(AddDailyRewardRequest(points: claimablePoints));
              }

              if (state is DailyRewardAdded) {
                AdvanceSnackBar(
                        mode: Mode.ADVANCE,
                        message: "Claimed",
                        bgColor: Colors.green)
                    .show(context);
                customerBloc.add(GetUserRewardDetailRequest(
                    id: Constant.auth!.id.toString()));
                print('cusotmer detail get');
              }

              if (state is CustomerDetailsLoaded) {
                setState(() {
                  Constant.customer = state.customer;
                  Navigator.of(context).pop();
                });
              }
            },
            child: SingleChildScrollView(
              child: Container(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 1.15,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Column(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Container(
                                      color: Constant.backgroundColor,
                                      child: Column(children: [
                                        Expanded(
                                            // child: Column(
                                            //   mainAxisAlignment:
                                            //       MainAxisAlignment.center,
                                            //   children: [
                                            //     // AutoSizeText(
                                            //     //   '30 daily claims rewards',
                                            //     //   style: TextStyle(
                                            //     //       color: Constant.color2,
                                            //     //       fontSize: 26,
                                            //     //       fontWeight:
                                            //     //           FontWeight.bold),
                                            //     //   maxLines: 1,
                                            //     // ),
                                            //     Padding(
                                            //       padding:
                                            //           const EdgeInsets.symmetric(
                                            //               vertical: 8.0),
                                            //       child: AutoSizeText(
                                            //         'the more u claim the more u get',
                                            //         maxLines: 1,
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
                                            child: Container(
                                          margin: EdgeInsets.only(
                                              top: 30, left: 10, right: 10),
                                          // child: Image.asset(
                                          //     'assets/claim_coin_title.png'),
                                          child: FadeInImage.memoryNetwork(
                                              placeholder: kTransparentImage,
                                              image:
                                                  'https://soccersport.club/wp-content/uploads/2022/18/title.png',
                                              imageErrorBuilder: (e, o, c) {
                                                return Container();
                                              }),
                                        )),
                                        Expanded(
                                          flex: 1,
                                          child: Container(),
                                        ),
                                      ]),
                                    )),
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                      color: Constant.backgroundColor),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              color: Constant.backgroundColor,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Terms & Conditions',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text(
                                          '1. Check in daily to soccer sport club to earn coin. (Update at 00:00 every day) ',
                                          style: TextStyle(fontSize: 16)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text(
                                          '2. More consecutive days you sign in, the more coins you get.',
                                          style: TextStyle(fontSize: 16)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text(
                                          '3. An account can only be signed in & earn coin once a day (no matter how many devices are used)',
                                          style: TextStyle(fontSize: 16)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text(
                                          '4. During the event, the maximum number of coins that an account can get is 31 times',
                                          style: TextStyle(fontSize: 16)),
                                    ),
                                  ]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Expanded(flex: 1, child: Container()),
                          Expanded(
                            flex: 3,
                            child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage('assets/claim_coin_bg.png'),
                                    fit: BoxFit.fill,
                                  ),
                                  // image: DecorationImage(
                                  //   image: NetworkImage(
                                  //     'https://soccersport.club/wp-content/uploads/2022/18/bkg.png',
                                  //   ),
                                  //   fit: BoxFit.fill,
                                  // ),

                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional.topEnd,
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.08),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04,
                                          // child: Image.asset(
                                          //     'assets/snowflakes_1.png'),
                                          child: FadeInImage.memoryNetwork(
                                              placeholder: kTransparentImage,
                                              image:
                                                  'https://soccersport.club/wp-content/uploads/2022/18/snowflakes_1.png',
                                              imageErrorBuilder: (e, o, c) {
                                                return Container();
                                              })),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional.topStart,
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.09),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03,
                                          // child: Image.asset(
                                          //     'assets/snowflakes_2.png'),
                                          child: FadeInImage.memoryNetwork(
                                              placeholder: kTransparentImage,
                                              image:
                                                  'https://soccersport.club/wp-content/uploads/2022/18/snowflakes_2.png',
                                              imageErrorBuilder: (e, o, c) {
                                                return Container();
                                              })),
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional.bottomEnd,
                                      child: Container(
                                          margin: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.04,
                                          // child: Image.asset(
                                          //     'assets/snowflakes_3.png'),
                                          child: FadeInImage.memoryNetwork(
                                              placeholder: kTransparentImage,
                                              image:
                                                  'https://soccersport.club/wp-content/uploads/2022/18/snowflakes_3.png',
                                              imageErrorBuilder: (e, o, c) {
                                                return Container();
                                              })),
                                    ),
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Expanded(
                                          //     flex: 1,
                                          //     // height:
                                          //     //     MediaQuery.of(context).size.height *
                                          //     //         0.05,
                                          //     child: Container()
                                          //     // child: Row(
                                          //     //   mainAxisAlignment:
                                          //     //       MainAxisAlignment.spaceAround,
                                          //     //   crossAxisAlignment:
                                          //     //       CrossAxisAlignment.center,
                                          //     //   children: [
                                          //     //     AutoSizeText('Claims history',
                                          //     //         style: TextStyle(
                                          //     //             fontWeight: FontWeight.bold)),
                                          //     //     AutoSizeText(
                                          //     //         'Claim ' +
                                          //     //             (Constant.customerRewardDetail !=
                                          //     //                     null
                                          //     //                 ? Constant
                                          //     //                     .customerRewardDetail!
                                          //     //                     .checkInCount
                                          //     //                     .toString()
                                          //     //                 : '0') +
                                          //     //             '/31',
                                          //     //         style: TextStyle(
                                          //     //             fontWeight: FontWeight.bold))
                                          //     //   ],
                                          //     // ),
                                          //     ),
                                          // Divider(
                                          //   color: Color.fromARGB(255, 85, 83, 83),
                                          // ),
                                          // Container(
                                          //   height:
                                          //       MediaQuery.of(context).size.height *
                                          //           0.02,
                                          // ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(),
                                          ),
                                          Expanded(
                                            flex: 6,
                                            child: Container(
                                              padding: EdgeInsets.all(5),
                                              child: AlignedGridView.count(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                // controller: _controller,
                                                crossAxisCount: 7,
                                                // mainAxisSpacing: 4,
                                                // crossAxisSpacing: 4,
                                                itemCount: 31,
                                                mainAxisSpacing: 10,
                                                crossAxisSpacing: 5,
                                                itemBuilder: (context, index) {
                                                  bool claimed = Constant
                                                              .customerRewardDetail !=
                                                          null
                                                      ? Constant
                                                              .customerRewardDetail!
                                                              .checkInCount >=
                                                          index + 1
                                                      : false;
                                                  var lastCheckIn = DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          Constant
                                                              .customerRewardDetail!
                                                              .lastCheckIn);

                                                  DateTime lastDate = DateTime(
                                                      lastCheckIn.year,
                                                      lastCheckIn.month,
                                                      lastCheckIn.day);
                                                  DateTime todayValue =
                                                      DateTime.now().toLocal();
                                                  DateTime todayDate = DateTime(
                                                      todayValue.year,
                                                      todayValue.month,
                                                      todayValue.day);
                                                  bool dateRequirement =
                                                      Constant.customerRewardDetail !=
                                                              null
                                                          ? todayDate
                                                                  .difference(
                                                                      lastDate)
                                                                  .inDays >=
                                                              1
                                                          : false;

                                                  if (index == 6) {
                                                    print(dateRequirement);
                                                    print('dayte req');
                                                  }

                                                  bool claimable = Constant
                                                              .customerRewardDetail !=
                                                          null
                                                      ? dateRequirement &&
                                                          (Constant
                                                                  .customerRewardDetail!
                                                                  .checkInCount ==
                                                              index)
                                                      : false;
                                                  return GestureDetector(
                                                    onTap: claimable
                                                        ? () {
                                                            showDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  false,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return LoginLoadingDialog();
                                                              },
                                                            );
                                                            var eventPeriod =
                                                                Constant
                                                                    .customerRewardDetail!
                                                                    .eventPeriod;
                                                            // if (today.compareTo(DateTime
                                                            //             .fromMillisecondsSinceEpoch(
                                                            //                 1671379200000)) >=
                                                            //         0 &&
                                                            //     today.compareTo(DateTime
                                                            //             .fromMillisecondsSinceEpoch(
                                                            //                 1671984000000)) <
                                                            //         0) {
                                                            //   eventPeriod
                                                            //       .add(index);
                                                            // }

                                                            // if (
                                                            //   (today.year)
                                                            //   today.difference(
                                                            //             (DateTime.fromMillisecondsSinceEpoch(1671379200000)
                                                            //                 )) >=
                                                            //         0 &&
                                                            //     today.day -
                                                            //             (DateTime.fromMillisecondsSinceEpoch(1671984000000)
                                                            //                 .day) <
                                                            //         0) {
                                                            //   eventPeriod
                                                            //       .add(index);
                                                            // }
                                                            // if(today.difference(DateTime.fromMillisecondsSinceEpoch(1671292800000)).inDays > 0 && )
                                                            var detail = CustomerRewardDetail(
                                                                id: Constant
                                                                    .customerRewardDetail!
                                                                    .id,
                                                                checkInCount: Constant
                                                                        .customerRewardDetail!
                                                                        .checkInCount +
                                                                    1,
                                                                lastCheckIn: DateTime
                                                                        .now()
                                                                    .toLocal()
                                                                    .millisecondsSinceEpoch,
                                                                eventPeriod:
                                                                    eventPeriod,
                                                                leagues: Constant
                                                                    .customerRewardDetail!
                                                                    .leagues);
                                                            customerBloc.add(
                                                                GetDailyRewardsRequest(
                                                                    customerRewardDetail:
                                                                        detail));
                                                            setState(() {
                                                              claimablePoints = (int.parse(
                                                                          pointCalculated(
                                                                              index)) *
                                                                      (eventPeriod
                                                                              .contains(index)
                                                                          ? 2
                                                                          : 1))
                                                                  .toString();
                                                            });
                                                          }
                                                        : null,
                                                    child: Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.055,
                                                      width: double.infinity,
                                                      // color: Colors.black,
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                                decoration: BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    boxShadow: [
                                                                      if (claimable)
                                                                        BoxShadow(
                                                                          color:
                                                                              Colors.white,
                                                                          blurRadius:
                                                                              5.0,
                                                                          spreadRadius:
                                                                              2.0,
                                                                        ),
                                                                    ]),
                                                                child:
                                                                    Container(
                                                                  child: claimed
                                                                      ? FadeInImage.memoryNetwork(
                                                                          placeholder: kTransparentImage,
                                                                          image: 'https://soccersport.club/wp-content/uploads/2022/18/soccer_coin_get.png',
                                                                          imageErrorBuilder: (e, o, c) {
                                                                            return Container();
                                                                          })
                                                                      : FadeInImage.memoryNetwork(
                                                                          placeholder: kTransparentImage,
                                                                          image: 'https://soccersport.club/wp-content/uploads/2022/18/soccer_coin.png',
                                                                          imageErrorBuilder: (e, o, c) {
                                                                            return Container();
                                                                          }),
                                                                )
                                                                // child: FadeInImage
                                                                //     .memoryNetwork(
                                                                //         placeholder:
                                                                //             kTransparentImage,
                                                                //         image:
                                                                //             'https://soccersport.club/wp-content/uploads/2021/12/Jan22-SSC-Coin-icon-150x150-1.png',
                                                                //         imageErrorBuilder:
                                                                //             (e, o, c) {
                                                                //           return Container();
                                                                //         }),
                                                                ),
                                                          ),
                                                          AutoSizeText(
                                                            claimed
                                                                ? '+' +
                                                                    (int.parse(pointCalculated(index)) *
                                                                            (Constant.customerRewardDetail!.eventPeriod.contains(index)
                                                                                ? 2
                                                                                : 1))
                                                                        .toString()
                                                                : 'Day ' +
                                                                    (index + 1)
                                                                        .toString(),
                                                            // style: TextStyle(
                                                            //     fontSize: 14,
                                                            //     fontWeight:
                                                            //         FontWeight
                                                            //             .bold),
                                                            style: GoogleFonts
                                                                .ebGaramond(
                                                              fontSize: 14,
                                                              // fontWeight:
                                                              //     FontWeight
                                                              //         .bold
                                                            ),
                                                            minFontSize: 3,
                                                            maxLines: 1,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),

                                          Expanded(
                                            flex: 1,
                                            // child: Container(),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                      margin: EdgeInsets.only(
                                                          left: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.2,
                                                          right: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.05),
                                                      child: Theme(
                                                        data: ThemeData(
                                                          textTheme: TextTheme(
                                                            labelLarge:
                                                                TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                          elevatedButtonTheme:
                                                              ElevatedButtonThemeData(
                                                                  style: ElevatedButton.styleFrom(
                                                                          foregroundColor: Constant
                                                                              .color2,
                                                                          disabledForegroundColor: Colors
                                                                              .black,
                                                                          shadowColor:
                                                                              Colors.white)
                                                                      .copyWith(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .resolveWith<
                                                                        Color>(
                                                              (Set<MaterialState>
                                                                  states) {
                                                                if (states.contains(
                                                                    MaterialState
                                                                        .disabled)) {
                                                                  return Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.8); // set the disabled button's color with an opacity of 0.5
                                                                }
                                                                return Constant
                                                                    .color2; // use the default color for enabled buttons
                                                              },
                                                            ),
                                                          )),
                                                        ),
                                                        child: ElevatedButton(
                                                          onPressed: has_claimed
                                                              ? () {
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    barrierDismissible:
                                                                        false,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return LoginLoadingDialog();
                                                                    },
                                                                  );
                                                                  var eventPeriod =
                                                                      Constant
                                                                          .customerRewardDetail!
                                                                          .eventPeriod;

                                                                  var detail = CustomerRewardDetail(
                                                                      id: Constant
                                                                          .customerRewardDetail!
                                                                          .id,
                                                                      checkInCount:
                                                                          Constant.customerRewardDetail!.checkInCount +
                                                                              1,
                                                                      lastCheckIn: DateTime
                                                                              .now()
                                                                          .toLocal()
                                                                          .millisecondsSinceEpoch,
                                                                      eventPeriod:
                                                                          eventPeriod,
                                                                      leagues: Constant
                                                                          .customerRewardDetail!
                                                                          .leagues);
                                                                  customerBloc.add(
                                                                      GetDailyRewardsRequest(
                                                                          customerRewardDetail:
                                                                              detail));
                                                                  setState(() {
                                                                    claimablePoints =
                                                                        (int.parse(pointCalculated(detail.checkInCount -
                                                                                1)))
                                                                            .toString();
                                                                    has_claimed =
                                                                        false;
                                                                  });
                                                                }
                                                              : null,
                                                          child: Text(
                                                            'Claim',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      )),
                                                ),
                                                Container(
                                                  height: double.infinity,
                                                  margin: EdgeInsets.all(10),
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      // begin: Alignment.bottomRight,
                                                      // end: Alignment.topRight,
                                                      colors: [
                                                        Color(0xFFFFEB3B),
                                                        Color.fromARGB(
                                                            255, 237, 169, 23),
                                                      ],
                                                    ),
                                                  ),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.15,
                                                  child: Center(
                                                    child: AutoSizeText(
                                                      (Constant.customerRewardDetail !=
                                                                  null
                                                              ? Constant
                                                                  .customerRewardDetail!
                                                                  .checkInCount
                                                                  .toString()
                                                              : '0') +
                                                          '/31',
                                                      minFontSize: 8,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black,
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ]),
                                  ],
                                )),
                          ),
                          // Constant.newsBanner != null ||
                          //         Constant.eventBanner != null
                          //     ? Container(
                          //         child: GestureDetector(
                          //             onTap: () async {
                          //               BannerHtml html = Constant.isMember
                          //                   ? Constant.newsBanner!
                          //                   : Constant.eventBanner!;
                          //               if (Constant.isMember) {
                          //                 if (html.href != null) {
                          //                   if (await canLaunch(html.href!)) {
                          //                     await launch(html.href!);
                          //                   } else {
                          //                     throw 'Could not launch ${html.href!}';
                          //                   }
                          //                 } else {
                          //                   Constant.pageController!
                          //                       .jumpToPage(0);
                          //                 }
                          //               } else {
                          //                 Navigator.of(context).push(
                          //                   MaterialPageRoute(
                          //                       builder: (context) =>
                          //                           LoginPage()),
                          //                 );
                          //               }
                          //             },
                          //             child: BannerWidget(imgSrc: bannerHTML)),
                          //       )
                          //     : Container(),
                          Expanded(
                            flex: 2,
                            child: Container(),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
