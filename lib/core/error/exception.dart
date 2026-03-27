class ServerException implements Exception {}

class ConflictException implements Exception {}

class CacheException implements Exception {}

class LocationException implements Exception {}

class NonExistingDataException implements Exception {}

class NotEnugCoin implements Exception {}

class RocketChatException implements Exception {
  String message;
  RocketChatException(this.message);

  String toString() {
    if (message == null) return "RocketChatException";
    return "RocketChatException: $message";
  }
}

class UserExistException implements Exception {}
