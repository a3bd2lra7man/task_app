import 'dart:developer';

import 'package:flutter/foundation.dart';

abstract class AppException implements Exception {
  final String userReadableMessage;
  final String internalErrorMessage;

  AppException(e, this.userReadableMessage, this.internalErrorMessage) {
    if (kDebugMode) {
      log("""\x1B[31m
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

Exception Has been thrown
Internal Message Error is : $internalErrorMessage
User Readable Message is : $userReadableMessage \n

Stack Trace : $e
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

\x1B[0m""");
    }
  }
}
