import 'dart:async';

import 'package:advance_notification/advance_notification.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/lucky_draw/domain/entities/lucky_draw_info.dart';
import 'package:soccer_sport/lucky_draw/domain/entities/lucky_draw_prize.dart';
import 'package:soccer_sport/lucky_draw/domain/entities/prize.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

class LuckyDrawHsitoryItem extends StatelessWidget {
  final Prize prize;
  final Map<String, dynamic> coupons;
  final List<LuckyDrawPrize> prizes;
  final int index;

  const LuckyDrawHsitoryItem(
      {required this.prize,
      required this.prizes,
      required this.index,
      required this.coupons});

  @override
  Widget build(BuildContext context) {
    DateTime date = prizes[index].date;
    int prizeID = prizes[index].index;
    String? code;
    List<int> listIndex = [];
    // List<int> samePrizeLength = prizes.where((e) => e.index == prizes[index].index).map((e) => e.index).toList();
    List<LuckyDrawPrize> samePrizeList =
        prizes.where((e) => e.index == prizes[index].index).toList();

    if (coupons.keys.contains(prizeID.toString())) {
      List<dynamic> couponsValues =
          (coupons[prizeID.toString()] as List<dynamic>).reversed.toList();
      for (var i = 0; i < samePrizeList.length; i++) {
        if (i < 1) {
          listIndex.add(prizes.map((e) => e.index).toList().indexOf(prizeID));
        } else {
          listIndex.add(prizes
              .map((e) => e.index)
              .toList()
              .indexOf(prizeID, (listIndex.last + 1)));
        }
      }
      int indexOfCoupon = listIndex.indexOf(index);
      code = indexOfCoupon >= couponsValues.length
          ? ''
          : couponsValues[indexOfCoupon];
    }

    // prizes.indexWhere((element) => element.index == prizes[index].index);

    bool notReload = prize.index == 3 || prize.index == 10 || prize.index == 8;
    bool isLongPress = false;
    // Timer? _timer;

    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      margin: EdgeInsets.all(10),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 4.0,
            spreadRadius: 0.1,
            // offset: Offset(0.2, 0.2),
          )
        ],
      ),
      child: Card(
          color: Constant.backgroundColor,
          child: Container(
            child: Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.2,
                  padding:
                      prize.index == 11 || prize.index == 1 || prize.index == 2
                          ? EdgeInsets.all(20)
                          : EdgeInsets.all(0),
                  child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: prize.img,
                      imageErrorBuilder: (e, o, c) {
                        return Container(
                          color: Colors.grey,
                          child: Image.asset('assets/image-loading.jpg'),
                        );
                      }),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            AutoSizeText(
                              prize.name,
                              softWrap: false,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                            ),
                          ],
                        ),
                        if (code != null)
                          Expanded(
                              flex: 2,
                              child: Container(
                                child: Center(
                                  child: AutoSizeText.rich(
                                    TextSpan(
                                      text: "Code: ",
                                      children: [
                                        TextSpan(
                                          text: code,
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.blue,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              await Clipboard.setData(
                                                  ClipboardData(text: code!));
                                              AdvanceSnackBar(
                                                      mode: Mode.ADVANCE,
                                                      message:
                                                          "Copied to clipboard",
                                                      bgColor: Colors.green)
                                                  .show(context);
                                            },
                                        ),
                                      ],
                                    ),
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.fade,
                                    // textAlign: TextAlign.justify,
                                  ),
                                ),
                              )),
                        if (prize.index == 3 ||
                            prize.index == 10 ||
                            prize.index == 8)
                          Expanded(
                              flex: 2,
                              child: Container(
                                child: Center(
                                  child: AutoSizeText.rich(
                                    TextSpan(
                                      text: "Claim at: ",
                                      children: [
                                        TextSpan(
                                            text:
                                                'https://secure.livechatinc.com/licence/9752245/v2/open_chat.cgi',
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.blue,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () async {
                                                if (!isLongPress) {
                                                  if (await canLaunch(
                                                      "https://secure.livechatinc.com/licence/9752245/v2/open_chat.cgi")) {
                                                    await launch(
                                                        "https://secure.livechatinc.com/licence/9752245/v2/open_chat.cgi");
                                                  } else {
                                                    throw 'Could not launch https://secure.livechatinc.com/licence/9752245/v2/open_chat.cgi';
                                                  }
                                                }
                                              }
                                            // ..onTapDown = (v) {
                                            //   _timer = Timer(
                                            //       Duration(milliseconds: 500),
                                            //       () {
                                            //     isLongPress = true;
                                            //   });
                                            // }
                                            // ..onTapUp = (v) async {
                                            //   if (_timer != null &&
                                            //       _timer!.isActive) {
                                            //     print('got active ??');
                                            //     _timer!.cancel();
                                            //     if (isLongPress) {
                                            //       print('is true ???');
                                            //       await Clipboard.setData(
                                            //           ClipboardData(
                                            //               text:
                                            //                   'https://secure.livechatinc.com/licence/9752245/v2/open_chat.cgi'));
                                            //       AdvanceSnackBar(
                                            //               mode: Mode.ADVANCE,
                                            //               message:
                                            //                   "Copied to clipboard",
                                            //               bgColor:
                                            //                   Colors.green)
                                            //           .show(context);
                                            //       isLongPress = false;
                                            //     }
                                            //   }
                                            // },
                                            ),
                                      ],
                                    ),
                                    maxLines: 1,
                                    softWrap: false,
                                    overflow: TextOverflow.fade,
                                    // textAlign: TextAlign.justify,
                                  ),
                                ),
                              )),
                        if (!notReload && code == null)
                          Expanded(
                            flex: 2,
                            child: Container(),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 8.0, bottom: 3),
                              child: Text(
                                Constant.formattedDate(date),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
