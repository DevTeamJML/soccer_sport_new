import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/lucky_draw/domain/entities/lucky_draw_info.dart';
import 'package:soccer_sport/lucky_draw/domain/entities/prize.dart';
import 'package:soccer_sport/lucky_draw/presentation/widget/lucky_draw_history_item.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wordpress_api/wordpress_api.dart';

import '../../../core/widgets/loading_widget.dart';

class LuckyDrawHistoryDialog extends StatelessWidget {
  final LuckyDrawInfo? lucky_draw_info;
  final List<Prize>? prizes;
  final Map<String, dynamic> coupons;
  const LuckyDrawHistoryDialog(
      {required this.lucky_draw_info,
      required this.prizes,
      required this.coupons});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> added = {};
    Map<String, dynamic> coupons_clone = {};
    coupons_clone = new Map<String, dynamic>.from(coupons);

    if (lucky_draw_info != null && lucky_draw_info!.prizes.length > 0) {
      return Dialog(
        child: Container(
          color: Constant.backgroundColor,
          height: MediaQuery.of(context).size.height * 0.7,
          // width: MediaQuery.of(context).size.width * 0.35,
          child: Column(
            children: [
              Container(
                color: Constant.color1,
                height: MediaQuery.of(context).size.height * 0.05,
                child:
                    Stack(alignment: AlignmentDirectional.centerEnd, children: [
                  Center(
                    child: Text("History",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Opacity(
                        opacity: 0.7,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: Icon(
                            CupertinoIcons.clear_circled_solid,
                            color: Colors.grey,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: prizes!.length,
                  itemBuilder: (BuildContext context, int index) {
                    Prize prize = prizes![index];

                    return LuckyDrawHsitoryItem(
                      prize: prize,
                      prizes: lucky_draw_info!.prizes.reversed.toList(),
                      coupons: coupons,
                      index: index,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Dialog(
          child: Container(
        color: Constant.backgroundColor,
        height: MediaQuery.of(context).size.height * 0.15,
        child: Column(
          children: [
            Container(
              color: Constant.color1,
              height: MediaQuery.of(context).size.height * 0.05,
              child:
                  Stack(alignment: AlignmentDirectional.centerEnd, children: [
                Center(
                  child: Text("History",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Opacity(
                      opacity: 0.7,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: Icon(
                          CupertinoIcons.clear_circled_solid,
                          color: Colors.grey,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            Expanded(
              child: Center(
                child: Text("User haven't lucky draw yet."),
              ),
            ),
          ],
        ),
      ));
    }
  }
}
