import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:soccer_sport/authentication/domain/entities/user.dart';
import 'package:soccer_sport/authentication/domain/entities/wordpress_auth.dart';
import 'package:soccer_sport/authentication/domain/usecases/check_auth.dart';
import 'package:soccer_sport/authentication/domain/usecases/check_first_time_login.dart';
import 'package:soccer_sport/authentication/domain/usecases/check_member.dart';
import 'package:soccer_sport/authentication/domain/usecases/delete_account.dart';
import 'package:soccer_sport/authentication/domain/usecases/get_auth.dart';
import 'package:soccer_sport/authentication/domain/usecases/persist_auth.dart';
import 'package:soccer_sport/authentication/domain/usecases/register_user.dart';
import 'package:soccer_sport/authentication/domain/usecases/remove_bet_guide.dart';
import 'package:soccer_sport/authentication/domain/usecases/remove_first_time_install.dart';
import 'package:soccer_sport/authentication/domain/usecases/set_bet_guide.dart';
import 'package:soccer_sport/authentication/domain/usecases/set_first_time_install.dart';
import 'package:soccer_sport/authentication/domain/usecases/validate_auth.dart';
import 'package:soccer_sport/authentication/domain/usecases/wordpress_login.dart';
import 'package:soccer_sport/authentication/domain/usecases/wordpress_logout.dart';
import 'package:soccer_sport/core/usecase/usecase.dart';
import 'package:soccer_sport/core/util/failure_message.dart';

part 'wordpress_auth_event.dart';
part 'wordpress_auth_state.dart';

class WordpressAuthBloc extends Bloc<WordpressAuthEvent, WordpressAuthState> {
  final CheckAuth checkAuth;
  final GetAuth getAuth;
  final PersistAuth persistAuth;
  final WordpressLogin wordpressLogin;
  final WordpressLogout wordpressLogout;
  final ValidateAuth validateAuth;
  final DeleteAccount deleteAccount;
  final CheckFirstTimeLogin checkFirstTimeLogin;
  final SetFirstTimeInstall setFirstTimeInstall;
  final RemoveFirstTimeInstall removeFirstTimeInstall;
  final RegisterUser registerUser;
  final CheckMember checkMember;
  final SetBetGuide setBetGuide;
  final RemoveBetGuide removeBetGuide;
  WordpressAuthBloc({
    required CheckAuth checkAuth,
    required GetAuth getAuth,
    required PersistAuth persistAuth,
    required WordpressLogin wordpressLogin,
    required WordpressLogout wordpressLogout,
    required ValidateAuth validateAuth,
    required DeleteAccount deleteAccount,
    required CheckFirstTimeLogin checkFirstTimeLogin,
    required SetFirstTimeInstall setFirstTimeInstall,
    required RemoveFirstTimeInstall removeFirstTimeInstall,
    required RegisterUser registerUser,
    required CheckMember checkMember,
    required SetBetGuide setBetGuide,
    required RemoveBetGuide removeBetGuide,
  })  : checkAuth = checkAuth,
        getAuth = getAuth,
        persistAuth = persistAuth,
        wordpressLogin = wordpressLogin,
        wordpressLogout = wordpressLogout,
        validateAuth = validateAuth,
        deleteAccount = deleteAccount,
        removeFirstTimeInstall = removeFirstTimeInstall,
        setFirstTimeInstall = setFirstTimeInstall,
        checkFirstTimeLogin = checkFirstTimeLogin,
        registerUser = registerUser,
        checkMember = checkMember,
        setBetGuide = setBetGuide,
        removeBetGuide = removeBetGuide,
        super(WordpressAuthInitial());
  @override
  Stream<WordpressAuthState> mapEventToState(
    WordpressAuthEvent event,
  ) async* {
    if (event is CheckAuthRequest) {
      yield CheckingAuth();
      final failureOrAuth = await checkAuth(NoParams());
      yield failureOrAuth.fold(
        (failure) => AuthError(message: Failure2Message.map(failure)),
        (auth) => AuthChecked(auth: auth),
      );
    }

    if (event is GetAuthRequest) {
      yield GettingAuth();
      final failureOrAuth = await getAuth(NoParams());
      yield failureOrAuth.fold(
          (failure) => AuthError(message: Failure2Message.map(failure)),
          (auth) => AuthLoaded(auth: auth));
    }

    if (event is PersistAuthRequest) {
      yield PersistingAuth();
      final failureOrAuth =
          await persistAuth(PersistAuthParams(auth: event.auth));
      yield failureOrAuth.fold(
          (failure) => AuthError(message: Failure2Message.map(failure)),
          (auth) => AuthPersisted(auth: auth));
    }

    if (event is WordpressLoginRequest) {
      yield WordpressLoginLoading();
      final failureOrAuth = await wordpressLogin(WordpressLoginParams(
          username: event.username, password: event.password));
      yield failureOrAuth
          .fold((failure) => AuthError(message: Failure2Message.map(failure)),
              (auth) {
        if (auth != null) {
          return WordpressLoginSuccess(auth: auth);
        } else {
          return WordpressLoginIncorrect();
        }
      });
    }

    if (event is WordpressLogoutRequest) {
      yield WordpressLogoutLoading();
      final failureOrAuth = await wordpressLogout(NoParams());
      yield failureOrAuth.fold(
          (failure) => AuthError(message: Failure2Message.map(failure)),
          (auth) => WordpressLogoutSuccess(auth: auth));
    }

    if (event is ValidateAuthRequest) {
      yield ValidatingAuth();
      final failureOrAuth = await validateAuth(NoParams());
      yield failureOrAuth.fold(
          (failure) => AuthError(message: Failure2Message.map(failure)),
          (auth) => AuthValidated(auth: auth));
    }

    if (event is DeleteAccountRequest) {
      yield DeletingAccount();
      final failureOrAuth = await deleteAccount(NoParams());
      yield failureOrAuth.fold(
          (failure) => AuthError(message: Failure2Message.map(failure)),
          (auth) => AccountDeleted(auth: auth));
    }

    if (event is SetFirstTimeInstallRequest) {
      yield SettingFirstTimeInstall();
      final failureOrAuth = await setFirstTimeInstall(NoParams());
      yield failureOrAuth.fold(
          (failure) => AuthError(message: Failure2Message.map(failure)),
          (auth) => FirstTimeInstallSet(auth: auth));
    }
    if (event is CheckFirstTimeLoginRequest) {
      yield CheckingFirstTimeInstall();
      final failureOrAuth = await checkFirstTimeLogin(NoParams());
      yield failureOrAuth.fold(
          (failure) => AuthError(message: Failure2Message.map(failure)),
          (auth) => FirstTimeInstallChecked(auth: auth));
    }
    if (event is RemoveFirstTimeInstallRequest) {
      yield RemovingFirstTimeInstall();
      final failureOrAuth = await removeFirstTimeInstall(NoParams());
      yield failureOrAuth.fold(
          (failure) => AuthError(message: Failure2Message.map(failure)),
          (auth) => FirstTimeInstallRemoved(auth: auth));
    }

    if (event is RegisterUserRequest) {
      yield RegisteringUser();
      final failureOrAuth = await registerUser(RegisterUserParams(
          username: event.username,
          email: event.email,
          password: event.password));
      yield failureOrAuth
          .fold((failure) => AuthError(message: Failure2Message.map(failure)),
              (auth) {
        if (auth != null) {
          return UserRegistered(auth: auth);
        } else {
          return UserExistError();
        }
      });
    }

    if (event is CheckMemberRequest) {
      yield CheckingMember();
      final failureOrAuth = await checkMember(NoParams());
      yield failureOrAuth.fold(
          (failure) => AuthError(message: Failure2Message.map(failure)),
          (auth) => MemberChecked(auth: auth));
    }

    if (event is SetBetGuideRequest) {
      yield SettingBetGuide();
      final failureOrAuth = await setBetGuide(NoParams());
      yield failureOrAuth.fold(
          (failure) => AuthError(message: Failure2Message.map(failure)),
          (auth) => BetGuideSet(auth: auth));
    }

    if (event is RemoveBetGuideRequest) {
      yield RemovingBetGuide();
      final failureOrAuth = await removeBetGuide(NoParams());
      yield failureOrAuth.fold(
          (failure) => AuthError(message: Failure2Message.map(failure)),
          (auth) => BetGuideRemoved(auth: auth));
    }
  }
}
