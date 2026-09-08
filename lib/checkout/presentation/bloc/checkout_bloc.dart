import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:soccer_sport/checkout/domain/usecase/check_limit_checkout.dart';
import 'package:soccer_sport/checkout/domain/usecase/create_order.dart';
import 'package:soccer_sport/checkout/domain/usecase/get_orders.dart';
import 'package:soccer_sport/products/domain/entities/cart_product.dart';

import '../../../core/util/failure_message.dart';
import '../../domain/entities/order.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CreateOrder createOrder;
  final GetOrders getOrders;
  final CheckLimitCheckout checkLimitCheckout;

  CheckoutBloc({
    required CreateOrder createOrder,
    required GetOrders getOrders,
    required CheckLimitCheckout checkLimitCheckout,
  })  : createOrder = createOrder,
        getOrders = getOrders,
        checkLimitCheckout = checkLimitCheckout,
        super(CheckoutInitial());

  @override
  Stream<CheckoutState> mapEventToState(
    CheckoutEvent event,
  ) async* {
    if (event is CreateOrderRequest) {
      yield CreatingOrder();
      final failureOrProduct =
          await createOrder(CreateOrderParams(order: event.order));
      yield failureOrProduct.fold(
          (failure) => CheckoutError(message: Failure2Message.map(failure)),
          (created) => OrderCreated(created: created));
    }

    if (event is GetOrdersRequest) {
      yield GettingOrders();
      final failureOrProduct =
          await getOrders(GetOrdersParams(userID: event.userID));
      yield failureOrProduct.fold(
          (failure) => CheckoutError(message: Failure2Message.map(failure)),
          (orders) => OrdersGot(orders: orders));
    }

    if (event is CheckLimitCheckoutRequest) {
      yield CheckingLimitCheckout();
      final failureOrProduct = await checkLimitCheckout(
          CheckLimitCheckoutParams(orders: event.line_items));
      yield failureOrProduct.fold(
          (failure) => CheckoutError(message: Failure2Message.map(failure)),
          (orders) => LimitCheckoutChecked(success: orders));
    }
  }
}
