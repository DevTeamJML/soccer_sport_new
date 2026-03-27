import 'package:advance_notification/advance_notification.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:soccer_sport/authentication/presentation/page/login_page.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/footballMatch/domain/entities/bet_entities/bet.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/bet_dialog.dart';

class BetButton extends StatelessWidget {
  final String predict;
  final FootballMatch match;
  final Bet? bet;
  final Function refresh;
  BetButton(
      {required this.predict,
      required this.match,
      this.bet,
      required this.refresh});

  @override
  Widget build(BuildContext context) {
    String name = '';
    if (predict == "Draw") {
      name = predict;
    } else {
      if (predict == "Home") {
        name = match.home.name;
      }
      if (predict == "Away") {
        name = match.away.name;
      }
    }
    return GestureDetector(
      onTap: () {
        if (Constant.auth != null) {
          var now = DateTime.now();

          var matchDate = DateTime.parse(match.fixture.date).toLocal();
          var fiveMinBefore = DateTime(matchDate.year, matchDate.month,
              matchDate.day, matchDate.hour, matchDate.minute);

          if (bet == null) {
            if (Constant.betList[0].length < 200) {
              if (!(fiveMinBefore.difference(now).isNegative)) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return BetDialog(
                      predict: predict,
                      match: match,
                    );
                  },
                ).then((value) => refresh());
              } else {
                AdvanceSnackBar(
                        mode: Mode.ADVANCE,
                        message: "Allowed to bet 5min before the match begin.",
                        bgColor: Constant.color1)
                    .show(context);
              }
            } else {
              AdvanceSnackBar(
                      mode: Mode.ADVANCE,
                      message: "Only can bet up to 200 matches",
                      bgColor: Constant.color1)
                  .show(context);
            }
          }
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      },
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            color: bet != null && bet!.predict != predict
                ? Colors.grey
                : Constant.color1,
          ),
          width: MediaQuery.of(context).size.width * 0.2,
          child: Center(
            child: AutoSizeText(
              name,
              style: TextStyle(
                color: Colors.white,
              ),
              minFontSize: 6,
              textAlign: TextAlign.center,
            ),
          )),
    );
  }
}
