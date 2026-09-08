import 'package:flutter/material.dart';
import 'package:soccer_sport/video/domain/entities/video_details.dart';
import 'package:soccer_sport/video/presentation/page/video_page.dart';
import 'package:transparent_image/transparent_image.dart';

class RecommendVideoListtile extends StatelessWidget {
  final VideoDetails videoDetails;
  final List<VideoDetails> clone;
  const RecommendVideoListtile(
      {required this.videoDetails, required this.clone});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => VideoPage(
                  videoDetails: videoDetails,
                  clone: clone,
                )));
      },
      child: Container(
        padding:
            EdgeInsets.only(right: MediaQuery.of(context).size.height * 0.03),
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: videoDetails.thumbnail != null
                    ? FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: videoDetails.thumbnail!,
                        imageErrorBuilder: (e, o, c) {
                          return Container(
                            color: Colors.grey,
                            child: Image.asset('assets/image-loading.jpg'),
                          );
                        })
                    : Container(
                        color: Colors.grey,
                        child: Image.asset('assets/image-loading.jpg'),
                      ),
              ),
            ),
            Text(videoDetails.title != null ? videoDetails.title! : 'Video')
          ],
        ),
      ),
    );
  }
}
