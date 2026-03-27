part of 'wordpress_auth_bloc.dart';

abstract class WordpressAuthEvent extends Equatable {
  const WordpressAuthEvent();

  @override
  List<Object> get props => [];
}

class CheckAuthRequest extends WordpressAuthEvent {}

class GetAuthRequest extends WordpressAuthEvent {}

class ValidateAuthRequest extends WordpressAuthEvent {}

class PersistAuthRequest extends WordpressAuthEvent {
  final WordpressAuth auth;
  PersistAuthRequest({required this.auth});

  @override
  List<Object> get props => [auth];
}

class WordpressLoginRequest extends WordpressAuthEvent {
  final String username;
  final String password;
  WordpressLoginRequest({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

class WordpressLogoutRequest extends WordpressAuthEvent {}

class DeleteAccountRequest extends WordpressAuthEvent {}

class CheckFirstTimeLoginRequest extends WordpressAuthEvent {}

class SetFirstTimeInstallRequest extends WordpressAuthEvent {}

class SetBetGuideRequest extends WordpressAuthEvent {}

class RemoveFirstTimeInstallRequest extends WordpressAuthEvent {}

class RemoveBetGuideRequest extends WordpressAuthEvent {}

class RegisterUserRequest extends WordpressAuthEvent {
  final String username;
  final String email;
  final String password;
  RegisterUserRequest(
      {required this.username, required this.email, required this.password});

  @override
  List<Object> get props => [username, email, password];
}

class CheckMemberRequest extends WordpressAuthEvent {}
