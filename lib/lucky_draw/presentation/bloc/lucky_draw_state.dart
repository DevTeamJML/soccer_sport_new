part of 'lucky_draw_bloc.dart';

abstract class LuckyDrawState extends Equatable {
  const LuckyDrawState();

  @override
  List<Object> get props => [];
}

class LuckyDrawInitial extends LuckyDrawState {}

class LuckyDrawing extends LuckyDrawState {}

class LuckyDrawed extends LuckyDrawState {
  final LuckyDrawInfo lucky_draw;
  LuckyDrawed({required this.lucky_draw});

  @override
  List<Object> get props => [lucky_draw];
}

class GettingLuckyDrawInfo extends LuckyDrawState {}

class LuckyDrawInfoGet extends LuckyDrawState {
  final LuckyDrawInfo lucky_draw;
  LuckyDrawInfoGet({required this.lucky_draw});

  @override
  List<Object> get props => [lucky_draw];
}

class LuckyDrawError extends LuckyDrawState {
  final String message;

  LuckyDrawError({required this.message});

  @override
  List<Object> get props => [message];
}

class GettingCoupons extends LuckyDrawState {}

class CouponsGet extends LuckyDrawState {
  final Map<String, dynamic> coupons;
  CouponsGet({required this.coupons});

  @override
  List<Object> get props => [coupons];
}

class PersistingCoupons extends LuckyDrawState {}

class CouponPersisted extends LuckyDrawState {
  final bool succes;
  CouponPersisted({required this.succes});

  @override
  List<Object> get props => [succes];
}

class LuckyDrawNotEnugCoin extends LuckyDrawState {}
