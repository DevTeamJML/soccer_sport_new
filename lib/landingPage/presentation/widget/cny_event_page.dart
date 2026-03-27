import 'dart:math';

import 'package:advance_notification/advance_notification.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soccer_sport/authentication/presentation/page/login_page.dart';
import 'package:soccer_sport/authentication/presentation/widget/login_loading_dialog.dart';
import 'package:soccer_sport/core/constant/analytics_service.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/customer/domain/entities/cny_detail.dart';
import 'package:soccer_sport/customer/presentation/bloc/customer_bloc.dart';
import 'package:soccer_sport/injection_container.dart';
import 'package:soccer_sport/landingPage/presentation/widget/daily_claims_page.dart';
import 'package:soccer_sport/products/presentation/page/product_page.dart';
import 'package:soccer_sport/setting/presentation/page/sign_up_page.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:bulleted_list/bulleted_list.dart';

class CnyEventPage extends StatefulWidget {
  @override
  State<CnyEventPage> createState() => _CnyEventPageState();
}

class _CnyEventPageState extends State<CnyEventPage> {
  final CustomerBloc customerBloc = serviceLocator<CustomerBloc>();
  bool openInviteFriends = false;
  bool claimedAngpao = false;
  List<int> notRandomCoins = [18, 18, 18, 18, 18, 58, 58, 58, 88, 88];
  Random random = Random();
  CnyRewardDetail? cnyDetail;
  int claimableCoin = 0;

  @override
  void initState() {
    // TODO: implement initState
    customerBloc.add(CnyGetDetailRequest(id: Constant.auth!.id.toString()));
    // customerBloc.add()

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Constant.color1,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Cny Event',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => customerBloc,
          child: BlocListener<CustomerBloc, CustomerState>(
            listener: (context, state) {
              if (state is CnyDetailGet) {
                setState(() {
                  print('got get cny detail ??');
                  cnyDetail = state.success;
                  DateTime lastDateValue = DateTime.fromMillisecondsSinceEpoch(
                      cnyDetail!.lastCheckIn);
                  DateTime lastDate = DateTime(lastDateValue.year,
                      lastDateValue.month, lastDateValue.day);
                  DateTime todayValue = DateTime.now().toLocal();
                  DateTime todayDate = DateTime(
                      todayValue.year, todayValue.month, todayValue.day);

                  claimedAngpao = !(todayDate.difference(lastDate).inDays >= 1);
                  print(claimedAngpao);

                  if (claimableCoin > 0) {
                    customerBloc.add(AddDailyRewardRequest(
                        points: claimableCoin.toString()));
                  }
                });
              }

              if (state is DailyRewardAdded) {
                AdvanceSnackBar(
                        mode: Mode.ADVANCE,
                        message: "Claimed",
                        bgColor: Colors.green)
                    .show(context);
                customerBloc
                    .add(GetCustomerDetailsRequest(id: Constant.auth!.id));
                print('cusotmer detail get');
              }

              if (state is CustomerDetailsLoaded) {
                setState(() {
                  Constant.customer = state.customer;
                  claimedAngpao = true;

                  Navigator.of(context).pop();
                });
              }
              if (state is CnyRewardAdded) {
                AdvanceSnackBar(
                        mode: Mode.ADVANCE,
                        message: "Claimed",
                        bgColor: Colors.green)
                    .show(context);
                customerBloc
                    .add(CnyGetDetailRequest(id: Constant.auth!.id.toString()));
              }

              // TODO: implement listener
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image:
                          'http://soccersport.club/wp-content/uploads/2022/20/cny_banner.png',
                      imageErrorBuilder: (e, o, c) {
                        return Container();
                      }),
                ),

                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: double.infinity,
                  child: Row(children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            if (openInviteFriends == false) {
                              setState(() {
                                openInviteFriends = true;
                              });
                            }
                          },
                          child: Column(children: [
                            Expanded(
                              flex: 3,
                              child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: openInviteFriends
                                      ? 'https://soccersport.club/wp-content/uploads/2022/20/angpao coin.png'
                                      : 'https://soccersport.club/wp-content/uploads/2022/20/angpao close.png',
                                  imageErrorBuilder: (e, o, c) {
                                    return Container();
                                  }),
                            ),
                            Expanded(
                              flex: 1,
                              child: openInviteFriends
                                  ? Row(children: [
                                      Expanded(
                                        child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(2.0)),
                                                border: Border.all(
                                                    color: Constant.color2)),
                                            child: Text(
                                              "http://soccersp...........",
                                              style: TextStyle(
                                                color: Constant.color2,
                                              ),
                                              maxLines: 1,
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                      ),
                                      GestureDetector(
                                          onTap: () async {
                                            await Clipboard.setData(ClipboardData(
                                                text:
                                                    'http://soccersport.club/register/?mref=${Constant.auth!.username}'));
                                            AdvanceSnackBar(
                                                    mode: Mode.ADVANCE,
                                                    message:
                                                        "Copied to clipboard",
                                                    bgColor: Colors.green)
                                                .show(context);
                                          },
                                          child: Icon(Icons.copy,
                                              color: Constant.color2))
                                    ])
                                  : Container(
                                      child: Center(
                                        child: Text(
                                            'Invite Friends (+ 88 coins)',
                                            style: TextStyle(
                                                color: Constant.color2),
                                            maxLines: 2,
                                            textAlign: TextAlign.center),
                                      ),
                                    ),
                            )
                          ]),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: cnyDetail != null && claimedAngpao == false
                              ? () {
                                  if (claimedAngpao == false) {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return LoginLoadingDialog();
                                      },
                                    );
                                    setState(() {
                                      int index = (random.nextDouble() *
                                              notRandomCoins.length)
                                          .floor();

                                      int value = notRandomCoins[index];
                                      claimableCoin = value;
                                      int totalCoin = cnyDetail != null &&
                                              cnyDetail!.totalCoin != 0
                                          ? cnyDetail!.totalCoin
                                          : 0;
                                      CnyRewardDetail detail = CnyRewardDetail(
                                          id: Constant.auth!.id,
                                          lastCheckIn: DateTime.now()
                                              .toLocal()
                                              .millisecondsSinceEpoch,
                                          cnyLastCoin: claimableCoin,
                                          totalCoin: totalCoin + claimableCoin);
                                      customerBloc.add(
                                          CnyAddRewardRequest(detail: detail));
                                    });

                                    // print(propability.floor());
                                  }
                                }
                              : null,
                          child: Column(children: [
                            Expanded(
                              flex: 3,
                              child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: claimedAngpao
                                      ? 'https://soccersport.club/wp-content/uploads/2022/20/angpao coin.png'
                                      : 'https://soccersport.club/wp-content/uploads/2022/20/angpao close.png',
                                  imageErrorBuilder: (e, o, c) {
                                    return Container();
                                  }),
                            ),
                            Expanded(
                              flex: 1,
                              child: cnyDetail != null && claimedAngpao
                                  ? Container(
                                      child: Center(
                                        child: Text(
                                          'Total ${cnyDetail!.totalCoin} (+ ${cnyDetail!.cnyLastCoin} coins)',
                                          style:
                                              TextStyle(color: Constant.color2),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      child: Center(
                                        child: Text(
                                          'Daily Claim',
                                          style:
                                              TextStyle(color: Constant.color2),
                                        ),
                                      ),
                                    ),
                            )
                          ]),
                        ),
                      ),
                    ),
                  ]),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Terms & Conditions",
                        style: TextStyle(
                            color: Constant.color2,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Text(
                          "1. Event Period：00:00, 6 JAN 2023 - 23:59, 6 FEB 2023"),
                      // SizedBox(
                      //   height: MediaQuery.of(context).size.height * 0.006,
                      // ),
                      // Text(
                      //     "2. Participants needs to be a registered member of the Soccer Sport Club."),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.006,
                      ),
                      Text("2. Participants receive two sorts of Red Ang Pau."),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.006,
                      ),
                      BulletedList(
                        style: TextStyle(color: Colors.white),
                        bulletColor: Colors.white,
                        listItems: [
                          'The first type is the daily red envelope (updated at 00:00 Daily, with a random amount until the end of the event)',
                          'The second type is for inviting friends through your affiliate link, which they need to registering an account in Soccer Sport Club (Affiliate Link needs to be sent to your friend, and let him/her click this link to register)'
                        ],
                        listOrder: ListOrder.ordered,
                        bulletType: BulletType.conventional,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.006,
                      ),
                      RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          text:
                              "3. Red angpau = coin of user profile (can be viewed in profile, and can be exchanged for physical products at ",
                          children: <TextSpan>[
                            TextSpan(
                              text: 'here',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => ProductPage()),
                                  );
                                },
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue,
                              ),
                            ),
                            TextSpan(text: ')')
                          ],
                        ),
                      ),
                      // Text(
                      //     "3. Red angpau = coin of user profile (can be viewed in profile, and can be exchanged for physical products at here "),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.006,
                      ),
                      Text(
                          "4. Participants can only log in and collect daily red angpau once a day (login from any device)"),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.006,
                      ),
                      Text(
                          "5. Soccer Sport reserves the right to amend the terms and conditions of this offer without any prior notice. Participants can only log in and redeem coin once a day (login from any device)"),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.08,
                ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.02,
                // ),
                // GestureDetector(
                //   onTap: () {
                //     if (Constant.auth != null) {
                //       Navigator.of(context).pop();
                //       serviceLocator<AnalyticsService>()
                //           .logScreens(name: '/dailyclaim');

                //       Navigator.of(context).push(
                //         MaterialPageRoute(builder: (context) => DailyClaimsPage()),
                //       );
                //     } else {
                //       Navigator.of(context).pop();

                //       Navigator.of(context).push(
                //         MaterialPageRoute(builder: (context) => LoginPage()),
                //       );
                //     }
                //   },
                //   child: Container(
                //     height: MediaQuery.of(context).size.height * 0.05,
                //     width: double.infinity,
                //     padding: EdgeInsets.all(10),
                //     margin: EdgeInsets.all(20),
                //     decoration: BoxDecoration(
                //         boxShadow: [
                //           BoxShadow(
                //             color: Colors.yellow,
                //             blurRadius: 5.0,
                //             spreadRadius: 2.0,
                //           ),
                //         ],
                //         gradient: LinearGradient(
                //           // begin: Alignment.bottomRight,
                //           // end: Alignment.topRight,
                //           colors: [
                //             Colors.yellow,
                //             Color.fromARGB(255, 237, 169, 23),
                //           ],
                //         ),
                //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
                //         border: Border.all()),
                //     child: Center(
                //       child: AutoSizeText(
                //         'Claim Now',
                //         style: TextStyle(
                //             color: Colors.black,
                //             fontWeight: FontWeight.bold,
                //             fontSize: 16),
                //         minFontSize: 8,
                //       ),
                //     ),
                //   ),
                // )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
