part of 'feedback_bloc.dart';

abstract class FeedbackEvent extends Equatable {
  const FeedbackEvent();

  @override
  List<Object> get props => [];
}

class SendFeedbackRequest extends FeedbackEvent {
  final FeedbackC feedback;

  SendFeedbackRequest({required this.feedback});

  @override
  List<Object> get props => [feedback];
}
