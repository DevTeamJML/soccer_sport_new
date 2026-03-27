import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soccer_sport/core/constant/constants.dart';
import 'package:soccer_sport/core/widgets/loading_widget.dart';

class RankRewardsDialog extends StatelessWidget {
  const RankRewardsDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            color: Constant.backgroundColor,
            borderRadius: BorderRadius.circular(20)),
        child: Column(children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            decoration: BoxDecoration(
                color: Constant.color1,
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0))),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: [
                  Center(
                    child: Text("Rewards",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      // child: Icon(
                      //   Icons.exit_to_app,
                      //   color: Colors.white,
                      // ),
                      child: Container(
                        // decoration: BoxDecoration(
                        //                     shape: BoxShape.circle,

                        // )
                        child: Opacity(
                          opacity: 0.7,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: Icon(
                              CupertinoIcons.clear_circled_solid,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   margin: EdgeInsets.symmetric(vertical: 10),
          //   padding: EdgeInsets.all(5),
          //   decoration: BoxDecoration(
          //       color: Constant.backgroundColor,
          //       borderRadius: BorderRadius.all(
          //         Radius.circular(20.0),
          //       ),
          //       border: Border.all(color: Colors.white, width: 0.3),
          //       boxShadow: [
          //         BoxShadow(
          //           offset: Offset(3, 3),
          //           spreadRadius: -3,
          //           blurRadius: 6,
          //           color: Color.fromRGBO(255, 255, 255, 1),
          //         )
          //       ]),
          //   child: Padding(
          //     padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          //     child: Row(children: [
          //       ShaderMask(
          //         shaderCallback: (Rect bounds) {
          //           return LinearGradient(
          //             colors: [Color(0xffdc9139), Color(0xfffff514)],
          //             begin: Alignment.bottomCenter,
          //             end: Alignment.topCenter,
          //           ).createShader(bounds);
          //         },
          //         child: Icon(
          //           Icons.emoji_events,
          //           color: Colors.white,
          //           size: 30,
          //         ),
          //       ),
          //       Expanded(
          //         child: Text(
          //           "P6 FREE Credit RM20, P6 Reload Bonus 10%, Nike Shoe Discount Coupon",
          //           maxLines: 3,
          //           softWrap: true,
          //           textAlign: TextAlign.center,
          //         ),
          //       )
          //     ]),
          //   ),
          // ),

          // Container(
          //   margin: EdgeInsets.symmetric(vertical: 10),
          //   padding: EdgeInsets.all(5),
          //   decoration: BoxDecoration(
          //       color: Constant.backgroundColor,
          //       borderRadius: BorderRadius.all(
          //         Radius.circular(20.0),
          //       ),
          //       boxShadow: [
          //         BoxShadow(
          //           offset: Offset(3, 3),
          //           spreadRadius: -3,
          //           blurRadius: 6,
          //           color: Color.fromRGBO(255, 255, 255, 1),
          //         )
          //       ]),
          //   child: Row(children: [
          //     ShaderMask(
          //       shaderCallback: (Rect bounds) {
          //         return LinearGradient(
          //           colors: [Color(0xffdc9139), Color(0xfffff514)],
          //           begin: Alignment.bottomCenter,
          //           end: Alignment.topCenter,
          //         ).createShader(bounds);
          //       },
          //       child: Icon(
          //         Icons.emoji_events,
          //         color: Colors.white,
          //         size: 30,
          //       ),
          //     ),
          //     Text(
          //         "P6 FREE Credit RM20, P6 Reload Bonus 10%, Nike Shoe Discount Coupon")
          //   ]),
          // ),
          // Container(
          //   margin: EdgeInsets.symmetric(vertical: 10),
          //   padding: EdgeInsets.all(5),
          //   decoration: BoxDecoration(
          //       color: Constant.backgroundColor,
          //       borderRadius: BorderRadius.all(
          //         Radius.circular(20.0),
          //       ),
          //       boxShadow: [
          //         BoxShadow(
          //           offset: Offset(3, 3),
          //           spreadRadius: -3,
          //           blurRadius: 6,
          //           color: Color.fromRGBO(255, 255, 255, 1),
          //         )
          //       ]),
          //   child: Row(children: [
          //     ShaderMask(
          //       shaderCallback: (Rect bounds) {
          //         return LinearGradient(
          //           colors: [Color(0xffdc9139), Color(0xfffff514)],
          //           begin: Alignment.bottomCenter,
          //           end: Alignment.topCenter,
          //         ).createShader(bounds);
          //       },
          //       child: Icon(
          //         Icons.emoji_events,
          //         color: Colors.white,
          //         size: 30,
          //       ),
          //     ),
          //     Text(
          //         "P6 FREE Credit RM20, P6 Reload Bonus 10%, Nike Shoe Discount Coupon")
          //   ]),
          // )

          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  listitle(context, 1),
                  listitle(context, 2),
                  listitle(context, 3)
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 25),
            child: Text(
              "Note : After the leaderboard event ended, top 3 winners will received email from us to get the rewards.",
              textAlign: TextAlign.justify,
            ),
          ),
          // Expanded(
          //     child: Column(
          //   children: [

          //   ],
          // ))
        ]),
      ),
    );
  }
}

Widget listitle(
  BuildContext context,
  int place,
) {
  String reward = place == 1
      ? "P6 FREE Credit RM20, P6 Reload Bonus 10%, Nike Shoe Discount Coupon"
      : place == 2
          ? "P6 Reload Bonus 20%, Adidas Leg Support Coupon"
          : "P6 Reload Bonus 10%";

  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShaderMask(
            shaderCallback: (Rect bounds) {
              if (place == 1) {
                return LinearGradient(
                  colors: [Color(0xffdc9139), Color(0xfffff514)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ).createShader(bounds);
              } else if (place == 2) {
                return LinearGradient(
                  colors: [Color(0xffb9b9b9), Color(0xff5d5d5d)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds);
              } else {
                return LinearGradient(
                  colors: [Color(0xffc47500), Color(0xff4e2f00)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds);
              }
            },
            child: Icon(
              Icons.emoji_events,
              color: Colors.white,
              size: 30,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              place == 1
                  ? "1st Place :"
                  : place == 2
                      ? "2nd Place :"
                      : "3rd Place :",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          )
        ],
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Constant.backgroundColor,
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
            border: Border.all(color: Colors.white, width: 0.3),
            boxShadow: [
              BoxShadow(
                offset: Offset(3, 3),
                spreadRadius: -3,
                blurRadius: 6,
                color: Color.fromRGBO(255, 255, 255, 1),
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(children: [
            Expanded(
              child: Text(
                reward,
                maxLines: 3,
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            )
          ]),
        ),
      ),
    ],
  );
}
