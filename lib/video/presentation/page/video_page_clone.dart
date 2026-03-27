// import 'dart:async';

// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:dartz/dartz_unsafe.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:fwfh_webview/fwfh_webview.dart' as facto;
// import 'package:soccer_sport/core/widgets/loading_widget.dart';
// import 'package:soccer_sport/video/presentation/bloc/video_details_bloc.dart';
// import 'package:soccer_sport/video/presentation/widget/recommend_video_listtile.dart';
// import 'package:soccer_sport/video/presentation/widget/video_clip_icon.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:wordpress_api/wordpress_api.dart';
// import 'package:html/parser.dart' show parse;
// import 'package:html/dom.dart' as dom;
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import '../../../core/constant/constants.dart';
// import '../../../injection_container.dart';
// import '../../domain/entities/video.dart';
// import '../../domain/entities/video_details.dart';

// class VideoPage extends StatefulWidget {
//   final VideoDetails videoDetails;
//   final List<VideoDetails> clone;
//   const VideoPage({required this.videoDetails, required this.clone});

//   @override
//   State<VideoPage> createState() => _VideoPageState();
// }

// class _VideoPageState extends State<VideoPage> {
//   late VideoDetails videoDetails;
//   YoutubePlayerController? _ytController;
//   final VideoDetailsBloc _videoDetailsBloc = serviceLocator<VideoDetailsBloc>();

// //https://www.youtube.com/watch?v=B6IlP26dW0s
// //  WebViewController controller;
//   int videoIndex = 0;
//   bool isLoading = true;
//   List<VideoDetails> cloneList = [];
//   List<VideoDetails> recommendList = [];
//   String? videoId;
//   bool _isPlayerReady = false;
//   bool isEnterFullScreen = false;
//   // String ytUrl = '';
//   int index = 0;
//   @override
//   void initState() {
//     super.initState();
//     videoDetails = widget.videoDetails;

//     // if (videoDetails.videos != null && videoDetails.videos!.length > 0) {
//     //   listController = videoDetails.videos!.map((e) {
//     //     print(e.embed!);
//     //     if (e.embed != null) {
//     //       return VideoPlayerController.network(e.embed!)
//     //         ..initialize().then((_) {
//     //           // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//     //           setState(() {});
//     //         });
//     //     }
//     //   }).toList() as List<VideoPlayerController>;
//     //   // _controller = listController[0];
//     // }
//     // _videoPlayer = VideoPlayerController.network(
//     //     'https://www.youtube.com/watch?v=XP-4BiWsuaQ');
//     // _chewieController = ChewieController(
//     //   videoPlayerController: _videoPlayer!,
//     //   autoPlay: true,
//     //   autoInitialize: true,
//     // );
//     _videoDetailsBloc.add(GetYtUrlFromApiRequest(
//       url: videoDetails.videos![videoIndex].ytLink!,
//     ));
//     cloneList = List<VideoDetails>.from(widget.clone);
//     cloneList.remove(videoDetails);
//     List<int> list = List.generate(cloneList.length, (i) => i);
//     list.shuffle();
//     final recommendIndex = list.getRange(0, 6).toList();
//     recommendList = recommendIndex.map((e) => cloneList[e]).toList();

//     //testing get ifreame

//     // for (dom.Element img in imgList) {
//     //   print(img.outerHtml);
//     // }
//   }

//   @override
//   void dispose() {
//     if (_ytController != null) _ytController!.dispose();
//     _videoDetailsBloc.close();
//     super.dispose();
//   }

//   @override
//   void deactivate() {
//     // Pauses video while navigating to next page.
//     if (_ytController != null) _ytController!.pause();
//     super.deactivate();
//   }

//   void initialYtController(String url) {
//     videoId = YoutubePlayer.convertUrlToId(url);
//     print(url);
//     if (videoId != null) {
//       print(videoId);
//       _ytController = YoutubePlayerController(
//           initialVideoId: videoId!,
//           flags: YoutubePlayerFlags(
//             autoPlay: true,
//             mute: false,
//             loop: true,
//           ));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: AutoSizeText(
//           videoDetails.competition != null
//               ? videoDetails.competition!
//               : 'Video',
//           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//           wrapWords: false,
//           maxFontSize: 30,
//           minFontSize: 8,
//         ),
//         centerTitle: true,
//       ),
//       body: BlocProvider(
//         create: (context) => _videoDetailsBloc,
//         child: BlocListener<VideoDetailsBloc, VideoDetailsState>(
//           listener: (context, state) {
//             if (state is YtUrlFromApiLoaded) {
//               setState(() {
//                 initialYtController(state.url);
//               });
//             }
//           },
//           child: Column(children: [
//             // listController[index].value.isInitialized
//             //     ? Container(
//             //         height: MediaQuery.of(context).size.height * 0.4,
//             //         width: double.infinity,
//             //         child: AspectRatio(
//             //           aspectRatio: _controller.value.aspectRatio,
//             //           child: VideoPlayer(listController[index]),
//             //         ),
//             //       )
//             //     : Container(
//             //         height: MediaQuery.of(context).size.height * 0.4,
//             //         width: double.infinity,
//             //         color: Colors.grey,
//             //       ),
//             Container(
//               height: MediaQuery.of(context).size.height * 0.06,
//               child: Center(
//                 child: Text(
//                     videoDetails.title != null ? videoDetails.title! : 'Match',
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: MediaQuery.of(context).size.height * 0.02)),
//               ),
//             ),
//             Container(
//                 // height: MediaQuery.of(context).size.height * 0.3,
//                 // width: MediaQuery.of(context).size.width,
//                 color: Colors.black,
//                 padding: EdgeInsets.symmetric(
//                     vertical: MediaQuery.of(context).size.height * 0.02),
//                 child: BlocBuilder<VideoDetailsBloc, VideoDetailsState>(
//                   builder: (context, state) {
//                     if (state is YtUrlFromApiLoaded) {
//                       return _ytController != null && videoId != null
//                           ? Container(
//                               // height: isEnterFullScreen
//                               //     ? 0
//                               //     : MediaQuery.of(context).size.height * 0.3,
//                               // width: isEnterFullScreen
//                               //     ? 0
//                               //     : MediaQuery.of(context).size.width,
//                               child: YoutubePlayerBuilder(
//                                 builder: (v, a) {
//                                   return Container();
//                                 },
//                                 // onEnterFullScreen: () {
//                                 //   setState(() {
//                                 //     isEnterFullScreen = true;
//                                 //     SystemChrome.setPreferredOrientations([
//                                 //       DeviceOrientation.landscapeLeft,
//                                 //       DeviceOrientation.landscapeRight,
//                                 //     ]);
//                                 //   });
//                                 // },
//                                 onExitFullScreen: () {
//                                   // setState(() {
//                                   //   onExitFullScreen:
//                                   //   () => SystemChrome
//                                   //           .setEnabledSystemUIOverlays([
//                                   //         SystemUiOverlay.bottom,
//                                   //         SystemUiOverlay.top
//                                   //       ]);
//                                   // });
//                                   // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
//                                 },
//                                 player: YoutubePlayer(
//                                   controller: _ytController!,
//                                   width: double.infinity,
//                                   aspectRatio: 16 / 9,
//                                   showVideoProgressIndicator: true,
//                                   progressIndicatorColor: Constant.color1,
//                                   progressColors: ProgressBarColors(
//                                     playedColor: Constant.color1,
//                                     handleColor: Constant.color1,
//                                   ),
//                                   onReady: () {
//                                     setState(() {
//                                       _isPlayerReady = true;
//                                     });
//                                     print('ended ');
//                                     print(_ytController!.value.errorCode
//                                         .toString());
//                                     if (_ytController!.value.hasError) {
//                                       print('errror code ');
//                                       print(_ytController!.value.errorCode
//                                           .toString());
//                                     }
//                                     // if () {
//                                     //   print(_ytController!.value.errorCode
//                                     //       .toString());
//                                     // }
//                                   },
//                                   onEnded: (v) {},
//                                   bottomActions: [
//                                     CurrentPosition(),
//                                     ProgressBar(isExpanded: true),
//                                   ],
//                                 ),
//                               ),
//                             )
//                           : htmlWidget();
//                     } else if (state is VideoDetailsError) {
//                       return htmlWidget();
//                     } else {
//                       return LoadingWidget();
//                     }
//                   },
//                 )),

//             // htmlWidget(),
//             Container(
//               child: Column(children: [
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.06,
//                   width: MediaQuery.of(context).size.width,
//                   padding: EdgeInsets.symmetric(
//                     vertical: MediaQuery.of(context).size.height * 0.01,
//                     horizontal: MediaQuery.of(context).size.height * 0.01,
//                   ),
//                   child: Container(
//                     child: Row(children: [
//                       Text(
//                         videoDetails.videos![videoIndex].title! + '',
//                         style: TextStyle(
//                             fontSize: MediaQuery.of(context).size.height * 0.02,
//                             fontWeight: FontWeight.bold),
//                         maxLines: 1,
//                       ),
//                     ]),
//                   ),
//                 ),
//                 Container(
//                     height: MediaQuery.of(context).size.height * 0.135,
//                     decoration: BoxDecoration(
//                       color: Constant.backgroundColor,
//                       boxShadow: [
//                         BoxShadow(
//                             color: Colors.grey,
//                             offset: Offset(0, 2),
//                             blurRadius: 10)
//                       ],
//                     ),
//                     padding: EdgeInsets.only(
//                       top: MediaQuery.of(context).size.height * 0.015,
//                       right: MediaQuery.of(context).size.height * 0.01,
//                       left: MediaQuery.of(context).size.height * 0.01,
//                       bottom: MediaQuery.of(context).size.height * 0.01,
//                     ),
//                     width: double.infinity,
//                     child: ListView.builder(
//                       shrinkWrap: true,
//                       physics: ClampingScrollPhysics(),
//                       scrollDirection: Axis.horizontal,
//                       itemCount: videoDetails.videos!.length,
//                       itemBuilder: (context, index) {
//                         Video video = videoDetails.videos![index];
//                         bool isSelected =
//                             videoDetails.videos![videoIndex] == video;

//                         return Padding(
//                           padding: EdgeInsets.only(
//                               right: MediaQuery.of(context).size.width * 0.05),
//                           child: Container(
//                             height: double.infinity,
//                             width: MediaQuery.of(context).size.width * 0.2,
//                             child: Column(children: [
//                               Expanded(
//                                 // padding: EdgeInsets.symmetric(
//                                 //   vertical:
//                                 //       MediaQuery.of(context).size.height * 0.01,
//                                 //   horizontal:
//                                 //       MediaQuery.of(context).size.height * 0.01,
//                                 // ),
//                                 child: ElevatedButton(
//                                   onPressed: isSelected
//                                       ? () {}
//                                       : () {
//                                           setState(() {
//                                             videoIndex = index;
//                                           });
//                                         },
//                                   child: Center(
//                                     child: Icon(
//                                         isSelected
//                                             ? FontAwesomeIcons.playCircle
//                                             : FontAwesomeIcons.film,
//                                         color: isSelected
//                                             ? Colors.white
//                                             : Constant.color1),
//                                   ),
//                                   style: ElevatedButton.styleFrom(
//                                     shape: CircleBorder(),
//                                     primary: isSelected
//                                         ? Constant.color1
//                                         : Colors.white,
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 height:
//                                     MediaQuery.of(context).size.height * 0.04,
//                                 padding: EdgeInsets.only(
//                                     top: MediaQuery.of(context).size.height *
//                                         0.01),
//                                 child: AutoSizeText(
//                                   video.title != null
//                                       ? video.title!
//                                       : 'Highlights',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       fontSize:
//                                           MediaQuery.of(context).size.height *
//                                               0.015,
//                                       color: isSelected
//                                           ? Constant.color1
//                                           : Colors.white,
//                                       fontWeight: isSelected
//                                           ? FontWeight.bold
//                                           : FontWeight.normal),
//                                   minFontSize: 8,
//                                   wrapWords: false,
//                                   maxLines: 2,
//                                 ),
//                               )
//                             ]),
//                           ),
//                         );
//                       },
//                     )),
//               ]),
//             ),

//             SizedBox(height: MediaQuery.of(context).size.height * 0.025),
//             //recommned video widget
//             Container(
//               height: MediaQuery.of(context).size.height * 0.25,
//               child: Column(children: [
//                 Text(
//                   "Recommend Video",
//                   style: TextStyle(
//                       fontSize: MediaQuery.of(context).size.height * 0.02),
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: EdgeInsets.all(
//                         MediaQuery.of(context).size.height * 0.03),
//                     child: ListView.builder(
//                         shrinkWrap: true,
//                         physics: ClampingScrollPhysics(),
//                         scrollDirection: Axis.horizontal,
//                         itemCount: recommendList.length,
//                         itemBuilder: (context, index) {
//                           return RecommendVideoListtile(
//                             videoDetails: recommendList[index],
//                             clone: widget.clone,
//                           );
//                         }),
//                   ),
//                 )
//               ]),
//             ),
//           ]),
//         ),
//       ),
//       // body: Container(
//       //   height: MediaQuery.of(context).size.height * 0.2,
//       //   width: double.infinity,
//       //   child: WebView(
//       //     javascriptMode: JavascriptMode.unrestricted,
//       //     initialUrl: 'https://soccersport.club/',
//       //     onWebViewCreated: (controller) {
//       //       this.controller = controller;
//       //     },
//       //     backgroundColor: Colors.transparent,
//       //     onProgress: (url) {
//       //       controller.evaluateJavascript(
//       //           "document.getElementsByTagName('header')[0].style.display='none'");
//       //       controller.evaluateJavascript(
//       //           "document.getElementsByTagName('section')[1].style.display='none'");
//       //       controller.evaluateJavascript(
//       //           "document.getElementsByTagName('section')[2].style.display='none'");
//       //       controller.evaluateJavascript(
//       //           "document.getElementsByTagName('section')[3].style.display='none'");
//       //       controller.evaluateJavascript(
//       //           "document.getElementsByClassName('elementor-element-4394977')[0].style.display='none'");

//       //       controller.evaluateJavascript(
//       //           "document.getElementsByClassName('elementor-element-95d92f8')[0].style.display='none'");
//       //       // controller.evaluateJavascript(
//       //       // "document.getElementsByTagName('header')[0].style.display='none'");
//       //       controller.evaluateJavascript(
//       //           "document.getElementsByTagName('footer')[0].style.display='none'");
//       //     },
//       //     onPageStarted: (url) {},
//       //     onPageFinished: (url) async {
//       //       double height = double.parse(await controller
//       //           .evaluateJavascript("document.documentElement.scrollHeight;"));
//       //       print(MediaQuery.of(context).size.height * 0.25);

//       //       print(height);
//       //       Timer(Duration(seconds: 2), () {
//       //         setState(() {
//       //           isLoading = false;
//       //         });
//       //       });
//       //     },
//       //   ),
//       // ),
//     );

//     return Scaffold(
//       appBar: AppBar(
//         title: AutoSizeText(
//           videoDetails.competition != null
//               ? videoDetails.competition!
//               : 'Video',
//           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//           wrapWords: false,
//           maxFontSize: 30,
//           minFontSize: 8,
//         ),
//         centerTitle: true,
//       ),
//       body: BlocProvider(
//         create: (context) => _videoDetailsBloc,
//         child: BlocListener<VideoDetailsBloc, VideoDetailsState>(
//           listener: (context, state) {
//             if (state is YtUrlFromApiLoaded) {
//               setState(() {
//                 initialYtController(state.url);
//               });
//             }
//           },
//           child: Column(children: [
//             // listController[index].value.isInitialized
//             //     ? Container(
//             //         height: MediaQuery.of(context).size.height * 0.4,
//             //         width: double.infinity,
//             //         child: AspectRatio(
//             //           aspectRatio: _controller.value.aspectRatio,
//             //           child: VideoPlayer(listController[index]),
//             //         ),
//             //       )
//             //     : Container(
//             //         height: MediaQuery.of(context).size.height * 0.4,
//             //         width: double.infinity,
//             //         color: Colors.grey,
//             //       ),
//             Container(
//               height: MediaQuery.of(context).size.height * 0.06,
//               child: Center(
//                 child: Text(
//                     videoDetails.title != null ? videoDetails.title! : 'Match',
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: MediaQuery.of(context).size.height * 0.02)),
//               ),
//             ),
//             Container(
//                 // height: MediaQuery.of(context).size.height * 0.3,
//                 // width: MediaQuery.of(context).size.width,
//                 color: Colors.black,
//                 padding: EdgeInsets.symmetric(
//                     vertical: MediaQuery.of(context).size.height * 0.02),
//                 child: BlocBuilder<VideoDetailsBloc, VideoDetailsState>(
//                   builder: (context, state) {
//                     if (state is YtUrlFromApiLoaded) {
//                       return _ytController != null && videoId != null
//                           ? Container(
//                               height: isEnterFullScreen
//                                   ? 0
//                                   : MediaQuery.of(context).size.height * 0.3,
//                               width: isEnterFullScreen
//                                   ? 0
//                                   : MediaQuery.of(context).size.width,
//                               child: YoutubePlayerBuilder(
//                                 builder: (v, a) {
//                                   return Container();
//                                 },
//                                 // onEnterFullScreen: () {
//                                 //   setState(() {
//                                 //     isEnterFullScreen = true;
//                                 //     SystemChrome.setPreferredOrientations([
//                                 //       DeviceOrientation.landscapeLeft,
//                                 //       DeviceOrientation.landscapeRight,
//                                 //     ]);
//                                 //   });
//                                 // },
//                                 onExitFullScreen: () {
//                                   // setState(() {
//                                   //   onExitFullScreen:
//                                   //   () => SystemChrome
//                                   //           .setEnabledSystemUIOverlays([
//                                   //         SystemUiOverlay.bottom,
//                                   //         SystemUiOverlay.top
//                                   //       ]);
//                                   // });
//                                   // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
//                                 },
//                                 player: YoutubePlayer(
//                                   controller: _ytController!,
//                                   showVideoProgressIndicator: true,
//                                   progressIndicatorColor: Constant.color1,
//                                   progressColors: ProgressBarColors(
//                                     playedColor: Constant.color1,
//                                     handleColor: Constant.color1,
//                                   ),
//                                   onReady: () {
//                                     setState(() {
//                                       _isPlayerReady = true;
//                                     });
//                                     print('ended ');
//                                     print(_ytController!.value.playbackRate);
//                                     if (_ytController!.value.hasError) {
//                                       print(_ytController!.value.errorCode);
//                                     }
//                                     // if () {
//                                     //   print(_ytController!.value.errorCode
//                                     //       .toString());
//                                     // }
//                                   },
//                                   onEnded: (v) {},
//                                 ),
//                               ),
//                             )
//                           : htmlWidget();
//                     } else if (state is VideoDetailsError) {
//                       return htmlWidget();
//                     } else {
//                       return LoadingWidget();
//                     }
//                   },
//                 )),
//             Container(
//               child: Column(children: [
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.06,
//                   width: MediaQuery.of(context).size.width,
//                   padding: EdgeInsets.symmetric(
//                     vertical: MediaQuery.of(context).size.height * 0.01,
//                     horizontal: MediaQuery.of(context).size.height * 0.01,
//                   ),
//                   child: Container(
//                     child: Row(children: [
//                       Text(
//                         videoDetails.videos![videoIndex].title! + '',
//                         style: TextStyle(
//                             fontSize: MediaQuery.of(context).size.height * 0.02,
//                             fontWeight: FontWeight.bold),
//                         maxLines: 1,
//                       ),
//                     ]),
//                   ),
//                 ),
//                 Container(
//                     height: MediaQuery.of(context).size.height * 0.135,
//                     decoration: BoxDecoration(
//                       color: Constant.backgroundColor,
//                       boxShadow: [
//                         BoxShadow(
//                             color: Colors.grey,
//                             offset: Offset(0, 2),
//                             blurRadius: 10)
//                       ],
//                     ),
//                     padding: EdgeInsets.only(
//                       top: MediaQuery.of(context).size.height * 0.015,
//                       right: MediaQuery.of(context).size.height * 0.01,
//                       left: MediaQuery.of(context).size.height * 0.01,
//                       bottom: MediaQuery.of(context).size.height * 0.01,
//                     ),
//                     width: double.infinity,
//                     child: ListView.builder(
//                       shrinkWrap: true,
//                       physics: ClampingScrollPhysics(),
//                       scrollDirection: Axis.horizontal,
//                       itemCount: videoDetails.videos!.length,
//                       itemBuilder: (context, index) {
//                         Video video = videoDetails.videos![index];
//                         bool isSelected =
//                             videoDetails.videos![videoIndex] == video;

//                         return Padding(
//                           padding: EdgeInsets.only(
//                               right: MediaQuery.of(context).size.width * 0.05),
//                           child: Container(
//                             height: double.infinity,
//                             width: MediaQuery.of(context).size.width * 0.2,
//                             child: Column(children: [
//                               Expanded(
//                                 // padding: EdgeInsets.symmetric(
//                                 //   vertical:
//                                 //       MediaQuery.of(context).size.height * 0.01,
//                                 //   horizontal:
//                                 //       MediaQuery.of(context).size.height * 0.01,
//                                 // ),
//                                 child: ElevatedButton(
//                                   onPressed: isSelected
//                                       ? () {}
//                                       : () {
//                                           setState(() {
//                                             videoIndex = index;
//                                           });
//                                         },
//                                   child: Center(
//                                     child: Icon(
//                                         isSelected
//                                             ? FontAwesomeIcons.playCircle
//                                             : FontAwesomeIcons.film,
//                                         color: isSelected
//                                             ? Colors.white
//                                             : Constant.color1),
//                                   ),
//                                   style: ElevatedButton.styleFrom(
//                                     shape: CircleBorder(),
//                                     primary: isSelected
//                                         ? Constant.color1
//                                         : Colors.white,
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 height:
//                                     MediaQuery.of(context).size.height * 0.04,
//                                 padding: EdgeInsets.only(
//                                     top: MediaQuery.of(context).size.height *
//                                         0.01),
//                                 child: AutoSizeText(
//                                   video.title != null
//                                       ? video.title!
//                                       : 'Highlights',
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                       fontSize:
//                                           MediaQuery.of(context).size.height *
//                                               0.015,
//                                       color: isSelected
//                                           ? Constant.color1
//                                           : Colors.white,
//                                       fontWeight: isSelected
//                                           ? FontWeight.bold
//                                           : FontWeight.normal),
//                                   minFontSize: 8,
//                                   wrapWords: false,
//                                   maxLines: 2,
//                                 ),
//                               )
//                             ]),
//                           ),
//                         );
//                       },
//                     )),
//               ]),
//             ),

//             SizedBox(height: MediaQuery.of(context).size.height * 0.025),
//             //recommned video widget
//             Container(
//               height: MediaQuery.of(context).size.height * 0.25,
//               child: Column(children: [
//                 Text(
//                   "Recommend Video",
//                   style: TextStyle(
//                       fontSize: MediaQuery.of(context).size.height * 0.02),
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: EdgeInsets.all(
//                         MediaQuery.of(context).size.height * 0.03),
//                     child: ListView.builder(
//                         shrinkWrap: true,
//                         physics: ClampingScrollPhysics(),
//                         scrollDirection: Axis.horizontal,
//                         itemCount: recommendList.length,
//                         itemBuilder: (context, index) {
//                           return RecommendVideoListtile(
//                             videoDetails: recommendList[index],
//                             clone: widget.clone,
//                           );
//                         }),
//                   ),
//                 )
//               ]),
//             ),
//           ]),
//         ),
//       ),
//       // body: Container(
//       //   height: MediaQuery.of(context).size.height * 0.2,
//       //   width: double.infinity,
//       //   child: WebView(
//       //     javascriptMode: JavascriptMode.unrestricted,
//       //     initialUrl: 'https://soccersport.club/',
//       //     onWebViewCreated: (controller) {
//       //       this.controller = controller;
//       //     },
//       //     backgroundColor: Colors.transparent,
//       //     onProgress: (url) {
//       //       controller.evaluateJavascript(
//       //           "document.getElementsByTagName('header')[0].style.display='none'");
//       //       controller.evaluateJavascript(
//       //           "document.getElementsByTagName('section')[1].style.display='none'");
//       //       controller.evaluateJavascript(
//       //           "document.getElementsByTagName('section')[2].style.display='none'");
//       //       controller.evaluateJavascript(
//       //           "document.getElementsByTagName('section')[3].style.display='none'");
//       //       controller.evaluateJavascript(
//       //           "document.getElementsByClassName('elementor-element-4394977')[0].style.display='none'");

//       //       controller.evaluateJavascript(
//       //           "document.getElementsByClassName('elementor-element-95d92f8')[0].style.display='none'");
//       //       // controller.evaluateJavascript(
//       //       // "document.getElementsByTagName('header')[0].style.display='none'");
//       //       controller.evaluateJavascript(
//       //           "document.getElementsByTagName('footer')[0].style.display='none'");
//       //     },
//       //     onPageStarted: (url) {},
//       //     onPageFinished: (url) async {
//       //       double height = double.parse(await controller
//       //           .evaluateJavascript("document.documentElement.scrollHeight;"));
//       //       print(MediaQuery.of(context).size.height * 0.25);

//       //       print(height);
//       //       Timer(Duration(seconds: 2), () {
//       //         setState(() {
//       //           isLoading = false;
//       //         });
//       //       });
//       //     },
//       //   ),
//       // ),
//     );
//   }

//   htmlWidget() {
//     return HtmlWidget(
//       // "<iframe src='https://www.scorebat.com/embed/v/QUZyNWhrMEpKckRwL0k3UWhrRUVkQT09/?token=MjYyNzNfMTY2MzU3NTkyN19jYmQwZDNiZjA4M2YyNWQyNGQ2Y2I1ZTQxZjQxYjFlNzJjMWE5OTE3&utm_source=api&utm_medium=video&utm_campaign=apifd' frameborder='0' width='100%' height='100%' allowfullscreen allow='autoplay; fullscreen' style='width:100%;height:100%;position:absolute;left:0px;top:0px;overflow:hidden;'></iframe>",
//       videoDetails.videos![videoIndex].embed!,
//       buildAsync: true,

//       // factoryBuilder: () {
//       //   print('twsting factory');
//       //   WidgetFactory().wid;
//       //   print(WidgetFactory().webView);
//       //   return WidgetFactory();
//       // },
//       // these callbacks are called when a complicated element is loading
//       // or failed to render allowing the app to render progress indicator
//       // and fallback widget

//       //                     onTapImage: (v){
//       // return true;
//       //                     },
//       onErrorBuilder: (context, element, error) {
//         print('erro dids ');
//         print(element);
//         print(error);
//         return Text(
//           '$element error: ',
//           style: TextStyle(color: Colors.white),
//         );
//       },
//       onTapImage: (v) {
//         print('on image');
//       },
//       onLoadingBuilder: (context, element, loadingProgress) =>
//           CircularProgressIndicator(),

//       // this callback will be triggered when user taps a link
//       onTapUrl: (v) async {
//         print('is on tap url');
//         print(v);
//         List<String> splittedUrl = v.split('&');
//         if (splittedUrl.length > 1) {
//           print(splittedUrl.length);
//           print(splittedUrl[0]);
//           print(splittedUrl[1]);
//           print('fsd');
//           return true;
//         } else {
//           if (v.contains('channel')) {
//             return true;
//           } else {
//             setState(() {
//               initialYtController(v);
//             });
//             return false;
//           }
//           // print(v);
//         }

//         // return true;
//       },
//       // select the render mode for HTML body
//       // by default, a simple `Column` is rendered
//       // consider using `ListView` or `SliverList` for better performance
//       renderMode: RenderMode.column,

//       // set the default styling for text
//       textStyle: TextStyle(fontSize: 14),
// //  isSelectable: true,
// //       webViewMediaPlaybackAlwaysAllow: true,
// //       webViewDebuggingEnabled: true,
// //       webView: true,
//       // turn on `webView` if you need IFRAME support (it's disabled by default)
//     );
//   }
// }

// // class MyWidgetFactory extends WidgetFactory with facto.WebViewFactory {
// //   // optional: override getter to configure how WebViews are built
// //   bool get webViewMediaPlaybackAlwaysAllow => true;
// //   String? get webViewUserAgent => 'My app';
// // }
