part of 'lucky_draw_bloc.dart';

abstract class LuckyDrawEvent extends Equatable {
  const LuckyDrawEvent();

  @override
  List<Object> get props => [];
}

class LuckyDrawRequest extends LuckyDrawEvent {
  final LuckyDrawInfo luckyDraw;

  LuckyDrawRequest({required this.luckyDraw});

  @override
  List<Object> get props => [luckyDraw];
}

class RetrieveLuckyDrawRequest extends LuckyDrawEvent {
  final int id;

  RetrieveLuckyDrawRequest({required this.id});

  @override
  List<Object> get props => [id];
}

class RetrieveCouponsRequest extends LuckyDrawEvent {}

class PersistCouponsRequest extends LuckyDrawEvent {
  final Map<String, dynamic> coupons;

  PersistCouponsRequest({required this.coupons});

  @override
  List<Object> get props => [coupons];
}
