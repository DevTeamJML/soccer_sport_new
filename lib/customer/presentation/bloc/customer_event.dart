part of 'customer_bloc.dart';

@immutable
abstract class CustomerEvent {}

class GetCustomerDetailsRequest extends CustomerEvent {
  final int id;
  GetCustomerDetailsRequest({
    required this.id,
  });
  @override
  List<Object> get props => [id];
}

class PurchaseRewardRequest extends CustomerEvent {
  final int value;
  final int id;
  PurchaseRewardRequest({
    required this.value,
    required this.id,
  });
  @override
  List<Object> get props => [value, id];
}

class ConvertDiamondsRequest extends CustomerEvent {
  final int value;
  ConvertDiamondsRequest({
    required this.value,
  });
  @override
  List<Object> get props => [value];
}

class EditAddressRequest extends CustomerEvent {
  final Shipping shipping;
  EditAddressRequest({
    required this.shipping,
  });
  @override
  List<Object> get props => [shipping];
}

class ChangePasswordRequest extends CustomerEvent {
  final String password;
  ChangePasswordRequest({
    required this.password,
  });
  @override
  List<Object> get props => [password];
}

class RemoveFirstLoginRequest extends CustomerEvent {}

class GetUserBalanceRequest extends CustomerEvent {
  final int id;
  GetUserBalanceRequest({
    required this.id,
  });
  @override
  List<Object> get props => [id];
}

class GetDailyRewardsRequest extends CustomerEvent {
  final CustomerRewardDetail customerRewardDetail;
  GetDailyRewardsRequest({
    required this.customerRewardDetail,
  });
  @override
  List<Object> get props => [customerRewardDetail];
}

class AddDailyRewardRequest extends CustomerEvent {
  final String points;
  AddDailyRewardRequest({
    required this.points,
  });
  @override
  List<Object> get props => [points];
}

class GetUserRewardDetailRequest extends CustomerEvent {
  final String id;
  GetUserRewardDetailRequest({
    required this.id,
  });
  @override
  List<Object> get props => [id];
}

class CheckVerifiedRequest extends CustomerEvent {
  final String id;
  CheckVerifiedRequest({
    required this.id,
  });
  @override
  List<Object> get props => [id];
}

class SendVerificationEmailRequest extends CustomerEvent {
  final String id;
  SendVerificationEmailRequest({
    required this.id,
  });
  @override
  List<Object> get props => [id];
}

class CnyGetDetailRequest extends CustomerEvent {
  final String id;
  CnyGetDetailRequest({
    required this.id,
  });
  @override
  List<Object> get props => [id];
}

class CnyAddRewardRequest extends CustomerEvent {
  final CnyRewardDetail detail;
  CnyAddRewardRequest({
    required this.detail,
  });
  @override
  List<Object> get props => [detail];
}

class UpdatePersonalizeRequest extends CustomerEvent {
  final String id;
  final List<int> leagues;
  UpdatePersonalizeRequest({
    required this.id,
    required this.leagues,
  });
  @override
  List<Object> get props => [id, leagues];
}
