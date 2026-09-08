import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/wc_8th_group_listtile.dart';

class WC8thFinals extends StatefulWidget {
  final List<FootballMatch>? liveMatches;
  final List<FootballMatch>? matches;
  WC8thFinals({
    this.liveMatches,
    this.matches,
  });
  @override
  State<WC8thFinals> createState() => _WC8thFinalsState();
}

class _WC8thFinalsState extends State<WC8thFinals> {
  List<FootballMatch>? liveMatches;
  List<FootballMatch>? match;
  FootballMatch? first;
  FootballMatch? second;
  FootballMatch? third;
  FootballMatch? fourth;
  FootballMatch? fifth;
  FootballMatch? sixth;
  FootballMatch? seven;
  FootballMatch? eight;

  @override
  void initState() {
    liveMatches = widget.liveMatches;
    match = widget.matches;

    first = liveMatches != null && liveMatches!.length > 0
        ? liveMatches!.firstWhereOrNull((element) {
            return Constant.formattedDateMonth(
                        (DateTime.parse(element.fixture.date).toLocal())) ==
                    '12/3' &&
                Constant.formattedHMTime(
                        (DateTime.parse(element.fixture.date).toLocal())) ==
                    '23:00';
          })
        : null;
    second = liveMatches != null && liveMatches!.length > 0
        ? liveMatches!.firstWhereOrNull((element) {
            return (Constant.formattedDateMonth(
                            (DateTime.parse(element.fixture.date).toLocal())) ==
                        '12/3' &&
                    Constant.formattedHMTime(
                            (DateTime.parse(element.fixture.date).toLocal())) ==
                        '03:00') ||
                element.fixture.id == 976642;
          })
        : null;
    third = liveMatches != null && liveMatches!.length > 0
        ? liveMatches!.firstWhereOrNull((element) {
            return Constant.formattedDateMonth(
                        (DateTime.parse(element.fixture.date).toLocal())) ==
                    '12/5' &&
                Constant.formattedHMTime(
                        (DateTime.parse(element.fixture.date).toLocal())) ==
                    '23:00';
          })
        : null;
    fourth = liveMatches != null && liveMatches!.length > 0
        ? liveMatches!.firstWhereOrNull((element) {
            return Constant.formattedDateMonth(
                        (DateTime.parse(element.fixture.date).toLocal())) ==
                    '12/6' &&
                Constant.formattedHMTime(
                        (DateTime.parse(element.fixture.date).toLocal())) ==
                    '03:00';
          })
        : null;
    fifth = liveMatches != null && liveMatches!.length > 0
        ? liveMatches!.firstWhereOrNull((element) {
            return Constant.formattedDateMonth(
                        (DateTime.parse(element.fixture.date).toLocal())) ==
                    '12/4' &&
                Constant.formattedHMTime(
                        (DateTime.parse(element.fixture.date).toLocal())) ==
                    '23:00';
          })
        : null;
    sixth = liveMatches != null && liveMatches!.length > 0
        ? liveMatches!.firstWhereOrNull((element) {
            return Constant.formattedDateMonth(
                        (DateTime.parse(element.fixture.date).toLocal())) ==
                    '12/5' &&
                Constant.formattedHMTime(
                        (DateTime.parse(element.fixture.date).toLocal())) ==
                    '03:00';
          })
        : null;
    // print(Constant.formattedDateMonth(
    //     DateTime.parse(liveMatches![0].fixture.date).toLocal()));
    // print(Constant.formattedHMTime(
    //     DateTime.parse(liveMatches![0].fixture.date).toLocal()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WC8thGroupListtile(
          first: liveMatches != null && liveMatches!.length > 0
              ? liveMatches!.firstWhereOrNull((element) {
                  return Constant.formattedDateMonth(
                              (DateTime.parse(element.fixture.date)
                                  .toLocal())) ==
                          '12/3' &&
                      Constant.formattedHMTime(
                              (DateTime.parse(element.fixture.date)
                                  .toLocal())) ==
                          '23:00';
                })
              : null,
          second: liveMatches != null && liveMatches!.length > 0
              ? liveMatches!.firstWhereOrNull((element) {
                  return (Constant.formattedDateMonth(
                                  (DateTime.parse(element.fixture.date)
                                      .toLocal())) ==
                              '12/3' &&
                          Constant.formattedHMTime(
                                  (DateTime.parse(element.fixture.date)
                                      .toLocal())) ==
                              '03:00') ||
                      element.fixture.id == 976642;
                })
              : null,
          firstDate: '12/3',
          firstTime: '23:00',
          secondDate: '12/4',
          secondTime: '03:00',
        ),
        WC8thGroupListtile(
          first: liveMatches != null && liveMatches!.length > 0
              ? liveMatches!.firstWhereOrNull((element) {
                  return Constant.formattedDateMonth(
                              (DateTime.parse(element.fixture.date)
                                  .toLocal())) ==
                          '12/5' &&
                      Constant.formattedHMTime(
                              (DateTime.parse(element.fixture.date)
                                  .toLocal())) ==
                          '23:00';
                })
              : null,
          second: liveMatches != null && liveMatches!.length > 0
              ? liveMatches!.firstWhereOrNull((element) {
                  return Constant.formattedDateMonth(
                              (DateTime.parse(element.fixture.date)
                                  .toLocal())) ==
                          '12/6' &&
                      Constant.formattedHMTime(
                              (DateTime.parse(element.fixture.date)
                                  .toLocal())) ==
                          '03:00';
                })
              : null,
          firstDate: '12/5',
          firstTime: '23:00',
          secondDate: '12/6',
          secondTime: '03:00',
        ),
        WC8thGroupListtile(
          first: liveMatches != null && liveMatches!.length > 0
              ? liveMatches!.firstWhereOrNull((element) {
                  return Constant.formattedDateMonth(
                              (DateTime.parse(element.fixture.date)
                                  .toLocal())) ==
                          '12/4' &&
                      Constant.formattedHMTime(
                              (DateTime.parse(element.fixture.date)
                                  .toLocal())) ==
                          '23:00';
                })
              : null,
          second: liveMatches != null && liveMatches!.length > 0
              ? liveMatches!.firstWhereOrNull((element) {
                  return Constant.formattedDateMonth(
                              (DateTime.parse(element.fixture.date)
                                  .toLocal())) ==
                          '12/5' &&
                      Constant.formattedHMTime(
                              (DateTime.parse(element.fixture.date)
                                  .toLocal())) ==
                          '03:00';
                })
              : null,
          firstDate: '12/4',
          firstTime: '23:00',
          secondDate: '12/5',
          secondTime: '03:00',
        ),
        WC8thGroupListtile(
          first: liveMatches != null && liveMatches!.length > 0
              ? liveMatches!.firstWhereOrNull((element) {
                  return Constant.formattedDateMonth(
                              (DateTime.parse(element.fixture.date)
                                  .toLocal())) ==
                          '12/6' &&
                      Constant.formattedHMTime(
                              (DateTime.parse(element.fixture.date)
                                  .toLocal())) ==
                          '23:00';
                })
              : null,
          second: liveMatches != null && liveMatches!.length > 0
              ? liveMatches!.firstWhereOrNull((element) {
                  return Constant.formattedDateMonth(
                              (DateTime.parse(element.fixture.date)
                                  .toLocal())) ==
                          '12/7' &&
                      Constant.formattedHMTime(
                              (DateTime.parse(element.fixture.date)
                                  .toLocal())) ==
                          '03:00';
                })
              : null,
          firstDate: '12/6',
          firstTime: '23:00',
          secondDate: '12/7',
          secondTime: '03:00',
        ),
      ],
    );
  }
}
