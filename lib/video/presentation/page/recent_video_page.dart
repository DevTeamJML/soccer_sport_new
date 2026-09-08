import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soccer_sport/video/domain/entities/video_details.dart';
import 'package:soccer_sport/video/presentation/bloc/video_details_bloc.dart';

import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/no_data_widget.dart';
import '../../../injection_container.dart';
import '../widget/recent_video_list_tile.dart';

class RecentVideoPage extends StatefulWidget {
  const RecentVideoPage();

  @override
  State<RecentVideoPage> createState() => _RecentVideoPageState();
}

class _RecentVideoPageState extends State<RecentVideoPage> {
  final VideoDetailsBloc _videoDetailsBloc = serviceLocator<VideoDetailsBloc>();
  List<VideoDetails> videoDetails = [];
  @override
  void initState() {
    _videoDetailsBloc.add(GetRecentFeedRequest());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _videoDetailsBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _videoDetailsBloc,
      child: BlocListener<VideoDetailsBloc, VideoDetailsState>(
        listener: (context, state) {
          if (state is RecentFeedLoaded) {
            setState(() {
              videoDetails = state.videos;
            });
          }
        },
        child: BlocBuilder<VideoDetailsBloc, VideoDetailsState>(
          builder: (context, state) {
            if (state is LoadingRecentFeed) {
              return LoadingWidget();
            } else if (state is VideoDetailsError) {
              return ErrorsWidget();
            } else {
              if (videoDetails.length > 0) {
                return ListView.builder(
                    // controller: _scrollController,
                    itemCount: videoDetails.length,
                    itemBuilder: (BuildContext context, int index) {
                      List<VideoDetails> clone = List.from(videoDetails);
                      return RecentVideoListTile(
                        videoDetails: videoDetails[index],
                        clone: clone,
                      );
                    });
              } else {
                return NoDataWidget();
              }
            }
          },
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
