part of 'video_details_bloc.dart';

abstract class VideoDetailsEvent extends Equatable {
  const VideoDetailsEvent();

  @override
  List<Object> get props => [];
}

class GetRecentFeedRequest extends VideoDetailsEvent {}

class GetYtUrlFromApiRequest extends VideoDetailsEvent {
  final String url;

  GetYtUrlFromApiRequest({required this.url});

  @override
  List<Object> get props => [url];
}

class CheckSscLiveRequest extends VideoDetailsEvent {}
