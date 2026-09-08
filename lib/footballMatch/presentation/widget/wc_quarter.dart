import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/wc_quarter_group_listtile.dart';

class WCQuarterFinals extends StatefulWidget {
  final List<FootballMatch>? liveMatches;
  final List<FootballMatch>? matches;
  WCQuarterFinals({
    this.liveMatches,
    this.matches,
  });
  @override
  State<WCQuarterFinals> createState() => _WCQuarterFinalsState();
}

class _WCQuarterFinalsState extends State<WCQuarterFinals> {
  List<FootballMatch>? liveMatches;
  List<FootballMatch>? match;
  FootballMatch? first;
  FootballMatch? second;
  FootballMatch? third;
  FootballMatch? fourth;
  @override
  void initState() {
    liveMatches = widget.liveMatches;
    match = widget.matches;
    first = liveMatches != null && liveMatches!.length > 0
        ? liveMatches!.firstWhereOrNull((element) {
            return Constant.formattedDateMonth(
                        (DateTime.parse(element.fixture.date).toLocal())) ==
                    '12/10' &&
                Constant.formattedHMTime(
                        (DateTime.parse(element.fixture.date).toLocal())) ==
                    '03:00';
          })
        : null;
    second = liveMatches != null && liveMatches!.length > 0
        ? liveMatches!.firstWhereOrNull((element) {
            return Constant.formattedDateMonth(
                        (DateTime.parse(element.fixture.date).toLocal())) ==
                    '12/9' &&
                Constant.formattedHMTime(
                        (DateTime.parse(element.fixture.date).toLocal())) ==
                    '23:00';
          })
        : null;

    third = liveMatches != null && liveMatches!.length > 0
        ? liveMatches!.firstWhereOrNull((element) {
            return Constant.formattedDateMonth(
                        (DateTime.parse(element.fixture.date).toLocal())) ==
                    '12/11' &&
                Constant.formattedHMTime(
                        (DateTime.parse(element.fixture.date).toLocal())) ==
                    '03:00';
          })
        : null;

    fourth = liveMatches != null && liveMatches!.length > 0
        ? liveMatches!.firstWhereOrNull((element) {
            return Constant.formattedDateMonth(
                        (DateTime.parse(element.fixture.date).toLocal())) ==
                    '12/10' &&
                Constant.formattedHMTime(
                        (DateTime.parse(element.fixture.date).toLocal())) ==
                    '23:00';
          })
        : null;
    super.initState();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      WCQuarterGroupListtile(
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
        firstDate: '12/10',
        firstTime: '03:00',
        secondDate: '12/9',
        secondTime: '23:00',
      ),
      WCQuarterGroupListtile(
        first: match != null &&
                third != null &&
                match!.first.fixture.id == third!.fixture.id
            ? match!.first
            : third,
        second: match != null &&
                fourth != null &&
                match!.first.fixture.id == fourth!.fixture.id
            ? match!.first
            : fourth,
        firstDate: '12/11',
        firstTime: '03:00',
        secondDate: '12/10',
        secondTime: '23:00',
      ),
    ]);
  }
}
