part of 'video_details_bloc.dart';

abstract class VideoDetailsState extends Equatable {
  const VideoDetailsState();

  @override
  List<Object> get props => [];
}

class VideoDetailsInitial extends VideoDetailsState {}

class LoadingRecentFeed extends VideoDetailsState {}

class RecentFeedLoaded extends VideoDetailsState {
  final List<VideoDetails> videos;

  RecentFeedLoaded({required this.videos});

  @override
  List<Object> get props => [videos];
}

class VideoDetailsError extends VideoDetailsState {
  final String message;

  VideoDetailsError({required this.message});

  @override
  List<Object> get props => [message];
}

class LoadingYtUrlFromApi extends VideoDetailsState {}

class YtUrlFromApiLoaded extends VideoDetailsState {
  final String url;

  YtUrlFromApiLoaded({required this.url});

  @override
  List<Object> get props => [url];
}

class CheckingSscLive extends VideoDetailsState {}

class SscLiveChecked extends VideoDetailsState {
  final bool isLive;

  SscLiveChecked({required this.isLive});

  @override
  List<Object> get props => [isLive];
}
