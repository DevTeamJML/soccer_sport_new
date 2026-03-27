import 'package:advance_notification/advance_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:transparent_image/transparent_image.dart';

class ReferFriendsWidget extends StatelessWidget {
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invite Friends',
                    style: TextStyle(
                        color: Constant.color2, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text('Refer a friend to join Soccer Sport'),
                ],
              ),
              Container(
                padding: EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width * 0.15,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Row(children: [
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.025,
                      width: MediaQuery.of(context).size.width * 0.06,
                      child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image:
                              'https://soccersport.club/wp-content/uploads/2021/12/Jan22-SSC-Coin-icon-150x150-1.png',
                          imageErrorBuilder: (e, o, c) {
                            return Container();
                          }),
                    ),
                  ),
                  Text('88'),
                ]),
              )
            ]),
            GestureDetector(
              onTap: () async {
                await Clipboard.setData(ClipboardData(
                    text:
                        'http://soccersport.club/register/?mref=${Constant.auth!.username}'));
                AdvanceSnackBar(
                        mode: Mode.ADVANCE,
                        message: "Copied to clipboard",
                        bgColor: Colors.green)
                    .show(context);
                // copied successfully
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(top: 5, bottom: 5),
                child: Text(
                    'http://soccersport.club/register/?mref=${Constant.auth!.username}'),
              ),
            ),
            Text(
                '*Copy the unique referral link above and start sharing to your friends!',
                style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    ]);
  }
}
