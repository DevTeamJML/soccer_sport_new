part of 'checkout_bloc.dart';

@immutable
abstract class CheckoutState {}

class CheckoutInitial extends CheckoutState {}

class CreatingOrder extends CheckoutState {}

class OrderCreated extends CheckoutState {
  final bool created;
  OrderCreated({required this.created});

  List<Object> get props => [created];
}

class GettingOrders extends CheckoutState {}

class OrdersGot extends CheckoutState {
  final List<OrderDetails> orders;
  OrdersGot({required this.orders});

  List<Object> get props => [orders];
}

class CheckoutError extends CheckoutState {
  final String message;

  CheckoutError({required this.message});

  @override
  List<Object> get props => [message];
}

class CheckingLimitCheckout extends CheckoutState {}

class LimitCheckoutChecked extends CheckoutState {
  final bool success;

  LimitCheckoutChecked({required this.success});

  List<Object> get props => [success];
}
