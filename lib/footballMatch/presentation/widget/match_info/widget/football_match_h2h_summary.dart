import 'package:flutter/material.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';

class H2HSummary extends StatelessWidget {
  final List<FootballMatch> matches;
  final FootballMatch match;

  const H2HSummary({required this.matches, required this.match});

  @override
  Widget build(BuildContext context) {
    var current_match_home = match.home;
    var current_match_away = match.away;

    // int homeValue = matches.where((element) {
    //   var tempHomeGoal = (element.goal != null && element.goal!.home != null) ? element.goal!.home! : 0;
    //   var tempAwayGoal = (element.goal != null && element.goal!.away != null) ? element.goal!.away! : 0;

    //   var home = element.home.id == current_match_home.id
    //       ? tempHomeGoal
    //       : tempAwayGoal;
    //   var away = element.away.id == current_match_away.id
    //       ? tempAwayGoal
    //       : tempHomeGoal;

    //   return home > away;
    // }).length;

    int homeValue = 0;
    int awayValue = 0;
    int drawValue = 0;

    matches.forEach((element) {
      var tempHomeGoal = (element.goal != null && element.goal!.home != null)
          ? element.goal!.home!
          : 0;
      var tempAwayGoal = (element.goal != null && element.goal!.away != null)
          ? element.goal!.away!
          : 0;
      var home = element.home.id == current_match_home.id
          ? tempHomeGoal
          : tempAwayGoal;
      var away = element.away.id == current_match_away.id
          ? tempAwayGoal
          : tempHomeGoal;

      if (home > away) {
        homeValue += 1;
      }
      if (away > home) {
        awayValue += 1;
      }
      if (home == away) {
        drawValue += 1;
      }
    });
    // int awayValue = matches.where((element) {
    //    var tempHomeGoal = (element.goal != null && element.goal!.home != null) ? element.goal!.home! : 0;
    //   var tempAwayGoal = (element.goal != null && element.goal!.away != null) ? element.goal!.away! : 0;
    //  var home = element.home.id == current_match_home.id
    //       ? tempHomeGoal
    //       : tempAwayGoal;
    //   var away = element.away.id == current_match_away.id
    //       ? tempAwayGoal
    //       : tempHomeGoal;
    //   return away > home;
    // }).length;
    // int drawValue = matches
    //     .where((element) {
    //        var tempHomeGoal = (element.goal != null && element.goal!.home != null) ? element.goal!.home! : 0;
    //   var tempAwayGoal = (element.goal != null && element.goal!.away != null) ? element.goal!.away! : 0;
    //  var home = element.home.id == current_match_home.id
    //       ? tempHomeGoal
    //       : tempAwayGoal;
    //   var away = element.away.id == current_match_away.id
    //       ? tempAwayGoal
    //       : tempHomeGoal;
    //   return away == home;
    //     })
    //     .length;

    int totalValue = homeValue + awayValue + drawValue;
    double width = MediaQuery.of(context).size.width - 50;
    double height = MediaQuery.of(context).size.height;

    return Container(
      height: height * 0.055,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white, width: 0.3))),
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 5,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text("Win " + homeValue.toString()),
                ),
                Expanded(
                    child: Center(child: Text("Draw " + drawValue.toString()))),
                Expanded(
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Text("Win " + awayValue.toString())),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: width * (homeValue / totalValue),
                    child: Container(
                      color: Constant.color2,
                    ),
                  ),
                  Container(
                      width: width * (drawValue / totalValue),
                      child: Container(color: Colors.grey)),
                  Container(
                      width: width * (awayValue / totalValue),
                      child: Container(color: Constant.color1)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
