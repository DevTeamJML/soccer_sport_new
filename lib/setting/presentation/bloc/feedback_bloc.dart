import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/util/failure_message.dart';
import 'package:soccer_sport/setting/domain/entity/feedback.dart';
import 'package:soccer_sport/setting/domain/usecase/send_feedback.dart';

part 'feedback_event.dart';
part 'feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final SendFeedback sendFeedback;

  FeedbackBloc({
    required SendFeedback sendFeedback,
  })  : sendFeedback = sendFeedback,
        super(FeedbackInitial());

  @override
  Stream<FeedbackState> mapEventToState(
    FeedbackEvent event,
  ) async* {
    if (event is SendFeedbackRequest) {
      yield SendingFeedback();
      final failureOrProduct =
          await sendFeedback(SendFeedbackParams(feedback: event.feedback));
      yield failureOrProduct.fold((failure) {
        // if (failure.runtimeType == NotEnugCoinFailure ||
        //     failure.runtimeType is NotEnugCoinFailure) {
        //   return LuckyDrawNotEnugCoin();
        // } else {

        // }
        return FeedbackError(message: Failure2Message.map(failure));
      }, (success) => FeedbackSent(success: success));
    }
  }
}
