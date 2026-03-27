import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:wordpress_api/wordpress_api.dart';

class ReadNews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: AlignmentDirectional.topEnd, children: [
      Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Color.fromRGBO(51, 51, 51, 1),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Read News',
                      style: TextStyle(
                          color: Constant.color2, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                        'Read up to 10 soccer news daily to earn up to 10 points.'),
                  ],
                ),
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Container(
                  padding: EdgeInsets.all(5),
                  width: MediaQuery.of(context).size.width * 0.13,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Row(children: [
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.025,
                        // width: MediaQuery.of(context).size.width * 0.04,
                        child: Center(
                          child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image:
                                  'https://soccersport.club/wp-content/uploads/2021/12/Jan22-SSC-Coin-icon-150x150-1.png',
                              imageErrorBuilder: (e, o, c) {
                                return Container();
                              }),
                        ),
                      ),
                    ),
                    Text('10'),
                  ]),
                ),
                GestureDetector(
                  onTap: () {
                    Constant.pageController!.jumpToPage(3);
                  },
                  child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.025,
                      decoration: BoxDecoration(
                        color: Constant.color2,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Center(
                        child: AutoSizeText(
                          'Read Now',
                          style: TextStyle(color: Colors.black),
                          minFontSize: 3,
                        ),
                      )),
                ),
              ])
            ]),
          ],
        ),
      ),
    ]);
  }
}
