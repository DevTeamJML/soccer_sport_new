import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();

  @override
  List<Object> get props => [];
}

// General failures
class ServerFailure extends Failure {}

class NonExistingData extends Failure {}

class ConflictFailure extends Failure {}

class CacheFailure extends Failure {}

class LocationFailure extends Failure {}

class RocketChatUnauthorized extends Failure {}

class RocketChatDuplicateUsername extends Failure {}

class RocketChatUsernameNotExist extends Failure {}

class RocketChatFailure extends Failure {}

class UserExistFailure extends Failure {}

class NotEnugCoinFailure extends Failure {}
