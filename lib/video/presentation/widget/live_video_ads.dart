import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LiveVideoAds extends StatefulWidget {
  // final Function overlay;
  // const LiveVideoAds({required this.overlay});

  @override
  State<LiveVideoAds> createState() => _LiveVideoAdsState();
}

class _LiveVideoAdsState extends State<LiveVideoAds> {
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: AlignmentDirectional.topEnd, children: [
      Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.1,
        color: Colors.white,
      ),
      GestureDetector(
        // onTap: () {
        //   widget.overlay;
        //   // serviceLocator<AnalyticsService>()
        //   //     .logScreens(name: '/homepageads/close');
        // },
        child: Opacity(
          opacity: 0.7,
          child: Container(
            decoration:
                BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Icon(
              CupertinoIcons.clear_circled_solid,
              color: Colors.grey,
              size: 26,
            ),
          ),
        ),
      ),
    ]);
  }
}
