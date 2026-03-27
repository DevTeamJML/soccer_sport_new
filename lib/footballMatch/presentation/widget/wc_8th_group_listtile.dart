import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/wc_content.dart';

class WC8thGroupListtile extends StatelessWidget {
  final FootballMatch? first;
  final FootballMatch? second;
  final String firstDate;
  final String firstTime;

  final String secondDate;
  final String secondTime;

  WC8thGroupListtile({
    this.first,
    this.second,
    required this.firstDate,
    required this.firstTime,
    required this.secondDate,
    required this.secondTime,
  });

  @override
  Widget build(BuildContext context) {
    String firstHome = 'TBD';
    String firstAway = 'TBD';
    String firstHomeGoal = '0';
    String firstAwayGoal = '0';
    if (first != null) {
      //name
      firstHome = first!.home.name;
      firstAway = first!.away.name;
      // if(first!.home.name.split(' ').length >1){

      // }else{=  first!.home.name;
      //   // if(first!.home.name.length > 10){
      //   //   firstHome =first!.home.;
      //   // }else{
      //   //
      //   // }
      // }
      // if(first!.away.name.split(' ').length >1){

      // }else{

      // }
      //goal
      if (first!.goal != null) {
        if (first!.goal!.away != null) {
          firstHomeGoal = first!.goal!.away.toString();
        }
        if (first!.goal!.home != null) {
          firstAwayGoal = first!.goal!.home.toString();
        }
      }
    }

    return Expanded(
      child: Column(
        children: [
          WcContent(
            match: first != null ? first : null,
            date: firstDate,
            time: firstTime,
            downward: true,
          ),
          WcContent(
            match: second != null ? second : null,
            date: secondDate,
            time: secondTime,
            downward: false,
          ),
        ],
      ),
    );
  }
}
