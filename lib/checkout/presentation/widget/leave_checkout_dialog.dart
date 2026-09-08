import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:soccer_sport/core/constant/constants.dart';

class LeaveCheckoutDialog extends StatelessWidget {
  const LeaveCheckoutDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Constant.backgroundColor,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Container(
              child: Column(
            children: [
              Expanded(
                child: Container(
                  child: Column(children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: AutoSizeText(
                            'Leave Page',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            maxFontSize: 40,
                          ),
                        ),
                      ),
                    )
                  ]),
                ),
              ),
              Divider(),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                    vertical: MediaQuery.of(context).size.height * 0.01,
                  ),
                  child: Container(
                      child: AutoSizeText(
                    'The form will not save after leave page',
                    maxFontSize: 39,
                    style: TextStyle(fontSize: 17, color: Colors.white),
                  )),
                ),
              ),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Container(
                  color: Constant.color1,
                  child: Center(
                      child: Text(
                    'Confirm',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
                ),
              )),
            ],
          )),
        ));
  }
}
