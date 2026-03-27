import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/core/error/failure.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/core/util/failure_message.dart';
import 'package:soccer_sport/lucky_draw/domain/entities/lucky_draw_info.dart';
import 'package:soccer_sport/lucky_draw/domain/usecase/lucky_draw.dart';
import 'package:soccer_sport/lucky_draw/domain/usecase/persist_coupons.dart';
import 'package:soccer_sport/lucky_draw/domain/usecase/retrieve_coupons.dart';
import 'package:soccer_sport/lucky_draw/domain/usecase/retrieve_lucky_draw.dart';

part 'lucky_draw_event.dart';
part 'lucky_draw_state.dart';

class LuckyDrawBloc extends Bloc<LuckyDrawEvent, LuckyDrawState> {
  final LuckyDraw luckyDraw;
  final RetrieveLuckyDraw retrieveLuckyDraw;
  final RetrieveCoupons retrieveCoupons;
  final PersistCoupons persistCoupons;
  LuckyDrawBloc({
    required LuckyDraw luckyDraw,
    required RetrieveLuckyDraw retrieveLuckyDraw,
    required RetrieveCoupons retrieveCoupons,
    required PersistCoupons persistCoupons,
  })  : luckyDraw = luckyDraw,
        retrieveLuckyDraw = retrieveLuckyDraw,
        persistCoupons = persistCoupons,
        retrieveCoupons = retrieveCoupons,
        super(LuckyDrawInitial());

  @override
  Stream<LuckyDrawState> mapEventToState(
    LuckyDrawEvent event,
  ) async* {
    if (event is LuckyDrawRequest) {
      yield LuckyDrawing();
      final failureOrProduct =
          await luckyDraw(LuckyDrawParams(lucky_draw: event.luckyDraw));
      yield failureOrProduct.fold((failure) {
        if (failure.runtimeType == NotEnugCoinFailure ||
            failure.runtimeType is NotEnugCoinFailure) {
          return LuckyDrawNotEnugCoin();
        } else {
          return LuckyDrawError(message: Failure2Message.map(failure));
        }
      }, (categories) => LuckyDrawed(lucky_draw: categories));
    }

    if (event is RetrieveLuckyDrawRequest) {
      yield GettingLuckyDrawInfo();
      final failureOrProduct =
          await retrieveLuckyDraw(RetrieveLuckyDrawParams(id: event.id));
      yield failureOrProduct.fold(
          (failure) => LuckyDrawError(message: Failure2Message.map(failure)),
          (categories) => LuckyDrawInfoGet(lucky_draw: categories));
    }

    if (event is RetrieveCouponsRequest) {
      yield GettingCoupons();
      final failureOrProduct = await retrieveCoupons(NoParams());
      yield failureOrProduct.fold(
          (failure) => LuckyDrawError(message: Failure2Message.map(failure)),
          (categories) => CouponsGet(coupons: categories));
    }

    if (event is PersistCouponsRequest) {
      yield PersistingCoupons();
      final failureOrProduct =
          await persistCoupons(PersistCouponsParams(coupons: event.coupons));
      yield failureOrProduct.fold(
          (failure) => LuckyDrawError(message: Failure2Message.map(failure)),
          (categories) => CouponPersisted(succes: categories));
    }
  }
}
