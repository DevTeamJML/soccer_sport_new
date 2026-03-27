import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:soccer_sport/authentication/presentation/page/login_page.dart';
import 'package:soccer_sport/core/constant/analytics_service.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/injection_container.dart';
import 'package:soccer_sport/landingPage/presentation/widget/daily_claims_page.dart';
import 'package:soccer_sport/setting/presentation/page/sign_up_page.dart';
import 'package:transparent_image/transparent_image.dart';

class ChristmasEventRule extends StatelessWidget {
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
          'Event',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image:
                      'https://soccersport.club/wp-content/uploads/2022/18/christmas_banner.png',
                  imageErrorBuilder: (e, o, c) {
                    return Container();
                  }),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text: '1. Check in daily during christmas week ',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: '19/12',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize: 18)),
                        TextSpan(text: ' - '),
                        TextSpan(
                            text: '25/12',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize: 18)),
                        TextSpan(text: ' will get '),
                        TextSpan(
                            text: 'DOUBLE POINTS',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 18)),
                        TextSpan(text: ' rewards daily.'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),

                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text:
                          '2. You will get double rewards for the amount you check in on that day ',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                '(example: people who check in on DAY1 will get 10+10 (double on the day)=20, people who check in on DAY 10 will get 100+100 (double on the day)= 200.)',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                  // AutoSizeText(
                  //   '2. You will get double rewards for the amount you check in on that day (example: people who check in on DAY1 will get 10+10 (double on the day)=20, people who check in on DAY 10 will get 100+100 (double on the day)= 200.',
                  //   minFontSize: 8,
                  //   style: TextStyle(fontSize: 16),
                  // ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text:
                          '3. It is recommended that the sooner you start participating in this check-in activity better ',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: '(will get more coins)',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                  // AutoSizeText(
                  //   '3. It is recommended that the sooner you start participating in this check-in activity better (will get more coins)',
                  //   minFontSize: 8,
                  //   style: TextStyle(fontSize: 16),
                  // ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text:
                          '4. After the event ends, the double coins obtained will not have any changes in your account and can be check in your profile.',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  // Text(
                  //   '5. Coins can be check in your profile',
                  //   style: TextStyle(fontSize: 16),
                  // ),
                ],
              ),
            ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * 0.02,
            // ),
            GestureDetector(
              onTap: () {
                if (Constant.auth != null) {
                  Navigator.of(context).pop();
                  serviceLocator<AnalyticsService>()
                      .logScreens(name: '/dailyclaim');

                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DailyClaimsPage()),
                  );
                } else {
                  Navigator.of(context).pop();

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
                    'Claim Now',
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
      ),
    );
  }
}
