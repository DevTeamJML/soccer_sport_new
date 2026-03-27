import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AboutUsPage extends StatefulWidget {
  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  // const TermsConditionPage({Key? key}) : super(key: key);
  late InAppWebViewController appController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('About Us'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: InAppWebView(
          initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                  useShouldOverrideUrlLoading: true,
                  javaScriptEnabled: true,
                  javaScriptCanOpenWindowsAutomatically: true,
                  preferredContentMode: UserPreferredContentMode.MOBILE),
              android: AndroidInAppWebViewOptions(),
              ios: IOSInAppWebViewOptions(
                enableViewportScale: true,

                // useShouldOverrideUrlLoading: true,
              )),
          initialUrlRequest:
              URLRequest(url: WebUri('https://soccersport.club/about-us/')),
          onWebViewCreated: (controller) {
            setState(() {
              appController = controller;
            });
          },
          onLoadStart: (c, uri) {},
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            return NavigationActionPolicy.ALLOW;
          },
          onLoadStop: (controller, uri) {
            controller.evaluateJavascript(
                source:
                    "document.getElementsByTagName('header')[0].style.display='none'");
            controller.evaluateJavascript(
                source:
                    "document.getElementsByTagName('footer')[0].style.display='none'");
          }

          // initialUrl: 'https://soccersport.club/about-us/',
          // onWebViewCreated: (controller) {
          //   this.controller = controller;
          // },
          ),
    );
  }
}
