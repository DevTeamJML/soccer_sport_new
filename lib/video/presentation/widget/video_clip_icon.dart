import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:soccer_sport/core/constant/constants.dart';

import '../../domain/entities/video.dart';

class VideoClipIcon extends StatefulWidget {
  final Video video;
  final bool isSelected;
  final Function function;
  const VideoClipIcon({
    required this.video,
    required this.isSelected,
    required this.function,
  });

  @override
  State<VideoClipIcon> createState() => _VideoClipIconState();
}

class _VideoClipIconState extends State<VideoClipIcon> {
  late bool isSelected;
  late Video video;
  late Function function;
  @override
  void initState() {
    isSelected = widget.isSelected;
    video = widget.video;
    function = widget.function;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ElevatedButton(
        onPressed: isSelected
            ? null
            : () {
                function;
              },
        child: Icon(
            isSelected ? FontAwesomeIcons.playCircle : FontAwesomeIcons.film,
            color: isSelected ? Constant.color1 : Colors.white),
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(20),
          backgroundColor: Colors.transparent,
          // onSurface: Colors.white,
          // onPrimary: Colors.white,
          // primary:
          //     isSelected ? Constant.color1 : Colors.white, // <-- Button color
          // // onPrimary: Colors.red, // <-- Splash color
          // onPrimary: isSelected ? Colors.white : Constant.color1, //
        ),
      ),
      Text(video.title != null ? video.title! : 'Highlights')
    ]);
  }
}
