import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intro_slider/intro_slider.dart';
// import 'package:intro_slider/slide_object.dart';
import 'package:soccer_sport/authentication/presentation/bloc/wordpress_auth_bloc.dart';
import 'package:soccer_sport/authentication/presentation/widget/login_loading_dialog.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/landingPage/presentation/page/way_to_earn_coin.dart';
// import 'package:intro_slider/scrollbar_behavior_enum.dart';

import '../../../injection_container.dart';

class BetGuideDemo extends StatefulWidget {
  @override
  State<BetGuideDemo> createState() => _BetGuideDemoState();
}

class _BetGuideDemoState extends State<BetGuideDemo> {
  // 1. Define a `GlobalKey` as part of the parent widget's state
  // final _introKey = GlobalKey<IntroductionScreenState>();
  final WordpressAuthBloc _authBloc = serviceLocator<WordpressAuthBloc>();

  // String _status = 'Waiting...';
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _authBloc,
      child: BlocListener<WordpressAuthBloc, WordpressAuthState>(
        listener: (context, state) {
          if (state is BetGuideRemoved) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }
        },
        child: IntroSlider(
          indicatorConfig: IndicatorConfig(
            sizeIndicator: 10,
            colorIndicator: Colors.grey[400],
            colorActiveIndicator: Constant.color2,
          ),
          // sizeDot: 10,
          renderSkipBtn: Icon(
            Icons.skip_next,
            color: Constant.color2,
          ),
          skipButtonStyle: myButtonStyle(),

          // Next button
          renderNextBtn: Icon(
            Icons.navigate_next,
            color: Constant.color2,
            size: 35.0,
          ),
          onNextPress: (_) {},
          nextButtonStyle: myButtonStyle(),

          // Done button
          renderDoneBtn: Icon(
            Icons.done,
            color: Constant.color2,
          ),
          onDonePress: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return LoginLoadingDialog();
              },
            );
            _authBloc.add(RemoveBetGuideRequest());
          },
          doneButtonStyle: myButtonStyle(),

          // // Dot indicator
          // colorDot: Colors.grey[400],
          // colorActiveDot: Constant.color2,

          // // Show or hide status bar
          // hideStatusBar: true,
          // backgroundColorAllSlides: Colors.grey,

          // Scrollbar
          // verticalScrollbarBehavior: scrollbarBehavior.SHOW_ALWAYS,

          listContentConfig: [
            slide('assets/intro_guide.png',
                'Soccer Sport Club now has bet game for user to gain more coin. To learn more about it, click next to proceed the tutorials.'),
            slide('assets/1_step.png',
                "Matches can be bet: Premier league, laliga, bundesliga , Ligue 1."),
            // slide('assets/1_step.png',
            //     ""),
            slide('assets/2_step.png',
                'Click “incoming”,  3 buttons for user to bet as picture shown above.',
                addtionalText:
                    ' (Unable to bet 5 minutes before the match begin)'),
            slide('assets/3_step.png',
                'After choosing your predicted winning team or predicting a DRAW, the betting dialog box will pop up, using soccer sport club gold coins to bet.',
                addtionalText:
                    ' Available betting amount: min. 10coins, max. 100coins a match'),
            slide('assets/4_step.png',
                'After you have done your betting, the match u bet will turn to this status',
                addtionalText: ' (Picture shown above)'),
            slide('assets/5_step.png',
                ' Refer to “bet log” to check the history and details of your betting match.'),
            slide('assets/6_step.png',
                'After the game you bet on is over, you can go back to the matches page or bet log to check the betting result.'),

            slide('assets/last_page_guide.png',
                'Thanks for your reading, you can read this guide again in "Setting" section.',
                addtionalText:
                    "All the prizes are provided by Soccer Sport Club and there are no other sponsors providing the prizes or coins.",
                wayToEarn: 'Ways to earn more coin'),
          ],
        ),
      ),
    );

    // return IntroductionScreen(
    //   // 2. Pass that key to the `IntroductionScreen` `key` param
    //   key: _introKey,
    //   showSkipButton: true,
    //   showNextButton: true,
    //   showDoneButton: true,
    //   onDone: () {
    //     Navigator.of(context).pop();
    //   },
    //   onSkip: () {
    //     Navigator.of(context).pop();
    //   },
    //   // isTopSafeArea: true,
    //   // isBottomSafeArea: true,
    //   onChange: (index) {
    //     setState(() {
    //       print(index);
    //       index = index;
    //     });
    //   },

    //   skipOrBackFlex: 0,
    //   nextFlex: 0,
    //   skip: Text("Skip", style: TextStyle(color: Colors.white)),
    //   done: Text("Done", style: TextStyle(color: Colors.white)),
    //   next: Text('Next', style: TextStyle(color: Colors.white)),
    //   back: Text('Back', style: TextStyle(color: Colors.white)),
    //   // dotsContainerDecorator: BoxDecoration(color: Colors.red),
    //   // dotsDecorator:
    //   //     DotsDecorator(activeColor: Colors.white, color: Colors.grey),

    //   pages: [
    //     PageViewModel(
    //         title: "",
    //         decoration: PageDecoration(bodyFlex: 2),

    //         // body: "Welcome to the app! This is a description of how it works.",
    //         bodyWidget: Column(children: [
    //           Container(
    //             margin: EdgeInsets.symmetric(
    //                 vertical: MediaQuery.of(context).size.height * 0.02),
    //             height: MediaQuery.of(context).size.height * 0.3,
    //             // child: Image.asset('assets/1_step.png'),
    //           ),
    //           Text(
    //             'Soccer Sport Club now has bet game for user to gain more coin.To learn more about it, click next to proceed the tutorials.',
    //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    //             textAlign: TextAlign.justify,
    //           ),
    //           // Text(
    //           //   "To learn more about it, click next to proceed the tutorials.",
    //           //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    //           //   textAlign: TextAlign.justify,
    //           // ),
    //         ])),
    //     PageViewModel(
    //         title: "",

    //         // body: "Welcome to the app! This is a description of how it works.",
    //         bodyWidget: Column(children: [
    //           Container(
    //             margin: EdgeInsets.symmetric(
    //                 vertical: MediaQuery.of(context).size.height * 0.02),
    //             height: MediaQuery.of(context).size.height * 0.6,
    //             child: Image.asset('assets/1_step.png'),
    //           ),
    //           Text(
    //             "Premier league, laliga, bundesliga and ligue's match are the only one can be bet. Select one of the leagues and click on the incoming tab to start your betting on the upcoming matches.",
    //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    //             textAlign: TextAlign.justify,
    //           ),
    //         ])),
    //     PageViewModel(
    //         title: "",

    //         // body: "Welcome to the app! This is a description of how it works.",
    //         bodyWidget: Column(children: [
    //           Container(
    //             margin: EdgeInsets.symmetric(
    //                 vertical: MediaQuery.of(context).size.height * 0.02),
    //             height: MediaQuery.of(context).size.height * 0.6,
    //             child: Image.asset('assets/2_step.png'),
    //           ),
    //           Text(
    //             "After clicking on the incoming tab, 3 buttons will be appeared for user to bet as the picture shown above but only until 5 minutes before the match begin.",
    //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    //             textAlign: TextAlign.justify,
    //           ),
    //         ])),
    //     PageViewModel(
    //         title: "",

    //         // body: "Welcome to the app! This is a description of how it works.",
    //         bodyWidget: Column(children: [
    //           Container(
    //             margin: EdgeInsets.symmetric(
    //                 vertical: MediaQuery.of(context).size.height * 0.02),
    //             height: MediaQuery.of(context).size.height * 0.6,
    //             child: Image.asset('assets/3_step.png'),
    //           ),
    //           Text(
    //             "When the choices had been made, it will prompt users a window which is for users to enter the amount of their bet. The bet of the amount can only more than 10 and can't more than 100.",
    //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    //             textAlign: TextAlign.justify,
    //           ),
    //         ])),
    //     PageViewModel(
    //         title: "",

    //         // body: "Welcome to the app! This is a description of how it works.",
    //         bodyWidget: Column(children: [
    //           Container(
    //             margin: EdgeInsets.symmetric(
    //                 vertical: MediaQuery.of(context).size.height * 0.02),
    //             height: MediaQuery.of(context).size.height * 0.6,
    //             child: Image.asset('assets/4_step.png'),
    //           ),
    //           Text(
    //             "After users has done the betting, the match that bet by the user will change as the picture shown above. ",
    //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    //             textAlign: TextAlign.justify,
    //           ),
    //         ])),
    //     PageViewModel(
    //         title: "",

    //         // body: "Welcome to the app! This is a description of how it works.",
    //         bodyWidget: Column(children: [
    //           Container(
    //             margin: EdgeInsets.symmetric(
    //                 vertical: MediaQuery.of(context).size.height * 0.02),
    //             height: MediaQuery.of(context).size.height * 0.6,
    //             child: Image.asset('assets/5_step.png'),
    //           ),
    //           Text(
    //             "Users also can go to the bet log tab to know more details of their betting.",
    //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    //             textAlign: TextAlign.justify,
    //           ),
    //         ])),
    //     PageViewModel(
    //         title: "",

    //         // body: "Welcome to the app! This is a description of how it works.",
    //         bodyWidget: Column(children: [
    //           Container(
    //             margin: EdgeInsets.symmetric(
    //                 vertical: MediaQuery.of(context).size.height * 0.02),
    //             height: MediaQuery.of(context).size.height * 0.6,
    //             child: Image.asset('assets/7_step.png'),
    //           ),
    //           Text(
    //             "After the match finished that bet by the users,  users need go to the league matches page , so it will prompt results windows based on how many betting they made on the matches and gain the coin amount they won.",
    //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    //             textAlign: TextAlign.justify,
    //           ),
    //         ])),
    //     PageViewModel(
    //         title: "",

    //         // body: "Welcome to the app! This is a description of how it works.",
    //         bodyWidget: Column(children: [
    //           Container(
    //               margin: EdgeInsets.symmetric(
    //                   vertical: MediaQuery.of(context).size.height * 0.02),
    //               height: MediaQuery.of(context).size.height * 0.6,
    //               child: Center(
    //                 child: Text('Thank You'),
    //               )),
    //           Text(
    //             "That all for the bet match tutorial guides. ",
    //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    //             textAlign: TextAlign.justify,
    //           ),
    //         ])),
    //   ],
    // );
  }

  ButtonStyle myButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(StadiumBorder()),
      backgroundColor: MaterialStateProperty.all<Color>(Color(0x33F3B4BA)),
      overlayColor: MaterialStateProperty.all<Color>(Color(0x33FFA8B0)),
    );
  }

  ContentConfig slide(String image, String description,
      {String? addtionalText, String? wayToEarn, String? columnText}) {
    return ContentConfig(
      backgroundColor: Constant.backgroundColor,
      description: description,
      styleDescription: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontStyle: FontStyle.italic,
        fontFamily: 'Raleway',
      ),
      verticalScrollbarBehavior: ScrollbarBehavior.alwaysShow,
      widgetDescription: Column(children: [
        RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
            text: description,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontFamily: 'Raleway',
            ),
            children: <TextSpan>[
              if (addtionalText != null)
                TextSpan(
                    text: addtionalText,
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 14)),
            ],
          ),
        ),
        if (columnText != null)
          Text(
            columnText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontFamily: 'Raleway',
            ),
          ),
        if (wayToEarn != null)
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => WayToEarnMoreMoney()));
            },
            child: Text(
              wayToEarn,
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.blue,
                fontSize: 16.0,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontFamily: 'Raleway',
              ),
            ),
          )
      ]),
      marginDescription:
          EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 70.0),
      centerWidget: Container(
        // margin: EdgeInsets.symmetric(
        //     vertical: MediaQuery.of(context).size.height * 0.02),
        height: MediaQuery.of(context).size.height * 0.5,
        child: Image.asset(image),
      ),
      directionColorBegin: Alignment.topLeft,
      directionColorEnd: Alignment.bottomRight,
      onCenterItemPress: () {},
    );
  }
}
