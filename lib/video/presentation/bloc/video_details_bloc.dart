import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/video/domain/usecases/get_yt_url_from_api.dart';

import '../../../core/util/failure_message.dart';
import '../../domain/entities/video_details.dart';
import '../../domain/usecases/check_ssc_live.dart';
import '../../domain/usecases/get_recent_feed.dart';

part 'video_details_event.dart';
part 'video_details_state.dart';

class VideoDetailsBloc extends Bloc<VideoDetailsEvent, VideoDetailsState> {
  final GetRecentFeed getRecentFeed;
  final GetYtUrlFromApi getYtUrlFromApi;
  final CheckSscLive checkSscLive;

  VideoDetailsBloc({
    required GetRecentFeed getRecentFeed,
    required GetYtUrlFromApi getYtUrlFromApi,
    required CheckSscLive checkSscLive,
  })  : getRecentFeed = getRecentFeed,
        getYtUrlFromApi = getYtUrlFromApi,
        checkSscLive = checkSscLive,
        super(VideoDetailsInitial());

  @override
  Stream<VideoDetailsState> mapEventToState(
    VideoDetailsEvent event,
  ) async* {
    if (event is GetRecentFeedRequest) {
      yield LoadingRecentFeed();
      final failureOrleagues = await getRecentFeed(NoParams());
      yield failureOrleagues.fold(
        (failure) => VideoDetailsError(message: Failure2Message.map(failure)),
        (videos) => RecentFeedLoaded(videos: videos),
      );
    }

    if (event is GetYtUrlFromApiRequest) {
      yield LoadingYtUrlFromApi();
      final failureOrleagues =
          await getYtUrlFromApi(GetYtUrlFromApiParams(api: event.url));
      yield failureOrleagues.fold(
        (failure) => VideoDetailsError(message: Failure2Message.map(failure)),
        (videos) => YtUrlFromApiLoaded(url: videos),
      );
    }

    if (event is CheckSscLiveRequest) {
      yield CheckingSscLive();
      final failureOrleagues = await checkSscLive(NoParams());
      yield failureOrleagues.fold(
        (failure) => VideoDetailsError(message: Failure2Message.map(failure)),
        (videos) => SscLiveChecked(isLive: videos),
      );
    }
    //
  }
}
