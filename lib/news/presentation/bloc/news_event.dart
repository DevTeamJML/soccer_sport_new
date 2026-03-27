part of 'news_bloc.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object?> get props => [];
}

class GetNewsRequest extends NewsEvent {
  final String page;
  GetNewsRequest({required this.page});

  @override
  List<Object> get props => [page];
}

class LoadNewsRequest extends NewsEvent {
  final String page;
  LoadNewsRequest({required this.page});

  @override
  List<Object> get props => [page];
}

class RefreshNewsRequest extends NewsEvent {}

class GetNewContentRequest extends NewsEvent {
  final String id;
  final int? userid;
  GetNewContentRequest({required this.id, this.userid});

  @override
  List<Object?> get props => [id, userid];
}

class GetNewsBySlugRequest extends NewsEvent {
  final String slug;
  GetNewsBySlugRequest({required this.slug});

  @override
  List<Object?> get props => [slug];
}
