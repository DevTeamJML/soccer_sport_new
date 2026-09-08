import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../core/constant/constants.dart';

class BannerWidget extends StatelessWidget {
  final String imgSrc;
  const BannerWidget({required this.imgSrc});

  @override
  Widget build(BuildContext context) {
    // return  Container(
    //           height: MediaQuery.of(context).size.height * 0.1,
    //           width: double.infinity,
    //           child: Column(children: [
    //             Expanded(
    //               child: InAppWebView(
    //                 // javascriptMode: JavascriptMode.unrestricted,
    //                 initialUrlRequest: URLRequest(
    //                     url: Uri.parse(
    //                         "https://soccersport.club/mobile-banner-testing-page/")),
    //                 initialOptions: InAppWebViewGroupOptions(
    //                   crossPlatform: InAppWebViewOptions(
    //                       javaScriptEnabled: true,
    //                       javaScriptCanOpenWindowsAutomatically: true,
    //                       preferredContentMode:
    //                           UserPreferredContentMode.MOBILE),
    //                 ),
    //                 onWebViewCreated: (controller) {
    //                   this.controller = controller;
    //                 },
    //                 onProgressChanged: (c, url) async {
    //                   final height = MediaQuery.of(context).size.height * 0.1;
    //                   final width = MediaQuery.of(context).size.width;
    //                   final html = await controller.evaluateJavascript(
    //                       source:
    //                           "document.getElementsByTagName('img')[0].innerText;");
    //                   final img = await controller.evaluateJavascript(
    //                       source:
    //                           "document.getElementsByTagName('img')[1].outerHTML;");
    //                   // print(html);

    //                   print(img);
    //                   c.evaluateJavascript(
    //                       source:
    //                           "document.getElementsByTagName('header')[0].style.display='none'");
    //                   controller.evaluateJavascript(
    //                       source:
    //                           "document.getElementsByTagName('section')[1].style.display='none'");
    //                   controller.evaluateJavascript(
    //                       source:
    //                           "document.getElementsByTagName('section')[2].style.display='none'");
    //                   controller.evaluateJavascript(
    //                       source:
    //                           "document.getElementsByTagName('section')[3].style.display='none'");
    //                   controller.evaluateJavascript(
    //                       source:
    //                           "document.getElementsByClassName('elementor-element-4394977')[0].style.display='none'");

    //                   controller.evaluateJavascript(
    //                       source:
    //                           "document.getElementsByClassName('elementor-element-95d92f8')[0].style.display='none'");
    //                   // controller.evaluateJavascript(
    //                   // "document.getElementsByTagName('header')[0].style.display='none'");
    //                   controller.evaluateJavascript(
    //                       source:
    //                           "document.getElementsByTagName('footer')[0].style.display='none'");
    //                 },
    //                 // onPageFinished: (url) async {
    //                 //   double height = double.parse(
    //                 //       await controller.evaluateJavascript(
    //                 //           "document.documentElement.scrollHeight;"));
    //                 //   print(MediaQuery.of(context).size.height * 0.25);

    //                 //   print(height);
    //                 //   Timer(Duration(seconds: 2), () {
    //                 //     setState(() {
    //                 //       isLoading = false;
    //                 //     });
    //                 //   });
    //                 // },
    //               ),
    //             ),
    //           ]),
    //         ),
    if (imgSrc != '') {
      return Container(
        // decoration:
        // BoxDecoration(color: Constant.backgroundColor.withOpacity(0.5)),
        height: MediaQuery.of(context).size.height * 0.07,
        width: MediaQuery.of(context).size.width.toInt() >= 500
            ? 500
            : MediaQuery.of(context).size.width,
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: imgSrc,
              imageErrorBuilder: (e, o, c) {
                return Container();
              }),
        ),
      );
    } else {
      return Container();
    }
  }
}
