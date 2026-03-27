import 'package:flutter/material.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/lucky_draw/domain/entities/prize.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../core/widgets/loading_widget.dart';

class LuckyDrawDialog extends StatelessWidget {
  final Prize prize;
  const LuckyDrawDialog({required this.prize});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
          color: Constant.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              blurRadius: 5.0,
              spreadRadius: 2.0,
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width * 0.35,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Container(
          //   padding: EdgeInsets.symmetric(
          //     horizontal: MediaQuery.of(context).size.width * 0.06,
          //     vertical: MediaQuery.of(context).size.height * 0.02,
          //   ),
          //   child: Text(
          //     'Congratulations you have won the prize below',
          //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          //     textAlign: TextAlign.justify,
          //   ),
          // ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.06,
                vertical: MediaQuery.of(context).size.height * 0.02,
              ),
              // color: Colors.red,
              child: Column(children: [
                Expanded(
                  child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: prize.img,
                            imageErrorBuilder: (e, o, c) {
                              return Container();
                            }),
                        if (prize.index == 1 ||
                            prize.index == 2 ||
                            prize.index == 11)
                          Container(
                            padding: EdgeInsets.all(4),
                            color: Constant.color1,
                            child: Text(prize.stack!),
                          ),
                      ]),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Text(
                  "Congratulations you have won " + prize.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                )
              ]),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.02,
            ),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Constant.color1,
                  //onPrimary: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Confirm',
                  style: TextStyle(fontSize: 18),
                )),
          )
        ]),
      ),
    );
  }
}
