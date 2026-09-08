import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:webview_flutter/webview_flutter.dart';

class TermsConditionPage extends StatefulWidget {
  @override
  State<TermsConditionPage> createState() => _TermsConditionPageState();
}

class _TermsConditionPageState extends State<TermsConditionPage> {
  late InAppWebViewController appController;

  // const TermsConditionPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms & Condition'),
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
          initialUrlRequest: URLRequest(
              url: WebUri('https://soccersport.club/privacy-policy/')),
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
