import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/banner/domain/entities/banner.dart';
import 'package:soccer_sport/banner/domain/usecases/get_update_date.dart';
import 'package:soccer_sport/banner/domain/usecases/persist_update_date.dart';

import '../../../core/usecase/usecase.dart';
import '../../../core/util/failure_message.dart';
import '../../domain/entities/ssc_dialog.dart';
import '../../domain/entities/ssc_fab.dart';
import '../../domain/usecases/get_banner.dart';
import '../../domain/usecases/get_ssc_dialog.dart';
import '../../domain/usecases/get_ssc_fab.dart';

part 'banner_event.dart';
part 'banner_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  final GetBanner getBanner;
  final GetDailyUpdateDate getUpdateDate;
  final PersistDailyUpdateDate persistUpdateDate;
  final GetSscDialog getSscDialog;
  final GetSscFab getSscFab;

  BannerBloc({
    required GetBanner getBanner,
    required GetDailyUpdateDate getUpdateDate,
    required PersistDailyUpdateDate persistUpdateDate,
    required GetSscDialog getSscDialog,
    required GetSscFab getSscFab,
  })  : getBanner = getBanner,
        persistUpdateDate = persistUpdateDate,
        getUpdateDate = getUpdateDate,
        getSscFab = getSscFab,
        getSscDialog = getSscDialog,
        super(BannerInitial());

  @override
  Stream<BannerState> mapEventToState(
    BannerEvent event,
  ) async* {
    if (event is GetBannerRequest) {
      yield LoadingBanner();
      final failureOrAuth =
          await getBanner(GetBannerParams(link: event.api, id: event.id));
      yield failureOrAuth.fold(
        (failure) => BannerError(message: Failure2Message.map(failure)),
        (auth) => BannerLoaded(html: auth),
      );
    }

    if (event is GetSettingBannerRequest) {
      yield LoadingSettingBanner();
      final failureOrAuth =
          await getBanner(GetBannerParams(link: event.api, id: event.id));
      yield failureOrAuth.fold(
        (failure) => BannerError(message: Failure2Message.map(failure)),
        (auth) => SettingBannerLoaded(html: auth),
      );
    }

    if (event is GetFirstTimeInstallBannerRequest) {
      yield LoadingFirstTimeBanner();
      final failureOrAuth =
          await getBanner(GetBannerParams(link: event.api, id: event.id));
      yield failureOrAuth.fold(
        (failure) => BannerError(message: Failure2Message.map(failure)),
        (auth) => FirstTimeBannerLoaded(html: auth),
      );
    }
    if (event is GetEventBanner) {
      yield LoadingEventBanner();
      final failureOrAuth =
          await getBanner(GetBannerParams(link: event.api, id: event.id));
      yield failureOrAuth.fold(
        (failure) => BannerError(message: Failure2Message.map(failure)),
        (auth) => EventBannerLoaded(html: auth),
      );
    }

    if (event is GetUpdateDateRequest) {
      yield GettingUpdateDate();
      final failureOrAuth = await getUpdateDate(NoParams());
      yield failureOrAuth.fold(
        (failure) => BannerError(message: Failure2Message.map(failure)),
        (auth) => UpdateDateGet(html: auth),
      );
    }

    if (event is PersistUpdateDateRequest) {
      yield PersistingUpdateDate();
      final failureOrAuth = await persistUpdateDate(
          PersistDailyUpdateDateParams(date: event.date));
      yield failureOrAuth.fold(
        (failure) => BannerError(message: Failure2Message.map(failure)),
        (auth) => UpdateDatePersisted(html: auth),
      );
    }

    if (event is GetSscDialogRequest) {
      yield GettingSscDialog();
      final failureOrAuth = await getSscDialog(NoParams());
      yield failureOrAuth.fold(
        (failure) => BannerError(message: Failure2Message.map(failure)),
        (auth) => SscDialogGet(html: auth),
      );
    }

    if (event is GetSscFabRequest) {
      yield GettingSscFab();
      final failureOrAuth = await getSscFab(NoParams());
      yield failureOrAuth.fold(
        (failure) => BannerError(message: Failure2Message.map(failure)),
        (auth) => SscFabGet(html: auth),
      );
    }
  }
}
