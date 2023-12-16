import '../../exceptions/app_exception.dart';

export 'network_failure_exception.dart';
export 'request_failure_exception.dart';
export 'server_sent_exception.dart';
export 'unexpected_response_format_exception.dart';

class APIException extends AppException {
  final dynamic responseData;

  APIException(
    e,
    String userReadableMessage,
    String internalErrorMessage, {
    this.responseData,
  }) : super(e, userReadableMessage, internalErrorMessage);
}
