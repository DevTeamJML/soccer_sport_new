import 'package:flutter/material.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/footballMatch/domain/entities/bet_ranking/bet_ranking.dart';

class BetRankListtile extends StatelessWidget {
  final BetRanking betRanking;

  final int index;
  final bool isWinCount;
  final bool? isMe;
  const BetRankListtile(
      {required this.betRanking,
      required this.index,
      required this.isWinCount,
      this.isMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.01,
          horizontal: MediaQuery.of(context).size.width * 0.02),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(3, 3),
            spreadRadius: -3,
            blurRadius: 6,
            color: Color.fromRGBO(255, 255, 255, 1),
          )
        ],
        color: isMe != null && isMe! ? Constant.color2 : Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            index == 1
                ? "1st"
                : index == 2
                    ? "2nd"
                    : index == 3
                        ? "3rd"
                        : (index.toString() + "th"),
            style: TextStyle(color: Colors.black),
          ),
        ),
        Expanded(
          child: Text(
            betRanking.name,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            isWinCount
                ? betRanking.total_win.toString()
                : betRanking.total_coin.toString(),
            style: TextStyle(color: Colors.black),
          ),
        )
      ]),
    );
  }
}
