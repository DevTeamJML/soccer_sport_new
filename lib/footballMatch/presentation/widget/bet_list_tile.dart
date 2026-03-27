import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/favorite_match/presentation/bloc/favorite_match_bloc.dart';
import 'package:soccer_sport/footballMatch/domain/entities/bet_entities/bet.dart';
import 'package:soccer_sport/footballMatch/domain/entities/event%20subentities/time.dart';
import 'package:soccer_sport/footballMatch/domain/entities/event.dart';
import 'package:soccer_sport/footballMatch/domain/entities/football_match.dart';
import 'package:soccer_sport/footballMatch/domain/usecase/check_fixture_on_live.dart';
import 'package:soccer_sport/footballMatch/presentation/bloc/football_match_bloc.dart';
import 'package:collection/collection.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_away_widget.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_events_text.dart';
import 'package:soccer_sport/footballMatch/presentation/widget/football_home_widget.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../../injection_container.dart';
import 'package:collection/collection.dart';

class BetListTile extends StatelessWidget {
  final Bet bet;
  const BetListTile({required this.bet});

  @override
  Widget build(BuildContext context) {
    String result = '';
    bool predict = false;
    String resultLogo = '';
    Color homeColor = Colors.black;
    Color awayColor = Colors.black;
    if (bet.home.winner != null &&
        bet.away.winner != null &&
        (bet.status == 'FT' || bet.status == 'AET' || bet.status == 'PEN')) {
      bool homeWin = (bet.home.winner! && (!bet.away.winner!));
      bool awayWin = (bet.away.winner! && (!bet.home.winner!));
      bool draw = bet.home.winner! == bet.away.winner!;

      String whoWin = '';
      if (homeWin || awayWin) {
        if (homeWin) {
          result = bet.home.name;
          resultLogo = bet.home.logoUrl;
          homeColor = Colors.green;
        } else {
          homeColor = Colors.red;
        }
        if (awayWin) {
          result = bet.away.name;
          resultLogo = bet.away.logoUrl;
          awayColor = Colors.green;
        } else {
          awayColor = Colors.red;
        }
      }
      if (draw) {
        result = "Draw";
        homeColor = Colors.grey;
        awayColor = Colors.grey;
      }

      if (bet.predict == "Home" && homeWin) {
        predict = true;
      }
      if (bet.predict == "Away" && awayWin) {
        predict = true;
      }

      if (bet.predict == "Draw" && draw) {
        predict = true;
      }
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.all(
            Radius.circular(20.0),
          )),
      child: Row(children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
              (bet.status == 'FT' || bet.status == 'AET' || bet.status == 'PEN')
                  ? "Finished"
                  : "Ongoing",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
        ),
        Expanded(
          flex: 2,
          child: Row(children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    // height: MediaQuery.of(context).size.height * 0.05,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.045,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: bet.home.logoUrl,
                              imageErrorBuilder: (e, o, c) {
                                return Container();
                              }),
                        ),
                        Expanded(
                          child: Text(bet.home.name,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: TextStyle(color: homeColor, fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    // height: MediaQuery.of(context).size.height * 0.04,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.045,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: bet.away.logoUrl,
                              imageErrorBuilder: (e, o, c) {
                                return Container();
                              }),
                        ),
                        Expanded(
                          child: Text(bet.away.name,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: TextStyle(color: awayColor, fontSize: 12)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(bottom: 3),
                      // decoration: BoxDecoration(
                      //     border:
                      //         Border(bottom: BorderSide(color: Colors.black))),
                      child: Center(
                        child: Text(
                          "Bet on:",
                          style: TextStyle(color: Colors.black, fontSize: 12),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (bet.predict != "Draw")
                          Container(
                            width: MediaQuery.of(context).size.width * 0.045,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: bet.predict == "Home"
                                    ? bet.home.logoUrl
                                    : bet.predict == "Away"
                                        ? bet.away.logoUrl
                                        : '',
                                imageErrorBuilder: (e, o, c) {
                                  return Container();
                                }),
                          ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 1, horizontal: 3),
                          // decoration: BoxDecoration(
                          //     color: result == '' && !predict
                          //         ? Constant.color2
                          //         : result != '' && predict
                          //             ? Colors.green
                          //             : Colors.red,
                          //     border: Border.all(),
                          //     borderRadius: BorderRadius.all(
                          //       Radius.circular(5.0),
                          //     )),
                          child: Center(
                            child: Text(
                                bet.predict == "Home"
                                    ? bet.home.name
                                    : bet.predict == "Away"
                                        ? bet.away.name
                                        : bet.predict,
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.fade,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12)),
                          ),
                        ),
                      ],
                    ),

                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.045,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image:
                                'https://soccersport.club/wp-content/uploads/2021/12/Jan22-SSC-Coin-icon-150x150-1.png',
                            imageErrorBuilder: (e, o, c) {
                              return Container();
                            }),
                      ),
                      Text(bet.value.toString(),
                          style: TextStyle(color: Colors.black)),
                    ]),

                    // Row(children: [
                    //   Text("Bet :", style: TextStyle(color: Colors.black)),
                    //   Container(
                    //     width: MediaQuery.of(context).size.width * 0.045,
                    //     margin: EdgeInsets.symmetric(horizontal: 5),
                    //     child: FadeInImage.memoryNetwork(
                    //         placeholder: kTransparentImage,
                    //         image:
                    //             'https://soccersport.club/wp-content/uploads/2021/12/Jan22-SSC-Coin-icon-150x150-1.png',
                    //         imageErrorBuilder: (e, o, c) {
                    //           return Container();
                    //         }),
                    //   ),
                    //   Text(bet.value.toString(),
                    //       style: TextStyle(color: Colors.black)),
                    // ]),
                    // Container(
                    //   padding: EdgeInsets.symmetric(vertical: 1, horizontal: 3),
                    //   decoration: BoxDecoration(
                    //       color: result == '' && !predict
                    //           ? Constant.color2
                    //           : result != '' && predict
                    //               ? Colors.green
                    //               : Colors.red,
                    //       border: Border.all(),
                    //       borderRadius: BorderRadius.all(
                    //         Radius.circular(5.0),
                    //       )),
                    //   child: Text(
                    //       bet.predict == "Home"
                    //           ? bet.home.name
                    //           : bet.predict == "Away"
                    //               ? bet.away.name
                    //               : bet.predict,
                    //       style: TextStyle(color: Colors.black)),
                    // ),
                    // Row(children: [
                    //   Text('Earn :', style: TextStyle(color: Colors.black)),
                    //   Container(
                    //     width: MediaQuery.of(context).size.width * 0.045,
                    //     margin: EdgeInsets.symmetric(horizontal: 5),
                    //     child: FadeInImage.memoryNetwork(
                    //         placeholder: kTransparentImage,
                    //         image:
                    //             'https://soccersport.club/wp-content/uploads/2021/12/Jan22-SSC-Coin-icon-150x150-1.png',
                    //         imageErrorBuilder: (e, o, c) {
                    //           return Container();
                    //         }),
                    //   ),
                    //   Text(
                    //       result == '' && !predict
                    //           ? '0'
                    //           : result != '' && predict
                    //               ? '+ ' + bet.value.toString()
                    //               : '- ' + bet.value.toString(),
                    //       style: TextStyle(
                    //         color: result == '' && !predict
                    //             ? Colors.black
                    //             : result != '' && predict
                    //                 ? Colors.green
                    //                 : Colors.red,
                    //       )),
                    // ])
                  ],
                ),
              ),
            ),
            if ((bet.status == 'FT' ||
                bet.status == 'AET' ||
                bet.status == 'PEN'))
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Result",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12))
                          ]),
                      // Divider(),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (resultLogo != '')
                              Container(
                                width:
                                    MediaQuery.of(context).size.width * 0.045,
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: resultLogo,
                                    imageErrorBuilder: (e, o, c) {
                                      return Container();
                                    }),
                              ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 1, horizontal: 3),
                                // decoration: BoxDecoration(
                                //     color: result == '' && !predict
                                //         ? Constant.color2
                                //         : result != '' && predict
                                //             ? Colors.green
                                //             : Colors.red,
                                //     border: Border.all(),
                                //     borderRadius: BorderRadius.all(
                                //       Radius.circular(5.0),
                                //     )),
                                child: Center(
                                  child: Text(result,
                                      maxLines: 1,
                                      softWrap: false,
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12)),
                                ),
                              ),
                            ),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Text('Earn :', style: TextStyle(color: Colors.black)),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.045,
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              child: FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image:
                                      'https://soccersport.club/wp-content/uploads/2021/12/Jan22-SSC-Coin-icon-150x150-1.png',
                                  imageErrorBuilder: (e, o, c) {
                                    return Container();
                                  }),
                            ),
                            Text(
                                result == '' && !predict
                                    ? '0'
                                    : result != '' && predict
                                        ? '+ ' + bet.value.toString()
                                        : '- ' + bet.value.toString(),
                                style: TextStyle(
                                  color: result == '' && !predict
                                      ? Colors.black
                                      : result != '' && predict
                                          ? Colors.green
                                          : Colors.red,
                                )),
                          ])
                    ],
                  ),
                ),
              ),
            if ((bet.status != 'FT' &&
                bet.status != 'AET' &&
                bet.status != 'PEN'))
              Expanded(
                child: Container(),
              )
          ]),
        ),
      ]),
    );
    // return Container(
    //   height: MediaQuery.of(context).size.height * 0.1,
    //   decoration: BoxDecoration(
    //       color: Colors.white,
    //       borderRadius: new BorderRadius.all(
    //         Radius.circular(20.0),
    //       )),
    //   child: Column(children: [
    //     Expanded(
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           Expanded(
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               crossAxisAlignment: CrossAxisAlignment.end,
    //               children: [
    //                 Expanded(
    //                     flex: 2,
    //                     child: Row(
    //                       children: [
    //                         SizedBox(
    //                           width: 10,
    //                         ),
    //                         Expanded(
    //                           child: AutoSizeText(
    //                             bet.home.name,
    //                             minFontSize: 8,
    //                             wrapWords: false,
    //                             textAlign: TextAlign.center,
    //                             style: TextStyle(
    //                               color: Colors.black,
    //                             ),
    //                           ),
    //                         ),
    //                         Image.network(
    //                           bet.home.logoUrl,
    //                           width: 36.0,
    //                         ),
    //                       ],
    //                     )),
    //               ],
    //             ),
    //           ),

    //           // if (!log)
    //           //   Expanded(
    //           //     child: Text(
    //           //       Constant.formattedTime(bet.date.toLocal()),
    //           //       textAlign: TextAlign.center,
    //           //       style: TextStyle(
    //           //         color: Colors.black,
    //           //         fontSize: 16.0,
    //           //       ),
    //           //     ),
    //           //   ),
    //           // if (log)
    //           Expanded(
    //               child: Column(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             children: [
    //               SizedBox(
    //                 height: MediaQuery.of(context).size.height * 0.01,
    //               ),
    //               Text(
    //                 bet.status,
    //                 style: TextStyle(
    //                   color: Colors.green,
    //                   fontSize: 12.0,
    //                 ),
    //               ),
    //               SizedBox(
    //                 height: MediaQuery.of(context).size.height * 0.02,
    //               ),
    //             ],
    //           )),
    //           Expanded(
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               crossAxisAlignment: CrossAxisAlignment.end,
    //               children: [
    //                 Expanded(
    //                     flex: 2,
    //                     child: Row(
    //                       children: [
    //                         SizedBox(
    //                           width: 10,
    //                         ),
    //                         Expanded(
    //                           child: AutoSizeText(
    //                             bet.away.name,
    //                             minFontSize: 8,
    //                             wrapWords: false,
    //                             textAlign: TextAlign.center,
    //                             style: TextStyle(
    //                               color: Colors.black,
    //                             ),
    //                           ),
    //                         ),
    //                         Image.network(
    //                           bet.away.logoUrl,
    //                           width: 36.0,
    //                         ),
    //                       ],
    //                     )),
    //               ],
    //             ),
    //           ),
    //           // Image.network(
    //           //   match.away.logoUrl,
    //           //   width: 36.0,
    //           // ),
    //           // Expanded(
    //           //   child: Text(
    //           //     match.away.name,
    //           //     textAlign: TextAlign.center,
    //           //     style: TextStyle(
    //           //       color: Colors.black,
    //           //       fontSize: 16.0,
    //           //     ),
    //           //   ),
    //           // ),
    //         ],
    //       ),
    //     ),
    //   ]),
    // );
  }
}
