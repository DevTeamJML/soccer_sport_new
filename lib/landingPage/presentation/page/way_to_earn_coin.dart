import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:soccer_sport/authentication/presentation/page/login_page.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/injection_container.dart';
import 'package:soccer_sport/landingPage/presentation/widget/cny_event_page.dart';
import 'package:soccer_sport/landingPage/presentation/widget/daily_claims_page.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../core/constant/analytics_service.dart';

class WayToEarnMoreMoney extends StatelessWidget {
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
          'Way to earn Coins',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          if ((DateTime.now()
              .toLocal()
              .difference(DateTime.fromMillisecondsSinceEpoch(1675699200000))
              .isNegative))
            Container(
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          '-During CNY event, users can daily claim coin from angpao.'),
                      Text('-User also can invite friends to earn coin too.')
                    ],
                  ),
                ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.02,
                // ),
                GestureDetector(
                  onTap: () {
                    if (Constant.auth != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => CnyEventPage()),
                      );
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    }
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellow,
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                        gradient: LinearGradient(
                          // begin: Alignment.bottomRight,
                          // end: Alignment.topRight,
                          colors: [
                            Colors.yellow,
                            Color.fromARGB(255, 237, 169, 23),
                          ],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        border: Border.all()),
                    child: Center(
                      child: AutoSizeText(
                        'CNY Event',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                        minFontSize: 8,
                      ),
                    ),
                  ),
                )
              ]),
            ),
          Container(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Image.asset('assets/event.JPG'),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '-Users just have to daily open and go to the event page to gain coin.'),
                  ],
                ),
              ),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.02,
              // ),
              GestureDetector(
                onTap: () {
                  if (Constant.auth != null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => DailyClaimsPage()),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  }
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.yellow,
                          blurRadius: 5.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                      gradient: LinearGradient(
                        // begin: Alignment.bottomRight,
                        // end: Alignment.topRight,
                        colors: [
                          Colors.yellow,
                          Color.fromARGB(255, 237, 169, 23),
                        ],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      border: Border.all()),
                  child: Center(
                    child: AutoSizeText(
                      'Daily Claim',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                      minFontSize: 8,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
            ]),
          ),
          Container(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Colors.grey, offset: Offset(0, 0), blurRadius: 3)
                ]),
                child: Image.asset('assets/read_news.png'),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('-Users can earn 1 coin by read news.'),
                    Text("-News that has been read before can't earn coin."),
                    Text(
                        '-Users can only earn up to 10 coin daily by read news.'),
                  ],
                ),
              ),
            ]),
          ),
          // Container(
          //   child:
          //       Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          //     Container(
          //       height: MediaQuery.of(context).size.height * 0.3,
          //       decoration: BoxDecoration(boxShadow: [
          //         BoxShadow(
          //             color: Colors.grey, offset: Offset(0, 0), blurRadius: 3)
          //       ]),
          //       child: Image.asset('assets/bet_example.png'),
          //     ),
          //     SizedBox(
          //       height: MediaQuery.of(context).size.height * 0.01,
          //     ),
          //     Container(
          //       padding: EdgeInsets.all(10),
          //       margin: EdgeInsets.all(20),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //               '-Users can place bet on the upcoming match to earn coins.'),
          //         ],
          //       ),
          //     ),
          //   ]),
          // ),
        ],
      )),
    );
  }
}
