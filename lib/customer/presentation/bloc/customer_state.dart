part of 'customer_bloc.dart';

@immutable
abstract class CustomerState {}

class CustomerInitial extends CustomerState {}

class LoadingCustomerDetails extends CustomerState {}

class CustomerDetailsLoaded extends CustomerState {
  final Customer customer;
  CustomerDetailsLoaded({required this.customer});

  @override
  List<Object> get props => [customer];
}

class ConvertingDiamonds extends CustomerState {}

class DiamondsConverted extends CustomerState {
  final bool success;
  DiamondsConverted({required this.success});

  @override
  List<Object> get props => [success];
}

class CustomerError extends CustomerState {
  final String message;

  CustomerError({required this.message});

  @override
  List<Object> get props => [message];
}

class PurchasingReward extends CustomerState {}

class RewardPurchased extends CustomerState {
  final Reference reference;
  RewardPurchased({required this.reference});

  @override
  List<Object> get props => [reference];
}

class EditingAddress extends CustomerState {}

class AddressEdited extends CustomerState {
  final Customer customer;
  AddressEdited({required this.customer});

  @override
  List<Object> get props => [customer];
}

class ChangingPassword extends CustomerState {}

class PasswordChanged extends CustomerState {
  final bool success;
  PasswordChanged({required this.success});

  @override
  List<Object> get props => [success];
}

class RemovingFirstLogin extends CustomerState {}

class FirstLoginRemoved extends CustomerState {
  final bool success;
  FirstLoginRemoved({required this.success});

  @override
  List<Object> get props => [success];
}

class LoadingUserBalance extends CustomerState {}

class UserBalanceLoaded extends CustomerState {
  final int success;
  UserBalanceLoaded({required this.success});

  @override
  List<Object> get props => [success];
}

class GettingDailyReward extends CustomerState {}

class DailyRewardGet extends CustomerState {
  final int success;
  DailyRewardGet({required this.success});

  @override
  List<Object> get props => [success];
}

class AddingDailyReward extends CustomerState {}

class DailyRewardAdded extends CustomerState {
  final bool success;
  DailyRewardAdded({required this.success});

  @override
  List<Object> get props => [success];
}

class GettingUserRewardDetail extends CustomerState {}

class UserRewardDetailGet extends CustomerState {
  final CustomerRewardDetail success;
  UserRewardDetailGet({required this.success});

  @override
  List<Object> get props => [success];
}

class CheckingVerified extends CustomerState {}

class VerifiedChecked extends CustomerState {
  final VerifiedDetail success;
  VerifiedChecked({required this.success});

  @override
  List<Object> get props => [success];
}

class SendingVerificationEmail extends CustomerState {}

class VerificationEmailSended extends CustomerState {
  final bool success;
  VerificationEmailSended({required this.success});

  @override
  List<Object> get props => [success];
}

class SendVerificationEmailFail extends CustomerState {}

class CnyGettingDetail extends CustomerState {}

class CnyDetailGet extends CustomerState {
  final CnyRewardDetail success;
  CnyDetailGet({required this.success});

  @override
  List<Object> get props => [success];
}

class CnyAddingReward extends CustomerState {}

class CnyRewardAdded extends CustomerState {
  final bool success;
  CnyRewardAdded({required this.success});

  @override
  List<Object> get props => [success];
}

class UpdatingPersonalize extends CustomerState {}

class PersonalizeUpdated extends CustomerState {
  final CustomerRewardDetail success;
  PersonalizeUpdated({required this.success});

  @override
  List<Object> get props => [success];
}
