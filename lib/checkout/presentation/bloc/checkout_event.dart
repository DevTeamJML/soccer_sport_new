part of 'checkout_bloc.dart';

@immutable
abstract class CheckoutEvent {}

class CreateOrderRequest extends CheckoutEvent {
  final OrderDetails order;
  CreateOrderRequest({required this.order});
  @override
  List<Object> get props => [order];
}

class GetOrdersRequest extends CheckoutEvent {
  final int userID;
  GetOrdersRequest({required this.userID});
  @override
  List<Object> get props => [userID];
}

class CheckLimitCheckoutRequest extends CheckoutEvent {
  final List<CartProduct> line_items;
  CheckLimitCheckoutRequest({required this.line_items});
  @override
  List<Object> get props => [line_items];
}
