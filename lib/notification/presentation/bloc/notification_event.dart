part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class GetNotificationRequest extends NotificationEvent {}

class PersistNotificationRequest extends NotificationEvent {
  final bool notification;
  PersistNotificationRequest({required this.notification});

  @override
  List<Object> get props => [notification];
}

class RemoveNotificationRequest extends NotificationEvent {}
