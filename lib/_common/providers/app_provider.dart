import 'package:flutter/foundation.dart';

import 'providers_enum.dart';

class AppProvider with ChangeNotifier {
  WidgetStatus _status = WidgetStatus.idle;
  String errorMessage = "";

  void changeStatusTo(WidgetStatus status) {
    _status = status;
    notifyListeners();
  }

  bool get isLoading => _status == WidgetStatus.loading;
  bool get isError => _status == WidgetStatus.error;
  bool get isIdle => _status == WidgetStatus.idle;
}
