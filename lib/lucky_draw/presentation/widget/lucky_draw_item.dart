import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/lucky_draw/domain/entities/prize.dart';
import 'package:super_banners/super_banners.dart';
import 'package:transparent_image/transparent_image.dart';

class LuckyDrawItem extends StatelessWidget {
  final Prize prize;
  const LuckyDrawItem({required this.prize});

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: prize.index == 0
            ? AlignmentDirectional.topStart
            : AlignmentDirectional.bottomEnd,
        children: [
          Center(
            child: Container(
              padding: prize.index == 1 || prize.index == 2 || prize.index == 11
                  ? EdgeInsets.all(15)
                  : EdgeInsets.all(0),
              child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: prize.img,
                  imageErrorBuilder: (e, o, c) {
                    return Container();
                  }),
            ),
          ),
          if (prize.index == 1 || prize.index == 2 || prize.index == 11)
            Container(
              padding: EdgeInsets.all(4),
              color: Constant.color1,
              child: Text(prize.stack!),
            ),
          if (prize.index == 0)
            CornerBanner(
              bannerPosition: CornerBannerPosition.topLeft,
              bannerColor: Constant.color2,
              child: AutoSizeText(
                "Grand Prize",
                style: TextStyle(fontSize: 8, color: Colors.black),
                minFontSize: 6,
                maxLines: 1,
              ),
            ),
        ]);
  }
}
