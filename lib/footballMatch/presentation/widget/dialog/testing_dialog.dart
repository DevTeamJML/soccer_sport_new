import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/footballMatch/domain/entities/bet_entities/bet.dart';
import 'package:transparent_image/transparent_image.dart';

class TestingDialog extends StatelessWidget {
  // final Bet bet;
  // const PredictResult({required this.bet});

  @override
  Widget build(BuildContext context) {
    // bool homeWin = (bet.home.winner! && (!bet.away.winner!));
    // bool awayWin = (bet.away.winner! && (!bet.home.winner!));
    // bool draw = bet.home.winner! == bet.away.winner!;
    bool predict = false;

    String whoWin = '';
    // if (homeWin || awayWin) {
    //   if (homeWin) {
    //     whoWin = bet.home.name + ' has won';
    //   }
    //   if (awayWin) {
    //     whoWin = bet.away.name + ' has won';
    //   }
    // }
    // if (draw) {
    //   whoWin = "It's draw";
    // }

    // if (bet.predict == "Home" && homeWin) {
    //   predict = true;
    // }
    // if (bet.predict == "Away" && awayWin) {
    //   predict = true;
    // }

    // if (bet.predict == "Draw" && draw) {
    //   predict = true;
    // }

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Constant.backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.35,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.07,
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: 'testing',
                    imageErrorBuilder: (e, o, c) {
                      return Container();
                    }),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: AutoSizeText('testingsdfffsdfsfdfsdfds',
                          textAlign: TextAlign.center,
                          minFontSize: 6,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      flex: 2,
                      child: AutoSizeText('VS',
                          textAlign: TextAlign.center,
                          minFontSize: 6,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      flex: 5,
                      child: AutoSizeText('testingdsfas',
                          textAlign: TextAlign.center,
                          minFontSize: 6,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.05,
                margin: EdgeInsets.symmetric(horizontal: 5),
                child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: 'testing',
                    imageErrorBuilder: (e, o, c) {
                      return Container();
                    }),
              ),
            ],
          ),
          Text('Result: ' + "dgffdgfdfgfgfdgfgfdgfdgdgfgdfgdfgdfg",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'You predict ' +
                      // (bet.predict == "Home"
                      //     ? bet.home.name
                      //     : bet.predict == "Away"
                      //         ? bet.away.name
                      //         : bet.predict) +
                      ' ',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              Container(
                width: MediaQuery.of(context).size.width * 0.05,
                child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image:
                        'https://soccersport.club/wp-content/uploads/2021/12/Jan22-SSC-Coin-icon-150x150-1.png',
                    imageErrorBuilder: (e, o, c) {
                      return Container();
                    }),
              ),
              Text(
                  '(' +
                      // (predict
                      //     ? (' +' + (bet.value * 2).toString())
                      //     : (' -' + bet.value.toString())) +
                      ')',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))
            ],
          ),
        ]),
      ),
    );
  }
}
