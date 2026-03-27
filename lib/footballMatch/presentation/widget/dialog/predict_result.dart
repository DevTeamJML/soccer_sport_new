import 'package:flutter/material.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/footballMatch/domain/entities/bet_entities/bet.dart';
import 'package:transparent_image/transparent_image.dart';

class PredictResult extends StatelessWidget {
  final Bet bet;
  const PredictResult({required this.bet});

  @override
  Widget build(BuildContext context) {
    bool homeWin = (bet.home.winner! && (!bet.away.winner!));
    bool awayWin = (bet.away.winner! && (!bet.home.winner!));
    bool draw = bet.home.winner! == bet.away.winner!;
    bool predict = false;

    String whoWin = '';
    if (homeWin || awayWin) {
      if (homeWin) {
        whoWin = bet.home.name + ' has won';
      }
      if (awayWin) {
        whoWin = bet.away.name + ' has won';
      }
    }
    if (draw) {
      whoWin = "It's draw";
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
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.07,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: bet.home.logoUrl,
                          imageErrorBuilder: (e, o, c) {
                            return Container();
                          }),
                    ),
                    Text(bet.home.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(3),
                child: Text('VS',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(bet.away.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.05,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: bet.away.logoUrl,
                          imageErrorBuilder: (e, o, c) {
                            return Container();
                          }),
                    ),
                  ],
                ),
              )
            ],
          ),
          Text('Result: ' + whoWin,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'You predict ' +
                      (bet.predict == "Home"
                          ? bet.home.name
                          : bet.predict == "Away"
                              ? bet.away.name
                              : bet.predict) +
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
                      (predict
                          ? (' +' + (bet.value * 2).toString())
                          : (' -' + bet.value.toString())) +
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
