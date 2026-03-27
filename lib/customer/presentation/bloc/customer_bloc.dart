import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/customer/domain/entities/cny_detail.dart';
import 'package:soccer_sport/customer/domain/entities/customer.dart';
import 'package:soccer_sport/customer/domain/entities/customer_reward_detail.dart';
import 'package:soccer_sport/customer/domain/entities/shipping.dart';
import 'package:soccer_sport/customer/domain/entities/verified_detail.dart';
import 'package:soccer_sport/customer/domain/usecase/add_daily_reward.dart';
import 'package:soccer_sport/customer/domain/usecase/check_verified.dart';
import 'package:soccer_sport/customer/domain/usecase/cny_add_reward.dart';
import 'package:soccer_sport/customer/domain/usecase/cny_get_detail.dart';
import 'package:soccer_sport/customer/domain/usecase/get_daily_reward.dart';
import 'package:soccer_sport/customer/domain/usecase/get_user_balance.dart';
import 'package:soccer_sport/customer/domain/usecase/get_user_reward_detail.dart';
import 'package:soccer_sport/customer/domain/usecase/purchase_reward.dart';
import 'package:soccer_sport/customer/domain/usecase/send_verification_email.dart';
import 'package:soccer_sport/customer/domain/usecase/update_personalize.dart';

import '../../../checkout/domain/entities/reference.dart';
import '../../../core/util/failure_message.dart';
import '../../domain/usecase/convert_diamonds.dart';
import '../../domain/usecase/edit_address.dart';
import '../../domain/usecase/get_customer_details.dart';
import '../../domain/usecase/remove_first_login.dart';

part 'customer_event.dart';

part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final GetCustomerDetails getCustomerDetails;
  final PurchaseReward purchaseReward;
  // final ConvertDiamonds convertDiamonds;
  final EditAddress editAddress;
  final GetUserBalance getUserBalance;
  final GetUserRewardDetail getUserRewardDetail;
  final GetDailyReward getDailyReward;
  final AddDailyReward addDailyReward;
  final CheckVerified checkVerified;
  final SendVerificationEmail sendVerificationEmail;
  final CnyGetDetail cnyGetDetail;
  final CnyAddReward cnyAddReward;
  // final ChangePassword changePassword;
  // final RemoveFirstLogin removeFirstLogin;

  final UpdatePersonalize updatePersonalize;

  CustomerBloc({
    required GetCustomerDetails getCustomerDetails,
    // required ConvertDiamonds convertDiamonds,
    required PurchaseReward purchaseReward,
    required EditAddress editAddress,
    required GetUserBalance getUserBalance,
    required GetDailyReward getDailyReward,
    required AddDailyReward addDailyReward,
    required GetUserRewardDetail getUserRewardDetail,
    required CheckVerified checkVerified,
    required SendVerificationEmail sendVerificationEmail,
    required CnyGetDetail cnyGetDetail,
    required CnyAddReward cnyAddReward,
    required UpdatePersonalize updatePersonalize,
    // required ChangePassword changePassword,
    // required RemoveFirstLogin removeFirstLogin,
  })  : getCustomerDetails = getCustomerDetails,
        purchaseReward = purchaseReward,
        getUserBalance = getUserBalance,
        // convertDiamonds = convertDiamonds,
        editAddress = editAddress,
        addDailyReward = addDailyReward,
        getDailyReward = getDailyReward,
        getUserRewardDetail = getUserRewardDetail,
        checkVerified = checkVerified,
        sendVerificationEmail = sendVerificationEmail,
        cnyAddReward = cnyAddReward,
        cnyGetDetail = cnyGetDetail,
        updatePersonalize = updatePersonalize,

        // removeFirstLogin = removeFirstLogin,
        // changePassword = changePassword,
        super(CustomerInitial());

  @override
  Stream<CustomerState> mapEventToState(
    CustomerEvent event,
  ) async* {
    if (event is GetCustomerDetailsRequest) {
      yield LoadingCustomerDetails();
      final failureOrProduct =
          await getCustomerDetails(GetCustomerDetailsParams(userID: event.id));
      yield failureOrProduct.fold(
          (failure) => CustomerError(message: Failure2Message.map(failure)),
          (customer) => CustomerDetailsLoaded(customer: customer));
    }

    if (event is PurchaseRewardRequest) {
      yield PurchasingReward();

      final failureOrProduct = await purchaseReward(
          PurchaseRewardParams(price: event.value, productID: event.id));
      yield failureOrProduct.fold(
          (failure) => CustomerError(message: Failure2Message.map(failure)),
          (reference) => RewardPurchased(reference: reference));
    }

    // if (event is ConvertDiamondsRequest) {
    //   yield ConvertingDiamonds();

    //   final failureOrProduct =
    //       await convertDiamonds(ConvertDiamondsParams(diamonds: event.value));
    //   yield failureOrProduct.fold(
    //       (failure) => CustomerError(message: Failure2Message.map(failure)),
    //       (success) => DiamondsConverted(success: success));
    // }

    if (event is EditAddressRequest) {
      yield EditingAddress();

      final failureOrProduct =
          await editAddress(EditAddressParams(shipping: event.shipping));
      yield failureOrProduct.fold(
          (failure) => CustomerError(message: Failure2Message.map(failure)),
          (success) => AddressEdited(customer: success));
    }

    if (event is GetUserBalanceRequest) {
      yield LoadingUserBalance();

      final failureOrProduct =
          await getUserBalance(GetUserBalanceParams(userID: event.id));
      yield failureOrProduct.fold(
          (failure) => CustomerError(message: Failure2Message.map(failure)),
          (success) => UserBalanceLoaded(success: success));
    }
    if (event is GetUserRewardDetailRequest) {
      yield GettingUserRewardDetail();

      final failureOrProduct =
          await getUserRewardDetail(GetUserRewardDetailParams(id: event.id));
      yield failureOrProduct.fold(
          (failure) => CustomerError(message: Failure2Message.map(failure)),
          (success) => UserRewardDetailGet(success: success));
    }

    if (event is AddDailyRewardRequest) {
      yield AddingDailyReward();

      final failureOrProduct =
          await addDailyReward(AddDailyRewardParams(points: event.points));
      yield failureOrProduct.fold(
          (failure) => CustomerError(message: Failure2Message.map(failure)),
          (success) => DailyRewardAdded(success: success));
    }

    if (event is GetDailyRewardsRequest) {
      yield GettingDailyReward();

      final failureOrProduct = await getDailyReward(GetDailyRewardParams(
          customerRewardDetail: event.customerRewardDetail));
      yield failureOrProduct.fold(
          (failure) => CustomerError(message: Failure2Message.map(failure)),
          (success) => DailyRewardGet(success: success));
    }

    if (event is CheckVerifiedRequest) {
      yield CheckingVerified();

      final failureOrProduct =
          await checkVerified(CheckVerifiedParams(id: event.id));
      yield failureOrProduct.fold(
          (failure) => CustomerError(message: Failure2Message.map(failure)),
          (success) => VerifiedChecked(success: success));
    }
    if (event is SendVerificationEmailRequest) {
      yield SendingVerificationEmail();

      final failureOrProduct = await sendVerificationEmail(
          SendVerificationEmailParams(id: event.id));
      yield failureOrProduct.fold((failure) => SendVerificationEmailFail(),
          (success) => VerificationEmailSended(success: success));
    }

    if (event is CnyGetDetailRequest) {
      yield CnyGettingDetail();

      final failureOrProduct =
          await cnyGetDetail(CnyGetDetailParams(id: event.id));
      yield failureOrProduct.fold(
          (failure) => CustomerError(message: Failure2Message.map(failure)),
          (success) => CnyDetailGet(success: success));
    }

    if (event is CnyAddRewardRequest) {
      yield CnyGettingDetail();

      final failureOrProduct =
          await cnyAddReward(CnyAddRewardParams(points: event.detail));
      yield failureOrProduct.fold(
          (failure) => CustomerError(message: Failure2Message.map(failure)),
          (success) => CnyRewardAdded(success: success));
    }

    if (event is UpdatePersonalizeRequest) {
      yield UpdatingPersonalize();

      final failureOrProduct = await updatePersonalize(
          UpdatePersonalizeParams(userID: event.id, leagues: event.leagues));
      yield failureOrProduct.fold(
          (failure) => CustomerError(message: Failure2Message.map(failure)),
          (success) => PersonalizeUpdated(success: success));
    }
  }
}
