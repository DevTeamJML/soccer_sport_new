part of 'wordpress_auth_bloc.dart';

abstract class WordpressAuthState extends Equatable {
  const WordpressAuthState();

  @override
  List<Object?> get props => [];
}

class WordpressAuthInitial extends WordpressAuthState {}

class CheckingAuth extends WordpressAuthState {}

class AuthChecked extends WordpressAuthState {
  final bool auth;
  AuthChecked({required this.auth});

  @override
  List<Object> get props => [auth];
}

class PersistingAuth extends WordpressAuthState {}

class AuthPersisted extends WordpressAuthState {
  final bool auth;
  AuthPersisted({required this.auth});

  @override
  List<Object> get props => [auth];
}

class GettingAuth extends WordpressAuthState {}

class AuthLoaded extends WordpressAuthState {
  final WordpressAuth auth;
  AuthLoaded({required this.auth});

  @override
  List<Object> get props => [auth];
}

class WordpressLoginLoading extends WordpressAuthState {}

class WordpressLogoutLoading extends WordpressAuthState {}

class WordpressLoginSuccess extends WordpressAuthState {
  final WordpressAuth? auth;
  WordpressLoginSuccess({required this.auth});

  @override
  List<Object?> get props => [auth];
}

class WordpressLoginIncorrect extends WordpressAuthState {}

class WordpressLogoutSuccess extends WordpressAuthState {
  final bool auth;
  WordpressLogoutSuccess({required this.auth});

  @override
  List<Object> get props => [auth];
}

class AuthError extends WordpressAuthState {
  final String message;

  AuthError({required this.message});

  @override
  List<Object> get props => [message];
}

class ValidatingAuth extends WordpressAuthState {}

class AuthValidated extends WordpressAuthState {
  final bool auth;

  AuthValidated({required this.auth});

  @override
  List<Object> get props => [auth];
}

class DeletingAccount extends WordpressAuthState {}

class AccountDeleted extends WordpressAuthState {
  final bool auth;

  AccountDeleted({required this.auth});

  @override
  List<Object> get props => [auth];
}

class CheckingFirstTimeInstall extends WordpressAuthState {}

class FirstTimeInstallChecked extends WordpressAuthState {
  final List<bool?> auth;

  FirstTimeInstallChecked({required this.auth});

  @override
  List<Object?> get props => [auth];
}

class SettingFirstTimeInstall extends WordpressAuthState {}

class FirstTimeInstallSet extends WordpressAuthState {
  final bool auth;

  FirstTimeInstallSet({required this.auth});

  @override
  List<Object> get props => [auth];
}

class RemovingFirstTimeInstall extends WordpressAuthState {}

class FirstTimeInstallRemoved extends WordpressAuthState {
  final bool auth;

  FirstTimeInstallRemoved({required this.auth});

  @override
  List<Object> get props => [auth];
}

class RemovingBetGuide extends WordpressAuthState {}

class BetGuideRemoved extends WordpressAuthState {
  final bool auth;

  BetGuideRemoved({required this.auth});

  @override
  List<Object> get props => [auth];
}

class RegisteringUser extends WordpressAuthState {}

class UserRegistered extends WordpressAuthState {
  final User? auth;

  UserRegistered({required this.auth});

  @override
  List<Object?> get props => [auth];
}

class UserExistError extends WordpressAuthState {
  // final String message;

  // UserExistError({required this.message});

  // @override
  // List<Object> get props => [message];
}

class CheckingMember extends WordpressAuthState {}

class MemberChecked extends WordpressAuthState {
  final bool? auth;

  MemberChecked({required this.auth});

  @override
  List<Object?> get props => [auth];
}

class SettingBetGuide extends WordpressAuthState {}

class BetGuideSet extends WordpressAuthState {
  final bool auth;

  BetGuideSet({required this.auth});

  @override
  List<Object> get props => [auth];
}
