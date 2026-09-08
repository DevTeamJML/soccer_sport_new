import 'package:flutter/material.dart';
import 'package:soccer_sport/core/constant/constants.dart';

import '../widget/checkpoints_step.dart';

class CheckoutPage extends StatefulWidget {
  CheckoutPage({Key? key}) : super(key: key);

  @override
  CheckoutPageState createState() => CheckoutPageState();
}

class CheckoutPageState<T extends CheckoutPage> extends State<T> {
  int currentPage = 0;
  bool showBackButton = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Constant.color1,
        automaticallyImplyLeading: showBackButton,
        title: Text(
          'Checkout',
          style: TextStyle(color: Colors.white),
        ),
        actions: [],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Column(
        children: [
          CheckpointsStep(currentStep: currentPage, checkPoints: [
            "Shipping",
            "Payment",
            "Order",
          ]),
          Divider(color: Colors.grey),
          pageUI(),
        ],
      )),
    );
  }

  Widget pageUI() {
    return Container();
  }
}
