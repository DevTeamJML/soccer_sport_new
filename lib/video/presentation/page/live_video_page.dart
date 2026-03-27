import 'dart:async';
import 'dart:io';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:soccer_sport/core/constant/analytics_service.dart';
import 'package:soccer_sport/injection_container.dart';
import 'package:soccer_sport/video/presentation/widget/live_video_ads.dart';
import 'package:url_launcher/url_launcher.dart';

class LiveVideoPage extends StatefulWidget {
  @override
  State<LiveVideoPage> createState() => _LiveVideoPageState();
}

class _LiveVideoPageState extends State<LiveVideoPage> {
  late InAppWebViewController controller;
  var d1 = DateTime.now().toLocal();
  var d2 = DateTime(2022, 9, 28).toLocal();
  OverlayState? overlay;
  bool removeAds = false;
  bool removeAds2 = false;
  Timer? adsTimer;
  int hideAdsCount = 0;
  bool adsClosed = true;
  int overloadTimer = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (controller != null) {
      if (state == AppLifecycleState.paused) {
        controller.pauseTimers();
        if (Platform.isAndroid) {
          controller.android.pause();
        }
      } else {
        controller.resumeTimers();
        if (Platform.isAndroid) {
          controller.android.resume();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            useShouldOverrideUrlLoading: true,
          ),
          android: AndroidInAppWebViewOptions(),
          // ios: IOSInAppWebViewOptions(
          //   enableViewportScale: true,

          //                 // useShouldOverrideUrlLoading: true,

          // )
        ),
        initialUrlRequest: URLRequest(
            url: WebUri('https://soccersport.club/live-channel/')),
        onEnterFullscreen: (controller) {
          AutoOrientation.landscapeAutoMode(forceSensor: true);

          // WidgetsBinding.instance!.addPostFrameCallback((_) {
          //   overlay = Overlay.of(context);
          //   overlay!.insert(OverlayEntry(builder: (context) {
          //     return LiveVideoAds(overlay: () {
          //       if (overlay != null) {
          //         overlay!.deactivate();
          //       }
          //     });
          //   },
          //   ));
          // });
        },
        // contextMenu: ContextMenu(menuItems : [ ] ),
        onExitFullscreen: (controller) {},
        // onAjaxProgress: (v, b) {
        //   print('on ajax progredss ');
        //   return Future.value(b.action);
        // },
        // onLoadResource: (v, a) {
        //   print('onLoadResource');
        // },
        // onReceivedClientCertRequest: (v, a) {
        //   print('onReceivedClientCertRequest');
        //   return Future.value(
        //       ClientCertResponse(certificatePath: a.protectionSpace.host));
        // },
        iosOnNavigationResponse: (controller, response) async {
          return IOSNavigationResponseAction.ALLOW;
        },
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          // if (navigationAction.request.url
          //     .toString()
          //     .contains('https://www.twitch.tv/soccersportclub')) {
          //   return NavigationActionPolicy.CANCEL;
          // }
          // if (navigationAction.request.url
          //     .toString()
          //     .contains('https://m.twitch.tv/directory/game/')) {
          //   return NavigationActionPolicy.CANCEL;
          // }
          // if (navigationAction.request.url
          //     .toString()
          //     .contains('https://www.play666my.com')) {
          //   if (await canLaunch(navigationAction.request.url.toString())) {
          //     await launch(navigationAction.request.url.toString());
          //   } else {
          //     throw 'Could not launch ${navigationAction.request.url.toString()}';
          //   }
          //   return NavigationActionPolicy.CANCEL;
          // }
          // if (navigationAction.request.url
          //     .toString()
          //     .contains('https://twitter.com/')) {
          //   if (await canLaunch(navigationAction.request.url.toString())) {
          //     await launch(navigationAction.request.url.toString());
          //   } else {
          //     throw 'Could not launch ${navigationAction.request.url.toString()}';
          //   }
          //   return NavigationActionPolicy.CANCEL;
          // }

          // return NavigationActionPolicy.ALLOW;
          return NavigationActionPolicy.ALLOW;
        },

        // contextMenu: ContextMenu(onContextMenuActionItemClicked: (v) {
        //   print(v.action);
        // }),
        // gestureRecognizers: Set()
        //   ..add(Factory<VerticalDragGestureRecognizer>(
        //       () => VerticalDragGestureRecognizer())),
        // javascriptMode: JavascriptMode.unrestricted,
        // initialUrl: 'https://soccersport.club/live-channel/',

        // navigationDelegate: (v) {
        //   print('form gere');
        //   print(v);
        //   controller.runJavascript(
        //       "document.getElementsByClassName('listbuilder-popup-scale')[0].remove()");
        //   if (v.url.contains('https://www.twitch.tv/soccersportclub')) {
        //     return NavigationDecision.prevent;
        //   }
        //   return NavigationDecision.navigate;
        // },
        onWebViewCreated: (controller) {
          setState(() {
            this.controller = controller;
          });
        },
        onLoadStop: (controller, uri) {
          Timer.periodic(const Duration(seconds: 1), (timer) async {
            overloadTimer += 1;
            controller
                .evaluateJavascript(
                    source:
                        "document.getElementsByClassName('sumo-form-wrapper')[0].outerHTML;")
                .then((value) {
              if (value.toString() != 'null') {
                controller.evaluateJavascript(
                    source:
                        "document.getElementsByClassName('sumo-form-wrapper')[0].remove();");
                setState(() {
                  hideAdsCount = hideAdsCount + 1;
                  if (hideAdsCount == 2) {
                    timer.cancel();
                  }
                });
              } else {
                if (overloadTimer > 120) {
                  timer.cancel();
                }
              }

              return value;
            });
          });
        }

        // onPageFinished: (url) {
        //   if (url.contains('service30.rumbletalk.')) {}

        //   // if(url.contains())
        // },
        );

    // '<iframe data-lazyloaded="1" src="https://player.twitch.tv/?channel=soccersportclub&amp;parent=soccersport.club" data-src="https://player.twitch.tv/?channel=soccersportclub&amp;parent=soccersport.club" border="none" autoplay="true" allowfullscreen="" height="200" width="100%" data-ll-status="loaded" class="entered litespeed-loaded"></iframe>',
    // return HtmlWidget(
    //   '<iframe data-lazyloaded="1" src="https://player.twitch.tv/?channel=soccersportclub&amp;parent=soccersport.club" data-src="https://player.twitch.tv/?channel=soccersportclub&amp;parent=soccersport.club" border="none" autoplay="true" allowfullscreen="" height="200" width="100%" data-ll-status="loaded" class="entered litespeed-loaded"></iframe>',

    //   buildAsync: true,
    //   isSelectable: true,
    //   webViewMediaPlaybackAlwaysAllow: true,
    //   webViewDebuggingEnabled: true,
    //   webView: true,
    //   // factoryBuilder: () {
    //   //   print('twsting factory');
    //   //   WidgetFactory().wid;
    //   //   print(WidgetFactory().webView);
    //   //   return WidgetFactory();
    //   // },
    //   // these callbacks are called when a complicated element is loading
    //   // or failed to render allowing the app to render progress indicator
    //   // and fallback widget

    //   //                     onTapImage: (v){
    //   // return true;
    //   //                     },
    //   onErrorBuilder: (context, element, error) {
    //     print('erro dids ');
    //     print(element);
    //     print(error);
    //     return Text(
    //       '$element error: ',
    //       style: TextStyle(color: Colors.white),
    //     );
    //   },
    //   onTapImage: (v) {
    //     print('on image');
    //   },
    //   onLoadingBuilder: (context, element, loadingProgress) =>
    //       CircularProgressIndicator(),

    //   // this callback will be triggered when user taps a link
    //   onTapUrl: (v) {
    //     print('gotamamdmsa');
    //     return true;
    //   },
    //   // select the render mode for HTML body
    //   // by default, a simple `Column` is rendered
    //   // consider using `ListView` or `SliverList` for better performance
    //   renderMode: RenderMode.column,

    //   // set the default styling for text
    //   textStyle: TextStyle(fontSize: 14),

    //   // turn on `webView` if you need IFRAME support (it's disabled by default)
    // );
  }
}



// <!--<iframe src="https://givemenbastreams.com/soccer.php?g=fifa#"frameborder="0" allowfullscreen scrolling="no" height="500" width="100%"><span data-mce-type="bookmark" style="display: inline-block; width: 0px; overflow: hidden; line-height: 0;" class="mce_SELRES_start"></span><span data-mce-type="bookmark" style="display: inline-block; width: 0px; overflow: hidden; line-height: 0;" class="mce_SELRES_start"></span></iframe>-->

// <!--<iframe src="https://play.streamingvideoprovider.com/popplayer.php?it=cf6oo7ohgsg0" frameborder="0" allowfullscreen scrolling="no" height="500" width="100%"></iframe>-->
// <!--<h3 style="text-align: center; text-transform: uppercase; margin-block: 0px;" align="center"><strong>World Cup 2022 Final Live:</strong></h3>-->
// <!--<h4 style="text-align: center; font-size: 20px; margin-block: 10px;" align="center">18 DEC (11PM) Argentina vs France</h4>-->
// <!--<blockquote class="twitter-tweet">-->
// <!--<p dir="ltr" lang="en">live now <a href="https://t.co/uhqoZunznQ">https://t.co/uhqoZunznQ</a></p>-->
// <!--— SSC Live991 (@SSCLive991) <a href="https://twitter.com/SSCLive991/status/1604535581325029376?ref_src=twsrc%5Etfw">December 18, 2022</a></blockquote>-->
// <!--<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>-->
// <!--<h3 style="text-align: center;"><strong>Join our telegram channel to watch more stable live!!! (<a href="http://bit.ly/3FLIUA3" target="_blank" rel="noopener">Join Now</a>). Sorry for inconvenience caused, Thanks!!</strong></h3>-->
// <!--<iframe src="https://player.twitch.tv/?channel=ssclive991&parent=soccersport.club" frameborder="0" allowfullscreen scrolling="no" height="500" width="100%"><span data-mce-type="bookmark" style="display: inline-block; width: 0px; overflow: hidden; line-height: 0;" class="mce_SELRES_start"></span></iframe>-->

// <!--
// <div style="padding: 56.25% 0 0 0; position: relative;"><iframe style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;" src="https://vimeo.com/event/2628210/embed" frameborder="0" allowfullscreen="allowfullscreen"></iframe></div>
// -->

// <!--<a href="https://www.play666my.com/register?affid=214&amp;utm_source=ssc&amp;utm_medium=live&amp;utm_campaign=free500" target="_blank" rel="noopener"><img id="live-ads" class="alignnone" src="http://soccersport.club/wp-content/uploads/2022/11/FIFA-WORLD-CUP-709x142-en-2-scaled.jpg" alt="mobile-banner" width="1198" height="308" /></a>-->

// <!--<a href="https://www.eybet.com/register?affid=110&amp;utm_source=ssc&amp;utm_medium=live&amp;utm_campaign=free500" target="_blank" rel="noopener"><img id="live-ads" class="alignnone" src="http://soccersport.club/wp-content/uploads/2022/11/lADPGT5jF7-eCmDNAjjNCxQ_2836_568-scaled.jpg" alt="mobile-banner" width="1198" height="308" /></a>-->

// <!--<style>-->
// <!--  .ct-footer {<br />    display: none;<br />  }<br />  .ct-header {<br />    display: none;<br />  }<br />  #live-video-section {<br />}<br />  #group-chat-section {<br />      bottom: 0;<br />  }<br /></style>-->




// <div style="display: flex; align-items: center; justify-content: center;  flex-direction: column;">
//     <div style="flex: 1;">
//             <h1>Live Football:</h1>

//     </div>
//     <div style="padding:10px">
        
//     </div>
//     <div style="flex: 1;">
//             <h3>Coming Soon & Stay Tuned</h3>

//     </div>
//  <div style="padding:10px">
        
//     </div>
//  <div style=" width: 60%;">
//         <img src="https://soccersport.club/wp-content/uploads/2022/18/bet_banner_live.png">
//     </div>
// </div>