part of 'banner_bloc.dart';

abstract class BannerEvent extends Equatable {
  const BannerEvent();

  @override
  List<Object> get props => [];
}

class GetBannerRequest extends BannerEvent {
  final String api;
  final String id;

  GetBannerRequest({required this.api, required this.id});

  @override
  List<Object> get props => [api, id];
}

class GetSettingBannerRequest extends BannerEvent {
  final String api;
  final String id;

  GetSettingBannerRequest({required this.api, required this.id});

  @override
  List<Object> get props => [api, id];
}

class GetFirstTimeInstallBannerRequest extends BannerEvent {
  final String api;
  final String id;

  GetFirstTimeInstallBannerRequest({required this.api, required this.id});

  @override
  List<Object> get props => [api, id];
}

class GetUpdateDateRequest extends BannerEvent {}

class PersistUpdateDateRequest extends BannerEvent {
  final String date;

  PersistUpdateDateRequest({required this.date});

  @override
  List<Object> get props => [date];
}

class GetEventBanner extends BannerEvent {
  final String api;
  final String id;

  GetEventBanner({required this.api, required this.id});

  @override
  List<Object> get props => [api, id];
}

class GetSscFabRequest extends BannerEvent {}

class GetSscDialogRequest extends BannerEvent {}
