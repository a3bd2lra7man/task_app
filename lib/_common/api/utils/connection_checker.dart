import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectionChecker {
  Future<bool> get hasInternetAccess {
    return InternetConnection().hasInternetAccess;
  }
}
