import 'package:flutter/material.dart';
import 'package:soccer_sport/core/constant/constants.dart';

class Testing2 extends StatefulWidget {
  @override
  State<Testing2> createState() => _Testing2State();
}

class _Testing2State extends State<Testing2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
          stream: Constant.test2Stream.stream,
          builder: (builder, snapshot) {
            if (snapshot.hasData) {
              print('test 2 got ');
              print("test value is" + snapshot.data.toString());
            }
            return Container();
          }),
    );
  }
}
