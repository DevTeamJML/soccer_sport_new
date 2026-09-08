import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/setting/domain/entity/feedback.dart';
import 'package:soccer_sport/setting/domain/repo/feedback_repo.dart';

import '../../../core/error/failure.dart';
import '../../../core/usecase/usecase.dart';

class SendFeedback extends UseCase<bool, SendFeedbackParams> {
  final FeedbackRepository repository;

  SendFeedback(this.repository);

  Future<Either<Failure, bool>> call(SendFeedbackParams params) async {
    return await repository.sendFeedback(
      params.feedback,
    );
  }
}

class SendFeedbackParams extends Equatable {
  final FeedbackC feedback;
  SendFeedbackParams({
    required this.feedback,
  });

  @override
  List<Object> get props => [feedback];
}
