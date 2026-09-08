import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/core/util/failure_message.dart';
import 'package:soccer_sport/notification/domain/usecases/get_notification.dart';
import 'package:soccer_sport/notification/domain/usecases/persist_notification.dart';
import 'package:soccer_sport/notification/domain/usecases/remove_notification.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotification getNotification;
  final PersistNotification persistNotification;
  final RemoveNotification removeNotification;
  NotificationBloc({
    required GetNotification getNotification,
    required PersistNotification persistNotification,
    required RemoveNotification removeNotification,
  })  : getNotification = getNotification,
        persistNotification = persistNotification,
        removeNotification = removeNotification,
        super(NotificationInitial());

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    if (event is GetNotificationRequest) {
      yield LoadNotification();
      final failureOrNotification = await getNotification(NoParams());
      yield failureOrNotification.fold(
        (failure) => NotificationError(message: Failure2Message.map(failure)),
        (notification) => NotificationLoaded(notification: notification),
      );
    }

    if (event is PersistNotificationRequest) {
      yield PersistingNotification();
      final failureOrNotification = await persistNotification(
          NotificationParams(notification: event.notification));
      yield failureOrNotification.fold(
        (failure) => NotificationError(message: Failure2Message.map(failure)),
        (notification) => NotificationPersisted(notification: notification),
      );
    }

    if (event is RemoveNotificationRequest) {
      yield RemovingNotification();
      final failureOrNotification = await removeNotification(NoParams());
      yield failureOrNotification.fold(
        (failure) => NotificationError(message: Failure2Message.map(failure)),
        (notification) => NotificationRemoved(notification: notification),
      );
    }
  }
}
