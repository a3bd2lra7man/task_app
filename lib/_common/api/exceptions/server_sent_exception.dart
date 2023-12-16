import 'api_exception.dart';

class ServerSentException extends APIException {
  ServerSentException(
    e,
    String? userReadableMessage,
  ) : super(
          e,
          userReadableMessage ?? "Oops! Looks like something has gone wrong. Please try again.",
          "Server sent error: $userReadableMessage",
        );
}
