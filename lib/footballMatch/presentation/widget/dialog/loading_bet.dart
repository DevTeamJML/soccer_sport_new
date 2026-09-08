import 'package:flutter/material.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';

class LoadingBet extends StatelessWidget {
  const LoadingBet();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        color: Constant.backgroundColor,
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.35,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
              child: LoadingWidget()),
          Text('Loading Bet results....'),
        ]),
      ),
    );
  }
}
