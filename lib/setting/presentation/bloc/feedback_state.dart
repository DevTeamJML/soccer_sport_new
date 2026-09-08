part of 'feedback_bloc.dart';

abstract class FeedbackState extends Equatable {
  const FeedbackState();

  @override
  List<Object> get props => [];
}

class FeedbackInitial extends FeedbackState {}

class SendingFeedback extends FeedbackState {}

class FeedbackSent extends FeedbackState {
  final bool success;

  FeedbackSent({required this.success});

  @override
  List<Object> get props => [success];
}

class FeedbackError extends FeedbackState {
  final String message;

  FeedbackError({required this.message});

  @override
  List<Object> get props => [message];
}
