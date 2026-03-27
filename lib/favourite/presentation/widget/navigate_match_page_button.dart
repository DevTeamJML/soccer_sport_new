import 'package:flutter/material.dart';
import 'package:soccer_sport/core/constant/analytics_service.dart';
import 'package:soccer_sport/core/constant/constants.dart';

import '../../../injection_container.dart';

class NavigateMatchPageButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Constant.color2,
        // shadowColor: Colors.white,
      ),
      // color: Constant.color2,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(30.0),
      // ),
      // textColor: Colors.white,
      child: Text(
        'Go to Match Page',
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Constant.pageController!.jumpToPage(0);
        serviceLocator<AnalyticsService>()
            .logScreens(name: '/footballMatchPage');
      },
    );
  }
}
