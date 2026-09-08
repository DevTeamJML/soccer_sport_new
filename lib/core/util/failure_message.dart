import 'package:soccer_sport/core/error/failure.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String LOCATION_FAILURE_MESSAGE =
    'Unable to locate your device, please turn on the location service.';
const String CHAT_FAILURE_MESSAGE = 'Chat Failure';

class Failure2Message {
  static String map(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      case LocationFailure:
        return LOCATION_FAILURE_MESSAGE;
      case RocketChatFailure:
        return CHAT_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
