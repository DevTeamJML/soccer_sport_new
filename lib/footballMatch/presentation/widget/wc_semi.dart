import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/wc_semi_group_listtile.dart';

class WCSemiFinals extends StatefulWidget {
  final List<FootballMatch>? liveMatches;
  final List<FootballMatch>? matches;

  WCSemiFinals({
    this.liveMatches,
    this.matches,
  });

  @override
  State<WCSemiFinals> createState() => _WCSemiFinalsState();
}

class _WCSemiFinalsState extends State<WCSemiFinals> {
  List<FootballMatch>? liveMatches;
  List<FootballMatch>? match;

  FootballMatch? first;
  FootballMatch? second;
  @override
  void initState() {
    liveMatches = widget.liveMatches;
    match = widget.matches;
    first = liveMatches != null && liveMatches!.length > 0
        ? liveMatches!.firstWhereOrNull((element) {
            return Constant.formattedDateMonth(
                        (DateTime.parse(element.fixture.date).toLocal())) ==
                    '12/14' &&
                Constant.formattedHMTime(
                        (DateTime.parse(element.fixture.date).toLocal())) ==
                    '03:00';
          })
        : null;
    second = liveMatches != null && liveMatches!.length > 0
        ? liveMatches!.firstWhereOrNull((element) {
            return Constant.formattedDateMonth(
                        (DateTime.parse(element.fixture.date).toLocal())) ==
                    '12/15' &&
                Constant.formattedHMTime(
                        (DateTime.parse(element.fixture.date).toLocal())) ==
                    '03:00';
          })
        : null;
    super.initState();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WCSemiGroupListtile(
      first: match != null &&
              first != null &&
              match!.first.fixture.id == first!.fixture.id
          ? match!.first
          : first,
      second: match != null &&
              second != null &&
              match!.first.fixture.id == second!.fixture.id
          ? match!.first
          : second,
      firstDate: '12/14',
      firstTime: '03:00',
      secondDate: '12/15',
      secondTime: '03:00',
    );
  }
}
