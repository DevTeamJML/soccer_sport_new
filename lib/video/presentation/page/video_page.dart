import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dartz/dartz_unsafe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:fwfh_webview/fwfh_webview.dart' as facto;
import 'package:soccer_sport/core/widgets/loading_widget.dart';
import 'package:soccer_sport/video/presentation/bloc/video_details_bloc.dart';
import 'package:soccer_sport/video/presentation/widget/recommend_video_listtile.dart';
import 'package:soccer_sport/video/presentation/widget/video_clip_icon.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wordpress_api/wordpress_api.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../core/constant/constants.dart';
import '../../../injection_container.dart';
import '../../domain/entities/video.dart';
import '../../domain/entities/video_details.dart';

String? extractIframeSrc(String htmlString) {
  final document = parse(htmlString);
  final iframe = document.querySelector('iframe');

  String? src = iframe?.attributes['src'];

  if (src == null) return null;

  src = src.replaceAll('&amp;', '&');

  return src;
}

String? currentUrl;

class VideoPage extends StatefulWidget {
  final VideoDetails videoDetails;
  final List<VideoDetails> clone;
  const VideoPage({required this.videoDetails, required this.clone});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoDetails videoDetails;
  YoutubePlayerController? _ytController;
  // final VideoDetailsBloc _videoDetailsBloc = serviceLocator<VideoDetailsBloc>();
  Widget buildWebView(String url) {
    final html = '''
    <html>
      <body style="margin:0;padding:0;">
        <iframe 
          src="$url" 
          width="100%" 
          height="100%" 
          frameborder="0" 
          allow="autoplay; fullscreen"
          allowfullscreen>
        </iframe>
      </body>
    </html>
  ''';

    return SizedBox(
      height: 200,
      child: Center(child: Text("WebView disabled")),
    );
    // return SizedBox(
    //   height: MediaQuery.of(context).size.height * 0.3,
    //   child: WebViewWidget(
    //     controller: WebViewController()
    //       ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //       ..setNavigationDelegate(
    //         NavigationDelegate(
    //           onWebResourceError: (error) {
    //             debugPrint("❌ WebView error: ${error.description}");
    //           },
    //         ),
    //       )
    //       ..loadHtmlString(html),
    //   ),
    // );
  }

//https://www.youtube.com/watch?v=B6IlP26dW0s
//  WebViewController controller;
  int videoIndex = 0;
  bool isLoading = true;
  List<VideoDetails> cloneList = [];
  List<VideoDetails> recommendList = [];
  String? videoId;
  bool _isPlayerReady = false;
  bool isEnterFullScreen = false;
  // String ytUrl = '';
  int index = 0;

  @override
  void initState() {
    super.initState();
    videoDetails = widget.videoDetails;

    print("🎯 INIT STATE VIDEO DETAILS: ${videoDetails.videos}");
    final videos = videoDetails.videos;

    if (videos == null || videos.isEmpty) {
      debugPrint("❌ No videos");
      return;
    }

    final raw = videos[index].ytLink;

    if (raw == null || raw.isEmpty) {
      debugPrint("❌ ytLink is null");
      return;
    }

    String? link;

    if (raw.contains("<iframe")) {
      link = extractIframeSrc(raw);
    } else {
      link = raw;
    }

    if (link == null) return;

    setState(() {
      videoIndex = index;
    });

    // if (link.contains("youtube.com") || link.contains("youtu.be")) {
    //   _videoDetailsBloc.add(GetYtUrlFromApiRequest(url: link));
    // } else if (link.contains("scorebat.com")) {
    //   setState(() {
    //     currentUrl = link;
    //     _ytController = null;
    //   });
    // }

    debugPrint("🚫 BLOC DISABLED, LINK: $link");

    cloneList = List<VideoDetails>.from(widget.clone);
    cloneList.remove(videoDetails);

    List<int> list = List.generate(cloneList.length, (i) => i);
    list.shuffle();

    final recommendIndex = list.take(6).toList();
    recommendList = recommendIndex.map((e) => cloneList[e]).toList();
  }

  // @override
  // void dispose() {
  //   if (_ytController != null) _ytController!.dispose();
  //   _videoDetailsBloc.close();
  //   super.dispose();
  // }

  // @override
  // void deactivate() {
  //   // Pauses video while navigating to next page.
  //   if (_ytController != null) _ytController!.pause();
  //   super.deactivate();
  // }

  void initialYtController(String url) {
    final id = YoutubePlayer.convertUrlToId(url);

    debugPrint("YT URL: $url");
    debugPrint("VIDEO ID: $id");

    if (id == null) {
      debugPrint("❌ Invalid YouTube URL");
      return;
    }

    _ytController?.dispose();

    _ytController = YoutubePlayerController(
      initialVideoId: id,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    setState(() {}); 
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<VideoDetailsBloc>(),
      child: BlocListener<VideoDetailsBloc, VideoDetailsState>(
        listener: (context, state) {
          debugPrint("🔥 BlocListener triggered: $state");
        },
        child: BlocBuilder<VideoDetailsBloc, VideoDetailsState>(
            builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(videoDetails.competition ?? "Video"),
            ),
            body: Column(
              children: [
                SizedBox(height: 20),

                Text(
                  videoDetails.title ?? "Match",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 20),

                Builder(
                  builder: (_) {
                    final videos = videoDetails.videos;

                    if (videos == null || videos.isEmpty) {
                      return Text("No videos");
                    }

                    final raw = videos[videoIndex].ytLink;

                    if (raw == null || raw.isEmpty) {
                      return Text("Invalid video");
                    }

                    String? link;

                    if (raw.contains("<iframe")) {
                      link = extractIframeSrc(raw);
                    } else {
                      link = raw;
                    }

                    if (link == null) {
                      return Text("Failed to parse video");
                    }

                    // 🎯 CASE 1: Scorebat → WebView
                    if (link.contains("scorebat.com")) {
                      return SizedBox(
                        height: 200,
                        child: WebViewWidget(
                          controller: WebViewController()
                            ..setJavaScriptMode(JavaScriptMode.unrestricted)
                            ..loadRequest(Uri.parse(link)), // 
                        ),
                      );
                    }

                    // 🎯 CASE 2: YouTube
                    if (link.contains("youtube.com") ||
                        link.contains("youtu.be")) {
                      final id = YoutubePlayer.convertUrlToId(link);

                      if (id == null) {
                        return Text("Invalid YouTube URL");
                      }

                      return YoutubePlayer(
                        controller: YoutubePlayerController(
                          initialVideoId: id,
                          flags: YoutubePlayerFlags(autoPlay: false),
                        ),
                      );
                    }

                    return Text("Unsupported video source");
                  },
                ),

                SizedBox(height: 20),

                // Text("Videos count: ${videoDetails.videos!.length}"),
              ],
            ),
          );
        }),
      ),
    );
  }

}
