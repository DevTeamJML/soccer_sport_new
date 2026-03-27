// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:transparent_image/transparent_image.dart';

// class SettingBanner extends StatelessWidget {
//   final String imgSrc;
//   const SettingBanner({required this.imgSrc});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       child: FittedBox(
//         fit: BoxFit.fitHeight,
//         // child: FadeInImage.memoryNetwork(
//         //     placeholder: kTransparentImage,
//         //     image: imgSrc,
//         //     imageErrorBuilder: (e, o, c) {
//         //       return Container();
//         //     }),

//         child: CachedNetworkImage(
//           imageUrl: imgSrc,
//           progressIndicatorBuilder: (context, url, downloadProgress) =>
//               CircularProgressIndicator(value: downloadProgress.progress),
//           errorWidget: (context, url, error) => Icon(Icons.error),
//         ),
//       ),
//     );
//   }
// }
