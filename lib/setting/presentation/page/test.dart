import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:soccer_sport/core/constant/constants.dart';

class TestingPaga extends StatefulWidget {
  // const TestingPaga({super.key});

  @override
  State<TestingPaga> createState() => _TestingPagaState();
}

class _TestingPagaState extends State<TestingPaga> {
  int i = 0;
  late Timer timer;
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      i++;
      Constant.test2Stream.add(i);
    });
    // TODO: implement initState

    Constant.test2Stream.listen((value) {
      print("value is" + value.toString());
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(),
    );
  }
}
