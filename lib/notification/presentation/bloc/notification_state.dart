part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class LoadNotification extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final bool? notification;

  NotificationLoaded({required this.notification});
  @override
  List<Object?> get props => [notification];
}

class PersistingNotification extends NotificationState {}

class NotificationPersisted extends NotificationState {
  final bool notification;

  NotificationPersisted({required this.notification});
  @override
  List<Object?> get props => [notification];
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError({required this.message});

  @override
  List<Object> get props => [message];
}

class RemovingNotification extends NotificationState {}

class NotificationRemoved extends NotificationState {
  final bool notification;

  NotificationRemoved({required this.notification});
  @override
  List<Object> get props => [notification];
}
