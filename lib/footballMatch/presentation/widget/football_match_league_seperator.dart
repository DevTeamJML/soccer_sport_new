import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';

class FootballMatchLeagueSeperator extends StatelessWidget {
  final String league;
  final List<FootballMatch> matchs;
  FootballMatchLeagueSeperator({required this.league, required this.matchs});

  @override
  Widget build(BuildContext context) {
    final FootballMatch? match =
        matchs.firstWhereOrNull((element) => element.league!.name == league);
    return Center(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Expanded(
            //   flex: 2,
            //   child: Container(),
            // ),
            if (match != null)
              Stack(children: [
                Container(
                  width: 36.0,
                  height: 36.0,
                  color: Colors.white,
                ),
                FittedBox(
                  fit: BoxFit.fill,
                  child: Image.network(
                    match.league!.logo!,
                    width: 36.0,
                    height: 36.0,
                  ),
                ),
              ]),
            if (match != null)
              SizedBox(
                width: 8,
              ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75),
                child: AutoSizeText(
                  league,
                  minFontSize: 5,
                  wrapWords: false,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
