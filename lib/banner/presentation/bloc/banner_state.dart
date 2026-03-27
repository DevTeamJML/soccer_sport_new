part of 'banner_bloc.dart';

abstract class BannerState extends Equatable {
  const BannerState();

  @override
  List<Object> get props => [];
}

class BannerInitial extends BannerState {}

class LoadingBanner extends BannerState {}

class BannerLoaded extends BannerState {
  final List<BannerHtml> html;

  BannerLoaded({required this.html});

  @override
  List<Object> get props => [html];
}

class LoadingSettingBanner extends BannerState {}

class SettingBannerLoaded extends BannerState {
  final List<BannerHtml> html;

  SettingBannerLoaded({required this.html});

  @override
  List<Object> get props => [html];
}

class LoadingFirstTimeBanner extends BannerState {}

class FirstTimeBannerLoaded extends BannerState {
  final List<BannerHtml> html;

  FirstTimeBannerLoaded({required this.html});

  @override
  List<Object> get props => [html];
}

class LoadingEventBanner extends BannerState {}

class EventBannerLoaded extends BannerState {
  final List<BannerHtml> html;

  EventBannerLoaded({required this.html});

  @override
  List<Object> get props => [html];
}

class BannerError extends BannerState {
  final String message;

  BannerError({required this.message});

  @override
  List<Object> get props => [message];
}

class GettingUpdateDate extends BannerState {}

class UpdateDateGet extends BannerState {
  final String html;

  UpdateDateGet({required this.html});

  @override
  List<Object> get props => [html];
}

class PersistingUpdateDate extends BannerState {}

class UpdateDatePersisted extends BannerState {
  final bool html;

  UpdateDatePersisted({required this.html});

  @override
  List<Object> get props => [html];
}

class GettingSscFab extends BannerState {}

class SscFabGet extends BannerState {
  final List<SscFab> html;

  SscFabGet({required this.html});

  @override
  List<Object> get props => [html];
}

class GettingSscDialog extends BannerState {}

class SscDialogGet extends BannerState {
  final List<SscDialog> html;

  SscDialogGet({required this.html});

  @override
  List<Object> get props => [html];
}
