import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soccer_sport/core/constant/constants.dart';

class EventNotStarted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: EdgeInsets.zero,
        // horizontal: MediaQuery.of(context).size.width * 0.1,

        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Container(
              color: Constant.backgroundColor,
              height: MediaQuery.of(context).size.height * 0.17,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: AutoSizeText(
                              "Coming Soon",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                            ),
                          ),
                          Expanded(
                              child: Text('Event starts on 06/01/2022(00:00am)',
                                  style: TextStyle(
                                    fontSize: 13,
                                  ))),
                        ],
                      )),
                  // Expanded(
                  //   flex: 1,
                  //   child: Container(),
                  // ),
                ],
              ),
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
                        size: 26,
                      ),
                    ),
                  ),
                )),
          ],
        ));
  }
}
