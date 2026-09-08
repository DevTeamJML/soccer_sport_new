part of 'news_bloc.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

class NewsInitial extends NewsState {}

class LoadAllNews extends NewsState {}

class NewsLoaded extends NewsState {
  final List<News> news;

  NewsLoaded({required this.news});
  @override
  List<Object> get props => [news];
}

class LoadPaginationNews extends NewsState {}

class PaginationNewsLoaded extends NewsState {
  final List<News> news;

  PaginationNewsLoaded({required this.news});
  @override
  List<Object> get props => [news];
}

class LoadRefreshNews extends NewsState {}

class RefreshNewsLoaded extends NewsState {
  final List<News> news;

  RefreshNewsLoaded({required this.news});
  @override
  List<Object> get props => [news];
}

class NewsError extends NewsState {
  final String message;

  NewsError({required this.message});

  @override
  List<Object> get props => [message];
}

class LoadNewContent extends NewsState {}

class NewContentLoaded extends NewsState {
  final NewsContent id;

  NewContentLoaded({required this.id});
  @override
  List<Object> get props => [id];
}

class LoadingNewsBySlug extends NewsState {}

class NewsBySlugLoaded extends NewsState {
  final News news;

  NewsBySlugLoaded({required this.news});
  @override
  List<Object> get props => [news];
}
