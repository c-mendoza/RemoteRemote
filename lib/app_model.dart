

import 'package:flutter/cupertino.dart';

//enum AppStatus {
//
//}

class AppModel with ChangeNotifier {

  bool _parametersReady;

  bool get parametersReady => _parametersReady;

  set parametersReady(bool value) {
    _parametersReady = value;
    notifyListeners();
  }
}