import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/news/domain/entities/news.dart';
import 'package:soccer_sport/news/domain/repositories/news_repository.dart';
import 'package:soccer_sport/notification/domain/repository/notification_repository.dart';
import 'package:wordpress_api/wordpress_api.dart';

class PersistNotification extends UseCase<bool, NotificationParams> {
  final NotificationRepository repository;

  PersistNotification(this.repository);

  Future<Either<Failure, bool>> call(NotificationParams params) async {
    return await repository.persistNotification(params.notification);
  }
}

class NotificationParams extends Equatable {
  final bool notification;
  NotificationParams({
    required this.notification,
  });

  @override
  List<Object> get props => [notification];
}
