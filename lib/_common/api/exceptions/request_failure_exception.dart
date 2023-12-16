import 'api_exception.dart';

class RequestFailureException extends APIException {
  static const String _USER_READABLE_MESSAGE = "Oops! Looks like something has gone wrong. Please try again.";

  RequestFailureException(e, String errorMessage) : super(e, _USER_READABLE_MESSAGE, errorMessage);
}
