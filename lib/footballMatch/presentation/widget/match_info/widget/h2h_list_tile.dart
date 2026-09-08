import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';

class H2HListtile extends StatefulWidget {
  final FootballMatch footballMatch;
  final Key key;

  const H2HListtile({
    required this.footballMatch,
    required this.key,
  }) : super(key: key);

  @override
  State<H2HListtile> createState() => _H2HListtileState();
}

class _H2HListtileState extends State<H2HListtile> {
  late FootballMatch match;
  @override
  void initState() {
    // TODO: implement initState
    match = widget.footballMatch;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.only(left: 5),
        height: MediaQuery.of(context).size.height * 0.09,
        width: double.infinity,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Expanded(flex: 1, child: Container()),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: AutoSizeText(
                      Constant.formattedDate(
                          DateTime.parse(match.fixture.date).toLocal()),
                      wrapWords: false,
                      minFontSize: 6,
                      style: TextStyle(fontSize: 10, color: Colors.black)),
                )
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: AutoSizeText(
                    match.home.name,
                    wrapWords: false,
                    textAlign: TextAlign.center,
                    minFontSize: 6,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Image.network(
                  match.home.logoUrl,
                  width: 36.0,
                ),
                Expanded(
                  child: match.fixture.status.short == "NS" ||
                          match.fixture.status.short == "TBD" ||
                          match.fixture.status.short == "PST" ||
                          match.fixture.status.short == "CANC" ||
                          match.fixture.status.short == "ABD" ||
                          match.fixture.status.short == "AWD" ||
                          match.fixture.status.short == "WO"
                      ? Text(match.fixture.status.long!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                          ))
                      : AutoSizeText(
                          "${match.goal != null && match.goal!.home != null ? match.goal!.home : '0'} - ${match.goal != null && match.goal!.away != null ? match.goal!.away : '0'}",
                          textAlign: TextAlign.center,
                          wrapWords: false,
                          minFontSize: 6,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                        ),
                ),
                Image.network(
                  match.away.logoUrl,
                  width: 36.0,
                ),
                Expanded(
                  child: AutoSizeText(
                    match.away.name,
                    textAlign: TextAlign.center,
                    wrapWords: false,
                    minFontSize: 6,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(flex: 2, child: Container())
        ]),
      ),
    );
  }
}
